import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/domain/server/datasource/server_remote_datasource.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockServerRemoteDataSource extends Mock
    implements IServerRemoteDataSource {}

void main() {
  late MockServerRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockServerRemoteDataSource();
  });

  group('IServerRemoteDataSource Tests', () {
    test('getServer returns a valid GetServerResponse', () async {
      // Arrange
      final request = GetServerRequest();
      final expectedResponse = GetServerResponse(
        server: Server(
          isSetUp: true,
          config: ServerConfig(serverName: 'Test Server'),
        ),
      );

      when(() => mockDataSource.getServer(request))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await mockDataSource.getServer(request);

      // Assert
      expect(result, equals(expectedResponse));
      expect(result.server.isSetUp, isTrue);
      expect(result.server.config.serverName, equals('Test Server'));
      verify(() => mockDataSource.getServer(request)).called(1);
    });

    test('getServer handles errors', () async {
      // Arrange
      final request = GetServerRequest();
      when(() => mockDataSource.getServer(request))
          .thenThrow(Exception('Server error'));

      // Act & Assert
      expect(() => mockDataSource.getServer(request), throwsException);
    });
  });
}
