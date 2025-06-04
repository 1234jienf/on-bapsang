import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/user/model/user_model.dart';
import 'package:frontend/user/provider/user_provider.dart';

final authProvider = ChangeNotifierProvider((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userProvider, (prev, next) {
      if (prev != next) {
        notifyListeners();
      }
    });
  }
}
