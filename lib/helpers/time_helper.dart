class TimeHelper {
  static String timeFormatter(int time) {
    Duration duration = Duration(seconds: time);

    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}
