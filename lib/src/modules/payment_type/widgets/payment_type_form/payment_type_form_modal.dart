import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/size_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../model/payment_type_model.dart';
import '../../payment_type_controller.dart';

class PaymentTypeFormModal extends StatefulWidget {
  final PaymentTypeController controller;
  final PaymentTypeModel? model;

  const PaymentTypeFormModal({
    super.key,
    required this.model,
    required this.controller,
  });

  @override
  State<PaymentTypeFormModal> createState() => _PaymentTypeFormModalState();
}

class _PaymentTypeFormModalState extends State<PaymentTypeFormModal> {
  final _nameEC = TextEditingController();
  final _acronymEC = TextEditingController();
  var enable = false;
  final _formKey = GlobalKey<FormState>();
  void _closeModal() => Navigator.of(context).pop();
  @override
  void initState() {
    final paymentModel = widget.model;
    if (paymentModel != null) {
      _nameEC.text = paymentModel.name;
      _acronymEC.text = paymentModel.acronym;
      enable = paymentModel.enabled;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _acronymEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    return SingleChildScrollView(
      child: Container(
        width: screenWidth * (screenWidth > 1200 ? .5 : .7),
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.model == null ? 'Adicionar' : 'Editar'} forma de pagamento',
                      textAlign: TextAlign.center,
                      style: context.textStyles.textTitle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _closeModal,
                      child: const Icon(Icons.close),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameEC,
                validator: Validatorless.required('Nome obrigatorio'),
                decoration: const InputDecoration(label: Text('Nome')),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _acronymEC,
                validator: Validatorless.required('Sigla obrigatoria'),
                decoration: const InputDecoration(label: Text('Sigla')),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Ativo',
                    style: context.textStyles.textRegular,
                  ),
                  Switch(
                    value: enable,
                    onChanged: (value) {
                      setState(() {
                        enable = value;
                      });
                    },
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: _closeModal,
                      child: Text(
                        'Cancelar',
                        style: context.textStyles.textExtraBold
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;
                        if (valid) {
                          widget.controller.savePayment(
                            id: widget.model?.id,
                            name: _nameEC.text,
                            acronym: _acronymEC.text,
                            enabled: enable,
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
