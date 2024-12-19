import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/cart_provider.dart';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:stylefront/pages/buypage.dart'; 

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final hasSelectedItems = cartProvider.selectedItems.isNotEmpty;
    final filteredItems = cartProvider.cartItem.where((item) {
      return item['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                  ],
                ),
              )
            : const Center(child: Text('Cart')),
        actions: <Widget>[
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Cart items
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('No items found!'),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
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
                                  height: 75.0,
                                  width: 75.0,
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
