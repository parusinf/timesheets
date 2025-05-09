/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time:  2019-06-26 13:17
*/
import '../../pull_to_refresh.dart';
import 'package:flutter/widgets.dart';

/// enable header link other header place outside the viewport
class LinkHeader extends RefreshIndicator {
  /// the key that widget outside viewport indicator
  final Key linkKey;

  const LinkHeader(
      {Key? key,
      required this.linkKey,
      double height = 0.0,
      RefreshStyle? refreshStyle,
      Duration completeDuration = const Duration(milliseconds: 200)})
      : super(
            height: height,
            refreshStyle: refreshStyle,
            completeDuration: completeDuration,
            key: key);

  @override
  State<StatefulWidget> createState() {
    return _LinkHeaderState();
  }
}

class _LinkHeaderState extends RefreshIndicatorState<LinkHeader> {
  @override
  void resetValue() {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .resetValue();
  }

  @override
  Future<void> endRefresh() {
    return ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .endRefresh();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .onOffsetChange(offset);
  }

  @override
  Future<void> readyToRefresh() {
    return ((widget.linkKey as GlobalKey).currentState as RefreshProcessor)
        .readyToRefresh();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return Container();
  }
}

/// enable footer link other footer place outside the viewport
class LinkFooter extends LoadIndicator {
  /// the key that widget outside viewport indicator
  final Key linkKey;

  const LinkFooter(
      {Key? key,
      required this.linkKey,
      double height = 0.0,
      LoadStyle loadStyle = LoadStyle.showAlways})
      : super(height: height, loadStyle: loadStyle, key: key);

  @override
  State<StatefulWidget> createState() {
    return _LinkFooterState();
  }
}

class _LinkFooterState extends LoadIndicatorState<LinkFooter> {
  @override
  void onModeChange(LoadStatus? mode) {
    ((widget.linkKey as GlobalKey).currentState as LoadingProcessor)
        .onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    ((widget.linkKey as GlobalKey).currentState as LoadingProcessor)
        .onOffsetChange(offset);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    return Container();
  }
}
