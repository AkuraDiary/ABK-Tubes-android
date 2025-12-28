class UserModel{
  String? id;
   String? name;
   String? email;

  UserModel({
     this.id,
     this.name,
     this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:  json['user_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email}';
  }
}