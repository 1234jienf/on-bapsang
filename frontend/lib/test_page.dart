// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/common/component/pagination_recipe_list_view.dart';
// import 'package:frontend/common/layout/default_layout.dart';
// import 'package:frontend/community/model/community_model.dart';
// import 'package:frontend/community/provider/community_provider.dart';
// import 'package:frontend/community/repository/community_repository.dart';
//
// import 'common/model/pagination_recipe_params.dart';
//
// class TestPage extends ConsumerWidget {
//   static String get routeName => 'Test';
//
//   TestPage({super.key});
//
//   final communityTestProvider = FutureProvider.autoDispose((ref) async {
//     final repository = ref.watch(communityRepositoryProvider);
//     final result = await repository.paginate(
//       paginationParams: PaginationParams(count: 10),
//     );
//     print('🔥 데이터 개수: ${result.data.length}');
//     print('🔥 전체 데이터: ${result.data.map((e) => e.title).toList()}');
//     return result;
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     final asyncValue = ref.watch(communityTestProvider);
//
//     return DefaultLayout(
//       appBar: AppBar(),
//       child: asyncValue.when(
//         data: (data) {
//           return Text('불러온 개수: ${data.data.length}');
//         },
//         loading: () => CircularProgressIndicator(),
//         error: (e, _) => Text('에러 발생: $e'),
//       ),
//     );
//
//     // return DefaultLayout(child: PaginationListView<CommunityModel>(provider: communityProvider, itemBuilder: <CommunityModel>(_, index, model) {
//     //   return ElevatedButton(onPressed: () {communityTestProvider;}, child: Text('h'));
//     // }));
//   }
// }
