import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:retrofit/http.dart';

import '../model/string/cursor_pagination_string_model.dart';
import '../model/string/pagination_string_params.dart';

abstract class IBasePaginationStringRepository<T extends IModelWithStringId> {

  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<CursorStringPagination<T>> paginate({
    PaginationStringParams paginationStringParams = const PaginationStringParams(),
});
}