
import 'package:flashsaledemo/bloc/base_bloc.dart';
import 'package:flutter/material.dart';

/// Provide [bloc] for it's [child] Widgets, every Widget under this Widget
/// can access the bloc without passing the bloc down the widget tree.
///
/// To access the bloc, use the [of] method
/// E.g:
///
/// BlocProvider<HomeBloc>(
///   child: HomePage(),
///   bloc: HomeBloc()
/// )
///
/// final homeBloc = BlocProvider<HomeBloc>.of(context)

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final T bloc;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc
  }): super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState();

  static T of<T extends BaseBloc>(BuildContext context){
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
