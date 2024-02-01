import 'dart:convert';

import 'package:api_crud/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/Product.dart';

enum PopUpMenuTypes { edit, delete }

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> productList = [];
  bool inProgress = false;

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  Future<void> getAllProducts() async {
    productList.clear();
    inProgress = true;
    setState(() {});
    var url = Uri.parse(Constants.baseUrl + Constants.readProductEndPoint);
    Response response = await get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['status'] == "success") {
        // productList = Product.fromJson(responseData['data']) as List<Product>;
        // for(Map<String,dynamic> responseProduct in responseData['data']) {
        //   productList.add(Product.fromJson(responseData));
        // }
        productList = (responseData['data'] as List<dynamic>).map((jsonProduct) => Product.fromJson(jsonProduct)).toList();
      }
    }
    print(productList.length);
    for(Product pro in productList){
      print(pro.productName);
      print(pro.img);
      print(pro.productCode);
      print(pro.unitPrice);
      print(pro.totalPrice);
    }
    inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getAllProducts,
        child: inProgress
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          product.img ?? 'https://picsum.photos/200/300'),
                    ),
                    title: Text(product.productName ?? 'Product Name'),
                    subtitle: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 16,
                      children: [
                        Text(product.productCode ?? 'Product code'),
                        Text(product.unitPrice ?? 'Product unit price'),
                        Text(product.totalPrice ?? 'Product total price'),
                        Text(product.qty ?? 'Product quantity'),
                      ],
                    ),
                    trailing: PopupMenuButton<PopUpMenuTypes>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PopUpMenuTypes.edit,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('EDIT'),
                          ),
                        ),
                        PopupMenuItem(
                          value: PopUpMenuTypes.delete,
                          child: ListTile(
                            leading: Icon(Icons.delete_forever_outlined),
                            title: Text('DELETE'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
