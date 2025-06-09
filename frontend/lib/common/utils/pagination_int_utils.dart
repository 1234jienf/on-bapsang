import 'package:flutter/material.dart';
import 'package:frontend/common/provider/pagination_int_provider.dart';

class PaginationIntUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationIntProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 100) {
      provider.paginate(fetchMore: true);
    }
  }
}
