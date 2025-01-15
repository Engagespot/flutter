class NotificationModel {
  int? unSeenCount;
  Pagination? pagination;
  List<EsMessage>? esMessage;

  NotificationModel({this.unSeenCount, this.pagination, this.esMessage});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    unSeenCount = json['unreadCount'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      esMessage = <EsMessage>[];
      json['data'].forEach((v) {
        esMessage!.add(EsMessage.fromJson(v));
      });
    }
  }
}

class Pagination {
  int? totalCount;

  Pagination({this.totalCount});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class EsMessage {
  int? id;
  String? title;
  String? message;
  String? icon;
  String? url;
  String? createdAt;
  String? seenAt;
  String? clickedAt;
  Map<String, dynamic>? data;

  EsMessage(
      {this.id,
      this.title,
      this.message,
      this.icon,
      this.url,
      this.createdAt,
      this.seenAt,
      this.clickedAt,
      this.data});

  EsMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    message ??= json["description"];
    icon = json['icon'];
    url = json['url'];
    createdAt = json['createdAt'];
    createdAt ??= json["created_at"];
    seenAt = json['seenAt'];
    clickedAt = json['clickedAt'];
    data = json["data"];
  }
}
