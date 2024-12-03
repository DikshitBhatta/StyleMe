import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/cart_provider.dart';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:stylefront/pages/buypage.dart'; 

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Check if there are selected items
    final hasSelectedItems = cartProvider.selectedItems.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Cart')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Cart items
          Expanded(
            child: cartProvider.cartItem.isEmpty
                ? const Center(
                    child: Text('Your cart is empty!'),
                  )
                : ListView.builder(
                    itemCount: cartProvider.cartItem.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItem[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: GestureDetector(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    productId: int.parse(item['id'].toString()),
                                  ),
                                ),
                              );
                            },
                            tileColor: Colors.grey.shade100,
                            leading: Checkbox(
                              value: item['isSelected'] ?? false,
                              onChanged: (value) {
                                cartProvider.toggleSelection(index);
                              },
                            ),
                            title: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 65.0,
                                  width: 65.0,
                                  child: Image.asset(
                                    item['image'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item['name'] ?? 'Product',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text('Price: ₹${item['price']}'),
                                      const SizedBox(height: 4.0),
                                      Text('Quantity: ${item['quantity']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever_outlined,
                                  color: Colors.red),
                              onPressed: () {
                                cartProvider.removeFromCart(index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Action Buttons (Delete and Checkout)
          if (hasSelectedItems)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Delete Button
                  ElevatedButton.icon(
                    onPressed: () {
                      for (var item in cartProvider.selectedItems) {
                        cartProvider.removeFromCart(
                          cartProvider.cartItem.indexOf(item),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Delete',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(150.00, 40.00),
                    ),
                  ),

                  // Checkout Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            selectedItems: cartProvider.selectedItems,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text('Checkout',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF73D83C),
                      minimumSize: Size(150.00, 40.00)
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
