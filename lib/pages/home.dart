import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:productprice/database.dart';
import 'package:productprice/model.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            showModalBottomSheet(
                elevation: 2.0,
                enableDrag: true,
                context: context,
                builder: (context) => Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration:
                              InputDecoration(label: Text('Product Name')),
                        ),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(
                              label: Text('Weight OR Quantity')),
                        ),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(label: Text('Price')),
                        ),
                        TextButton(
                            onPressed: () {
                              Product product = Product(
                                  nameController.text.toString(),
                                  double.parse(
                                      weightController.text.toString()),
                                  double.parse(
                                      priceController.text.toString()));
                              Database db = Database();
                              db.addData(product);
                              Navigator.pop(context);
                            },
                            child: Text('Add Product'))
                      ],
                    ));
          },
        ),
        // body: ListView.builder(itemBuilder: (_)=>),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data!.docs;
              // items = snapshot.data.['products'];
              print(docs);
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(docs[index]['pname']),
                    subtitle: Text(docs[index]['pprice'].toString() + 'Rs')),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else {
              return Center(
                child: Text('No Data In Database'),
              );
            }
          }),
        ));
  }
}
