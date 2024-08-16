class create {
  String? message;
  Data? data;

  create({this.message, this.data});

  create.fromJson(Map<String, dynamic> json) {
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
  String? name;
  int? phone;
  String? emailId;
  String? password;
  String? sId;
  int? iV;

  Data({this.name, this.phone, this.emailId, this.password, this.sId, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    emailId = json['emailId'];
    password = json['password'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['emailId'] = this.emailId;
    data['password'] = this.password;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
