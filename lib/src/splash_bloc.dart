import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_bloc.freezed.dart';

@freezed
abstract class SplashEvent with _$SplashEvent {
  const SplashEvent._();

  const factory SplashEvent.initialize() = Initialize;
}

@freezed
abstract class SplashState with _$SplashState {
  const SplashState._();
  const factory SplashState.initial({@required int progress}) = Initial;
  const factory SplashState.initialized({@required SharedPreferences sharedPreferences}) = Initialized;
}

class SplashBLoC extends Bloc<SplashEvent, SplashState> {
  SplashBLoC() : super(const Initial(progress: 0));

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) => event.when<Stream<SplashState>>(
        initialize: _initialize,
      );

  Stream<SplashState> _initialize() async* {
    final sharedPreferences = await SharedPreferences.getInstance();
    for (var i = 1; i < 100; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      yield Initial(progress: i);
    }
    yield Initialized(
      sharedPreferences: sharedPreferences,
    );
  }
}
