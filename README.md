# Engagespot SDK for Flutter

The Engagespot SDK for Flutter provides functionalities to integrate the Engagespot service into your Flutter applications. With this SDK, you can handle notifications, mark notifications as read, register Firebase Cloud Messaging (FCM) tokens, and listen to real-time notification events.

## Installation

To use the Engagespot SDK in your Flutter project, follow these steps:

1. Add the `engagespot_sdk` dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  engagespot_sdk: ^1.0.0
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

### Marking Notifications as Read

You can mark all notifications as read using the `markAsRead` method:

```dart
Engagespot.markAsRead();
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
int unreadCount = notificationSet.unReadCount;
List<EsMessage> notifications = notificationSet.NotificationMessage;
```

### Logging in User

To login a user, use the `loginUser` method:

```dart
Engagespot.loginUser(userId: 'user_id');
```

## Note

- Ensure that you have the necessary permissions and configurations set up on the Engagespot dashboard before using the SDK functionalities.
- Handle errors and edge cases appropriately in your application logic.
- Refer to the Engagespot API documentation for more details on available endpoints and functionalities.

That's it! You've successfully integrated the Engagespot SDK into your Flutter application. Happy coding!# engagespot
