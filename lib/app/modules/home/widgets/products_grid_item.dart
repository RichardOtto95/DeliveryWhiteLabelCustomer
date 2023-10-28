import 'package:delivery_customer/app/constants/themes/text_theme.dart';
import 'package:flutter/material.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                //color: Colors.orange,
                child: Center(
                  child: Image.asset(
                    './assets/images/exemple_product.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Text(
                'Titulo do Produto',
                style: CustomTextTheme.secundaryTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  'Lorem Ipsum lorem ipsum \n lorem ipsum lorem ipsum',
                  style: CustomTextTheme.descriptionStyle,
                ),
              ),
            ),
            Text(
              'R\$ 100,00',
              style: CustomTextTheme.priceStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
