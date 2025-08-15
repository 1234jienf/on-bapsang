import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/go_router/provider/main_provider.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.watch(mainProvider);
  return GoRouter(
    initialLocation: '/splash',
    routes: provider.routes,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
    debugLogDiagnostics: true,
  );
});
