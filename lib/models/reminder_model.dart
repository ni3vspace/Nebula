class Reminders {
  String? id;
  String? name;
  String? description;
  String? userName;
  String? location;
  String? imageUrl;
  String? startDate;
  String? endDate;

  Reminders(
      {this.id,
        this.name,
        this.userName,
        this.location,
        this.imageUrl,
        this.startDate,
        this.endDate});

  Reminders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    userName = json['userName'];
    location = json['location'];
    imageUrl = json['imageUrl'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['userName'] = this.userName;
    data['location'] = this.location;
    data['imageUrl'] = this.imageUrl;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
