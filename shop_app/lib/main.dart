import 'package:flutter/material.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
          //primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: Colors.purple, secondary: Colors.deepOrange),
          fontFamily: 'Lato'),
      home: ProductsOverviewScreen(),
    );
  }
}
