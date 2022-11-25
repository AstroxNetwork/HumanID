import 'package:permission_handler/permission_handler.dart';
import 'package:human_id/exports.dart';
import 'package:human_id/ui/fragments/settings.dart';
import 'package:human_id/ui/pages/home.dart';
import 'package:human_id/ui/pages/scan.dart';

part 'buttons.g.dart';

@swidget
Widget _backButton(
  BuildContext context, {
  bool useCardColor = false,
}) {
  return Material(
    color:
        useCardColor ? context.theme.cardColor : context.theme.backgroundColor,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(16.0),
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: Assets.icons.back.svg(
            height: 22.0,
            color: context.theme.textTheme.bodyText1?.color,
          ),
        ),
      ),
    ),
  );
}

@swidget
Widget _settingsButton(BuildContext context) {
  return Material(
    color: context.theme.cardColor,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(16.0),
    child: InkWell(
      onTap: () {
        showPanel(
          context: context,
          builder: (context) {
            return const SettingsPanel();
          },
        );
      },
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: Assets.icons.settings.svg(
            height: 22.0,
            color: context.theme.textTheme.bodyText1?.color,
          ),
        ),
      ),
    ),
  );
}

@swidget
Widget _scanButton(BuildContext context) {
  return Material(
    color: context.theme.cardColor,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(16.0),
    child: InkWell(
      onTap: () async {
        final isGranted = await [Permission.camera].isGranted();
        if (!isGranted) {
          return;
        }
        final ScanManager manager = ScanManager({});
        final qr = await Navigator.pushNamed(
          context,
          Routes.scan.name,
          arguments: Routes.scan.d(manager: manager),
        );
        if (qr is QR) {}
      },
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: Assets.icons.scan.svg(
            height: 22.0,
          ),
        ),
      ),
    ),
  );
}
