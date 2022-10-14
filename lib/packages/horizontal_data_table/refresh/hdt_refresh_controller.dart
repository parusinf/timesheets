import 'package:timesheets/packages/horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

class HDTRefreshController {
  final List<RefreshController> _refreshControllers = [];
  List<RefreshController> get refreshControllers => _refreshControllers;

  void setRefreshController(RefreshController? refreshController) {
    if (refreshController != null &&
        !_refreshControllers.contains(refreshController)) {
      _refreshControllers.add(refreshController);
    }
  }

  void requestRefresh([
    RefreshController? skipThisController,
  ]) {
    for (var element in _refreshControllers) {
      if (element != skipThisController) {
        element.requestRefresh();
      }
    }
  }

  void refreshCompleted() {
    for (var element in _refreshControllers) {
      element.refreshCompleted();
    }
  }

  void refreshFailed() {
    for (var element in _refreshControllers) {
      element.refreshFailed();
    }
  }

  void requestLoading([RefreshController? skipThisController]) {
    for (var element in _refreshControllers) {
      if (element != skipThisController) {
        element.requestLoading();
      }
    }
  }

  void loadComplete() {
    for (var element in _refreshControllers) {
      element.loadComplete();
    }
  }

  void loadNoData() {
    for (var element in _refreshControllers) {
      element.loadNoData();
    }
  }

  void loadFailed() {
    for (var element in _refreshControllers) {
      element.loadFailed();
    }
  }
}
