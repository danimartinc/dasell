import 'package:DaSell/commons.dart';

class ResponseProductVo {
  List<String>? images;
  String? description;
  String? title;
  bool? isFav;
  String? uid;
  Timestamp? createdAt;
  String? condition;
  double? price;
  bool? isSold;
  $Location? location;
  List<String>? categories;
  int? id;
  bool? makeShipments;

  /// usado para localizacion
  double fromLoc = 0;

  ResponseProductVo(
      {this.images,
      this.description,
      this.title,
      this.isFav,
      this.uid,
      this.createdAt,
      this.condition,
      this.price,
      this.isSold = false,
      this.location,
      this.categories,
      this.id,
      this.makeShipments});

  bool get isMe {
    return FirebaseService.get().uid == uid;
  }

  String get textEstadoArticulo {
    return 'Estado del artículo:\n' + (condition ?? "");
  }

  bool getHasShipment() {
    return makeShipments == true;
  }

  String get textShipment {
    if (makeShipments == true) {
      return 'Acepta envíos - desde 2,50 €';
    }
    return 'No admite envíos';
  }

  bool getHasPrice() {
    return (price ?? 0) != 0;
  }

  String get textDetailsPrice {
    if (isSold ?? false) {
      return "Vendido";
    } else {
      return '$price €';
    }
  }

  String get textPrice {
    if (price == 0) {
      return 'Donación';
    } else {
      return '$price €';
    }
  }

  bool getIsSold() {
    return isSold ?? false;
  }

  String get textId => '$id';

  String get itemImageUrl {
    return images?.first ?? '';
  }

  String get textTitle => title ?? '-';

  @override
  String toString() {
    return 'ResponseProductVo{images: $images, description: $description, title: $title, isFav: $isFav, uid: $uid, createdAt: $createdAt, condition: $condition, price: $price, isSold: $isSold, location: $location, categories: $categories, id: $id, makeShipments: $makeShipments}';
  }

  ResponseProductVo.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    description = json['description'];
    title = json['title'];
    isFav = json['isFav'];
    uid = json['uid'];
    createdAt = json['createdAt'];
    condition = json['condition'];
    price = json['price'];
    isSold = json['isSold'];
    location = json['location'] != null
        ? new $Location.fromJson(json['location'])
        : null;
    categories = json['categories'].cast<String>();
    id = json['id'];
    makeShipments = json['makeShipments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['description'] = this.description;
    data['title'] = this.title;
    data['isFav'] = this.isFav;
    data['uid'] = this.uid;
    data['createdAt'] = this.createdAt?.toDate().toString();
    data['condition'] = this.condition;
    data['price'] = this.price;
    data['isSold'] = this.isSold;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['categories'] = this.categories;
    data['id'] = this.id;
    data['makeShipments'] = this.makeShipments;
    return data;
  }

  bool getFav() {
    return isFav ?? false;
  }
}

class $Location {
  String? address;
  double? latitude;
  double? longitude;

  $Location({this.address, this.latitude, this.longitude});

  $Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
