import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;

  const OrderScreen(this.orderId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido Realizado'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: primaryColor, size: 80),
            Text(
              'Pedido realizado com sucesso!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Código do pedido: $orderId', style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
