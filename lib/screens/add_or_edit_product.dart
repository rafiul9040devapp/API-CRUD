import 'package:flutter/material.dart';

class AddOrEditProduct extends StatefulWidget {
  const AddOrEditProduct({super.key});

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
      ),
    );
  }
}
