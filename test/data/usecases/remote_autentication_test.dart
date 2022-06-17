import 'package:ForDev/data/http/http_client.dart';
import 'package:ForDev/data/usercases/remote_autentication.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_autentication_test.mocks.dart';

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
