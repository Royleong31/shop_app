import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/productsProvider.dart';
import 'package:shop_app/screens/editProductsScreen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  UserProductItem(this.imageUrl, this.title, this.id);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully Deleted!')));
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                    print(err);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
