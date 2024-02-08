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
  bool _isFetching = false;

  @override
  void initState() {
    _getAllProductsFromApi();
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
        onRefresh: _getAllProductsFromApi,
        child: _isFetching
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

  void _onTapPopUpMenuItemSelected(PopUpMenuTypes value, Product? product) {
    switch (value) {
      case PopUpMenuTypes.edit:
        _navigateToAddOrEditProductScreen(context, product: product);
        break;
      case PopUpMenuTypes.delete:
        _showDeleteAlertDialogue(product?.id ?? '');
        break;
    }
  }

  Future<void> _navigateToAddOrEditProductScreen(BuildContext context,
      {Product? product}) async {
    bool updatedList = false;
    if (context.mounted) {
      updatedList = (product == null)
          ? await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddOrEditProduct(),
              ),
            )
          : await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrEditProduct(product: product),
              ),
            );
    }
    if (updatedList == true) {
      _getAllProductsFromApi();
    }
  }

  Future<void> _getAllProductsFromApi() async {
    try {
      _setFetchOrDeleteProductInProgress(true);
      final Uri url =
          Uri.parse('${Constants.baseUrl}${Constants.readProductEndPoint}');
      final Response response = await get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          productList.clear();
          productList = _parsedProductList(responseBody['data']);
        }
      } else {
        _showSnackBar(
            'Failed to fetch product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('An error occurred while fetching the product $e');
    } finally {
      _setFetchOrDeleteProductInProgress(false);
    }
  }

  List<Product> _parsedProductList(dynamic response){
    return (response as List<dynamic>).map((e) => Product.fromJson(e)).toList();
  }

  Future<void> _deleteProductFromApi(String productId) async{
    try{
      _setFetchOrDeleteProductInProgress(true);

      final Uri url = Uri.parse('${Constants.baseUrl}${Constants.deleteProductEndPoint}');
      final Response response = await get(url);

      if(response.statusCode ==200){
        productList.removeWhere((element) => element.id == productId);
        _showSnackBar('Product Is Deleted Successfully');
      }else{
        _showSnackBar('Unable to Delete the Product. Status code: ${response.statusCode}');
      }
    }catch (e){
      _showSnackBar('An error occurred while deleting the product: $e');
    }finally{
      _setFetchOrDeleteProductInProgress(false);
    }
  }

  void _setFetchOrDeleteProductInProgress(bool inProgress) {
    if (mounted) {
      _isFetching = inProgress;
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
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
              onPressed: (){
                _deleteProductFromApi(productId);
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
