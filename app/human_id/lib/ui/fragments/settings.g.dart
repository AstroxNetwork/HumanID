// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class SettingsPanel extends HookConsumerWidget {
  const SettingsPanel({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      _settingsPanel(_context);
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
    this.hasArrow = true,
  }) : super(key: key);

  final String title;

  final void Function() onTap;

  final Widget? trailing;

  final bool hasArrow;

  @override
  Widget build(BuildContext _context) => _menuItem(
        _context,
        title: title,
        onTap: onTap,
        trailing: trailing,
        hasArrow: hasArrow,
      );
}
