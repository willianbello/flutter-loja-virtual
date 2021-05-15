import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  // pode usar também widget.product
  final ProductData product;

  String selectedSize;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              dotSize: 4,
              dotSpacing: 20,
              dotBgColor: Colors.black26,
              dotColor: Colors.white,
              dotIncreasedColor: primaryColor,
              dotIncreaseSize: 3,
              autoplay: true,
              indicatorBgPadding: 10,
              autoplayDuration: Duration(seconds: 8),
              images: product.images.map((url) {
                return Image.network(url);
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5,20,5,5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map((size) {
                      return InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: selectedSize == size ? primaryColor : Colors.grey[500],
                              width: 3
                            ),
                            color: selectedSize == size ? primaryColor : Colors.white
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              color: selectedSize == size ? Colors.white : Colors.black
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: selectedSize != null ?
                      () {
                        if (UserModel.of(context).isLoggedIn()) {

                          CartProduct cartProduct = CartProduct();
                          cartProduct.size = selectedSize;
                          cartProduct.quantity = 1;
                          cartProduct.pid = product.id;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                          );

                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        }
                      }
                      : null,
                    child: Text(UserModel.of(context).isLoggedIn() ?
                      'Adicionar ao Carrinho' : 'Entre para Comprar',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor)
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Descrição',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                      fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
