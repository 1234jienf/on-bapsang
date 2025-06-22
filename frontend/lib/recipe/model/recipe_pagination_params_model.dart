import 'package:frontend/common/model/int/pagination_int_params.dart';

class PaginationWithNameParams extends PaginationIntParams {
  final String? name;

  const PaginationWithNameParams({
    int page = 0,
    int size = 10,
    this.name,
  }) : super(page: page, size: size);

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (name != null) 'name': name,
  };
}