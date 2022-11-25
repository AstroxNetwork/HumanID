import 'package:human_id/exports.dart';

import 'home.dart';

part 'failed.g.dart';

@swidget
@FFRoute(name: "/failed")
Widget _failed(BuildContext context, String scope) {
  return Scaffold(
    body: Column(
      children: [
        spacer,
        Assets.icons.failed.svg(width: 100.0),
        const Text(
          "Failed!",
          style: TextStyle(
            fontFamily: FontFamily.gotham,
            fontSize: 40.0,
            height: 1.0,
          ),
        ),
        const Ver(4.0),
        Text(
          'Please retry.',
          style: context.theme.textTheme.caption?.copyWith(
            fontSize: 14.0,
          ),
        ),
        spacer,
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.settings.name == Routes.home.name,
                      );
                    },
                    child: Text(context.l10n.cancelButton),
                  ),
                ),
                const Hor(16.0),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      final toast = showLoading();
                      final actions = await [
                        HumanIDService().getActions(),
                        Future.delayed(const Duration(milliseconds: 800))
                      ].allSettled();
                      toast.dismiss(showAnim: true);
                      await Future.delayed(const Duration(milliseconds: 250));
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.verifying.name,
                        (route) => route.settings.name == Routes.home.name,
                        arguments: Routes.verifying
                            .d(actions: actions.first.data, scope: scope),
                      );
                    },
                    child: Text(context.l10n.retryButton),
                  ),
                ),
              ],
            ),
          ),
        ),
        sizedHeight36WithNavBar,
      ],
    ),
  );
}
