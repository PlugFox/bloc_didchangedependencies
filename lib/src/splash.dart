import 'package:bloc_sample/src/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class Splash extends StatelessWidget {
  final Widget child;
  const Splash({
    @required this.child,
    Key key,
  })  : assert(child != null, 'Field child in widget Splash must not be null'),
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<SplashBLoC>(
        create: (context) => SplashBLoC()..add(const SplashEvent.initialize()),
        child: BlocBuilder<SplashBLoC, SplashState>(
          buildWhen: (prev, next) => (prev is Initial && next is Initialized) || (prev is Initialized && next is Initial),
          builder: (context, state) => state.map(
            initial: (_) => const _SplashScreen(),
            initialized: (state) => Provider<SharedPreferences>.value(
              value: state.sharedPreferences,
              child: child,
            ),
          ),
        ),
      );
}

@immutable
class _SplashScreen extends StatelessWidget {
  const _SplashScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Initialization'),
        ),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: BlocBuilder<SplashBLoC, SplashState>(
                buildWhen: (prev, next) => !identical(prev, next) && prev != next,
                builder: (context, state) => Stack(
                  children: [
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: (state as Initial).progress / 100,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          '${(state as Initial).progress.toString().padLeft(2, ' ')}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
