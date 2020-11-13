class Alert {
  String priority, to, topic, condition;
  PushNotification notification;
  Data data;

  Alert({
    this.priority,
    this.to,
    this.topic,
    this.condition,
    this.notification,
    this.data,
  });

  static Alert model({Map map}) => Alert(
        priority: map['priority'],
        to: map['to'],
        topic: map['topic'],
        condition: map['condition'],
        notification: PushNotification.model(map: map['notification']),
        data: Data.model(map: map['data']),
      );

  Map<String, dynamic> map() => <String, dynamic>{
        'priority': this.priority,
        'to': this.to,
        'topic': this.topic,
        'condition': this.condition,
        'notification': this.notification.map(),
        'data': this.data.map(),
      };
}

class PushNotification {
  String title, body, image, sound;
  int badge;
  Map<String, dynamic> customData;

  PushNotification({
    this.title,
    this.body,
    this.image,
    this.sound,
    this.badge,
    this.customData,
  });

  static PushNotification model({Map map}) => PushNotification(
        title: map['title'],
        body: map['body'],
        image: map['image'],
        sound: map['sound'],
        badge: map['badge'],
        customData: map['customData'],
      );

  Map<String, dynamic> map({PushNotification notification}) =>
      <String, dynamic>{
        'title': this.title,
        'body': this.body,
        'image': this.image,
        'sound': this.sound,
        'badge': this.badge,
        'customData': this.customData,
      };
}

class Data {
  String dataID, clickAction, status, tag, chatID, userID;

  Data({
    this.dataID,
    this.clickAction,
    this.status,
    this.tag,
    this.chatID,
  });

  static Data model({Map map}) => Data(
        dataID: map['id'],
        clickAction: map['click_action'],
        status: map['status'],
        tag: map['tag'],
        chatID: map['chatID'],
      );

  Map<String, dynamic> map() => <String, dynamic>{
        'id': this.dataID,
        'click_action': this.clickAction,
        'status': this.status,
        'tag': this.tag,
        'chatID': this.chatID,
      };
}
