import 'package:flutter/material.dart';
import 'package:frontend/common/provider/pagination_string_provider.dart';

import '../../search/provider/search_normal_pagination_list_view_provider.dart';

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

class PaginationNormalUtils {
  static void paginateGET({
    required ScrollController controller,
    required SearchNormalPaginationListViewProvider provider,
}) {
    if (controller.offset > controller.position.maxScrollExtent - 100) {
      provider.paginateGET(fetchMore: true);
    }
  }
}