import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login_screen.dart';


class LoginCartScreen extends StatefulWidget {

  String title;
  IconData icon;

  LoginCartScreen({String titleButtom, IconData icon, Key key}) : super(key: key) {
    titleButtom != null && titleButtom.isNotEmpty ? title = titleButtom : title = null;
    icon != null ? this.icon = icon : icon = null;
  }

  @override
  _LoginCartScreenState createState() => _LoginCartScreenState(titleButtom: title);
}

class _LoginCartScreenState extends State<LoginCartScreen> {

  String frase = 'Faça o Login para adicionar produtos';
  IconData icon = Icons.remove_shopping_cart;

  _LoginCartScreenState({String titleButtom, IconData icon}) {
    print(titleButtom);
    titleButtom != null && titleButtom.isNotEmpty ? this.frase = titleButtom : null;
    icon != null ? this.icon = icon : icon = null;
  }

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, size: 80, color: primaryColor),
          SizedBox(height: 16),
          Text(
            frase,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginScreen())
              );
            },
            child: Text(
              'Entrar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor)
            ),
          )
        ],
      ),
    );
  }
}
