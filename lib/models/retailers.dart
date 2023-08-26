class Retailers {
  String? uid;
  String? name;
  String? email;


  Retailers(
      {this.uid,
      this.name,
      this.email});

  Retailers.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
