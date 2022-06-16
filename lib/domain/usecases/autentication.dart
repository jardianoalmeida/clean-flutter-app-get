import '../entities/entities.dart';

abstract class Autentication {
  Future<AccountEntity> auth({
    required String email,
    required String assword,
  });
}
