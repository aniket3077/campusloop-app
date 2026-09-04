import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop/providers/auth_provider.dart';
import 'package:campusloop/repositories/auth_repository.dart';
import 'package:campusloop/services/auth_service.dart';

class FakeAuthService extends MockAuthService {
  bool logoutCalled = false;

  @override
  Future<void> logout() async {
    logoutCalled = true;
    await super.logout();
  }
}

void main() {
  group('Auth Logout Tests', () {
    test('AuthProvider logout clears current user and updates authentication status', () async {
      final fakeService = FakeAuthService();
      final repository = AuthRepository(authService: fakeService);
      final provider = AuthProvider(repository: repository);

      // Wait for provider initialization
      await Future.delayed(const Duration(milliseconds: 300));

      // Initially user should be authenticated from mock service
      expect(provider.user, isNotNull);
      expect(provider.isAuthenticated, isTrue);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      // Execute logout
      await provider.logout();

      // Verify that the user state is reset
      expect(provider.user, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isVerifiedStudent, isFalse);
      expect(notified, isTrue);
      expect(fakeService.logoutCalled, isTrue);
    });

    test('AuthRepository logout successfully calls underlying auth service', () async {
      final fakeService = FakeAuthService();
      final repository = AuthRepository(authService: fakeService);

      expect(fakeService.logoutCalled, isFalse);
      await repository.logout();
      expect(fakeService.logoutCalled, isTrue);
    });
  });
}
