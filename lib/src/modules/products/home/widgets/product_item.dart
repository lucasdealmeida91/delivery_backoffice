import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/env/env.dart';
import '../../../../core/extensions/formatter_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../model/product_model.dart';
import '../products_controller.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: constraints.maxHeight * .6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Env.instance.get('backend_base_url')}${productModel.image}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Tooltip(
                  message: productModel.name,
                  child: Text(
                    productModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.textMedium,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(productModel.price.currencyPTBR),
                  ),
                  TextButton(
                    onPressed: ()async {

              context.read<ProductsController>().editProduct(productModel);

                    },
                    child: const Text('Editar'),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
