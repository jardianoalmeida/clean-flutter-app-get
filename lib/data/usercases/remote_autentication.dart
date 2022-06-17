import '../../domain/entities/entities.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http_client.dart';
import '../http/http_error.dart';

class RemoteAutentication {
  final HttpClient httpClient;
  final String url;

  RemoteAutentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AutenticationParams params) async {
    final body = RemoteAutenticationParams.fromDomain(params).toJson();

    try {
      final httpResponse =  await httpClient.request(url: url, method: 'post', body: body);
      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      throw error == HttpError.anauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAutenticationParams {
  final String email;
  final String password;

  RemoteAutenticationParams({required this.email, required this.password});

  factory RemoteAutenticationParams.fromDomain(AutenticationParams entity) =>
      RemoteAutenticationParams(email: entity.email, password: entity.secret);
  Map toJson() => {'email': email, 'password': password};
}
