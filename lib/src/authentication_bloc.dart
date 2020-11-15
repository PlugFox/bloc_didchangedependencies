import 'package:bloc/bloc.dart';
import 'package:bloc_sample/src/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_bloc.freezed.dart';

@freezed
abstract class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.login(int id) = LogIn;
  const factory AuthenticationEvent.logout() = LogOut;
}

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.authenticated(User user) = Authenticated;
  const factory AuthenticationState.notAuthenticated() = NotAuthenticated;
}

class AuthenticationBLoC extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBLoC() : super(const NotAuthenticated());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) => event.when<Stream<AuthenticationState>>(
        login: _login,
        logout: _logout,
      );

  Stream<AuthenticationState> _login(int id) async* {
    yield Authenticated(User(id: id));
  }

  Stream<AuthenticationState> _logout() async* {
    yield const NotAuthenticated();
  }
}
