import 'package:DaSell/commons.dart';
import 'package:DaSell/services/firebase/models/product_vo.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'product_details_state.dart';
import 'widgets/action_button.dart';
import 'widgets/image_slider.dart';
import 'widgets/widgets.dart';

class ProductDetails extends StatefulWidget {
  final ResponseProductVo data;

  const ProductDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  createState() => _ProductDetailsState();
}

class _ProductDetailsState extends ProductDetailsState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0x44000000),
        actions: [
          if (data.isMe)
            ActionButtonMoreOptions(onDelete: onDeleteTap, onSell: onSellTap),
        ],
      ),
      body: getContent(),
      floatingActionButton: Visibility(
        visible: hasChat,
        child: FittedBox(
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 15,
            label: Text(''),
            icon: Icon(FontAwesomeIcons.comments),
            onPressed: onChatTap,
          ),
        ),
      ),
    );
  }

  //floatingActionButton: !isMe && !isSold
  //                 ? Container(
  //                     height: 90.0,
  //                     width: 90.0,
  //                     child: FittedBox(
  //                       child: FloatingActionButton.extended(
  //                         backgroundColor: Theme.of(context).primaryColor,
  //                         foregroundColor: Colors.white,
  //                         elevation: 15,
  //                         label: Text(''),
  //                         icon: Icon(
  //                           FontAwesomeIcons.comments,
  //                         ),
  //                         onPressed: () => Navigator.of(context).pushNamed(
  //                           ChatScreen.routeName,
  //                           arguments: userData,
  //                         ),
  //                       ),
  //                     ),
  //
  //                 )

  Widget getContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: data.id.toString(),
                child: ProductImageSlider(
                  images: data.images!,
                  onChanged: onImageChanged,
                ),
              ),
              SliderDots(images: data.images!, current: current),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Gap(15),
                Text(
                  data.textDetailsPrice,
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                ),
                Gap(5),
                Text(
                  data.textTitle,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
                Gap(10),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.boxOpen),
                    Gap(30),
                    Text(
                      data.textShipment,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: data.getHasShipment()
                            ? Colors.pink[200]
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
                kDivider1,
                ProductCategoryButtons(
                  categories: data.categories ?? [],
                  onCategoryTap: onCategoryTap,
                ),
                Gap(10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book_outlined),
                            Gap(20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                data.textEstadoArticulo,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 170,
                        decoration:
                            BoxDecoration(color: Theme.of(context).cardColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Gap(10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: !hasLocation
                                  ? CommonProgress()
                                  : Text(
                                      locationText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 170,
                        decoration:
                            BoxDecoration(color: Theme.of(context).cardColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today),
                            Gap(10),
                            Text(
                              'Fecha de publicación',
                              style: TextStyle(fontFamily: 'Poppins'),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              textPublicationDate,
                              style: TextStyle(fontFamily: 'Poppins'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      if (!hasAdUser) CommonProgress(),
                      if (hasAdUser)
                      //TODO: Roi
                        ProductUserAvatar(imageUrl: adUser?.profilePicture),
                      Gap(25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Producto publicado por ',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                          ),
                          if (!hasAdUser) CommonProgress(),
                          if (hasAdUser)
                            Text(
                              textAdUserName,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins'),
                            ),
                        ],
                      )
                    ],
                  ),
                ),

                /// description?
                AutoSizeText(
                  textDescription,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                  minFontSize: 18,
                  maxLines: 4,
                ),

                Gap(25),

                if (hasAddress)
                  Column(
                    children: [
                      Row(children: [
                        Icon(FontAwesomeIcons.mapMarkedAlt, size: 30),
                        Gap(15),
                        Expanded(
                          child: AutoSizeText(
                            textAddress,
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 18),
                            minFontSize: 18,
                            maxLines: 4,
                          ),
                        )
                      ]),
                    ],
                  ),

                /// ---- MAP ---
                GestureDetector(
                  onTap: onMapTap,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Center(
                      child: mapUrl.isEmpty
                          ? Text('No hay ubicación')
                          : Image.network(mapUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Gap(70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
