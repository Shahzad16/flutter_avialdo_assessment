import 'package:flutter/material.dart';
import 'package:flutter_avialdo_assessment/model/provider_class.dart';
import 'package:flutter_avialdo_assessment/screens/product_detail_page.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadProductsFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        title: const Text(
          'PRODUCTS',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          var selectedIndex = productProvider.selectedIndex;
          var products = productProvider.products;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 32.0,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              dynamic product = products[index];
              String title = product['title'];
              List<String> words = title.split(' ');
              String truncatedTitle = words.length > 3
                  ? '${words.sublist(0, 3).join(' ')}...'
                  : title;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                  productProvider.setSelectedIndex(product);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: selectedIndex == product
                        ? Border.all(color: Colors.blue.shade500, width: 3)
                        : null,
                    boxShadow: selectedIndex == product
                        ? [
                            BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 30,
                                offset: const Offset(0, 10))
                          ]
                        : [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 5))
                          ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(top: 10),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(product['image'],
                              fit: BoxFit.cover),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            truncatedTitle,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          product['category'],
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text('Available: ${product['rating']['count']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600)),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '\$${product['price']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
