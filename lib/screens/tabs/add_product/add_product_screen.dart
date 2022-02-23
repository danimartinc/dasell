import 'package:DaSell/commons.dart';
import 'package:flutter/material.dart';

//Widgets
import 'package:DaSell/widgets/add/category_item.dart';

//Data
import 'package:DaSell/data/categories.dart';

class AddProduct extends StatelessWidget {

  static const routeName = './add_product_screen';
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona el tipo de producto que quieres vender',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey[700],
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
            ),
            Gap(15),
            Expanded(
              child: GridView.builder(
                itemCount: Categories.categories.length,
                itemBuilder: (context, index ) {
                  return CategoryItem( index );
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
