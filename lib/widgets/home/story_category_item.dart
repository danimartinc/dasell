import 'package:DaSell/data/categories.dart';
import 'package:flutter/material.dart';

import '../../const/colors.dart';

class StoryCategoryItem extends StatelessWidget {
  final String? img;

  //final String name;
  final int index;

  const StoryCategoryItem({
    Key? key,
    required this.index,
    this.img,
    //required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cats = Categories.categories[index];
    var color = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                color.withOpacity(0.40),
                color.withOpacity(0.5),
                color.withOpacity(0.6),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   color: Theme.of(context).primaryColor,
              //   width: 1,
              // ),
            ),
            /*decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: storyBorderColor
            ),
          ),*/
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 65,
                height: 65,
                child: Icon(
                  cats["icon"],
                  size: 45,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: black, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 70,
            child: Text(
              cats['category'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: white),
            ),
          ),
        ],
      ),
    );
  }
}

/*return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: favorites[index],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                              AssetImage(favorites[index].imageUrl),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          favorites[index].name,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }*/
