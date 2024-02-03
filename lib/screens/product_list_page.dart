import 'dart:convert';

import 'package:api_crud/screens/add_or_edit_product.dart';
import 'package:api_crud/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/product.dart';

enum PopUpMenuTypes { edit, delete }

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> productList = [];
  bool _inProgress = false;

  @override
  void initState() {
    getAllProductsFromApi();
    super.initState();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddOrEditProductScreen(context),
        label: const Text('ADD'),
        icon: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: getAllProductsFromApi,
        child: _inProgress
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
                      onSelected: (value) =>
                          _onTapPopUpMenuItemSelected(value, product),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: PopUpMenuTypes.edit,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('EDIT'),
                          ),
                        ),
                        const PopupMenuItem(
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

  Future<void> _navigateToAddOrEditProductScreen(BuildContext context,{Product? product}) async {
    bool updatedList =false;
    if(context.mounted){
      updatedList= product==null ? await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddOrEditProduct(),
        ),
      ) : await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  AddOrEditProduct(product: product),
        ),
      );
    }
    if(updatedList == true){
      getAllProductsFromApi();
    }
  }

  Future<void> getAllProductsFromApi() async {
    _inProgress = true;
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
        productList.clear();
        productList = (responseData['data'] as List<dynamic>)
            .map((jsonProduct) => Product.fromJson(jsonProduct))
            .toList();
      }
    }
    print(productList.length);
    for (Product pro in productList) {
      print(pro.productName);
      print(pro.img);
      print(pro.productCode);
      print(pro.unitPrice);
      print(pro.totalPrice);
    }
    _inProgress = false;
    setState(() {});
  }

  Future<void> deleteProductFromApi(String productId) async {
    _inProgress = true;
    setState(() {});

    Uri uri = Uri.parse(
        Constants.baseUrl + Constants.deleteProductEndPoint + productId);
    print(productId);
    Response response = await get(
      uri,
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
    );
    if (response.statusCode == 200) {
      getAllProductsFromApi();
    } else {
      _inProgress = false;
      setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to Delete the Product'),
          ),
        );
      }
    }
  }

  void _onTapPopUpMenuItemSelected(PopUpMenuTypes value, Product? product) {
    switch (value) {
      case PopUpMenuTypes.edit:
        _navigateToAddOrEditProductScreen(context,product: product);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>  AddOrEditProduct(product: product),
        //   ),
        // );
        break;
      case PopUpMenuTypes.delete:
        _showDeleteAlertDialogue(product?.id ?? '');
        break;
    }
  }

  void _showDeleteAlertDialogue(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Product',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Are you sure?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.green.shade400,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                deleteProductFromApi(productId);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent.shade400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
