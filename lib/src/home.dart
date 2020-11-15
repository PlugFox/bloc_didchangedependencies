import 'package:bloc_sample/src/authentication.dart';
import 'package:bloc_sample/src/home_bloc.dart';
import 'package:bloc_sample/src/home_repository.dart';
import 'package:bloc_sample/src/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ProxyProvider2<User, SharedPreferences, HomeRepository>(
        /// Build repository with dependencies
        update: (context, user, sharedPrefs, _) => HomeRepositoryImpl(
          user: user,
          sharedPreferences: sharedPrefs,
        ),
        child: ProxyProvider<HomeRepository, HomeBLoC>(
          /// Close old HomeBLoC (if exist) and create new with HomeRepository,
          /// also recreate BLoC if HomeRepository or hes dependencies is changed
          update: (context, repository, prev) {
            prev?.close();
            return HomeBLoC(
              repository: Provider.of<HomeRepository>(context),
            )..add(
                const HomeEvent.fetch(),
              );
          },
          child: const _HomeLayout(),
        ),
      );
}

@immutable
class _HomeLayout extends StatelessWidget {
  const _HomeLayout({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () => Authentication.of(context).logout(),
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
              onPressed: () => BlocProvider.of<HomeBLoC>(context).add(const HomeEvent.increment()),
            ),
            IconButton(
              iconSize: 48,
              splashRadius: 24,
              color: Colors.red,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => BlocProvider.of<HomeBLoC>(context).add(const HomeEvent.decrement()),
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
                Text('USER #${Authentication.of(context).user.id}'),
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
      );
}
