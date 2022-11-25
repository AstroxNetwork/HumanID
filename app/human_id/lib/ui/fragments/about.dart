import 'package:human_id/exports.dart';

import 'package:url_launcher/url_launcher_string.dart';

part 'about.g.dart';

@swidget
Widget _aboutPanel(BuildContext context) {
  final items = [
    Tuple3(
      context.l10n.twitter,
      Assets.icons.about.twitter,
      'https://twitter.com/Astrox_Network',
    ),
    Tuple3(
      context.l10n.discord,
      Assets.icons.about.discord,
      'https://discord.com/invite/HpP5mvwJT2',
    ),
    Tuple3(
      context.l10n.medium,
      Assets.icons.about.medium,
      'https://astrox.medium.com/',
    ),
    Tuple3(
      context.l10n.telegram,
      Assets.icons.about.telegram,
      'https://t.me/astrox_network',
    ),
    Tuple3(
      context.l10n.github,
      Assets.icons.about.github,
      'https://github.com/AstroxNetwork',
    ),
    Tuple3(
      context.l10n.email,
      Assets.icons.about.email,
      'mailto:team@astrox.network',
    ),
  ];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Ver(30.0),
        const BackButton(),
        spacer,
        Assets.icons.logo.image(width: 98.0),
        const Ver(16.0),
        const Text(
          "HumanID",
          style: TextStyle(
            fontFamily: FontFamily.gotham,
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
        spacer,
        SizedBox(
          height: 200.0,
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 72.0,
              mainAxisSpacing: 16.0,
            ),
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: <Widget>[
                  Material(
                    color: context.theme.iconTheme.color,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        launchUrlString(
                          item.item3,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: item.item2.svg(
                            width: 24.0,
                            color: context.theme.cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Ver(4),
                  Text(
                    item.item1,
                    style: context.theme.textTheme.caption?.copyWith(
                      fontFamily: FontFamily.pTSans,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        spacer,
      ],
    ),
  );
}
