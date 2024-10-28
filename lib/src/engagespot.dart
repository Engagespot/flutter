part of '/engagespot_sdk.dart';

String? _apiKey;
//String? _apiSecret;
bool _isDebug = false;
String? _userID;
String _baseUrl = "https://api.engagespot.co/";
String _version = "v3/";

class Engagespot {
  static void initSdk({required String apiKey, isDebug = false}) {
    _apiKey = apiKey;
    // _apiSecret = apiSecret;
    _isDebug = isDebug;

    if (isDebug) {
      log("SDK key initalised -- > Successfully");
    }
    _getUserID();
  }

  static markAsRead() async {
    await post(
      Uri.parse(
          _baseUrl + _version + "notifications/markAllNotificationsAsSeen"),
      headers: {
        "X-ENGAGESPOT-API-KEY": _apiKey!,
        "X-ENGAGESPOT-USER-ID": _userID!,
        "X-ENGAGESPOT-DEVICE-ID": "123"
      },
    );
  }

  static clearAllNotification() async {
    await post(
      Uri.parse(
          _baseUrl + _version + "notifications/markAllNotificationsAsDeleted"),
      headers: {
        "X-ENGAGESPOT-API-KEY": _apiKey!,
        "X-ENGAGESPOT-USER-ID": _userID!,
        "X-ENGAGESPOT-DEVICE-ID": "123"
      },
    );
  }

  static RegisterFCM(String Token) async {
    try {
      final Response = await put(Uri.parse(_baseUrl + _version + "profile"),
          headers: {
            "X-ENGAGESPOT-API-KEY": _apiKey!,
            "X-ENGAGESPOT-USER-ID": _userID!,
            "Content-Type": "application/json"
          },
          body: json.encode({
            "fcm": {
              "tokens": [Token]
            }
          }));

      log(Response.body);
      if (Response.statusCode == 200) {
        if (_isDebug) {
          log("FCM Register -- > Successfully ");
        }
      } else {
        if (_isDebug) {
          if (_apiKey == null) log("API key is not initalised");
          if (_userID == null) log("User not logined");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static ListernMessage(
      {required void onMessage(EsMessage es),
      required void onReadAll()}) async {
    try {
      if (_userID != null && _apiKey != null) {
        IO.Socket socket = IO.io(
            'https://api.engagespot.com?apiKey=$_apiKey&userId=$_userID',
            OptionBuilder().setTransports(['websocket']).build());
        socket.onConnect((data) {
          if (_isDebug) {
            log("Notication Listerner --> Initalised");
          }
        });
        socket.onDisconnect((data) {
          if (_isDebug) {
            log("Notication Listerner --> Disconnected");
          }
        });

        socket.io.connect();

        socket.on('NEW_NOTIFICATION', (data) {
          EsMessage esMessage = EsMessage.fromJson(data["notification"]);
          onMessage(esMessage);
        });
        socket.on('NOTIFICATION_UNREAD_COUNT', (data) {
          onReadAll();
        });
      } else {
        if (_isDebug) {
          if (_apiKey == null) log("API key is not initalised");
          if (_userID == null) log("User not logined");
        }
      }
    } catch (e) {}
  }

  static Future<NotificationSet> getNotifications() async {
    List<EsMessage> NotificationList = [];
    NotificationSet nsList =
        NotificationSet(unReadCount: 0, notificationMessage: []);

    try {
      if (_apiKey != null &&
          _apiKey != "" &&
          _userID != null &&
          _userID != "") {
        final Response = await get(
            Uri.parse(_baseUrl + _version + "notifications"),
            headers: {
              "X-ENGAGESPOT-API-KEY": _apiKey!,
              "X-ENGAGESPOT-USER-ID": _userID!,
            });

        if (Response.statusCode == 200) {
          if (_isDebug) {
            log("Get Notification -- > Successfully ");
          }
          var jMessage = json.decode(Response.body);
          NotificationModel MessageData = NotificationModel.fromJson(jMessage);
          NotificationList = MessageData.esMessage!;
          nsList.unReadCount = MessageData.unreadCount;
          nsList.notificationMessage = NotificationList;
        } else {
          if (_isDebug) {
            log("Get Notification Failed -- > ${Response.statusCode} ");
          }
        }
      } else {
        if (_isDebug) {
          if (_apiKey == null) log("API key is not initalised");
          if (_userID == null) log("User ID is not initalised");
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return nsList;
  }

  static void _getUserID() async {
    SharedPreferences lstorage = await SharedPreferences.getInstance();
    _userID = lstorage.getString("es_userID");
  }

  static LoginUser({required String userId}) async {
    _userID = userId;

    try {
      if (_apiKey != null) {
        final Response = await post(
            Uri.parse(_baseUrl + _version + "sdk/connect"),
            headers: {
              "X-ENGAGESPOT-API-KEY": _apiKey!,
              "X-ENGAGESPOT-USER-ID": _userID!,
              "X-ENGAGESPOT-DEVICE-ID": "123"
            },
            body: {
              "deviceType": "android"
            });

        if (Response.statusCode == 200) {
          if (_isDebug) {
            log("User Login -- > Successfully ");
          }

          SharedPreferences lstorage = await SharedPreferences.getInstance();

          lstorage.setString("es_userID", userId);
        } else {
          if (_isDebug) {
            log("User login failed --> ${Response.statusCode}");
            log(Response.body);
          }
        }
      } else {
        if (_isDebug) {
          if (_apiKey == null) log("API key is not initalised");
          if (_userID == null) log("User not logined");
        }
      }
    } catch (e) {}
  }
}
