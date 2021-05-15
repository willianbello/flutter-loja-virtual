import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CollectionReference products = FirebaseFirestore.instance.collection('products');

  CartTile(this.cartProduct, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: products.doc(cartProduct.category)
              .collection('items').doc(cartProduct.pid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent(context);
            } else {
              return Container(
                height: 70,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          }
        ) :
        _buildContent(context)
    );
  }

  Widget _buildContent(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    CartModel.of(context).updatePrices();

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          width: 120,
          child: Image.network(
            cartProduct.productData.images[0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cartProduct.productData.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'Tamanho ${cartProduct.size}',
                  style: TextStyle(
                    fontWeight: FontWeight.w300
                  ),
                ),
                Text(
                  'R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: primaryColor,
                      onPressed: cartProduct.quantity > 1 ? () {
                        CartModel.of(context).decProduct(cartProduct);
                      } : null,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        color: primaryColor,
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        }
                    ),
                    TextButton(
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                      child: Text(
                        'Remover',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }
}
