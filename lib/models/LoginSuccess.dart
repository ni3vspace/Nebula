class LoginSuccess {
  String? id;
  String? userName;
  String? emailId;
  String? password;
  String? date;
  String? count;

  LoginSuccess(
      {this.id,
        this.userName,
        this.emailId,
        this.password,
        this.date,
        this.count});

  LoginSuccess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    emailId = json['email_id'];
    password = json['password'];
    date = json['date'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_name'] = userName;
    data['email_id'] = emailId;
    data['password'] = password;
    data['date'] = date;
    data['count'] = count;
    return data;
  }
}