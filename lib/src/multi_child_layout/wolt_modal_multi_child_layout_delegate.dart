import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// A custom [MultiChildLayoutDelegate] that handles the layout of the modal and barrier content within [WoltScrollableModalSheet].
class WoltModalMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  /// The maximum height percentage of the content relative to the available size.
  final double maxPageHeight;

  /// The minimum height percentage of the content relative to the available size.
  final double minPageHeight;

  final double minDialogWidth;

  final double maxDialogWidth;

  /// The layout identifier for the content.
  final String contentLayoutId;

  /// The layout identifier for the barrier.
  final String barrierLayoutId;

  /// The type of the scrollable modal.
  final WoltModalType modalType;

  /// Creates a [WoltModalMultiChildLayoutDelegate].
  ///
  /// [maxPageHeight] represents the maximum page height in the range of [0, 1] relative to the available size.
  ///
  /// [minPageHeight] represents the minimum page height in the range of [0, 1] relative to the available size.
  ///
  /// [contentLayoutId] represents the layout identifier for the content.
  ///
  /// [barrierLayoutId] represents the layout identifier for the barrier.
  ///
  /// [modalType] represents the type of the scrollable modal.
  WoltModalMultiChildLayoutDelegate({
    required this.maxPageHeight,
    required this.minPageHeight,
    required this.contentLayoutId,
    required this.barrierLayoutId,
    required this.modalType,
    required this.minDialogWidth,
    required this.maxDialogWidth,
  });

  @override
  void performLayout(Size size) {
    print('maxPageHeight: $maxPageHeight');
    print('minPageHeight: $minPageHeight');
    final modalWidth = modalType.modalContentWidth(
      size.width,
      minDialogWidth: minDialogWidth,
      maxDialogWidth: maxDialogWidth,
    );
    layoutChild(
      barrierLayoutId,
      BoxConstraints(maxWidth: size.width, maxHeight: size.height),
    );
    final modalHeight = layoutChild(
      contentLayoutId,
      BoxConstraints(
        minHeight: 100,
        maxHeight: 200,
        maxWidth: modalWidth,
        minWidth: modalWidth,
      ),
    ).height;

    /// Position Modal Content
    positionChild(
      contentLayoutId,
      Offset(
        modalType.xOffsetOfModalContent(
          size.width,
          maxDialogWidth: maxDialogWidth,
          minDialogWidth: minDialogWidth,
        ),
        modalType.yOffsetOfModalContent(size.height, modalHeight),
      ),
    );

    /// Position Barrier
    positionChild(barrierLayoutId, Offset.zero);
  }

  /// Determines whether the delegate should re-layout the children based on changes in [modalType].
  @override
  bool shouldRelayout(covariant WoltModalMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.modalType != modalType ||
        oldDelegate.minDialogWidth != minDialogWidth ||
        oldDelegate.maxDialogWidth != maxDialogWidth ||
        oldDelegate.maxPageHeight != maxPageHeight ||
        oldDelegate.minPageHeight != minPageHeight;
  }
}
