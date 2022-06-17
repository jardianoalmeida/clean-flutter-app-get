import '../../domain/usecases/usecases.dart';
import '../http/http_client.dart';

class RemoteAutentication {
  final HttpClient httpClient;
  final String url;

  RemoteAutentication({required this.httpClient, required this.url});

  @override
  Future<void> auth(AutenticationParams params) async {
    final body = RemoteAutenticationParams.fromDomain(params).toJson();
    await httpClient.request(url: url, method: 'post', body: body);
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
