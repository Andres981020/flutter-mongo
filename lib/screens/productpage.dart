import 'package:flutter/material.dart';
import 'package:flutter_todo/components/app_bar.dart';
import 'package:flutter_todo/components/create_product.dart';
import 'package:flutter_todo/components/product_list.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<RealmServices?>(context, listen: false) == null
        ? Container()
        : const Scaffold(
            appBar: TodoAppBar(),
            body: ProductList(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: 
              CreateProductAction()
            // Row(
            //   children: [
            //     CreateItemAction(),
            //     CreateProductAction(),
            //   ],
            // )
            );
  }
}