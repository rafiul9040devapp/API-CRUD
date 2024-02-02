import 'package:flutter/material.dart';

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
  final TextEditingController _productCodeTEController = TextEditingController();
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
        title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
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
                  validator: (value) => validateInput(value, 'Empty Unit Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(
                      label: Text('Total Price'), hintText: 'Enter total price'),
                  validator: (value) => validateInput(value, 'Empty total Price'),
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
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(widget.product == null ? 'Create' : 'Update'),
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
    return value?.trim().isEmpty ?? true ? errorMessage : null;
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

  void clearControllers(){
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
