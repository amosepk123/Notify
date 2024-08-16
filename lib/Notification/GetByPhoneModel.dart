class getByPhone {
  String? message;
  Data? data;

  getByPhone({this.message, this.data});

  getByPhone.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  int? phone;
  String? emailId;
  String? password;
  String? token;
  int? iV;

  Data(
      {this.sId,
        this.name,
        this.phone,
        this.emailId,
        this.password,
        this.token,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    emailId = json['emailId'];
    password = json['password'];
    token = json['token'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['emailId'] = this.emailId;
    data['password'] = this.password;
    data['token'] = this.token;
    data['__v'] = this.iV;
    return data;
  }
}
