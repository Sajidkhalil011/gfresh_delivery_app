import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';
import 'package:intl/intl.dart';
import '../services/order_services.dart';

class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;

  const OrderSummaryCard({Key? key, required this.document}) : super(key: key);

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  final OrderServices _orderServices = OrderServices();
  final FirebaseServices _services = FirebaseServices();
  DocumentSnapshot? _customer;

  @override
  void initState() {
    _services.getCustomerDetails(widget.document['userId']).then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      } else {
        print('no data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: _orderServices.statusIcon(widget.document),
            ),
            title: Text(
              widget.document['orderStatus'],
              style: TextStyle(
                fontSize: 12,
                color: _orderServices.statusColor(widget.document),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'On ${DateFormat.yMMMd().format(DateTime.parse(widget.document['timestamp']))}',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment Type : ${widget.document['cod'] == true ? 'Cash on delivery' : 'Paid Online'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Amount : \$${widget.document['total'].toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _customer != null
              ? ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Customer : ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_customer!['firstName']} ${_customer!['lastName']}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    _customer!['address'],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _orderServices.launchMap(
                            _customer!['latitude'],
                            _customer!['longitude'],
                          _customer!['firstName'],),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => _orderServices
                            .launchUrl('tel:${_customer!['number']}'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Icon(
                              Icons.phone_in_talk,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          ExpansionTile(
            title: Text(
              'Order details',
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            subtitle: Text(
              'View order details',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.network(
                          widget.document['products'][index]['productImage']),
                    ),
                    title: Text(
                      widget.document['products'][index]['productName'],
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      '${widget.document['products'][index]['qty']} x \$${widget.document['products'][index]['price'].toStringAsFixed(0)} = \$${widget.document['products'][index]['total'].toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                },
                itemCount: widget.document['products'].length,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 8, bottom: 8),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Seller: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              widget.document['seller']['shopName'],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (int.parse(widget.document['discount']) >
                            0) //only if discount available will show
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Discount: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '${widget.document['discount']}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Discount Code: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '${widget.document['discountCode']}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Delivery Fee: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              '\$${widget.document['deliveryFee'].toString()}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
          _orderServices.statusContainer(widget.document, context),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
