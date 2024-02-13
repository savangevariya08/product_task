import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_task/screen/config/data/datas.dart';
import 'package:product_task/screen/products.dart';
import 'package:badges/badges.dart' as badges;
import '../provider/multi_rovider.dart';
import 'cart_screen.dart';

class Main_screen extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(cart);
    // TODO: implement build
   return SafeArea(
     child: Scaffold(
       appBar: AppBar(
           centerTitle: true,
           title: Text("Products", style: GoogleFonts.alata(fontSize: 25)),actions: [
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
       ]
       ),
       body: GridView.builder(
         itemCount: l.length-1,
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
         itemBuilder: (context, index) {
           return InkWell(
             onTap: () {
               Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => Products(index),
                   ));
             },
             child: Card(
               child: Column(
                 children: [
                   Expanded(child: Image.asset(image[index])),
                   Text("${l[index]}"),
                 ],
               ),
             ),
           );
         },
       ),
     ),
   );
  }

}
