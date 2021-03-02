import 'package:bloc_sample/src/home_bloc.dart';
import 'package:bloc_sample/src/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_sample/src/authentication_bloc.dart';

@immutable
class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthenticationBLoC bloc) => bloc.state
          .maybeWhen(authenticated: (user) => user, orElse: () => null),
    );
    return RepositoryProvider<HomeRepository>(
      create: (context) => HomeRepositoryImpl(
        user: user,
        sharedPreferences: context.read<SharedPreferences>(),
      ),
      child: BlocProvider<HomeBLoC>(
        create: (context) => HomeBLoC(
          repository: context.read<HomeRepository>(),
        )..add(
            const HomeEvent.fetch(),
          ),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<AuthenticationBLoC>().add(const LogOut()),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  iconSize: 48,
                  splashRadius: 24,
                  color: Colors.green,
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => BlocProvider.of<HomeBLoC>(context)
                      .add(const HomeEvent.increment()),
                ),
                IconButton(
                  iconSize: 48,
                  splashRadius: 24,
                  color: Colors.red,
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => BlocProvider.of<HomeBLoC>(context)
                      .add(const HomeEvent.decrement()),
                ),
              ],
            ),
            body: SafeArea(
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('USER #${user.id}'),
                    BlocBuilder<HomeBLoC, HomeState>(
                      builder: (context, state) => state.map<Widget>(
                        fetching: (_) => const Text('LOADING...'),
                        received: (state) => Text('DATA: ${state.data}'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
