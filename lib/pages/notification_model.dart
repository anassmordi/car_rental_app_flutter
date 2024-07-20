class Notification {
  final int id;
  final String message;
  final String timestamp;
  final bool seen;
  final int? bookingId;
  final String? bookingStatus;

  Notification({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.seen,
    this.bookingId,
    this.bookingStatus,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      message: json['message'],
      timestamp: json['timestamp'],
      seen: json['seen'],
      bookingId: json['bookingId'],
      bookingStatus: json['bookingStatus'],
    );
  }
}
