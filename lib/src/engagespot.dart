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

  /// Deletes a notification by its ID.
  ///
  /// This method sends a DELETE request to the specified notification endpoint
  /// to remove a notification from the server. It requires the notification ID
  /// as a parameter and uses predefined API keys and user credentials.
  ///
  /// **Parameters:**
  /// - [notificationID]: The unique ID of the notification to delete. This is a required parameter.
  ///
  /// **Returns:**
  /// - A [Future<bool>] indicating the success or failure of the deletion:
  ///   - `true`: If the notification was successfully deleted.
  ///   - `false`: If the deletion failed.
  ///
  /// **Usage Example:**
  /// ```dart
  /// bool isDeleted = await Engagespot.deleteNotification(notificationID: 12345);
  /// if (isDeleted) {
  ///   print("Notification deleted successfully.");
  /// } else {
  ///   print("Failed to delete the notification.");
  /// }
  /// ```
  ///
  /// **Error Handling:**
  /// - Catches exceptions and logs any errors that occur during the deletion process.
  /// - Ensures null-safety for `_apiKey` and `_userID` but throws an exception if either is null.
  ///
  /// **Dependencies:**
  /// - Ensure Engagespot sdk is initalised.
  ///
  /// **Logs:**
  /// - Logs success, failure, and error messages for debugging purposes.
  ///
  /// **Method Implementation

  static Future<bool> deleteNotification({required int notificationID}) async {
    try {
      final response = await delete(
        Uri.parse("$_baseUrl${_version}notifications/$notificationID"),
        headers: {
          "X-ENGAGESPOT-API-KEY": _apiKey!,
          "X-ENGAGESPOT-USER-ID": _userID!,
          "X-ENGAGESPOT-DEVICE-ID": "123",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        if (_isDebug) {
          log("Notification with ID $notificationID deleted successfully.");
        }
        return true;
      } else {
        log("Failed to delete notification with ID $notificationID. Status code: ${response.statusCode}");
        log("Response body: ${response.body}");
      }
    } catch (e) {
      log("Error occurred while deleting notification with ID $notificationID: $e");
    }

    return false;
  }

  /// The operation requires the user to be logged in (validated via `_userID`).
  ///
  /// If the request is successful, the method returns `true`. Otherwise, it returns `false`.
  ///
  /// Example:
  /// ```dart
  ///   bool isSuccess = await Engagespot.markNotificationAsRead(notificationID: {{notificationID}});
  ///
  ///   if (isSuccess) {
  ///     print("Notification marked as read successfully.");
  ///   } else {
  ///     print("Failed to mark notification as read.");
  ///   }
  /// ```
  ///
  /// Parameters:
  /// - [notificationID]: The unique identifier of the notification to be marked as read.
  ///
  /// Returns:
  /// A `Future<bool>` indicating whether the notification was successfully marked as read:
  /// - Returns `true` if the operation was successful.
  /// - Returns `false` if the operation failed or the user was not logged in.
  static Future<bool> markNotificationAsRead(
      {required int notificationID}) async {
    try {
      if (_userID != null && _userID != "") {
        final response = await post(
            Uri.parse(
                "$_baseUrl${_version}notifications/$notificationID/click"),
            headers: {
              "X-ENGAGESPOT-API-KEY": _apiKey!,
              "X-ENGAGESPOT-USER-ID": _userID!,
              "X-ENGAGESPOT-DEVICE-ID": "123",
            },
            body: {
              "read": "true"
            });

        if (response.statusCode == 200) {
          if (_isDebug) {
            log("Notification with ID $notificationID mark as read successfully.");
          }
          return true;
        } else {
          log("Failed to mark as read notification with ID $notificationID. Status code: ${response.statusCode}");
          log("Response body: ${response.body}");
        }
      } else {
        if (_isDebug) {
          log("User not logined");
        }
      }
    } catch (e) {
      log("Error occurred while updating status notification with ID $notificationID: $e");
    }

    return false;
  }

  @Deprecated(
      "Use 'markAllAsRead' instead. This function will be removed in a future release.")
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

  /// Marks all notifications as read for the current user.
  ///
  /// This method sends a POST request to the notification service endpoint
  /// to mark all notifications as seen for the specified user. It requires the
  /// `_userID` to be non-null and non-empty, ensuring the user is logged in.
  ///
  /// **Parameters:**
  /// - None
  ///
  /// **Returns:**
  /// - A [Future<void>] indicating the asynchronous operation.
  ///
  /// **Usage Example:**
  /// ```dart
  /// await markAllAsRead();
  /// ```
  ///
  /// **Error Handling:**
  /// - If `_userID` is `null` or empty, the method logs an error message if `_isDebug` is enabled.
  /// - Ensure `_apiKey` and `_userID` are properly initialized before calling this method.
  ///
  /// **Dependencies:**
  /// - Requires `_baseUrl`, `_version`, `_apiKey`, `_userID`, and `_isDebug` to be correctly configured.
  ///
  /// **Logs:**
  /// - Logs a debug message if the user is not logged in.
  ///
  /// **Method Implementation
  @Deprecated(
      "Use 'markAllAsSeen' instead. This function will be removed in a future release.")
  static markAllAsRead() async {
    if (_userID != null && _userID != "") {
      await post(
        Uri.parse(
            _baseUrl + _version + "notifications/markAllNotificationsAsSeen"),
        headers: {
          "X-ENGAGESPOT-API-KEY": _apiKey!,
          "X-ENGAGESPOT-USER-ID": _userID!,
          "X-ENGAGESPOT-DEVICE-ID": "123"
        },
      );
    } else {
      if (_isDebug) log("User not logined");
    }
  }

  /// The operation requires the user to be logged in (validated via `_userID`).
  ///
  /// If the request is successful, the method returns `true`. Otherwise, it returns `false`.
  ///
  /// Example:
  /// ```dart
  ///   bool isSuccess = await Engagespot.markNotificationAsSeen(notificationID: {{notificationID}});
  ///
  ///   if (isSuccess) {
  ///     print("Notification marked as seen successfully.");
  ///   } else {
  ///     print("Failed to mark notification as seen.");
  ///   }
  /// ```
  ///
  /// Parameters:
  /// - [notificationID]: The unique identifier of the notification to be marked as seen.
  ///
  /// Returns:
  /// A `Future<bool>` indicating whether the notification was successfully marked as seen:
  /// - Returns `true` if the operation was successful.
  /// - Returns `false` if the operation failed or the user was not logged in.
  static Future<bool> markNotificationAsSeen(
      {required int notificationID}) async {
    try {
      if (_userID != null && _userID != "") {
        final response = await post(
          Uri.parse("$_baseUrl${_version}notifications/$notificationID/views"),
          headers: {
            "X-ENGAGESPOT-API-KEY": _apiKey!,
            "X-ENGAGESPOT-USER-ID": _userID!,
            "X-ENGAGESPOT-DEVICE-ID": "123",
          },
        );
        if (response.statusCode == 200) {
          if (_isDebug) {
            log("Notification with ID $notificationID mark as seen successfully.");
          }
          return true;
        } else {
          log("Failed to mark as seen notification with ID $notificationID. Status code: ${response.statusCode}");
          log("Response body: ${response.body}");
        }
      } else {
        if (_isDebug) {
          log("User not logined");
        }
      }
    } catch (e) {
      log("Error occurred while updating status notification with ID $notificationID: $e");
    }
    return false;
  }

  /// Marks all notifications as read for the current user.
  ///
  /// This method sends a POST request to the notification service endpoint
  /// to mark all notifications as seen for the specified user. It requires the
  /// `_userID` to be non-null and non-empty, ensuring the user is logged in.
  ///
  /// **Parameters:**
  /// - None
  ///
  /// **Returns:**
  /// - A [Future<void>] indicating the asynchronous operation.
  ///
  /// **Usage Example:**
  /// ```dart
  /// await markAllAsRead();
  /// ```
  ///
  /// **Error Handling:**
  /// - If `_userID` is `null` or empty, the method logs an error message if `_isDebug` is enabled.
  /// - Ensure `_apiKey` and `_userID` are properly initialized before calling this method.
  ///
  /// **Dependencies:**
  /// - Requires `_baseUrl`, `_version`, `_apiKey`, `_userID`, and `_isDebug` to be correctly configured.
  ///
  /// **Logs:**
  /// - Logs a debug message if the user is not logged in.
  ///
  /// **Method Implementation
  static markAllAsSeen() async {
    if (_userID != null && _userID != "") {
      await post(
        Uri.parse(
            _baseUrl + _version + "notifications/markAllNotificationsAsSeen"),
        headers: {
          "X-ENGAGESPOT-API-KEY": _apiKey!,
          "X-ENGAGESPOT-USER-ID": _userID!,
          "X-ENGAGESPOT-DEVICE-ID": "123"
        },
      );
    } else {
      if (_isDebug) log("User not logined");
    }
  }

  static clearAllNotification() async {
    if (_userID != null && _userID != "") {
      await post(
        Uri.parse(_baseUrl +
            _version +
            "notifications/markAllNotificationsAsDeleted"),
        headers: {
          "X-ENGAGESPOT-API-KEY": _apiKey!,
          "X-ENGAGESPOT-USER-ID": _userID!,
          "X-ENGAGESPOT-DEVICE-ID": "123"
        },
      );
    } else {
      if (_isDebug) log("User not logined");
    }
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
          nsList.unReadCount = MessageData.unSeenCount;
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
