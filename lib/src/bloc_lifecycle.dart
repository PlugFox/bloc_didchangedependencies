import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Callback when BLoC ready to create
/// [bloc] - previous closed BLoC or null if first create
typedef BlocLifecycleCreate<T> = T Function(
    BuildContext context,
    T bloc,
    );

/// Callback when BLoC ready to close
typedef BlocLifecycleClose<T> = void Function(
    BuildContext context,
    T bloc,
    );

/// Widget is responsible for the life cycle of the block, rebuilding when context is changed.
@immutable
class BlocLifecycle<T extends Cubit<Object>> extends StatefulWidget {
  final Widget child;
  final BlocLifecycleCreate<T> create;
  final BlocLifecycleClose<T> close;
  const BlocLifecycle({
    @required this.child,
    @required this.create,
    this.close,
    Key key,
  })  : assert(child != null, 'Field child in widget BlocLifecycle<T> must not be null'),
        assert(create != null, 'Field create in widget BlocLifecycle<T> must not be null'),
        super(key: key);
  @override
  State<BlocLifecycle<T>> createState() => _BlocLifecycleState<T>();
}

class _BlocLifecycleState<T extends Cubit<Object>> extends State<BlocLifecycle<T>> {
  T _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _closeIfNotNull();
    _bloc = widget.create(
      context,
      _bloc,
    );
  }

  @override
  void dispose() {
    _closeIfNotNull();
    _bloc = null;
    super.dispose();
  }

  void _closeIfNotNull() {
    if (_bloc != null) {
      if (widget.close != null) {
        widget.close(
          context,
          _bloc,
        );
      }
      _bloc.close();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider<T>.value(
    value: _bloc,
    child: widget.child,
  );
}