import 'package:human_id/exports.dart';

part 'language.g.dart';

@cwidget
Widget _languagePanel(BuildContext context, WidgetRef ref) {
  final locale =
      ref.watch(Hives.settingsProvider.select((value) => value.locale));
  final bgcTween = ColorTween(
    begin: context.theme.cardColor,
    end: context.theme.backgroundColor,
  );
  return CustomScrollView(
    slivers: [
      SimpleSliverPinnedHeader(
        maxExtent: 160.0,
        minExtent: 66.0,
        custom: true,
        builder: (context, maxOffset, offsetRatio) {
          return Container(
            decoration: BoxDecoration(
              color: bgcTween.transform(offsetRatio),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.0 * offsetRatio),
              ),
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
                    context.l10n.settingsList5,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 30.0 * (1 - offsetRatio) + 8.0,
                  start: 0.0,
                  child: const BackButton(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              HumanIDLocalizations.supportedLocales.length + 1,
              (index) {
                final Widget child;
                if (index == 0) {
                  child = Text(
                    context.l10n.languagePageText,
                    style: context.theme.textTheme.caption?.copyWith(
                      fontSize: 14.0,
                    ),
                  );
                } else {
                  final item = HumanIDLocalizations.supportedLocales[index - 1];
                  child = Material(
                    color: context.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        ref.read(Hives.settingsProvider.notifier).locale = item;
                      },
                      child: Container(
                        height: 46.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.languageName)),
                            AnimatedScale(
                              scale: item == locale ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Assets.icons.checked.svg(width: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    ],
  );
}
