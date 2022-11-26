import 'dart:ui';

import 'package:human_id/exports.dart';
import 'package:human_id/hooks/hooks.dart';

part 'index.g.dart';

@cwidget
Widget _humanID(WidgetRef ref) {
  final settings = ref.watch(Hives.settingsProvider);
  return OKToast(
    radius: 8.0,
    duration: const Duration(seconds: 3),
    textStyle: const TextStyle(fontSize: 14.0),
    position: ToastPosition.bottom,
    child: MaterialApp(
      scrollBehavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        dragDevices: PointerDeviceKind.values.toSet(),
        physics: const BouncingScrollPhysics(),
        platform: TargetPlatform.iOS,
      ),
      locale: settings.locale,
      themeMode:
          settings.themeMode == ThemeMode.system ? null : settings.themeMode,
      theme: HumanIDTheme.getTheme(Brightness.light),
      darkTheme: HumanIDTheme.getTheme(Brightness.dark),
      supportedLocales: HumanIDLocalizations.supportedLocales,
      localizationsDelegates: HumanIDLocalizations.localizationsDelegates,
      navigatorObservers: [HistoryNavigatorObserver(), routeObserver],
      initialRoute: Routes.splash.name,
      navigatorKey: gNavKey,
      builder: (context, child) {
        return AnnotatedRegion(
          value: context.fitSystemUiOverlayStyle,
          child: child!,
        );
      },
      onGenerateRoute: (settings) => onGenerateRoute(
        settings: settings,
        getRouteSettings: getRouteSettings,
        notFoundPageBuilder: () => Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Text(
            '${settings.name ?? 'Unknown'} route not found',
            style: const TextStyle(color: Colors.white, inherit: false),
          ),
        ),
      ),
    ),
  );
}

@hcwidget
@FFRoute(name: "/splash")
Widget _splash(BuildContext context, WidgetRef ref) {
  useDelay(() {
    final showGuide = ref.read(Hives.settingsProvider).showGuide;
    Navigator.pushNamedAndRemoveUntil(context,
        showGuide ? Routes.guide.name : Routes.home.name, (route) => true);
  }, const Duration(milliseconds: 1500));
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
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
          const Spacer(),
          const Align(
            child: Text(
              // todo: COPYRIGHT © 2021 AstroX, All rights reserved.
              "COPYRIGHT © 2021 AstroX, All rights reserved.",
              style: TextStyle(
                fontFamily: FontFamily.pTSans,
                fontSize: 12.0,
                height: 1.25,
              ),
            ),
          ),
          sizedHeight36WithNavBar,
        ],
      ),
    ),
  );
}
