import 'package:flutter/material.dart';
import 'package:stylefront/pages/paymentpage.dart';
import 'package:stylefront/pages/shippingaddress.dart';

import 'package:stylefront/payment/esewa.dart';


class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  const CheckoutPage({Key? key, required this.selectedItems}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Select payment method';

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.selectedItems.fold(
      0.0,
      (sum, item) {
        double price = double.tryParse(item['price'].toString()) ?? 0.0;
        int quantity = int.tryParse(item['quantity'].toString()) ?? 0;
        return sum + (price * quantity);
      },
    );
    Esewa esewa = Esewa();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  return ListTile(
                    leading: null,
                    title:  Row(
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
                    subtitle: null,
          
                  );
                },
              ),
            ),
            const Text(
              'SHIPPING ADDRESS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add shipping address', style: TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShippingAddressPage()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PAYMENT METHOD',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedPaymentMethod, style: TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              onPaymentMethodSelected: (method) {
                                setState(() {
                                  selectedPaymentMethod = method;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF023C45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (selectedPaymentMethod == 'Esewa') {
                    String productName = widget.selectedItems.isNotEmpty
                        ? widget.selectedItems[0]['name']
                        : 'Product';
                    esewa.initiatePayment(productName, totalPrice.toString());
                  } else {
                  }
                },
                child: Text(
                  'Pay - NPR $totalPrice',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
