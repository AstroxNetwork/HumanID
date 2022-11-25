import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:human_id/exports.dart';
@FFArgumentImport()
import 'package:image_picker/image_picker.dart';
@FFArgumentImport()
import 'package:mlkit_scan_plugin/mlkit_scan_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';

@FFRoute(name: '/scan', argumentImports: ["import '../ui/pages/scan.dart';"])
class QRScan extends StatefulWidget {
  const QRScan({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final ScanManager manager;

  @override
  State<QRScan> createState() => QRScanState();
}

class QRScanState extends LifecycleState<QRScan>
    with ScanFlashlightMixin, ScanFocusListenerMixin, ScanNotificationMixin {
  /// 当前的扫码模式
  final ScanType scanType = ScanType.qrCode;

  /// 扫描区域左右间隔
  final double scanPaddingHorizontal = Screen.screenWidth / 10;

  late final double _scanPadding = 48;
  late final double _scanRectSize = math.max(
    Screen.screenWidth - _scanPadding * 2,
    280,
  );
  late final double _centerPosition =
      Screen.screenHeight / 2 - _scanRectSize / 2;

  Rect get rect {
    return Rect.fromLTWH(
      _scanPadding,
      _centerPosition,
      _scanRectSize,
      _scanRectSize,
    );
  }

  final Rect _fullscreen = Rect.fromLTWH(
    0,
    0,
    Screen.screenWidth,
    Screen.screenHeight,
  );

  /// 平台界面
  late final Widget _scanView;

  /// 接收扫描结果的回调监听
  late ScanResultCallback resultListener;

  List<Widget>? _children;

  final ValueNotifier<bool> _flashlightOpened = ValueNotifier(false);

  @override
  void onResume() {
    if (ScanPlugin.isScanningPaused) {
      ScanPlugin.resumeScan();
    }
    widget.manager.onResume();
  }

  @override
  void onPause() {
    widget.manager.onPause();
    if (!ScanPlugin.isScanningPaused) {
      ScanPlugin.pauseScan();
    }
  }

  @override
  void initState() {
    super.initState();
    _setResultListener();
    _scanView = ScanView(
      scanType: scanType,
      scanRect: _fullscreen,
      resultListener: resultListener,
    );
  }

  @override
  void dispose() {
    widget.manager.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _setResultListener();
  }

  void _setResultListener() {
    resultListener = (ScanResult result) async {
      if (!mounted) {
        return;
      }
      result.debug();
      try {
        final ok = await widget.manager.accept(this, result);
        final state = ok.value.state;
        if (state == ScanState.processing) {
          _children = ok.value.children;
          safeSetState(() {});
        } else if (state == ScanState.processed) {
          if (mounted) {
            Navigator.pop(context, ok);
          }
        }
      } catch (e, s) {
        e.error(stackTrace: s);
      } finally {
        _restartScan();
      }
    };
  }

  void _restartScan() {
    Future.delayed(SCAN_INTERVAL).then((_) {
      if (mounted) {
        ScanPlugin.switchScanType(ScanType.qrCode, rect: _fullscreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _scanView),
        PositionedDirectional(
          start: _scanPadding,
          end: _scanPadding,
          top: _centerPosition,
          bottom: _centerPosition,
          child: Scanner(color: context.theme.primaryColor),
        ),
        focusWrapper(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 30.0,
                  ),
                  margin: const EdgeInsets.only(top: 30.0),
                  child: const BackButton(),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsetsDirectional.only(
                      bottom: Screen.navBarHeight + 36.0,
                    ),
                    child: _buildButtons(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        notificationOverlay(context),
        ...?_children,
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _flashlightOpened,
              builder: (_, opened, __) {
                return Material(
                  color: opened
                      ? context.theme.primaryColor
                      : context.theme.cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (_flashlightOpened.value) {
                        ScanPlugin.closeFlashlight();
                      } else {
                        ScanPlugin.openFlashlight();
                      }
                      _flashlightOpened.value = !_flashlightOpened.value;
                    },
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Center(
                        child: opened
                            ? Assets.icons.qrscan.flashlightBlack
                                .svg(height: 20.0)
                            : Assets.icons.qrscan.flashlightWhite.svg(
                                width: 20.0,
                                color: context.theme.textTheme.bodyText1?.color,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Ver(4.0),
            Text(
              context.l10n.flashlightButton,
              style: const TextStyle(
                color: HumanIDTheme.captionTextColorDark,
                fontSize: 11.0,
                fontFamily: FontFamily.pTSans,
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async {
                  final grant = await [Permission.storage].isGranted();
                  if (!grant) {
                    return;
                  }
                  final imagePicker = ImagePicker();
                  final xFile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    requestFullMetadata: false,
                    imageQuality: 100,
                  );
                  if (xFile != null) {
                    final list = await ScanPlugin.scanFromFile(
                      xFile.path,
                      [BarcodeFormat.QR_CODE],
                    );
                    if (list.isEmpty) {
                      showToast(context.l10n.invalidQrCodePromptText);
                      return;
                    }
                    final code = list.firstWhereOrNull((e) {
                      final uri = Uri.tryParse(e.value);
                      if (uri == null) {
                        return false;
                      }
                      if (uri.scheme == "astrox" && uri.host == 'human') {
                        return true;
                      }
                      return false;
                    });
                    if (code == null) {
                      showToast(context.l10n.qrCodeErrorInvalid);
                      return;
                    }
                    if (mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.scanFile.name,
                        arguments: Routes.scanFile.d(
                          xFile: xFile,
                          barcode: code,
                        ),
                      );
                    }
                  }
                },
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: Center(
                    child: Assets.icons.qrscan.gallery.svg(
                      width: 20.0,
                      color: context.theme.textTheme.bodyText1?.color,
                    ),
                  ),
                ),
              ),
            ),
            const Ver(4),
            Text(
              context.l10n.galleryButton,
              style: const TextStyle(
                color: HumanIDTheme.captionTextColorDark,
                fontSize: 11.0,
                fontFamily: FontFamily.pTSans,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

@FFRoute(name: '/scan/file')
class AnalyzingQR extends StatelessWidget {
  const AnalyzingQR({
    Key? key,
    required this.xFile,
    required this.barcode,
  }) : super(key: key);
  final XFile xFile;
  final Barcode barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHeader(context),
                _buildBody(context),
              ],
            ),
          ),
          _buildBottom(context)
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsetsDirectional.only(
          start: 30.0,
          end: 30.0,
          top: 30.0,
          bottom: 120.0 + Screen.navBarHeight,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.file(File(xFile.path)),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SimpleSliverPinnedHeader(
      maxExtent: Screen.statusBarHeight + 96.0,
      minExtent: Screen.statusBarHeight + 70.0,
      builder: (context, maxOffset, offsetRatio) {
        return const Padding(
          padding: EdgeInsetsDirectional.only(bottom: 10.0),
          child: BackButton(useCardColor: true),
        );
      },
    );
  }

  Future<void> _handleBarcode(BuildContext context, Barcode code) async {
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
      arguments:
          Routes.verifying.d(actions: actions.first.data, scope: code.value),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: bottomBarPadding,
      decoration: bottomBarDecoration(context),
      child: ElevatedButton(
        onPressed: () {
          _handleBarcode(context, barcode);
        },
        child: Text(context.l10n.confirmButton),
      ),
    );
  }
}

final bottomBarPadding = EdgeInsetsDirectional.only(
  start: 24.0,
  end: 24.0,
  bottom: 24.0 + Screen.navBarHeight,
  top: 16.0,
);

BoxDecoration bottomBarDecoration(
  BuildContext context, {
  Color? backgroundColor,
}) {
  backgroundColor ??= context.theme.backgroundColor;
  return BoxDecoration(
    color: backgroundColor,
    boxShadow: [
      BoxShadow(
        color: backgroundColor,
        blurRadius: 10.0,
        spreadRadius: 10.0,
        offset: const Offset(0.0, -10.0),
      ),
    ],
  );
}

class Scanner extends StatelessWidget {
  const Scanner({
    Key? key,
    this.duration = const Duration(milliseconds: 1500),
    this.color = Colors.blue,
    this.lineWidth = 30,
    this.lineHeight = 4,
    this.scannerHeight = 50,
  }) : super(key: key);

  final Duration duration;
  final Color color;
  final double lineWidth;
  final double lineHeight;
  final double scannerHeight;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanRectPainter(
        color: color,
        lineWidth: lineWidth,
        lineHeight: lineHeight,
      ),
      child: Padding(
        padding: EdgeInsets.all(lineHeight * 2),
        child: _Scanner(
          duration: duration,
          color: color,
          height: scannerHeight,
        ),
      ),
    );
  }
}

class _Scanner extends StatefulWidget {
  const _Scanner({
    Key? key,
    required this.duration,
    required this.color,
    required this.height,
  }) : super(key: key);
  final Duration duration;
  final Color color;
  final double height;

  @override
  State<_Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<_Scanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this)
    ..duration = widget.duration
    ..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

  late final Animation<double> _animation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(_controller);

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) => CustomPaint(
        painter: _ScannerPainter(
          color: widget.color,
          height: widget.height,
          ratio: _animation.value,
        ),
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({
    required this.color,
    required this.height,
    required this.ratio,
  });

  final double height;
  final Color color;
  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..isAntiAlias = true;
    final Rect rect =
        Offset(0, size.height * ratio) & Size(size.width, height * (1 - ratio));
    paint.shader = LinearGradient(
      colors: <Color>[color.withOpacity(.05), color.withOpacity(1 - ratio)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.height != height ||
        oldDelegate.ratio != ratio;
  }
}

class _ScanRectPainter extends CustomPainter {
  _ScanRectPainter({
    required this.color,
    required this.lineWidth,
    required this.lineHeight,
  });

  final Color color;
  final double lineWidth;
  final double lineHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = lineHeight
      ..style = PaintingStyle.fill;

    // draw horizontal line
    // tl
    final double halfLineHeight = lineHeight / 2;
    canvas.drawLine(
      Offset.zero,
      Offset(lineWidth, 0),
      paint,
    );
    // tr
    canvas.drawLine(
      Offset(size.width - lineWidth, 0),
      Offset(size.width, 0),
      paint,
    );
    // bl
    canvas.drawLine(
      Offset(halfLineHeight, size.height - lineHeight),
      Offset(lineWidth, size.height - lineHeight),
      paint,
    );
    // br
    canvas.drawLine(
      Offset(size.width - lineWidth, size.height - lineHeight),
      Offset(size.width, size.height - lineHeight),
      paint,
    );

    // draw vertical line
    // tl
    canvas.drawLine(
      Offset(halfLineHeight, 0),
      Offset(halfLineHeight, lineWidth),
      paint,
    );
    // tr
    canvas.drawLine(
      Offset(size.width - halfLineHeight, 0),
      Offset(size.width - halfLineHeight, lineWidth),
      paint,
    );
    // bl
    canvas.drawLine(
      Offset(halfLineHeight, size.height - lineWidth),
      Offset(halfLineHeight, size.height - halfLineHeight),
      paint,
    );
    // br
    canvas.drawLine(
      Offset(size.width - halfLineHeight, size.height - lineWidth),
      Offset(size.width - halfLineHeight, size.height - halfLineHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

@immutable
class QR<T> {
  const QR({this.handler, required this.value});

  final ScanHandler<T>? handler;
  final ScanDat<T> value;
}

mixin _Timeout on ScanManager {
  late Timer _timeoutTimer;
  Timer? _showTimer;
  bool _disposed = false;
  bool _active = true;

  @override
  void onInit() {
    super.onInit();
    _active = true;
    _timeoutTimer = _newTimeoutTimer();
  }

  void onScanSuccess() {
    if (_disposed) {
      return;
    }
    _timeoutTimer.cancel();
    _showTimer?.cancel();
    _timeoutTimer = _newTimeoutTimer();
  }

  Timer _newTimeoutTimer() {
    return Timer(const Duration(seconds: 10), () {
      if (!_active) {
        return;
      }
      _showTimer?.cancel();
      _showTimer = _newShowTimer();
      showToast(gl10n.qrCodeErrorResolve);
    });
  }

  Timer _newShowTimer() {
    return Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!_active) {
        return;
      }
      showToast(gl10n.qrCodeErrorResolve);
    });
  }

  @override
  void dispose() {
    _active = false;
    _disposed = true;
    _timeoutTimer.cancel();
    _showTimer?.cancel();
    super.dispose();
  }

  @override
  void onPause() {
    _active = false;
    super.onPause();
  }

  @override
  void onResume() {
    _active = true;
    super.onResume();
  }
}

mixin _NotSupported on ScanManager {
  DateTime? _last;

  void notSupported() {
    if (_last == null) {
      showToast(gl10n.qrCodeErrorInvalid);
      _last = DateTime.now();
    } else {
      final DateTime expired = _last!.add(const Duration(seconds: 5));
      if (expired.isBefore(DateTime.now())) {
        showToast(gl10n.qrCodeErrorInvalid);
        _last = DateTime.now();
      }
    }
  }
}

abstract class ScanManager implements ScanLifecycle {
  factory ScanManager(Set<ScanHandler> handlers) {
    return _ScanManagerImpl(handlers);
  }

  ScanManager._(this.handlers) {
    onInit();
  }

  final Set<ScanHandler> handlers;

  FutureOr<QR> accept(QRScanState state, ScanResult result);

  @override
  @mustCallSuper
  void dispose() {
    for (final handler in handlers) {
      handler.dispose();
    }
  }

  @override
  @mustCallSuper
  void onPause() {}

  @override
  @mustCallSuper
  void onResume() {}

  @override
  @mustCallSuper
  void onInit() {}
}

class _ScanManagerImpl extends ScanManager with _Timeout, _NotSupported {
  _ScanManagerImpl(Set<ScanHandler> handlers) : super._(handlers);

  @override
  Future<QR> accept(QRScanState state, ScanResult result) async {
    for (final handler in handlers) {
      final dat = await handler.accept(state, result);
      final st = dat.state;
      if (st == ScanState.mismatched) {
        continue;
      }
      onScanSuccess();
      return QR(handler: handler, value: dat);
    }
    notSupported();
    return QR(value: ScanDat.mismatched());
  }
}

abstract class ScanLifecycle {
  void onInit();

  void onPause();

  void onResume();

  void dispose();
}

enum ScanState {
  mismatched,
  processing,
  processed,
  ;
}

class ScanDat<T> {
  factory ScanDat.mismatched() => ScanDat._(ScanState.mismatched);

  factory ScanDat.processing([List<Widget>? children]) =>
      ScanDat._(ScanState.processing, children: children);

  factory ScanDat.processed(T payload) =>
      ScanDat._(ScanState.processed, payload: payload);

  ScanDat._(this.state, {this.payload, this.children});

  final T? payload;
  final List<Widget>? children;
  final ScanState state;
}

abstract class ScanHandler<T> implements ScanLifecycle {
  ScanHandler() {
    onInit();
  }

  @override
  @mustCallSuper
  void onInit() {}

  @override
  @mustCallSuper
  void onResume() {}

  @override
  @mustCallSuper
  void onPause() {}

  @override
  @mustCallSuper
  void dispose() {}

  FutureOr<ScanDat> accept(QRScanState state, ScanResult result) async {
    if (result.status == ScanResultStatus.succeed && result.code != null) {
      return await acceptSuccess(state, result.code!);
    }
    return ScanDat.mismatched();
  }

  FutureOr<ScanDat> acceptSuccess(QRScanState state, String text);
}

abstract class AstroXSchemeHandler<T> extends ScanHandler<T> {
  @override
  FutureOr<ScanDat> acceptSuccess(QRScanState state, String text) {
    final uri = Uri.tryParse(text);
    if (uri == null) {
      return ScanDat.mismatched();
    }
    if (uri.scheme == 'astrox') {
      return acceptAstroX(state, uri);
    }
    return ScanDat.mismatched();
  }

  FutureOr<ScanDat> acceptAstroX(QRScanState state, Uri uri);
}

class HumanHandler extends AstroXSchemeHandler<Uri> {
  @override
  FutureOr<ScanDat> acceptAstroX(QRScanState state, Uri uri) {
    if (uri.host == 'human') {
      return ScanDat.processed(uri);
    }
    return ScanDat.mismatched();
  }
}
