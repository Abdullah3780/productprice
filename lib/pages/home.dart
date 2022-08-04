import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:productprice/database.dart';
import 'package:productprice/model.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController=TextEditingController();
  
  TextEditingController weightController=TextEditingController();
  
  TextEditingController priceController=TextEditingController();
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
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () {
        // showModalBottomSheet(
        // elevation: 2.0,
        // enableDrag: true,

        //   context: context, builder: (context)=>Column(children: [TextField(controller: nameController,decoration: InputDecoration(label: Text('Product Name'))
        // ,)
        // ,TextField(controller:weightController,decoration: InputDecoration(label: Text('Weight OR Quantity')
        // ),),TextField(controller: priceController,decoration: InputDecoration(label: Text('Price')),),TextButton(onPressed: (){
          
          
        //   Product product=Product(nameController.text.toString(), double.parse(weightController.text.toString()), double.parse(priceController.text.toString()));
        //   Database db=Database();
        //   db.addData(product);
        // }, child: Text('Add Product'))],));


        AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title:'Title for your notification',
          body: 'body text/ content',
          
        )
    );
      },),
    );
  }
}
