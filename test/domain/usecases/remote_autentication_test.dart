import 'package:clean_flutter_app/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_autentication_test.mocks.dart';

class RemoteAutentication {
  final HttpClient httpClient;
  final String url;

  RemoteAutentication({required this.httpClient, required this.url});

  @override
  Future<void> auth(AutenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
    Map? body,
  });
}

@GenerateMocks([HttpClient])
void main() {
  late RemoteAutentication sut;
  late String url;
  late MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAutentication(
      httpClient: httpClient,
      url: url,
    );
  });
  test('Should call HttpClient with correct values', () async {
    final params = AutenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
}
