import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;

  const CheckoutPage({Key? key, required this.selectedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          final item = selectedItems[index];
          return ListTile(
            leading: SizedBox(
              height: 50.0,
              width: 50.0,
              child: Image.asset(item['image'], fit: BoxFit.cover),
            ),
            title: Text(item['name'] ?? 'Product'),
            subtitle: Text('Price: ₹${item['price']} x ${item['quantity']}'),
            trailing: Text(
              'Total: ₹${item['price'] * item['quantity']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
