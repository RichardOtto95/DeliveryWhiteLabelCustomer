import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/cart_model.dart';
import 'item.dart';

class Items extends StatelessWidget {
  final Function(String id) onAdd, onClean, onRemove;
  final MainStore mainStore = Modular.get();
  final CartStore store = Modular.get();

  Items({
    Key? key, 
    required this.onAdd, 
    required this.onClean, 
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            wXD(23, context),
            wXD(23, context),
            wXD(23, context),
            wXD(8, context),
          ),
          child: Text(
            'Itens adicionados',
            style: textFamily(
              context,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: getColors(context).onSurface,
            ),
          ),
        ),
        Observer(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: store.cartList.map((adsId) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("ads")
                      .doc(adsId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: wXD(86, context),
                        width: maxWidth(context),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              getColors(context).primary),
                        ),
                      );
                    }

                    DocumentSnapshot itemDoc = snapshot.data!;
                    CartModel cartModel = mainStore.cart[adsId]!;

                    return Item(
                      maxAmount: itemDoc['amount'],
                      amount: cartModel.amount,
                      description: itemDoc['description'],
                      image: itemDoc['images'].first,
                      name: itemDoc['title'],
                      price: cartModel.totalPrice.toDouble(),
                      onAdd: () {
                        onAdd(itemDoc.id);
                      },
                      onClean: () {
                        onClean(itemDoc.id);
                      },
                      onRemove: () {
                        onRemove(itemDoc.id);
                      },
                      onItemTap: () {
                        Modular.to.pushNamed('/cart/product', arguments: itemDoc.id);
                      },
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: lightGrey.withOpacity(.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
