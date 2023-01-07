import 'dart:convert';
import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uni_libro/services/connection_service.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../models/download_model.dart';
import '../utils/show_toast.dart';
import 'local_api.dart';
import 'localization/strs.dart';

class Downloader {
  static final Downloader _instance = Downloader._initialize();

  Downloader._initialize();

  factory Downloader() {
    return _instance;
  }

  final Map<int, MapEntry<DownloadModel, DownloaderCore>> dQueue = {};
  late final String _baseStorePath;

  Future<void> init() async {
    _baseStorePath = (await path.getExternalStorageDirectory())!.path;
  }

  Future<void> getFile(DownloadModel model) async {
    final file = File('$_baseStorePath/${model.id!}.epub');
    if (file.existsSync() ? file.lengthSync() > 0 : false) {
      openFile(model);
    } else {
      final isConnect = await ConnectionService().checkInternetConnection();
      if (isConnect) {
        await download(model);
      } else {
        showSnackbar(Strs.downloadFailedError.tr,
            messageType: MessageType.error);
      }
    }
  }

  Future<void> download(DownloadModel model) async {
    model.status = DownloadStatus.loading;

    final utils = DownloaderUtils(
      progress: ProgressImplementation(),
      file: File('$_baseStorePath/${model.id!}.epub'),
      onDone: () {
        model.status = DownloadStatus.completed;
        dQueue.remove(model.id!);
      },
      deleteOnCancel: true,
      progressCallback: (count, total) {
        model.progress = count / total * 100;
        model.status = DownloadStatus.downloading;
      },
    );

    final downloader = await Flowder.download(model.url!, utils);

    dQueue[model.id!] = MapEntry(model, downloader);
  }

  Future<void> cancel(DownloadModel model) async {
    try {
      await dQueue[model.id!]!.value.cancel();
      model.status = DownloadStatus.canceled;
      dQueue.remove(model.id!);
    } catch (e) {}
  }

  Future<void> forceFailAll() async {
    Downloader().dQueue.forEach((key, value) {
      value.key.status = DownloadStatus.failed;
      cancel(value.key);
    });
  }

  Future<void> openFile(DownloadModel model) async {
    try {
      VocsyEpub.setConfig(
        themeColor: Get.theme.colorScheme.primary,
        scrollDirection: EpubScrollDirection.HORIZONTAL,
        allowSharing: false,
        enableTts: false,
        nightMode: false,
      );

      final lastLocator = LocalAPI().getLastBookLocator(model.id!);

      VocsyEpub.open(
        '$_baseStorePath/${model.id!}.epub',
        lastLocation: lastLocator == null
            ? null
            : EpubLocator.fromJson(jsonDecode(lastLocator)),
      );

      VocsyEpub.locatorStream.listen((locator) async {
        await LocalAPI().setLastBookLocator(model.id!, locator);
      });
    } on Exception catch (e) {
      final file = File('$_baseStorePath/${model.id!}.epub');
      if (file.existsSync()) {
        file.deleteSync();
      }
      getFile(model);
    }
  }
}
