String fromNow(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  final seconds = diff.inSeconds;
  final years = (seconds / 31536000).floor();
  final months = (seconds / 2592000).floor();
  final days = (seconds / 86400).floor();

  if (days > 548) {
    return '$years years ago';
  }
  if (days >= 320 && days <= 547) {
    return 'a year ago';
  }
  if (days >= 45 && days <= 319) {
    return '$months months ago';
  }
  if (days >= 26 && days <= 45) {
    return 'a month ago';
  }

  final hours = (seconds / 3600).floor();

  if (hours >= 36 && days <= 25) {
    return '$days days ago';
  }
  if (hours >= 22 && hours <= 35) {
    return 'a day ago';
  }

  final minutes = (seconds / 60).floor();

  if (minutes >= 90 && hours <= 21) {
    return '$hours hours ago';
  }
  if (minutes >= 45 && minutes <= 89) {
    return 'an hour ago';
  }
  if (seconds >= 90 && minutes <= 44) {
    return '$minutes minutes ago';
  }
  if (seconds >= 45 && seconds <= 89) {
    return 'a minute ago';
  }
  if (seconds >= 0 && seconds <= 45) {
    return 'a few seconds ago';
  }
  return '$years years ago';
}
