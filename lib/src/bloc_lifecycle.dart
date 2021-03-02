import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Callback when BLoC ready to create
///
/// [context] - BuildContext
/// [bloc] - previous closed BLoC or null if first create
///
typedef BlocLifecycleCreate<T> = T Function(
  BuildContext context,
  T? bloc,
);

/// Callback when BLoC ready to be recreated.
/// Called when dependencies is changed.
///
/// [context] - BuildContext
/// [bloc] - current BLoC before recreated and closed
///
/// if return `true` - bloc recreating
/// if return `false` - bloc remains the same
///
typedef BlocLifecycleTest<T> = bool Function(
  BuildContext context,
  T bloc,
);

/// Callback when BLoC ready to close
///
/// [context] - BuildContext
/// [bloc] - previous BLoC (before closing)
///
typedef BlocLifecycleClose<T> = void Function(
  BuildContext context,
  T bloc,
);

/// Widget is responsible for the life cycle of the block,
/// rebuilding when context is changed.
///
/// Must using with BlocBuilder and BlocListner like this way:
///
/// ```dart
///  BlocBuilder<YourBloc, YourState>(
///    cubit: BlocProvider.of<YourBloc>(context, listen: true) // <= listen - must be true, not false as default!!!
///    builder: ...
///  )
/// ```
///
@immutable
class BlocLifecycle<T extends Bloc<Object, Object>> extends StatefulWidget {
  final Widget child;
  final BlocLifecycleCreate<T> create;
  final BlocLifecycleTest<T>? test;
  final BlocLifecycleClose<T>? close;
  const BlocLifecycle({
    required this.child,
    required this.create,
    this.test,
    this.close,
    Key? key,
  }) : super(key: key);

  @override
  State<BlocLifecycle<T>> createState() => _BlocLifecycleState<T>();
}

class _BlocLifecycleState<T extends Bloc<Object, Object>> extends State<BlocLifecycle<T>> {
  T? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc != null && (widget.test?.call(context, _bloc!) ?? false)) return;
    _rebuildBLoC(context, _bloc);
  }

  @override
  void dispose() {
    _closeBLoC(_bloc!);
    super.dispose();
  }

  void _rebuildBLoC(BuildContext context, T? currentBloc) {
    _bloc = widget.create(
      context,
      _bloc,
    );
    if (currentBloc != null && !identical(currentBloc, _bloc)) {
      _closeBLoC(currentBloc);
    }
  }

  void _closeBLoC(T oldBloc) {
    widget.close?.call(
      context,
      oldBloc,
    );
    oldBloc.close();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) => super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'Manages the life cycle of a BLoC',
            ),
          )
          ..add(
            StringProperty(
              'current state',
              _bloc?.state.toString() ?? 'none',
            ),
          ),
      );

  @override
  Widget build(BuildContext context) => InheritedProvider<T>.value(
        value: _bloc!,
        startListening: _startListening,
        lazy: false,
        child: widget.child,
      );

  static VoidCallback _startListening(
    InheritedContext<Bloc> e,
    Bloc value,
  ) {
    final subscription = value.listen(
      (dynamic _) => e.markNeedsNotifyDependents(),
    );
    return subscription.cancel;
  }
}
