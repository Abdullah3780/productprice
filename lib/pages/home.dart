import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:productprice/database.dart';
import 'package:productprice/model.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  final storage = FirebaseStorage.instance;
  TextEditingController weightController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  uploadFile() async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child("mountains.jpg");

// Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child("images/mountains.jpg");

// While the file names are the same, the references point to different files
    assert(mountainsRef.name == mountainImagesRef.name);
    assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/file-to-upload.png';
    File file = File(filePath);

    try {
      await mountainsRef.putFile(file);
    } on FirebaseException catch (e) {
      return e.message;
      // ...
    }
  }
  // Future<String> uploadFile(File _image) async {
  //   StorageReference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('sightings/${Path.basename(_image.path)}');
  //   StorageUploadTask uploadTask = storageReference.putFile(_image);
  //   await uploadTask.onComplete;
  //   print('File Uploaded');
  //   String returnURL;
  //   await storageReference.getDownloadURL().then((fileURL) {
  //     returnURL = fileURL;
  //   });
  //   return returnURL;
  // }

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            weightController.text = "";

            nameController.text = "";
            priceController.text = "";
            showModalBottomSheet(
                elevation: 2.0,
                enableDrag: true,
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
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
                      ),
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
                    onTap: () async {
                      weightController.text =
                          docs[index]['pweightorquantity'].toString();
                      priceController.text = docs[index]['pprice'].toString();
                      nameController.text = docs[index]['pname'].toString();
                      showModalBottomSheet(
                          elevation: 2.0,
                          enableDrag: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          label: Text('Product Name')),
                                    ),
                                    TextField(
                                      controller: weightController,
                                      decoration: InputDecoration(
                                          label: Text('Weight OR Quantity')),
                                    ),
                                    TextField(
                                      controller: priceController,
                                      decoration:
                                          InputDecoration(label: Text('Price')),
                                    ),
                                    image != null
                                        ? Image.asset(image!.path)
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext ctx) {
                                                    return Material(
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Container(
                                                          color: Colors.white,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Select Image From'),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        // Capture a photo
                                                                        image = await _picker.pickImage(
                                                                            source:
                                                                                ImageSource.camera);
                                                                        Navigator.pop(
                                                                            ctx);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .picture_in_picture)),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        image = await _picker.pickImage(
                                                                            source:
                                                                                ImageSource.gallery);
                                                                        Navigator.pop(
                                                                            ctx);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .image))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.image)),
                                    TextButton(
                                        onPressed: () {
                                          Product product = Product(
                                              nameController.text.toString(),
                                              double.parse(weightController.text
                                                  .toString()),
                                              double.parse(priceController.text
                                                  .toString()));
                                          Database db = Database();
                                          db.updateData(
                                              product, docs[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Update Product'))
                                  ],
                                ),
                              ));
                    },
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
