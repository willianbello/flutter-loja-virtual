import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartModel cartModel = CartModel.of(context);
    CollectionReference coupons =
        FirebaseFirestore.instance.collection('coupons');
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Digite seu cupom'),
              initialValue: cartModel.couponCode ?? '',
              onFieldSubmitted: (text) {
                coupons.doc(text).get().then((docSnap) {
                  if (docSnap.data() != null) {
                    cartModel.setCoupon(text, docSnap.data()['percent']);
                    messenger.showSnackBar(SnackBar(
                      content: Text(
                          'Desconto de ${docSnap.data()['percent']}% aplicado'),
                      backgroundColor: primaryColor,
                    ));
                  } else {
                    cartModel.setCoupon(null, 0);
                    messenger.showSnackBar(SnackBar(
                      content: Text('Cupom não existente!'),
                      backgroundColor: Colors.red,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
