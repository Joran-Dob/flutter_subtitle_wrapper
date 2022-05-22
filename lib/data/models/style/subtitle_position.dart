const _defaultSubtitleBottomPosition = 50.0;

class SubtitlePosition {
  final double left;
  final double right;
  final double? top;
  final double bottom;

  const SubtitlePosition({
    this.left = 0.0,
    this.right = 0.0,
    this.top,
    this.bottom = _defaultSubtitleBottomPosition,
  });
}
