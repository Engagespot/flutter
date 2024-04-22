import 'package:engagespot_sdk/models/notificationModel.dart';

class NotificationSet {
  int? unReadCount = 0;
  List<EsMessage>? notificationMessage = [];
  NotificationSet({this.unReadCount, this.notificationMessage});
}
