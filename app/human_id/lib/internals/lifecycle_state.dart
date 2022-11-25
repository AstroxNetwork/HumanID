import 'package:flutter/material.dart';

final routeObserver = RouteObserver<Route>();

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onPause();
        break;
    }
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  @mustCallSuper
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didPush() {
    super.didPush();
    onResume();
  }

  @override
  @mustCallSuper
  void didPopNext() {
    super.didPopNext();
    onResume();
  }

  @override
  @mustCallSuper
  void didPop() {
    super.didPop();
    onPause();
  }

  @override
  @mustCallSuper
  void didPushNext() {
    super.didPushNext();
    onPause();
  }

  void onPause() {}

  void onResume() {}
}

abstract class LifecycleRouteState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  @mustCallSuper
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didPush() {
    super.didPush();
    onResume();
  }

  @override
  @mustCallSuper
  void didPopNext() {
    super.didPopNext();
    onResume();
  }

  @override
  @mustCallSuper
  void didPop() {
    super.didPop();
    onPause();
  }

  @override
  @mustCallSuper
  void didPushNext() {
    super.didPushNext();
    onPause();
  }

  void onPause() {}

  void onResume() {}
}

abstract class LifecycleAppState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onPause();
        break;
    }
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  @mustCallSuper
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onPause() {}

  void onResume() {}
}
