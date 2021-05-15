import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {

  CollectionReference _products = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _products.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          
          Iterable<Widget> dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.docs.map((doc) {
              return CategoryTile(doc);
            }).toList(),
            color: Colors.grey[500]
          ).toList();
          
          return ListView(
            children: dividedTiles,
          );
        }
      }
    );
  }
}