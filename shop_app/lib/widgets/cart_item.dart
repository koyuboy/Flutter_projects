import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  }) : super(key: key);

  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Products().findById(productId).imageUrl;
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are you sure?',
            ),
            content: Text(
              'Do you want to remove \'$title\' from the chart?',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('\'$title\' deleted from the cart!'),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  child: const Text('Yes')),
            ],
          ),
        );
        //return Future.value(true);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text('\$ $price'),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FittedBox(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text('Total: \$ ${(price * quantity)}'),
            trailing: Consumer<Cart>(
              builder: (_, cartData, __) => Wrap(
                  //width: 42,
                  spacing: 10,
                  children: [
                    SizedBox(
                      height: 65,
                      width: 27,
                      child: Center(
                        child: Text(
                          '${cartData.items[productId]!.quantity} x',
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              cartData.updateQuantitySingleItem(
                                  productId: productId, increase: true);
                            },
                            child: const Icon(Icons.arrow_circle_up_rounded)),
                        InkWell(
                            onTap: () {
                              if (cartData.items[productId]!.quantity > 1) {
                                cartData.updateQuantitySingleItem(
                                    productId: productId, increase: false);
                              }
                            },
                            child: const Icon(Icons.arrow_circle_down_rounded)),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
