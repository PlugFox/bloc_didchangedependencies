import 'package:bloc/bloc.dart';
import 'package:bloc_sample/src/home_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_bloc.freezed.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.fetch() = Fetch;
  const factory HomeEvent.increment() = Increment;
  const factory HomeEvent.decrement() = Decrement;
}

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.fetching() = Fetching;
  const factory HomeState.received({@required int data}) = Received;
}

class HomeBLoC extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  HomeBLoC({@required HomeRepository repository, HomeState initialState})
      : _repository = repository,
        super(initialState ?? const Fetching());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) => event.when<Stream<HomeState>>(
        fetch: _fetch,
        increment: _increment,
        decrement: _decrement,
      );

  Stream<HomeState> _fetch() async* {
    yield const Fetching();
    final data = await _repository.fetch();
    yield Received(data: data);
  }

  Stream<HomeState> _increment() async* {
    yield const Fetching();
    await _repository.increment();
    yield* _fetch();
  }

  Stream<HomeState> _decrement() async* {
    yield const Fetching();
    await _repository.decrement();
    yield* _fetch();
  }
}
