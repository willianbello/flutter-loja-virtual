import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  CollectionReference home = FirebaseFirestore.instance.collection('home');

  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 201, 188)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );
    
    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades'),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: home.orderBy('pos').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loading();
                } else {
                  return _gridViewImages(context, snapshot);
                }
              }
            )
          ],
        )
      ],
    );
  }

  Widget loading() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  Widget _gridViewImages(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return SliverStaggeredGrid.countBuilder(
      itemCount: snapshot.data.docs.length,
      crossAxisCount: 2,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      staggeredTileBuilder: (int index) {
        return new StaggeredTile.count(snapshot.data.docs[index]['x'], snapshot.data.docs[index]['y'].toDouble());
      },
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.green,
          child: fadeImageBuild(snapshot, index)
      ),
    );
  }

  Widget fadeImageBuild(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return FadeInImage.memoryNetwork (
      key: UniqueKey(),
      placeholder: kTransparentImage,
      image: snapshot.data.docs[index]['image'],
      fit: BoxFit.cover,
    );
  }
}