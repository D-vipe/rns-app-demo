import 'package:rns_app/app/features/home/data/dto/directions_dto.dart';
import 'package:rns_app/app/features/home/domain/models/directions_model.dart';

class DirectionsConverter {
  static Direction mapDTO(DirectionDTO data) => Direction(text: data.text, isHeader: data.isHeader);
}
