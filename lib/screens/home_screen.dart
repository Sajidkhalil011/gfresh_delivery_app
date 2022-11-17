import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfresh_delivery_app/screens/login_screen.dart';
import 'package:gfresh_delivery_app/services/firebase_services.dart';
import 'package:gfresh_delivery_app/widgets/order_summary_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  final FirebaseServices _services=FirebaseServices();
  String? status;
  int tag = 0;
  List<String> options = [
    'All',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    status = null;
                  });
                }
                setState(() {
                  tag = val;
                  status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.orders.where('deliveryBoy.email',isEqualTo: user!.email).where('orderStatus',isEqualTo: tag==0?null:status).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
               if (snapshot.data!.size==0) {
                  return Center(child: Text('No $status Orders'));
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderSummaryCard(document: document),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
