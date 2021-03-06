import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//Providers
import 'package:DaSell/provider/ad_provider.dart';

//Data
import 'package:DaSell/data/categories.dart';

//Screens
import 'package:DaSell/screens/add/further_cat.dart';

class CategoryItem extends StatelessWidget {
  
  final int index;
  //final Color color;
  //final String id;

  String icon = 'icon';
  //final String? color;

  //Constructor
  CategoryItem(
    this.index,
  );

  @override
  Widget build(BuildContext context) {

    var color = Theme.of(context).primaryColor;
    var cats = Categories.categories[index];

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          FurtherCat.routeName,
          arguments: index,
        )
        .then((_) {
          Categories.storedCategories.clear();
        });
        //Categories.addCategory(cats['category']);
        Provider.of<AdProvider>(
          context,
          listen: false,
        ).addCategory(cats['category']);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon( cats["icon"], size: 45, ),
              SizedBox ( height: 10.0 ), 
              Text(
                cats['category'],
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
      
            ]
          ) 
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.40),
              color.withOpacity(0.5),
              color.withOpacity(0.6),
            ], 
            begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Theme.of(context).primaryColor,
          //   width: 1,
          // ),
        ),
      ),
    );
  }
}
