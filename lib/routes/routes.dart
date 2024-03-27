import 'package:flutter/material.dart';
import 'package:flutter_todo/components/inicio.dart';
import 'package:flutter_todo/components/product_list.dart';

///Asigna nombres a las diferentes vistas de la aplicacion, para facilitar la navegacion entre vistas 
Map<String, WidgetBuilder> getApplicationRoutes() {

  return <String, WidgetBuilder>{
    'productos': (BuildContext context) => const ProductList(),
    'inicio': (BuildContext context) => const Inicio(),
  }; 
}