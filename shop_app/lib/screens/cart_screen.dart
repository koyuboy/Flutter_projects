import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreeen extends StatelessWidget {
  const CartScreeen({Key? key}) : super(key: key);
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            onPressed: () {
              if (cart.items.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Are you sure?',
                    ),
                    content: const Text(
                      'Do you want to delete the cart?',
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No')),
                      TextButton(
                          onPressed: () {
                            cart.clear();
                            Navigator.of(context).pop(true);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Cart deleted!',
                              ),
                              duration: Duration(seconds: 1),
                            ));
                          },
                          child: const Text('Yes')),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                    child: const Text('ORDER NOW'),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
                productId: cart.items.keys.toList()[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
