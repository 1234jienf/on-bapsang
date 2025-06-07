import 'package:frontend/common/model/model_with_id.dart';
import 'package:retrofit/http.dart';

import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {

  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
});
}