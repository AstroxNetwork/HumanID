import 'package:flutter/material.dart';

typedef ReloadAsyncWidgetBuilderWith<T> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T> snapshot,
  VoidCallback reload,
);

class ReloadFutureBuilder<T> extends StatefulWidget {
  const ReloadFutureBuilder({
    Key? key,
    required this.future,
    required this.reloadFutureFactory,
    required this.builder,
    this.initialData,
  }) : super(key: key);

  final Future<T> future;
  final Future<T>? Function() reloadFutureFactory;
  final ReloadAsyncWidgetBuilderWith<T> builder;
  final T? initialData;

  @override
  State<ReloadFutureBuilder<T>> createState() => _ReloadFutureBuilderState<T>();
}

class _ReloadFutureBuilderState<T> extends State<ReloadFutureBuilder<T>> {
  late Future<T>? _future = widget.future;

  void reload() {
    if (!mounted) {
      return;
    }
    _future = widget.reloadFutureFactory.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      initialData: widget.initialData,
      builder: (context, snapshot) {
        return widget.builder.call(context, snapshot, reload);
      },
    );
  }
}
