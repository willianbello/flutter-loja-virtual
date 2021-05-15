import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/order_tile.dart';
import 'package:loja_virtual/widgets/login_cart_screen.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    if (!UserModel.of(context).isLoggedIn()) {
      return LoginCartScreen(titleButtom: 'Faça o login para acompanhar');
    } else {

      String uid = UserModel.of(context).firebaseUser.user.uid;

      return FutureBuilder<QuerySnapshot>(
        future: users.doc(uid).collection('orders').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView(
              children: snapshot.data.docs.map((doc) =>
                OrderTile(doc.id)
              ).toList().reversed.toList(),
            );
          }
        }
      );

    }

    return Container();
  }
}
