import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
            child: Text(
              'CRIAR CONTA',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white
              ),
            )
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) return Center(child: CircularProgressIndicator());
          return buildFormLogin(context, child, model);
        },
      ),
    );
  }

  Widget buildFormLogin(BuildContext context, Widget child, UserModel model) {

    final _emailController = TextEditingController();
    final _passController = TextEditingController();

    final primaryColor = Theme.of(context).primaryColor;
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email'
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (emailField) {
              if (emailField.isEmpty || !emailField.contains('@')) {
                return 'Email inválido';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passController,
            decoration: InputDecoration(
                hintText: 'Senha'
            ),
            obscureText: true,
            validator: (senhaField) {
              if (senhaField.isEmpty || senhaField.length < 6) {
                return 'Senha inválida!';
              } else {
                return null;
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (_emailController.text == null || _emailController.text.isEmpty) {
                  _messageSnackBar('Insira seu email para recuparar a senha!', 2, Colors.redAccent);
                } else {
                  model.recoverPass(_emailController.text);
                  _messageSnackBar('Senha recuperada!', 2, primaryColor);
                }
              },
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: primaryColor
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  model.signIn(
                    email: _emailController.text,
                    pass: _passController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFail
                  );
                }
              },
              child: Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Usuário logado com sucesso!',
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );

    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Falha ao logar usuário!',
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _messageSnackBar(String message, int seconds, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: color,
          duration: Duration(seconds: seconds),
        )
    );
  }
}
