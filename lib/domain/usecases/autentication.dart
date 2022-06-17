import '../entities/entities.dart';

abstract class Autentication {
  Future<AccountEntity> auth(AutenticationParams params);
}

class AutenticationParams {
  final String email;
  final String secret;

  AutenticationParams({required this.email, required this.secret});


 Map toJson() => {'email': email, 'password': secret};
}
