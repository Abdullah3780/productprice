import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productprice/model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
class Database{
  var db;
  Database(){
    db=FirebaseFirestore.instance;
  }
  addData(Product product)async{
    try{
    await db.collection("products").add({'pname':product.name,'pweightorquantity':product.weightQuantity,'pprice':product.price});
    AwesomeNotifications().createNotification(
  content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: "Price of "+product.name+ " Updated",
      body: "Price of "+product.price.toString()+""
  )
);
    }
    on FirebaseException catch(e){
      throw e.message.toString();
    }
  }
}