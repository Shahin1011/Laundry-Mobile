class NotificationsModel {
  final String? status;
  final Data? data;

  NotificationsModel({this.status, this.data});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      status: json['status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class Data {
  final List<Notifications>? notifications;
  final int? totalCount;
  final int? page;
  final int? limit;
  final int? totalPages;

  Data({
    this.notifications,
    this.totalCount,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      notifications: json['notifications'] != null
          ? List<Notifications>.from(
          json['notifications'].map((x) => Notifications.fromJson(x)))
          : null,
      totalCount: json['totalCount'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.map((x) => x.toJson()).toList(),
      'totalCount': totalCount,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

class Notifications {
  final String? id;
  final String? receiver;
  final String? receiverRole;
  final String? orderId;
  final String? type;
  final String? title;
  final String? message;
  final String? previousStatus;
  final String? newStatus;
  final bool? isRead;
  final String? platform;
  final String? channel;
  final String? createdAt;
  final String? updatedAt;
  final int? version;

  Notifications({
    this.id,
    this.receiver,
    this.receiverRole,
    this.orderId,
    this.type,
    this.title,
    this.message,
    this.previousStatus,
    this.newStatus,
    this.isRead,
    this.platform,
    this.channel,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['_id'],
      receiver: json['receiver'],
      receiverRole: json['receiverRole'],
      orderId: json['orderId'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      previousStatus: json['previousStatus'],
      newStatus: json['newStatus'],
      isRead: json['isRead'],
      platform: json['platform'],
      channel: json['channel'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'receiver': receiver,
      'receiverRole': receiverRole,
      'orderId': orderId,
      'type': type,
      'title': title,
      'message': message,
      'previousStatus': previousStatus,
      'newStatus': newStatus,
      'isRead': isRead,
      'platform': platform,
      'channel': channel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }
}
