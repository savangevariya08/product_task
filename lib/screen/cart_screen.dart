import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/multi_rovider.dart';
import 'config/data/cart_model.dart';
import 'config/data/db_helper.dart';
import 'package:badges/badges.dart' as badges;

class CartScreen extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DBHelper? db = DBHelper();
    final c = ref.watch(cart);
    // TODO: implement build
  return  Scaffold(
    appBar: AppBar(
      title: Text('Shopping Cart'),
      centerTitle: true,
      actions: [
        Center(
          child:
          badges.Badge(
            badgeContent: Text(c.getCounter().toString()),
            child: Icon(Icons.shopping_bag_outlined),
          ),
        ),
        SizedBox(width: 20.0)
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future:c.getData() ,
              builder: (context , AsyncSnapshot<List<Cart>> snapshot){
                if(snapshot.hasData){

                  if(snapshot.data!.isEmpty){
                    return Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('empty/empty_cart.png'),
                          ),
                          SizedBox(height: 20,),
                          Text('Your cart is empty 😌' ,style: Theme.of(context).textTheme.headline5),
                          SizedBox(height: 20,),
                          Text('Explore products and shop your\nfavourite items' , textAlign: TextAlign.center ,style: Theme.of(context).textTheme.subtitle2)

                        ],
                      ),
                    );
                  }else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index){
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image(
                                          height: 100,
                                          width: 100,
                                          image: AssetImage(snapshot.data![index].image.toString()),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(snapshot.data![index].productName.toString() ,
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                  ),
                                                  InkWell(
                                                      onTap: (){
                                                        db!.delete(snapshot.data![index].id!);
                                                        c.removerCounter();
                                                        c.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                      },
                                                      child: Icon(Icons.delete))
                                                ],
                                              ),

                                              SizedBox(height: 5,),
                                              Text(""+r"$"+ snapshot.data![index].productPrice.toString() ,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(height: 5,),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: (){


                                                  },
                                                  child:  Container(
                                                    height: 35,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child:  Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                              onTap: (){

                                                                int quantity =  snapshot.data![index].quantity! ;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity--;
                                                                int? newPrice = price * quantity ;

                                                                if(quantity > 0){
                                                                  db!.updateQuantity(
                                                                      Cart(
                                                                          id: snapshot.data![index].id!,
                                                                          productId: snapshot.data![index].id!.toString(),
                                                                          productName: snapshot.data![index].productName!,
                                                                          initialPrice: snapshot.data![index].initialPrice!,
                                                                          productPrice: newPrice,
                                                                          quantity: quantity,
                                                                          image: snapshot.data![index].image.toString())
                                                                  ).then((value){
                                                                    newPrice = 0 ;
                                                                    quantity = 0;
                                                                    c.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                  }).onError((error, stackTrace){
                                                                    print(error.toString());
                                                                  });
                                                                }

                                                              },
                                                              child: Icon(Icons.remove , color: Colors.white,)),
                                                          Text( snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white)),
                                                          InkWell(
                                                              onTap: (){
                                                                int quantity =  snapshot.data![index].quantity! ;
                                                                int price = snapshot.data![index].initialPrice!;
                                                                quantity++;
                                                                int? newPrice = price * quantity ;

                                                                db!.updateQuantity(
                                                                    Cart(
                                                                        id: snapshot.data![index].id!,
                                                                        productId: snapshot.data![index].id!.toString(),
                                                                        productName: snapshot.data![index].productName!,
                                                                        initialPrice: snapshot.data![index].initialPrice!,
                                                                        productPrice: newPrice,
                                                                        quantity: quantity,
                                                                        image: snapshot.data![index].image.toString())
                                                                ).then((value){
                                                                  newPrice = 0 ;
                                                                  quantity = 0;
                                                                  c.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace){
                                                                  print(error.toString());
                                                                });
                                                              },
                                                              child: Icon(Icons.add , color: Colors.white,)),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }

                }
                return Text('') ;
              }),
          Visibility(
            visible: c.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
            child: Column(
              children: [
                ReusableWidget(title: 'Sub Total', value: r'$'+c.getTotalPrice().toStringAsFixed(2),),
                ReusableWidget(title: 'Discout 5%', value: r'$'+'20',),
                ReusableWidget(title: 'Total', value: r'$'+c.getTotalPrice().toStringAsFixed(2),)
              ],
            ),
          )
        ],
      ),
    ) ,
  );
  }

}

class ReusableWidget extends StatelessWidget {
  final String title , value ;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title , style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString() , style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}