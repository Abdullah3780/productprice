import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:productprice/model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;

class Database {
  var db;
  Database() {
    db = FirebaseFirestore.instance;
  }

  addData(Product product) async {
    try {
      await db.collection("products").add({
        'pname': product.name,
        'pweightorquantity': product.weightQuantity,
        'pprice': product.price,
        'iurl': product.url
      });
      // AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: 10,
      //         channelKey: 'key1',
      //         title: "Price of " + product.name + " Updated",
      //         body: "Price is " + product.price.toString() + ""));
      // Future<bool> callOnFcmApiSendPushNotifications(
      //     {required String title, required String body}) async {
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data = {
        "to": "/topics/topic",
        "notification": {
          "title": "Price of " + product.name + " Added",
          "body": "Price is " + product.price.toString() + "",
        },
        "data": {
          "type": '0rder',
          "id": '28',
          "click_action": 'FLUTTER_NOTIFICATION_CLICK',
        }
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAAkVSkf-g:APA91bFH4E5wsqng9fV1IU4NUM8rn0tIsltuipOBrvhW9iRCRa2DHsrX0qyPUUH0OYTuq4xE1UfGxK4zOonnVWcVMo762j1BKjkoEbO3xyuWhJIQdtib49cM255wP-eCYyQCoQnAeWjb' // 'key=YOUR_SERVER_KEY'
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // on success do sth
        print('test ok push CFM');
        return true;
      } else {
        print(' CFM error');
        // on failure do sth
        return false;
      }
      // }
// AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().microsecondsSinceEpoch.remainder(10000),
//           channelKey: 'key1',
//           title:'Title for your notification',
//           body: 'body text/ content'

//         )
//     );
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  updateData(Product product, id) async {
    db
        .collection('products')
        .doc(id) // <-- Doc ID where data should be updated.
        .update({
      'pname': product.name,
      'pweightorquantity': product.weightQuantity,
      'pprice': product.price,
      'iurl': product.url
    });
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/topic",
      "notification": {
        "title": "Price of " + product.name + " Added",
        "body": "Price is " + product.price.toString() + "",
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAkVSkf-g:APA91bFH4E5wsqng9fV1IU4NUM8rn0tIsltuipOBrvhW9iRCRa2DHsrX0qyPUUH0OYTuq4xE1UfGxK4zOonnVWcVMo762j1BKjkoEbO3xyuWhJIQdtib49cM255wP-eCYyQCoQnAeWjb' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('Cloud Messaging Successful');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  readAllData() {
    return db.collection("products").get();
  }

  deleteSpecificData(id, imageUrl) async {
    Reference photoRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await photoRef.delete().then((value) {
      print('deleted Successfully');
    });
    db.collection("products").doc(id).delete();
  }
}
