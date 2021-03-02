import 'package:bloc_sample/src/authentication_bloc.dart';
import 'package:bloc_sample/src/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class Authentication extends StatefulWidget {
  final Widget child;
  const Authentication({
    @required this.child,
    Key key,
  })  : assert(
          child != null,
          'Field child in widget Authentication must not be null',
        ),
        super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  User _user;
  User get user => _user;
  AuthenticationBLoC _bloc;

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
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<AuthenticationBLoC, AuthenticationState>(
          cubit: _bloc,
          listener: (context, state) => state.map<void>(
            authenticated: (state) => _user = state.user,
            notAuthenticated: (_) => _user = null,
          ),
          builder: (context, state) => state.map<Widget>(
            authenticated: (_) => widget.child,
            notAuthenticated: (_) => const _AuthenticationScreen(),
          ),
        ),
      );
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
                TextButton(
                  onPressed: () =>
                      context.read<AuthenticationBLoC>().add(const LogIn(1)),
                  child: const Text('Log in with user #1'),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<AuthenticationBLoC>().add(const LogIn(2)),
                  child: const Text('Log in with user #2'),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<AuthenticationBLoC>().add(const LogIn(3)),
                  child: const Text('Log in with user #3'),
                ),
              ],
            ),
          ),
        ),
      );
}
