import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/news/domain/repository/news_repository.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class NewsController extends GetxController {
  final _repository = NewsRepository();
  final int limit = 10;
  String errorMessage = '';
  final scrollController = ScrollController();
  int page = 0;
  bool noMoreToLoad = false;
  Rx<bool> isLoadingMore = false.obs;
  Rx<bool> loadingData = false.obs;
  Rx<bool> refreshing = false.obs;
  Rx<bool> loadingError = false.obs;
  RxList<NewsItem> news = RxList([]);
  Rxn<NewsItem> chosenItem = Rxn(null);

  @override
  void onReady() {
    scrollController.addListener(_scrollListener);
    _getData(loadingMore: true);
    super.onReady();
  }

  void chooseItem(NewsItem item) {
    chosenItem.value = item;
    HomeController.to.navigateTo(Routes.NEWS_DETAILED);
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.maxScrollExtent - scrollController.offset < 220.0 &&
        scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isLoadingMore.value) {
        return;
      }

      if (!noMoreToLoad) {
        isLoadingMore.value = true;
        await _getData(loadingMore: true);
      }
    }

    if (scrollController.position.userScrollDirection == ScrollDirection.forward && scrollController.offset < -125) {
      if (refreshing.value) {
        return;
      } else {
        refreshing.value = true;
        HomeController.to.disableScroll.value = true;
        // сбросим все значения
        page = 1;
        noMoreToLoad = false;
        // Без этой задержки происходит дергание элементов, когда их мало или нет
        // из-за быстрого ответа от сервера
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await _getData(pullToRefresh: true).then((value) {
            refreshing.value = false;
            HomeController.to.disableScroll.value = false;
          });
        });
      }
    }
  }

  Future<void> _getData({bool loadingMore = false, bool pullToRefresh = false}) async {
    int _pageToLoad = page;
    if (!loadingMore && !pullToRefresh) {
      loadingData.value = true;
    } else if (loadingMore) {
      _pageToLoad = page + 1;
    }
    print(page);
    try {
      final List<NewsItem> newItems = await _repository.getAllNews(_pageToLoad, pageSize: limit);

      if (newItems.isEmpty) {
        noMoreToLoad = true;
      } else if (loadingMore) {
        page = _pageToLoad;
        final List<NewsItem> updatedItems = List.from(news);
        updatedItems.addAll(newItems);
        news.value = updatedItems;
      } else {
        news.value = newItems;
        news.refresh();
      }
    } catch (e) {
      errorMessage = e.toString().cleanException();
      loadingError.value = true;
    }

    loadingData.value = false;
    isLoadingMore.value = false;
  }
}
