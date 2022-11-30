import 'package:carousel_slider/carousel_slider.dart';
import 'package:human_id/exports.dart';

part 'guide.g.dart';

@cwidget
@FFRoute(name: "/guide")
Widget guide(BuildContext context, WidgetRef ref) {
  final guides = [
    Tuple2(
      "Quick Human Verification\non mobile phone",
      Assets.icons.guide.p1,
    ),
  ];
  final indicator = ValueNotifier(0);
  final hasMore = guides.length > 1;
  return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacer,
        CarouselSlider(
          items: List.generate(guides.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: guides[index].item2.image(
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitWidth,
                  ),
            );
          }, growable: false),
          options: CarouselOptions(
            autoPlay: hasMore,
            reverse: false,
            enableInfiniteScroll: hasMore,
            aspectRatio: 1.0,
            viewportFraction: 1.0,
            onPageChanged: (index, _) {
              indicator.value = index;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            top: 30.0,
            bottom: 8.0,
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: indicator,
            builder: (context, ind, child) {
              final item = guides[ind];
              return Text(
                item.item1,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamily.gotham,
                  height: 1.0,
                ),
              );
            },
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              top: 6.0,
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: indicator,
              builder: (context, ind, child) {
                return Row(
                  children: List.generate(
                    guides.length,
                    (index) {
                      final active = index == ind;
                      return AnimatedContainer(
                        width: active ? 24.0 : 16.0,
                        height: 6.0,
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: active
                              ? context.theme.primaryColor
                              : context.theme.cardColor,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        spacer,
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(Hives.settingsProvider).showGuide = false;
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home.name, (route) => false);
              },
              child: const Text("Enter"),
            ),
          ),
        ),
        sizedHeight36WithNavBar,
      ],
    ),
  );
}
