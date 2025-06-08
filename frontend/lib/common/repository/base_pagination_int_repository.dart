import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:frontend/common/model/wrapper/pagination_int_wrapper_response.dart';
import 'package:retrofit/http.dart';

abstract class IBasePaginationIntRepository<T extends IModelWithIntId> {

  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<PaginationIntWrapperResponse<T>> paginate({
    PaginationIntParams? paginationIntParams = const PaginationIntParams(),
  });
}