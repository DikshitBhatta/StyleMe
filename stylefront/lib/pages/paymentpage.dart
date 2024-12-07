import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentPage({Key? key, required this.onPaymentMethodSelected}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = 'Credit card';

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardHolderNameController = TextEditingController();
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Payment Method',
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
            ListTile(
              leading: Image.asset('assets/payment/CreditCard.png', width: 40),
              title: const Text('Credit card'),
              trailing: Radio<String>(
                value: 'Credit card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              leading: Image.asset('assets/payment/esewa.png', width: 40),
              title: const Text('Esewa'),
              trailing: Radio<String>(
                value: 'Esewa',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'Esewa';
                });
                widget.onPaymentMethodSelected('Esewa');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset('assets/payment/Khalti.png', width: 40),
              title: const Text('Khalti'),
              trailing: Radio<String>(
                value: 'Khalti',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'Khalti';
                });
                widget.onPaymentMethodSelected('Khalti');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            // Conditionally show these fields only when "Credit card" is selected
            if (selectedPaymentMethod == 'Credit card') ...[
              TextField(
                controller: cardHolderNameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder name',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card number',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF023C45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  String cardHolderName = cardHolderNameController.text;
                  String cardNumber = cardNumberController.text;
                  String date = dateController.text;
                  String cvv = cvvController.text;

                  print('Selected Payment Method: $selectedPaymentMethod');
                  print('Cardholder Name: $cardHolderName');
                  print('Card Number: $cardNumber');
                  print('Date: $date');
                  print('CVV: $cvv');

                  widget.onPaymentMethodSelected(selectedPaymentMethod);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add card',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
