import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8.0,
                      left: 0,
                      child: Text(
                        'Loja Virtual \nWill - Roupas',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)
                      )
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          if (model.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return loginRegister(context, child, model);
                        },
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', _pageController, 0),
              DrawerTile(Icons.list, 'Produtos', _pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', _pageController, 2),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos', _pageController, 3),
            ],
          )
        ],
      ),
    );
  }

  Widget loginRegister(BuildContext context, Widget child, UserModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${model.isLoggedIn() ? model.userData['name'] : ""}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          child: Text(
            model.isLoggedIn() ? 'Sair' : 'Entre ou Cadastre-se >',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
          onTap: () {
            if (model.isLoggedIn()) {
              model.signOut();
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen())
              );
            }
          },
        ),
      ],
    );
  }
}
