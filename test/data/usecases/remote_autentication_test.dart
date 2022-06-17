import 'package:ForDev/data/http/http.dart';
import 'package:ForDev/data/usercases/usecases.dart';
import 'package:ForDev/domain/helpers/helpers.dart';
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
  late AutenticationParams params;
  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAutentication(
      httpClient: httpClient,
      url: url,
    );
    params = AutenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });
  test('Should call HttpClient with correct values', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        });
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.anauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Accaunt if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final accaunt = await sut.auth(params);

    expect(accaunt.token, accessToken);
  });

  test(
      'Should throws UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {
          'invalid_key': 'invalid_value',
        });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
