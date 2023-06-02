import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/env/env.dart';
import '../../../core/extensions/formatter_extensions.dart';
import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/helpers/size_extensions.dart';
import '../../../core/ui/helpers/upload_html_helper.dart';
import '../../../core/ui/styles/text_styles.dart';
import 'product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final int? productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with Loader, Messages {
  final controller = Modular.get<ProductDetailController>();
  final _nameEC = TextEditingController();
  final _priceEC = TextEditingController();
  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final ReactionDisposer statusDisposer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusDisposer = reaction((_) => controller.status, (status) {
        switch (status) {
          case ProductsDetailStateStatus.initial:
            break;
          case ProductsDetailStateStatus.loading:
            showLoader();
            break;
          case ProductsDetailStateStatus.loaded:
            final model = controller.productModel!;
            _nameEC.text = model.name;
            _priceEC.text = model.price.currencyPTBR;
            _descriptionEC.text = model.description;
            hideLoader();

            break;
          case ProductsDetailStateStatus.error:
            hideLoader();
            showError(controller.errorMessage!);
            break;
          case ProductsDetailStateStatus.errorLoadProduct:
            hideLoader();
            showError(controller.errorMessage!);
            Navigator.of(context).pop();
            break;
          case ProductsDetailStateStatus.uploaded:
            hideLoader();
            break;
          case ProductsDetailStateStatus.deleted:
          case ProductsDetailStateStatus.saved:
            hideLoader();
            Navigator.pop(context);
            break;
        }
      });
      controller.loadProduct(widget.productId);
    });
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _descriptionEC.dispose();
    _priceEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthButtonAction = context.percentWidth(.40);
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.productId != null ? 'Alterar' : 'Adicionar'} Produto',
                      textAlign: TextAlign.center,
                      style: context.textStyles.textTitle.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Observer(
                        builder: (_) {
                          if (controller.imagePath != null) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                '${Env.instance.get('backend_base_url')}${controller.imagePath}',
                                width: 200,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                          ),
                          onPressed: () {
                            UploadHtmlHelper()
                                .startUpload(controller.uploadImageProduct);
                          },
                          child: Observer(
                            builder: (_) {
                              return Text(
                                '${controller.imagePath == null ? 'Adicionar' : 'Alterar'} foto',
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          validator: Validatorless.required('Nome é requerido'),
                          controller: _nameEC,
                          decoration:
                              const InputDecoration(label: Text('Nome')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator:
                              Validatorless.required('Preço é requerido'),
                          controller: _priceEC,
                          decoration:
                              const InputDecoration(label: Text('Preço')),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(
                              moeda: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: Validatorless.required('Descrição é requerido'),
                controller: _descriptionEC,
                minLines: 10,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: widthButtonAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: widthButtonAction / 2,
                        height: 60,
                        child: Visibility(
                          visible: widget.productId != null,
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('confirmar'),
                                    content: Text(
                                        'Confirma a exclusão do produto ${controller.productModel!.name}'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: context.textStyles.textBold
                                                .copyWith(color: Colors.red),
                                          )),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await controller.deleteProduct();
                                        },
                                        child: Text('Confirmar',
                                            style: context.textStyles.textBold),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: Text(
                              'Deletar',
                              style: context.textStyles.textBold
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: widthButtonAction / 2,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            final valid =
                                _formKey.currentState?.validate() ?? false;
                            if (valid) {
                              if (controller.imagePath == null) {
                                showWarning(
                                    'Imagem obrigatoria, por favor clique em adicionar foto');
                                return;
                              }
                              controller.save(
                                _nameEC.text,
                                UtilBrasilFields.converterMoedaParaDouble(
                                  _priceEC.text,
                                ),
                                _descriptionEC.text,
                              );
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: context.textStyles.textBold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
