import 'package:bloc_sample/src/authentication_bloc.dart';
import 'package:bloc_sample/src/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

@immutable
class Authentication extends StatefulWidget {
  final Widget child;
  const Authentication({
    @required this.child,
    Key key,
  })  : assert(child != null, 'Field child in widget Authentication must not be null'),
        super(key: key);
  static _AuthenticationState of(BuildContext context) => _AuthenticationScope.of(context)?.state;

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  User _user;
  User get user => _user;
  AuthenticationBLoC _bloc;

  void login(int id) => _bloc.add(LogIn(id));
  void logout() => _bloc.add(const LogOut());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc?.close();
    _bloc = AuthenticationBLoC();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _AuthenticationScope(
        state: this,
        child: BlocConsumer<AuthenticationBLoC, AuthenticationState>(
          cubit: _bloc,
          listener: (context, state) => state.map<void>(
            authenticated: (state) => _user = state.user,
            notAuthenticated: (_) => _user = null,
          ),
          builder: (context, state) => state.map<Widget>(
            authenticated: (state) => Provider<User>.value(
              updateShouldNotify: (prev, next) => prev?.id != next?.id,
              value: state.user,
              child: widget.child,
            ),
            notAuthenticated: (_) => const _AuthenticationScreen(),
          ),
        ),
      );
}

@immutable
class _AuthenticationScope extends InheritedWidget {
  final _AuthenticationState state;

  const _AuthenticationScope({
    @required Widget child,
    @required this.state,
    Key key,
  })  : assert(child != null, 'Field child in widget _AuthenticationScope must not be null'),
        assert(state is _AuthenticationState, '_AuthenticationState must not be null'),
        super(key: key, child: child);

  /// Find _AuthenticationScope in BuildContext
  static _AuthenticationScope of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_AuthenticationScope>();

  @override
  bool updateShouldNotify(_AuthenticationScope oldWidget) =>
      !identical(state.user, oldWidget.state.user) || state.user != oldWidget.state.user;
}

@immutable
class _AuthenticationScreen extends StatelessWidget {
  const _AuthenticationScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                  onPressed: () => Authentication.of(context).login(1),
                  child: const Text('Log in with user #1'),
                ),
                FlatButton(
                  onPressed: () => Authentication.of(context).login(2),
                  child: const Text('Log in with user #2'),
                ),
                FlatButton(
                  onPressed: () => Authentication.of(context).login(3),
                  child: const Text('Log in with user #3'),
                ),
              ],
            ),
          ),
        ),
      );
}
