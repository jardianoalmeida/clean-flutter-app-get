import '../../domain/usecases/usecases.dart';
import '../http/http_client.dart';

class RemoteAutentication {
  final HttpClient httpClient;
  final String url;

  RemoteAutentication({required this.httpClient, required this.url});

  @override
  Future<void> auth(AutenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }
}
