import 'dart:convert';

import 'package:api_crud/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/product.dart';

class AddOrEditProduct extends StatefulWidget {
  final Product? product;

  const AddOrEditProduct({super.key, this.product});

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
  TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addOrEditProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    initializeController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTEController,
                  decoration: const InputDecoration(
                      label: Text('Title'), hintText: 'Enter product title'),
                  validator: (value) =>
                      validateInput(value, 'Empty Product Title'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: const InputDecoration(
                      label: Text('Product Code'),
                      hintText: 'Enter product code'),
                  validator: (value) =>
                      validateInput(value, 'Empty Product Code'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _quantityTEController,
                  decoration: const InputDecoration(
                      label: Text('Quantity'),
                      hintText: 'Enter product quantity'),
                  validator: (value) =>
                      validateInput(value, 'Empty Product Quantity'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _unitPriceTEController,
                  decoration: const InputDecoration(
                      label: Text('Unit Price'), hintText: 'Enter unit price'),
                  validator: (value) =>
                      validateInput(value, 'Empty Unit Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(
                      label: Text('Total Price'),
                      hintText: 'Enter total price'),
                  validator: (value) =>
                      validateInput(value, 'Empty total Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                      label: Text('Product Image'),
                      hintText: 'Enter product image'),
                  validator: (value) =>
                      validateInput(value, 'Empty Product Image'),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: MediaQuery
                      .sizeOf(context)
                      .width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.product == null) {
                          createNewProduct();
                        } else {
                          updatedProduct();
                        }
                      }
                    },
                    child: _addOrEditProductInProgress
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(widget.product == null ? 'Create' : 'Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateInput(String? value, String errorMessage) {
    return value
        ?.trim()
        .isEmpty ?? true ? errorMessage : null;
  }

  void initializeController() {
    if (widget.product != null) {
      _titleTEController.text = widget.product?.productName ?? '';
      _imageTEController.text = widget.product?.img ?? '';
      _productCodeTEController.text = widget.product?.productCode ?? '';
      _quantityTEController.text = widget.product?.qty ?? '';
      _unitPriceTEController.text = widget.product?.unitPrice ?? '';
      _totalPriceTEController.text = widget.product?.totalPrice ?? '';
    }
  }

  dynamic _sendRequiredParamsForApi({String? productId}) {
    if (productId == null) {
      return {
        "Img": _imageTEController.text.trim(),
        "ProductCode": _productCodeTEController.text.trim(),
        "ProductName": _titleTEController.text.trim(),
        "Qty": _quantityTEController.text.trim(),
        "TotalPrice": _totalPriceTEController.text.trim(),
        "UnitPrice": _unitPriceTEController.text.trim(),
      };
    } else {
      return Product(
        id: productId,
        productName: _titleTEController.text.trim(),
        productCode: _productCodeTEController.text.trim(),
        img: _imageTEController.text.trim(),
        unitPrice: _unitPriceTEController.text.trim(),
        qty: _quantityTEController.text.trim(),
        totalPrice: _titleTEController.text.trim(),
        createdDate: DateTime.now().toString(),
      );
    }
  }

  Future<void> createNewProduct() async {
    try {
      _setAddOrEditProductInProgress(true);
      final Uri uri = Uri.parse(
          '${Constants.baseUrl}${Constants.createProductEndPoint}');

      final Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_sendRequiredParamsForApi()),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Product has been added');
        _clearControllers();
        await Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pop(context, true));
      } else if (response.statusCode == 400) {
        _showSnackBar('Product code should be unique');
      } else {
        _showSnackBar(
            'Failed to create product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('An error occurred while creating the product');
    } finally {
      _setAddOrEditProductInProgress(false);
    }
  }


  Future<void> updatedProduct() async {
    try {
      _setAddOrEditProductInProgress(true);

      String productId = widget.product?.id ?? '';
      final Uri uri = Uri.parse(
          '${Constants.baseUrl}${Constants.updateProductEndPoint}$productId');

      final Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json',},
        body: jsonEncode(_sendRequiredParamsForApi(productId: productId).toJson(),),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Product has been updated');
        _clearControllers();
        await Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pop(context, true));
      } else if (response.statusCode == 400) {
        _showSnackBar('Product code should be unique');
      } else {
        _showSnackBar(
            'Failed to update product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('An error occurred while updating the product');
    } finally {
      _setAddOrEditProductInProgress(false);
    }
  }

  void _setAddOrEditProductInProgress(bool inProgress) {
    if (mounted) {
      _addOrEditProductInProgress = inProgress;
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

  void _clearControllers() {
    _titleTEController.clear();
    _imageTEController.clear();
    _productCodeTEController.clear();
    _quantityTEController.clear();
    _totalPriceTEController.clear();
    _unitPriceTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _imageTEController.dispose();
    _productCodeTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
    super.dispose();
  }
}
