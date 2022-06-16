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
  Future<void> auth() async {
    httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method,});
}

@GenerateMocks([HttpClient])
void main() {
  test('Should call HttpClient with correct values', () async {
    final httpClient = MockHttpClient();
    final url = faker.internet.httpUrl();
    final sut = RemoteAutentication(httpClient: httpClient, url: url, );

    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post',
    ));
  });
}
