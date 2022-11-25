import 'dart:async';

import 'package:human_id/exports.dart';
import 'package:human_id/ui/pages/home.dart';
@FFArgumentImport()
import 'package:live_detection_plugin/live_detection.dart';

part 'verifying.g.dart';

final LiveDetection liveDetection = LiveDetection();

@swidget
@FFRoute(name: "/verifying")
Widget _verifying(
  BuildContext context, {
  required List<LiveAction> actions,
  required String scope,
}) {
  // useDelay(() {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     Routes.failed.name,
  //     (route) => Routes.home.name == route.settings.name,
  //     arguments: Routes.failed.d(scope),
  //   );
  // }, const Duration(minutes: 1));
  return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: 30.0,
            top: Screen.statusBarHeight + 40.0,
          ),
          child: const BackButton(useCardColor: true),
        ),
        const Ver(64.0),
        Center(
          child: Stack(
            children: [
              AnimatedCrossFade(
                secondChild: LiveDetectionView(
                  size: const Size(240.0, 320.0),
                  liveDetection: liveDetection,
                  action: actions.removeAt(0).name,
                  onPlatformViewCreated: () {},
                  auth:
                      "opkZkOMqNJyYTC41JUIgoCPQ2vsK+IaVrT4FjRLUSHNCJDRa3uq41hAnYtkalGPyGn455dluAsXqjBW0Indl0N/ogUzIAszZJlXLXOkj2EhwJtWSzQl4k/w48lLt+cY3/BEHxKctU/r072Y6rhjP1xLO+to4jmjQLOEJ2GIcE1g=",
                ),
                firstChild: Container(
                  color: context.theme.backgroundColor,
                  width: 240.0,
                  height: 320.0,
                ),
                crossFadeState: CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 250),
              ),
              Mask(
                actions: actions,
                scope: scope,
              ),
            ],
          ),
        ),
        const Ver(42.0),
        const Center(child: Actions()),
      ],
    ),
  );
}

@cwidget
Widget _mask(
  BuildContext context,
  WidgetRef ref, {
  required List<LiveAction> actions,
  required String scope,
}) {
  bool? last;
  Future<void> whenVerifiedAction() async {
    if (actions.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 800), () {
        final action = actions.removeAt(0);
        liveDetection.setAction(action.name);
        "new action: ${action.name}".debug();
      });
    } else {
      final service = HumanIDService();
      final loading = showLoading();
      [
        service.setVerified(scope),
        Future.delayed(const Duration(milliseconds: 800))
      ].allSettled().then((value) async {
        await Future.delayed(const Duration(milliseconds: 250));
        if (value.hasError) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.failed.name,
            (route) => Routes.home.name == route.settings.name,
            arguments: Routes.failed.d(scope),
          );
        } else {
          ref.invalidate(isVerifiedProvider);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.verified.name,
            (route) => Routes.home.name == route.settings.name,
          );
        }
      }).whenComplete(() {
        loading.dismiss(showAnim: true);
      });
    }
  }

  return StreamBuilder<bool>(
    stream: liveDetection.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final map = (data as Map).cast<String, dynamic>();
          final type = map["type"];
          bool d = false;
          if (type == "action") {
            d = true;
          } else if (type == "result") {
            d = map["data"]["success"] == true;
            if (d) {
              whenVerifiedAction();
            }
          }
          if (last != d) {
            last = d;
            sink.add(d);
          }
        },
      ),
    ),
    builder: (context, snapshot) {
      final ok = snapshot.data == true;
      if (ok) {
        return context.theme.isDark
            ? Assets.icons.scanVerifyGreen.svg(width: 240.0, height: 320.0)
            : Assets.icons.scanVerifyGreenWhite
                .svg(width: 240.0, height: 320.0);
      }
      return context.theme.isDark
          ? Assets.icons.scanVerifyRed.svg(width: 240.0, height: 320.0)
          : Assets.icons.scanVerifyRedWhite.svg(width: 240.0, height: 320.0);
    },
  );
}

@swidget
Widget _actions(BuildContext context) {
  Tuple2<bool, String>? desc;
  final actions = {
    LiveAction.blink.name: "Please blink",
    LiveAction.mouth.name: "Please open and close your mouth",
    LiveAction.shake.name: "Please shake your head",
    LiveAction.nod.name: "Please nod",
  };
  return StreamBuilder<Tuple2<bool, String>>(
    stream: liveDetection.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final map = (data as Map).cast<String, dynamic>();
          final type = map["type"];
          Tuple2<bool, String>? d;
          if (type == "action") {
            final action = actions[map["data"]];
            if (action != null) {
              d = Tuple2(true, action);
            }
          } else if (type == "result") {
            d = Tuple2(map["data"]["success"] == true, map["data"]["desc"]);
          }
          if (desc != d && d != null) {
            desc = d;
            sink.add(d);
            d.debug();
          }
        },
      ),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.requireData;
        final child = Text(
          data.item2,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        );
        return Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 6.0,
          ),
          child: data.item1
              ? child
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.warningRed.svg(width: 20.0),
                    const Hor(8.0),
                    child,
                  ],
                ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}
