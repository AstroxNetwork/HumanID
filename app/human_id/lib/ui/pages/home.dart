import 'package:carousel_slider/carousel_slider.dart';
import 'package:human_id/exports.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home.g.dart';

String get astroxScope {
  return Uri(
    scheme: "astrox",
    host: "human",
    queryParameters: {
      "address": Settings.pk.address.toString(),
      "host": "astrox.me"
    },
  ).toString();
}

final networkProvider = StateProvider((ref) {
  return EthNetwork.selected;
});

final isVerifiedProvider = FutureProvider<bool>((ref) async {
  final network = ref.watch(networkProvider);
  final service = HumanIDService(network);
  final list = await Future.wait([
    service.isVerified(astroxScope.toString()),
    Future.delayed(const Duration(milliseconds: 1200)),
  ]);
  return list.first;
});

@swidget
@FFRoute(name: "/home")
Widget _home(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 10.0,
            top: Screen.statusBarHeight + 40.0,
          ),
          child: Row(
            children: const [
              SettingsButton(),
              spacer,
              Network(),
              spacer,
              ScanButton(),
            ],
          ),
        ),
        spacer,
        const SizedBox(
          width: double.infinity,
          child: Human(),
        ),
        const SizedBox(
          width: 230.0,
          child: Center(
            child: Text(
              "HumanID",
              style: TextStyle(
                fontSize: 40.0,
                fontFamily: FontFamily.gotham,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
          ),
        ),
        spacer,
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 40.0,
          ),
          child: SizedBox(width: double.infinity, child: VerifiedButton()),
        ),
        Ver(72.0 + Screen.navBarHeight),
      ],
    ),
  );
}

@cwidget
Widget _network(BuildContext context, WidgetRef ref) {
  final selected = ref.watch(networkProvider);
  return Material(
    color: context.theme.cardColor,
    borderRadius: BorderRadius.circular(16.0),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () {
        showSelectedNetwork(context, ref);
      },
      child: SizedBox(
        width: 180.0,
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selected.name,
              style: const TextStyle(
                fontFamily: FontFamily.gotham,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Transform.translate(
              offset: const Offset(8.0, 0),
              child: const Icon(
                Icons.arrow_drop_down_rounded,
                size: 28.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showSelectedNetwork(BuildContext context, WidgetRef ref) {
  showCupertinoModalBottomSheet(
    context: context,
    topRadius: const Radius.circular(24.0),
    builder: (context) {
      return Material(
        color: context.theme.cardColor,
        child: Container(
          height: Screen.screenHeight * 2 / 3,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Chain",
                style: TextStyle(
                  fontFamily: FontFamily.gotham,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Ver(28.0),
              ...List.generate(EthNetwork.networks.length, (index) {
                final network = EthNetwork.networks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Material(
                    color: context.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      onTap: () {
                        EthNetwork.selected = network;
                        ref.read(networkProvider.notifier).state = network;
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                network.name,
                                style: const TextStyle(
                                  fontFamily: FontFamily.gotham,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (EthNetwork.selected == network)
                              Icon(
                                Icons.check_circle_rounded,
                                color: context.theme.primaryColor,
                                size: 24.0,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

@cwidget
Widget _human(BuildContext context, WidgetRef ref) {
  final isVerified = ref.watch(isVerifiedProvider);

  Widget verified() {
    return context.theme.isDark
        ? Assets.icons.verifiedDark.svg()
        : Assets.icons.verifiedLight.svg();
  }

  Widget unverified() {
    return context.theme.isDark
        ? Assets.icons.unverifiedDark.svg()
        : Assets.icons.unverifiedLight.svg();
  }

  return isVerified.when(
    data: (v) {
      return v ? verified() : unverified();
    },
    error: (e, s) {
      return unverified();
    },
    loading: () {
      return unverified();
    },
    skipLoadingOnRefresh: false,
  );
}

@cwidget
Widget _verifiedButton(BuildContext context, WidgetRef ref) {
  final isVerified = ref.watch(isVerifiedProvider);
  Future<void> verify() async {
    final isGranted = await [Permission.camera].isGranted();
    if (isGranted) {
      final toast = showLoading();
      final list = await [
        HumanIDService().getActions(),
        Future.delayed(const Duration(milliseconds: 800))
      ].allSettled();
      toast.dismiss(showAnim: true);
      await Future.delayed(const Duration(milliseconds: 250));
      final actions = list.first.requireData;
      Log.d(actions);
      Navigator.pushNamed(
        context,
        Routes.verifying.name,
        arguments: Routes.verifying.d(
          actions: actions,
          scope: astroxScope,
        ),
      );
    } else {
      showToast("Camera permission is not granted.");
    }
  }

  Widget verifyNow() {
    return ElevatedButton(
      onPressed: verify,
      child: const Text("Verify Now"),
    );
  }

  Widget verified() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.cardColor,
        foregroundColor: context.theme.primaryColor,
      ),
      onPressed: verify,
      child: const Text("Verified"),
    );
  }

  return isVerified.when(
    data: (value) {
      return value ? verified() : verifyNow();
    },
    error: (e, s) {
      e.error(stackTrace: s);
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: HumanIDTheme.errorColor,
          backgroundColor: context.theme.cardColor,
        ),
        onPressed: () async {
          ref.invalidate(isVerifiedProvider);
        },
        child: const Text("Refresh"),
      );
    },
    loading: () {
      return TextButton(
        onPressed: () {},
        child: const SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(),
        ),
      );
    },
    skipLoadingOnRefresh: false,
  );
}

ToastFuture showLoading() {
  return showToastWidget(
    Container(
      width: double.infinity,
      height: double.infinity,
      color: gContext.theme.backgroundColor.withOpacity(0.3),
      child: Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: gContext.theme.cardColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 32.0,
            height: 32.0,
            child: CircularProgressIndicator(
              color: gContext.theme.primaryColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                gContext.theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    ),
    position: ToastPosition.center,
    duration: const Duration(days: 9999999),
  );
}

@cwidget
Widget _recommend(BuildContext context, WidgetRef ref) {
  final guides = [1, 2, 3, 4];
  final indicator = ValueNotifier(0);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 10.0,
        ),
        child: Text(
          "Events You Might Like",
          style: context.theme.textTheme.caption?.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            fontFamily: FontFamily.pTSans,
          ),
        ),
      ),
      Stack(
        children: [
          CarouselSlider(
            items: List.generate(guides.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              );
            }, growable: false),
            options: CarouselOptions(
              autoPlay: true,
              reverse: false,
              enableInfiniteScroll: true,
              aspectRatio: 315.0 / 120.0,
              viewportFraction: 1.0,
              onPageChanged: (index, _) {
                indicator.value = index;
              },
            ),
          ),
          PositionedDirectional(
            start: 50.0,
            bottom: 8.0,
            child: ValueListenableBuilder<int>(
              valueListenable: indicator,
              builder: (context, ind, child) {
                return Row(
                  children: List.generate(
                    guides.length,
                    (index) {
                      final active = index == ind;
                      return AnimatedContainer(
                        width: active ? 16.0 : 10.0,
                        height: 4.0,
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: active
                              ? context.theme.primaryColor
                              : Colors.white.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ],
  );
}

Future<T?> showPanel<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) {
  return showCustomModalBottomSheet<T>(
    context: context,
    builder: builder,
    containerWidget: (context, animation, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          child: Material(
            color: backgroundColor ?? context.theme.cardColor,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(16.0),
            child: child,
          ),
        ),
      );
    },
    expand: true,
    isDismissible: false,
    enableDrag: false,
  );
}
