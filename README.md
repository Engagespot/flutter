# Engagespot SDK for Flutter

The Engagespot SDK for Flutter provides functionalities to integrate the Engagespot service into your Flutter applications. With this SDK, you can handle notifications, mark notifications as read, register Firebase Cloud Messaging (FCM) tokens, and listen to real-time notification events.

## Installation

To use the Engagespot SDK in your Flutter project, follow these steps:

1. Add the `engagespot_sdk` dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  engagespot_sdk: ^0.0.6
```

2. Install the package by running the following command in your terminal:

```
flutter pub get
```

## Usage

### Initializing the SDK

Before using any functionalities of the Engagespot SDK, you need to initialize it with your API key and secret. You can do this by calling the `initSdk` method:

```dart
Engagespot.initSdk(
  apiKey: 'your_api_key',
  isDebug: true, // Set to true for debugging
);
```

### Logging in User

To login a user, use the `loginUser` method:

```dart
Engagespot.loginUser(userId: 'user_id');
```

### Marking Single Notifications as Read

You can mark notification as read using the `markNotificationAsRead` method:

```dart
bool isSuccess = await Engagespot.markNotificationAsRead(notificationID: {{notificationID}});
  
     if (isSuccess) {
       print("Notification marked as read successfully.");
      } else {
     print("Failed to mark notification as read.");
     }
```

### Marking Single Notifications as Seen

You can mark notification as read using the `markNotificationAsSeen` method:

```dart
bool isSuccess = await Engagespot.markNotificationAsSeen(notificationID: {{notificationID}});
  
     if (isSuccess) {
       print("Notification marked as read successfully.");
      } else {
     print("Failed to mark notification as read.");
     }
```



### Marking Notifications as Seen

You can mark all notifications as seen using the `markAllAsSeen` method:

```dart
Engagespot.markAllAsSeen();
```

### Delete  Notification

You can delete  notification using the `deleteNotification` method:

```dart
Engagespot.deleteNotification(notificationID : "notificationID" );
```


### Delete All Notification

You can delete all notification using the `clearAllNotification` method:

```dart
Engagespot.clearAllNotification();
```


### Registering FCM Tokens

To register FCM tokens with Engagespot, use the `registerFCM` method:

```dart
Engagespot.registerFCM('your_fcm_token');
```

### Listening to Notification Events

You can listen to real-time notification events using the `listenMessage` method. Provide callbacks to handle incoming messages and when all notifications are marked as read:

```dart
Engagespot.listenMessage(
  onMessage: (EsMessage es) {
    // Handle incoming message
  }
 
);
```

### Getting Notifications

Retrieve notifications using the `getNotifications` method. This returns a `NotificationSet` object containing unread notification count and a list of notifications:

```dart
NotificationSet notificationSet = await Engagespot.getNotifications();
int unSeenCount = notificationSet.unSeenCount;
List<EsMessage> notifications = notificationSet.NotificationMessage;
```

## Note

- Ensure that you have the necessary permissions and configurations set up on the Engagespot dashboard before using the SDK functionalities.
- Handle errors and edge cases appropriately in your application logic.
- Refer to the Engagespot API documentation for more details on available endpoints and functionalities.

That's it! You've successfully integrated the Engagespot SDK into your Flutter application. Happy coding!# engagespot
