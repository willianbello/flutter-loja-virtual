import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  UserModel user;

  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn())
      _loadCartItems();
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    users
        .doc(user.firebaseUser.user.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((cartDoc) {
      cartProduct.cid = cartDoc.id;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    users
        .doc(user.firebaseUser.user.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity --;
    users.doc(user.firebaseUser.user.uid).collection('cart').doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity ++;
    users.doc(user.firebaseUser.user.uid).collection('cart').doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await users.doc(user.firebaseUser.user.uid).collection('cart').get();
    
    products = query.docs.map((product) => CartProduct.fromDocument(product)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    products.forEach((p) {
      if (p.productData != null) {
        price += (p.quantity * p.productData.price);
      }
    });

    return price;
  }

  double getDiscount() {
    return getProductsPrice() * (discountPercentage / 100);
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {

    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await orders.add(
      {
        'clientId': user.firebaseUser.user.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productsPrice,
        'discount': discount,
        'totalPrice': productsPrice - discount + shipPrice,
        'status': 1
      }
    );

    await users.doc(user.firebaseUser.user.uid).collection('orders').doc(refOrder.id).set({
      'orderId': refOrder.id
    });

    QuerySnapshot query = await users.doc(user.firebaseUser.user.uid).collection('cart').get();

    query.docs.forEach((doc) {
      doc.reference.delete();
    });

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }

}
