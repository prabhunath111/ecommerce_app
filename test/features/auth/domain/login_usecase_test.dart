import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123';
  const tUser = UserEntity(
    id: 'usr_1',
    name: 'Test User',
    email: tEmail,
    token: 'jwt_mock_token',
  );

  test('should return UserEntity when repository login succeeds', () async {
    // Arrange
    when(() => mockRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tUser));

    // Act
    final result = await useCase(const LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Right(tUser));
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when credentials are invalid', () async {
    // Arrange
    const tFailure = AuthFailure(message: 'Invalid credentials');
    when(() => mockRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(const LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
  });
}
