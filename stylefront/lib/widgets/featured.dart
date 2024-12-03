import 'package:flutter/material.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:stylefront/methods/productfromcsv.dart';

class FeaturedSection extends StatelessWidget {
@override   
Widget build(BuildContext context){
  return FutureBuilder<List<Product>>(
    future: productfromcsv(),
     builder:(context,snapshot){
      if (snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError){
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty){
        return Center(child: Text("No products found"));
      }
      else {
        final products = snapshot.data!.take(5).toList();
        return Padding(padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Featured',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 8.0),
                SizedBox(
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child:GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: int.parse(product.id)),
                      ),
                    );
                  },
                  child:Card(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/images/${product.id}.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.broken_image, size: 100),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productDisplayName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        product.brandName,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                              'Rs.${product.price}',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )));
                    },
                  ),
                ),

          ],

        ),
        );


      }
      
     } );
}
}


