import 'package:flutter/material.dart';

import '../../../core/ui/widgets/base_header.dart';

class PaymentTypeHeader extends StatelessWidget {
  const PaymentTypeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHeader(
      title: 'ADMINISTRAR FORMAS DE PAGAMENTO',
      buttonLabel: 'adicionar',
      buttonPressed: () {},
      filterWidget: DropdownButton<bool?>(
        value: true,
        items: const [
          DropdownMenuItem(
            value: true,
            child: Text('Todos'),
          ),
          DropdownMenuItem(
            value: false,
            child: Text('Ativos'),
          ),
          DropdownMenuItem(
            value: null,
            child: Text('Inativos'),
          ),
        ],
        onChanged: (value) {},
      ),
    );
  }
}
