import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {

  CollectionReference places = FirebaseFirestore.instance.collection('places');

  PlacesTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: places.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            children: snapshot.data.docs.map((doc) => PlaceTile(doc)).toList(),
          );
        }
      }
    );
  }
}
