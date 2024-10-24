import 'package:flutter/material.dart';

import '../SignIn.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  bool showTimes;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    Key? key,
    required this.duration,
    this.showTimes = true,
    required this.position,
    required this.bufferedPosition,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positionValue = position.inMilliseconds.toDouble();
    final maxValue = duration.inMilliseconds.toDouble();
    // Set a safe default value if maxValue is zero or negative
    final validMaxValue = maxValue > 0 ? maxValue : 1.0;

    return
      // Padding(
      // padding: EdgeInsets.only(
      //     left: !showTimes ? 0 : 15, right: !showTimes ? 0 : 15),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     showTimes
      //         ? Text(
      //       _formatDuration(position),
      //       style:
      //       const TextStyle(fontSize: 12, color: yellowColor),
      //     )
      //         : const SizedBox.shrink(),
          Slider(
            min: 0.0,
            max: validMaxValue,
            value: positionValue.clamp(0.0, validMaxValue),
            activeColor: yellowColor,
            thumbColor: yellowColor,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              if (onChangeEnd != null) {
                onChangeEnd!(Duration(milliseconds: value.round()));
              }
            },
          );
    //       showTimes
    //           ? Text(
    //         _formatDuration(duration),
    //         style:
    //         const TextStyle(fontSize: 12, color: yellowColor),
    //       )
    //           : const SizedBox.shrink(),
    //     ],
    //   ),
    // );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}