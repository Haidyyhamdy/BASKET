class LoginModel {
  bool? status;
  String? message;
  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? UserData.fromJson(json['data'])
        : null; //3lshan l data momkn tegy b null lw gt b null aktb null
    //ast5dmt l userdata.json 3lshan a3rf atl3 l data kolha
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  dynamic points;
  dynamic credit;
  String? token;

  //named constructor

  UserData.fromJson(Map<String, dynamic> json) {
    //3mltha map 3lashan da shkl l data lle btegy
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['images'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}
