// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './config/app_routes.dart';

import './views/product_form_screen.dart';
import './views/products_panel_screen.dart';
import './views/products_overview_screen.dart';
import './views/product_detail_screen.dart';
import './views/cart_screen.dart';
import './views/orders_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

// roda o app
void main() => runApp(LojaApp());

// app
class LojaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // retorna um widget(component)
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha loja',

        // olha aqui outro componente
        theme: ThemeData(
          // mais componente
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),

        // essa eh uma pagina (um componente como vc pode ver)
        home: ProductOverviewScreen(),

        // rotas da aplicação
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS_PANEL: (ctx) => ProductsPanelScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen()
        },
      ),
    );
  }
}
