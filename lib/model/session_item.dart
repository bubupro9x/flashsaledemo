// To parse this JSON data, do
//
//     final sessionItem = sessionItemFromJson(jsonString);

import 'dart:convert';

SessionItem sessionItemFromJson(String str) {
  final jsonData = json.decode(str);
  return SessionItem.fromJson(jsonData);
}

String sessionItemToJson(SessionItem data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SessionItem {
  int status;
  String message;
  DataSession data;

  SessionItem({
    this.status,
    this.message,
    this.data,
  });

  factory SessionItem.fromJson(Map<String, dynamic> json) => new SessionItem(
    status: json["status"],
    message: json["message"],
    data: DataSession.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class DataSession {
  int currentTime;
  int waitTime;
  String currentSlot;
  List<Slot> slots;

  DataSession({
    this.currentTime,
    this.waitTime,
    this.currentSlot,
    this.slots,
  });

  factory DataSession.fromJson(Map<String, dynamic> json) => new DataSession(
    currentTime: json["current_time"],
    waitTime: json["wait_time"],
    currentSlot: json["current_slot"],
    slots: new List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "current_time": currentTime,
    "wait_time": waitTime,
    "current_slot": currentSlot,
    "slots": new List<dynamic>.from(slots.map((x) => x.toJson())),
  };
}

class Slot {
  String slot;
  int waitTime;
  String title;

  Slot({
    this.slot,
    this.waitTime,
    this.title
  });

  factory Slot.fromJson(Map<String, dynamic> json) => new Slot(
    slot: json["slot"],
    waitTime: json["wait_time"],
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "wait_time": waitTime,
  };
  String toTime(){
    return slot.substring(slot.length - 8, slot.length -3);
  }

  int toMilliseconds(){
    DateTime time = DateTime.parse(slot);
    return time.millisecondsSinceEpoch;
  }
}
