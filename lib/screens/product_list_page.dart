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
              backgroundImage: NetworkImage(
                  'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Fnice-france&psig=AOvVaw12C7NP4flnBU8LD-wKvy5i&ust=1706767473334000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCLioqL36hoQDFQAAAAAdAAAAABAE'),
            ),
            title: Text('Product Name'),
            subtitle: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
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
