import 'package:flutter/services.dart';
import 'package:human_id/exports.dart';
import 'package:human_id/internals/cache.dart';
import 'package:human_id/ui/fragments/about.dart';
import 'package:human_id/ui/fragments/display_mode.dart';
import 'package:human_id/ui/fragments/language.dart';
import 'package:human_id/ui/pages/home.dart';
import 'package:human_id/ui/widgets/reload_future_builder.dart';

part 'settings.g.dart';

@hcwidget
Widget _settingsPanel(BuildContext context) {
  final bgcTween = ColorTween(
    begin: context.theme.cardColor,
    end: context.theme.backgroundColor,
  );
  VoidCallback? reload;
  return CustomScrollView(
    slivers: [
      SimpleSliverPinnedHeader(
        maxExtent: 160.0,
        minExtent: 88.0,
        custom: true,
        builder: (context, maxOffset, offsetRatio) {
          return Container(
            decoration: BoxDecoration(
              color: bgcTween.transform(offsetRatio),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
              end: 20.0,
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 66.0 * offsetRatio,
                  bottom: 8.0 + 10.0 * offsetRatio,
                  child: Text(
                    context.l10n.settingsPageTitle,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
                const PositionedDirectional(
                  top: 30.0,
                  start: 0.0,
                  child: BackButton(),
                ),
              ],
            ),
          );
        },
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              MenuItem(
                title: context.l10n.settingsList5,
                onTap: () {
                  showPanel(
                    context: context,
                    builder: (context) => const LanguagePanel(),
                  );
                },
              ),
              MenuItem(
                title: context.l10n.settingsList6,
                onTap: () {
                  showPanel(
                    context: context,
                    builder: (context) => const DisplayModePanel(),
                  );
                },
              ),
              MenuItem(
                title: context.l10n.settingsList7,
                onTap: () {
                  CacheManager.clearCache().whenComplete(() {
                    HapticFeedback.heavyImpact();
                    showToast(context.l10n.clearCachePrompt);
                    reload?.call();
                  });
                },
                trailing: ReloadFutureBuilder<String>(
                  future: CacheManager.getFormatCacheSize(),
                  reloadFutureFactory: () => CacheManager.getFormatCacheSize(),
                  builder: (context, snapshot, r) {
                    reload = r;
                    return Text(
                      snapshot.data ?? '0 B',
                      style: context.theme.textTheme.caption,
                    );
                  },
                ),
              ),
              MenuItem(
                title: context.l10n.settingsList8,
                onTap: () {
                  showPanel(
                    context: context,
                    builder: (context) => const AboutPanel(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

@swidget
Widget _menuItem(
  BuildContext context, {
  required String title,
  required VoidCallback onTap,
  Widget? trailing,
  bool hasArrow = true,
}) {
  return Material(
    color: context.theme.cardColor,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            )),
            if (trailing != null) trailing,
            const Hor(10.0),
            if (hasArrow) Assets.icons.arrowRight.svg(height: 20.0),
          ],
        ),
      ),
    ),
  );
}
