import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_task/screen/config/data/cart_model.dart';
import 'package:product_task/screen/config/data/datas.dart';
import 'package:badges/badges.dart' as badges;

import '../provider/multi_rovider.dart';
import '../widgets/rounded_btn.dart';
import 'cart_screen.dart';
import 'config/data/db_helper.dart';

class Products extends ConsumerWidget {
  int index;

  Products(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DBHelper? db = DBHelper();
    final c = ref.watch(cart);
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Shoping"),  centerTitle: true,
            actions: [
          InkWell(onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ));
          },
            child: Center(
              child: badges.Badge(
                badgeContent: Text(c.getCounter().toString()),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ]),
        body: Card(
          child: Column(
            children: [
              Expanded(child: Center(child: Image.asset(image[index]))),
              Center(
                child: Text(
                  "${l[index]}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 150,
                child: RoundedButton(bgcolor: Colors.blue,
                  btnName: 'Add to Cart',
                  callback: () {
                    db!.insert(Cart(
                        id: index,
                        productId: index.toString(),
                        productName: l[index].toString(),
                        initialPrice: productPrice[index],
                        productPrice: productPrice[index],
                        quantity: 1,
                        image: image[index].toString()))
                        .then((value) {
                      c.addTotalPrice(
                          double.parse(productPrice[index].toString()));
                      c.addCounter();
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Product is added to cart'),
                        duration: Duration(seconds: 1),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
