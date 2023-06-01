import 'package:flutter/material.dart';
import './payment_type_controller.dart';

class PaymentTypePage extends StatelessWidget {
  final PaymentTypeController _controller;

  const PaymentTypePage({
    Key? key,
    required PaymentTypeController controller,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('data'),
    );
  }
}
