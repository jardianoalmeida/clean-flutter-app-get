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
  Future<void> request({
    required String url,
    required String method,
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
    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post',
    ));
  });
}
