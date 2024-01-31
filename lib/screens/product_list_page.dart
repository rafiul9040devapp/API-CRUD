import 'package:flutter/material.dart';

enum PopUpMenuTypes { edit, delete }

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200/300'),
            ),
            title: Text('Product Name'),
            subtitle: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 16,
              children: [
                Text('Product code'),
                Text('Product unit price'),
                Text('Product total price'),
                Text('Product quantity'),
              ],
            ),
            trailing: PopupMenuButton<PopUpMenuTypes>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: PopUpMenuTypes.edit,
                  child: ListTile(
                  leading: Icon(Icons.edit),
                    title: Text('EDIT'),
                ),),
                PopupMenuItem(
                  value: PopUpMenuTypes.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_forever_outlined),
                    title: Text('DELETE'),
                  ),),
              ],
            ),
          );
        },
      ),
    );
  }
}
