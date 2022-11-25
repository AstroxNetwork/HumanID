import 'package:human_id/exports.dart';

part 'verified.g.dart';

@swidget
@FFRoute(name: "/verified")
Widget _verified(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        spacer,
        Assets.icons.success.svg(width: 100.0),
        const Text(
          "Success!",
          style: TextStyle(
            fontFamily: FontFamily.gotham,
            fontSize: 40.0,
            height: 1.0,
          ),
        ),
        const Ver(4.0),
        Text(
          'You have been verified.',
          style: context.theme.textTheme.caption?.copyWith(
            fontSize: 14.0,
          ),
        ),
        spacer,
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context,
                    (route) => route.settings.name == Routes.home.name);
              },
              child: Text(context.l10n.confirmButton),
            ),
          ),
        ),
        sizedHeight36WithNavBar,
      ],
    ),
  );
}
