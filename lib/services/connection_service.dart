import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'download_service.dart';
import 'local_api.dart';
import 'localization/strs.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();

  ConnectionService._internal() {
    _setupConnectionListener();
    checkInternetConnection()
        .then((value) => value ? null : _showConnectionError());
  }

  factory ConnectionService() {
    return _instance;
  }

  final Connectivity connectivity = Connectivity();
  final Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;

  bool isShowDialog = false;

  void _setupConnectionListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // _showConnectionError();
        Downloader().forceFailAll();
      } else {
        // if (isShowDialog) {
        //   isShowDialog = false;
        //   Get.back();
        // }
      }
    });
  }

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    // if (!isConnectedToInternet) {
    //   _showConnectionError();
    // }
  }

  Future<void> _showConnectionError() async {
    if (isShowDialog) return;
    isShowDialog = true;
    showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext buildContext) {
        return CupertinoAlertDialog(
          title: Text(
            Strs.noInternetConnection.tr,
            style: TextStyle(
                fontFamily: Get.theme.textTheme.button!.fontFamily,
                fontSize: 16),
          ),
          content: Text(
            Strs.noInternetConnectionMessage.tr,
            style: TextStyle(
                fontFamily: Get.theme.textTheme.button!.fontFamily,
                fontSize: 14),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(Strs.cancel.tr),
              onPressed: () {
                isShowDialog = false;
                // Get.back();
                SystemNavigator.pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(Strs.tryAgain.tr),
              onPressed: () {
                isShowDialog = false;
                Get.back();
                checkInternetConnection().then((value) =>
                    value ? LocalAPI().rebuild() : _showConnectionError());
              },
            ),
          ],
        );
      },
    );
  }
}
