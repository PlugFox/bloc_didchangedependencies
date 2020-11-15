import 'dart:async';

import 'package:bloc_sample/src/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeRepository {
  FutureOr<int> fetch();
  FutureOr<void> increment();
  FutureOr<void> decrement();
}

class HomeRepositoryImpl implements HomeRepository {
  final User _user;
  final SharedPreferences _sharedPreferences;
  String get _storageKey => 'data_${_user.id.toRadixString(36)}';

  HomeRepositoryImpl({
    @required User user,
    @required SharedPreferences sharedPreferences,
  })  : _user = user,
        _sharedPreferences = sharedPreferences;

  @override
  FutureOr<int> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _sharedPreferences.getInt(_storageKey) ?? 0;
  }

  @override
  FutureOr<void> increment() async {
    final data = await fetch();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _sharedPreferences.setInt(_storageKey, data + 1);
  }

  @override
  FutureOr<void> decrement() async {
    final data = await fetch();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _sharedPreferences.setInt(_storageKey, data - 1);
  }
}

class HomeRepositoryStub implements HomeRepository {
  int _data = 0;

  @override
  FutureOr<int> fetch() => _data;

  @override
  FutureOr<void> increment() => _data++;

  @override
  FutureOr<void> decrement() => _data--;
}
