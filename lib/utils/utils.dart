import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {

static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>> transformer<T>(
      T Function(Map<String, dynamic> json) fromJson) =>
  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>.fromHandlers(
    handleData: (QuerySnapshot<Map<String, dynamic>> data, EventSink<List<T>> sinks) {
      final snaps = data.docs.map((doc) => doc.data()).toList();
      final users = snaps.map((json) => fromJson(json)).toList();
      sinks.add(users);
    },
  );

  static DateTime? toDateTimeConverter(Timestamp value) {
    return value.toDate().toLocal();
  }

  static int toTimeStampConverter(Timestamp val) {
    return val.millisecondsSinceEpoch;
  }

  static dynamic dateTimeToJsonConverter(DateTime? inputDate) =>
    (inputDate?.toUtc() != null ) ? inputDate?.toUtc() : null;
}