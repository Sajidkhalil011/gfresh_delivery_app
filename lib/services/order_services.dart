import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gfresh_delivery_app/services/firebase_services.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices{
  final FirebaseServices _services=FirebaseServices();

  Color statusColor(DocumentSnapshot document){
    if(document['orderStatus']=='Accepted'){
      return Colors.blueGrey.shade400;
    }
    if(document['orderStatus']=='Rejected'){
      return Colors.red;
    }
    if(document['orderStatus']=='Picked Up'){
      return Colors.pink.shade900;
    }
    if(document['orderStatus']=='On the way'){
      return Colors.purple.shade900;
    }
    if(document['orderStatus']=='Delivered'){
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document){
    if(document['orderStatus']=='Accepted'){
      return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
    }
    if(document['orderStatus']=='Picked Up'){
      return Icon(Icons.cases_outlined,color: statusColor(document),);
    }
    if(document['orderStatus']=='On the way'){
      return Icon(Icons.delivery_dining,color: statusColor(document),);
    }
    if(document['orderStatus']=='Delivered'){
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
  }

  Widget statusContainer(DocumentSnapshot document,context){
    if(document['deliveryBoy']['name'].length>1){
      if(document['orderStatus']=='Accepted'){
        return Container(
          color: Colors.grey.shade300,
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                40.0, 8, 40, 8),
            child: TextButton(
              child: Text(
                'Update Status Picked Up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                EasyLoading.show();
                _services.updateStatus(id: document.id,status: 'Picked Up').then((value){
                  EasyLoading.showSuccess('Order Status is now Picked Up');
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: statusColor(document), // Background Color
              ),
            ),
          ),
        );
      }
    }
    if(document['orderStatus']=='Picked Up'){
      return Container(
        color: Colors.grey.shade300,
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              40.0, 8, 40, 8),
          child: TextButton(
            child: Text(
              'Update Status On The Way',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              EasyLoading.show();
              _services.updateStatus(id: document.id,status: 'On the way').then((value){
                EasyLoading.showSuccess('Order Status is now On the way');
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: statusColor(document), // Background Color
            ),
          ),
        ),
      );
    }

    if(document['orderStatus']=='On the way'){
      return Container(
        color: Colors.grey.shade300,
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              40.0, 8, 40, 8),
          child: TextButton(
            child: Text(
              'Deliver Order',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if(document['cod']==true){
                return showMyDialog('Receive Payment', 'Delivered', document.id, context);
              }else{
                EasyLoading.show();
                _services.updateStatus(id: document.id,status: 'Delivered').then((value){
                  EasyLoading.showSuccess('Order Status is now delivered');
                });
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: statusColor(document), // Background Color
            ),
          ),
        ),
      );
    }

      return Container(
        color: Colors.grey.shade300,
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          child: Text(
            'Order Completed',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {

          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green, // Background Color
          ),
        ),
      );
  }

  launchUrl(number) async =>
    await canLaunchUrl(number) ?
    await canLaunchUrl(number) : throw 'Could not launch $number';

  launchMap(lat,long,name)async{
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(lat, long),
      title: name,
    );
  }
  showMyDialog(title, status, documentId,context) {
    OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Make sure have received payment'),
            actions: [
              TextButton(
                child: Text(
                  'RECEIVE',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  EasyLoading.show();
                  _services.updateStatus(id: documentId,status: 'Delivered').then((value){
                    EasyLoading.showSuccess('Order Status is now Delivered');
                    Navigator.pop(context);
                  });
                },
                style: TextButton.styleFrom(
                  primary: Color(0xff84c225), // Background color
                ),
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  primary: Color(0xff84c225), // Background color
                ),
              ),
            ],
          );
        });
  }
}