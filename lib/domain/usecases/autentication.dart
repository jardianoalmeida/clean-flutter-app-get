import '../entities/entities.dart';

abstract class Autentication {
  Future<AccountEntity> auth(AutenticationParams params);
}



class AutenticationParams {
      final String email;
    final String assword;

  AutenticationParams({required this.email, required this.assword});
}