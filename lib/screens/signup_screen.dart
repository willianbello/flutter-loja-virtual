import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Criar Conta'
        ),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return buildFormRegister(context, child, model, _scaffoldKey);
        },
      ),
    );
  }

  Widget buildFormRegister(BuildContext context, Widget child, UserModel model, GlobalKey<ScaffoldState> _scaffoldKey) {

    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passController = TextEditingController();
    final _addressController = TextEditingController();

    final primaryColor = Theme.of(context).primaryColor;
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                hintText: 'Nome Completo'
            ),
            keyboardType: TextInputType.text,
            validator: (nomeField) {
              if (nomeField.isEmpty) {
                return 'Nome inválido';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 16),
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
                return 'Senha inválida! Mínimo 6 caracteres';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
                hintText: 'Endereço'
            ),
            validator: (enderecoField) {
              if (enderecoField.isEmpty) {
                return 'Endereço inválido!';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {

                  Map<String, dynamic> userData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'address': _addressController.text,
                  };

                  model.signUp(
                    userData: userData,
                    pass: _passController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFail
                  );
                }
              },
              child: Text(
                'Criar Conta',
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
          'Usuário criado com sucesso!',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Falha ao criar usuário!',
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
