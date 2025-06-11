import 'package:flutter/material.dart';
import 'package:frontend/common/provider/pagination_string_provider.dart';

class PaginationStringUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationStringProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 100) {
      provider.paginate(fetchMore: true);
    }
  }
}