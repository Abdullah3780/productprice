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
      channelKey: 'key1',
      title: "Price of "+product.name+ " Updated",
      body: "Price is "+product.price.toString()+""
  )
);
// AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().microsecondsSinceEpoch.remainder(10000),
//           channelKey: 'key1',
//           title:'Title for your notification',
//           body: 'body text/ content'
      
//         )
//     );
    }
    on FirebaseException catch(e){
      throw e.message.toString();
    }
  }
  readAllData(){
  return db.collection("products").get();
    
    
  }
}