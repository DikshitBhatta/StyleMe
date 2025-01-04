import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // Load orders from SharedPreferences
    _loadOrders(orderProvider);

    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'No orders yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final item = orders[index];
                  return GestureDetector(
                    onTap: () {
                      final productId = item['productId'] is int ? item['productId'] : int.tryParse(item['productId'].toString());
                      if (productId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(productId: productId),
                          ),
                        );
                      } else {
                        print('Error: productId is null or invalid');
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              children: [
                                Image.asset(
                                  item['image'],
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Rs. ${item['price']}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _loadOrders(OrderProvider orderProvider) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getStringList('orders') ?? [];
    orderProvider.loadOrders(orders);
  }
}
