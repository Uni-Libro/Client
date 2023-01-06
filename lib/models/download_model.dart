import 'package:get/get.dart';

class DownloadModel {
  final String? url;
  final String? path;
  final int? id;

  final RxDouble _progress;
  final Rx<DownloadStatus> _status;

  DownloadModel({this.url, this.path, this.id})
      : _progress = 0.0.obs,
        _status = DownloadStatus.unStarted.obs;

  double get progress => _progress.value;
  set progress(double value) => _progress.value = value;

  DownloadStatus get status => _status.value;
  set status(DownloadStatus value) => _status.value = value;

  @override
  String toString() {
    return 'DownloadModel{url: $url, path: $path, progress: $progress, status: $status}';
  }
}

enum DownloadStatus {
  unStarted,
  loading,
  downloading,
  canceled,
  completed,
  failed,
}
