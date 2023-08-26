class Products {
  String? uid;
  String? name;
  String? description;
  String? couleur;
  String? image;
  double? price;
  int? stock;

  Products({this.uid, this.name, this.description, this.couleur, this.price, this.stock});

  Products.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    couleur = json['couleur'];
    price = json['price'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    data['couleur'] = couleur;
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}

