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

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};
  PostExpectation _mockRequest() {
    return when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    ));
  }

  void mockHttpData(Map data) {
    _mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    _mockRequest().thenThrow(error);
  }

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

    mockHttpData(mockValidData());
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
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    mockHttpError(HttpError.anauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Accaunt if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final accaunt = await sut.auth(params);

    expect(accaunt.token, validData['accessToken']);
  });

  test(
      'Should throws UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
