import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:retrofit/http.dart';

import '../model/int/cursor_pagination_int_model.dart';

abstract class IBasePaginationIntRepository<T extends IModelWithIntId> {

  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<CursorIntPagination<T>> paginate({
    PaginationIntParams? paginationIntParams = const PaginationIntParams(),
  });
}