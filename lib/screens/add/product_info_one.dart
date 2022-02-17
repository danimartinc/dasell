import 'package:flutter/material.dart';


//Widgets
import 'package:DaSell/widgets/add/info_form.dart';
import 'package:DaSell/widgets/bottom_button.dart';

class ProductInfoOne extends StatefulWidget {

  static const routeName = './product_info';
  
  @override
  _ProductInfoOneState createState() => _ProductInfoOneState();
}

class _ProductInfoOneState extends State<ProductInfoOne> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Detalles del producto'),
      ),
      body: BookInfoForm(),
      // bottomNavigationBar: BottomButton(
      //   'Next',
      //   () {},
      //   Icons.arrow_forward,
      // ),
    );
  }
}
