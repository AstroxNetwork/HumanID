// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verifying.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class Verifying extends HookWidget {
  const Verifying({
    Key? key,
    required this.actions,
    required this.scope,
  }) : super(key: key);

  final List<LiveAction> actions;

  final String scope;

  @override
  Widget build(BuildContext _context) => _verifying(
        _context,
        actions: actions,
        scope: scope,
      );
}

class Mask extends ConsumerWidget {
  const Mask({
    Key? key,
    required this.actions,
    required this.scope,
  }) : super(key: key);

  final List<LiveAction> actions;

  final String scope;

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      _mask(
        _context,
        _ref,
        actions: actions,
        scope: scope,
      );
}

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _actions(_context);
}
