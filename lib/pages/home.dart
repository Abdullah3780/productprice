import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:anim_search_app_bar/anim_search_app_bar.dart';
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
  TextEditingController searchController = TextEditingController();
  final storage = FirebaseStorage.instance;
  TextEditingController weightController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  UploadTask? uploadTask;
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  String searchValue = "";
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  uploadFile() async {
    // Create a storage reference from our app
    // final storageRef = FirebaseStorage.instance.ref();
    final path = 'files/${image!.name}';
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

// Create a reference to "mountains.jpg"
    // final mountainsRef = storageRef.child("mountains.jpg");

// Create a reference to 'images/mountains.jpg'
    // final mountainImagesRef = storageRef.child("images/mountains.jpg");

// While the file names are the same, the references point to different files
    // assert(mountainsRef.name == mountainImagesRef.name);
    // assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String filePath = '${appDocDir.absolute}/file-to-upload.png';
    // File file = File(filePath);

    try {
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } on FirebaseException catch (e) {
      print(e.message);
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
                          // image != null
                          //     ? SizedBox(
                          //         height: 30,
                          //         width: 30,
                          //         child: Image.file(File(image!.path)))
                          //     :
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Select Image From'),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          // Capture a photo
                                                          image = await _picker
                                                              .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera);
                                                          Navigator.pop(ctx);
                                                        },
                                                        icon: Icon(Icons
                                                            .picture_in_picture)),
                                                    IconButton(
                                                        onPressed: () async {
                                                          image = await _picker
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          Navigator.pop(ctx);
                                                        },
                                                        icon: Icon(Icons.image))
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
                              onPressed: () async {
                                String url = "";

                                showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator
                                                  .adaptive(),
                                              Text('Uploading Data...')
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                url = await uploadFile();
                                Navigator.pop(context);
                                Product product = Product(
                                    nameController.text.toString(),
                                    double.parse(
                                        weightController.text.toString()),
                                    double.parse(
                                        priceController.text.toString()),
                                    url);
                                Database db = Database();
                                db.addData(product);
                                uploadFile();
                                Navigator.pop(context);
                              },
                              child: Text('Add Product'))
                        ],
                      ),
                    ));
          },
        ),
        // body: ListView.builder(itemBuilder: (_)=>),
        drawer: Drawer(
            child: SafeArea(
          child: Column(
            children: [
              Flexible(flex: 2, child: Icon(Icons.person)),
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text('Sign Out'))
            ],
          ),
        )),
        body: Column(
          children: [
            AnimSearchAppBar(
              cancelButtonText: "Cancel",
              hintText: 'Search',
              appBar: AppBar(
                title: Text('Home'),
              ),
              cSearch: searchController,
              onChanged: (val) {
                // print(searchController.text);
                setState(() {
                  searchValue = val;
                });
                print(val);
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    //  searchValue == ""
                    //     ?
                    FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                //     :
                // FirebaseFirestore.instance
                //     .collection("products")
                //     .where("pname", arrayContains: searchValue)
                //     .snapshots(),
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    if (searchValue != "") {
                      docs = snapshot.data!.docs
                          .where((element) => element['pname']
                              .toString()
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()))
                          .toList();
                    }

                    // items = snapshot.data.['products'];
                    print(docs);
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          key: UniqueKey(),
                          onDismissed: (value) {
                            if (value == DismissDirection.endToStart) {
                              final db = Database();
                              db.deleteSpecificData(
                                  docs[index].id, docs[index]['iurl']);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Product Deleted',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ));
                          },
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onTap: () async {
                              weightController.text =
                                  docs[index]['pweightorquantity'].toString();
                              priceController.text =
                                  docs[index]['pprice'].toString();
                              nameController.text =
                                  docs[index]['pname'].toString();
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
                                                  label: Text(
                                                      'Weight OR Quantity')),
                                            ),
                                            TextField(
                                              controller: priceController,
                                              decoration: InputDecoration(
                                                  label: Text('Price')),
                                            ),
                                            // image != null
                                            //     ? SizedBox(
                                            //         height: 20,
                                            //         width: 20,
                                            //         child: Image.file(File(image!.path)))
                                            //     :
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext ctx) {
                                                        return Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Center(
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
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
                                                                            image =
                                                                                await _picker.pickImage(source: ImageSource.camera);
                                                                            Navigator.pop(ctx);
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.picture_in_picture)),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            image =
                                                                                await _picker.pickImage(source: ImageSource.gallery);
                                                                            Navigator.pop(ctx);
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.image))
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
                                                onPressed: () async {
                                                  String url = "";

                                                  showCupertinoDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext ctx) {
                                                        return Center(
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircularProgressIndicator
                                                                    .adaptive(),
                                                                Text(
                                                                    'Uploading Data...')
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });

                                                  url = await uploadFile();
                                                  Navigator.pop(context);
                                                  Product product = Product(
                                                      nameController.text
                                                          .toString(),
                                                      double.parse(
                                                          weightController.text
                                                              .toString()),
                                                      double.parse(
                                                          priceController.text
                                                              .toString()),
                                                      url);
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
                            subtitle:
                                Text(docs[index]['pprice'].toString() + 'Rs'),
                            leading: docs[index]['iurl'] == ""
                                ? null
                                : CircleAvatar(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        docs[index]['iurl'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  } else {
                    return Center(
                      child: Text('No Data In Database'),
                    );
                  }
                }),
              ),
            ),
          ],
        ));
  }
}
