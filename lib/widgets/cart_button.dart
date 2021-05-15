import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartScreen())
        );
      },
      child: Icon(Icons.shopping_cart, color: Colors.white),
      backgroundColor: primaryColor,
    );
  }
}
