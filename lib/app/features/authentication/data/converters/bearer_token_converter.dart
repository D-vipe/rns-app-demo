import 'package:rns_app/app/features/authentication/data/dto/bearer_token_dto.dart';
import 'package:rns_app/app/features/authentication/domain/models/bearer_token_model.dart';

class BearerTokenConverter {
  static BearerToken convertDTO(BearerTokenDTO data) => BearerToken(
        data: data.data,
        type: data.type,
        expDate: DateTime.now().add(Duration(seconds: data.expireIn)),
      );
}
