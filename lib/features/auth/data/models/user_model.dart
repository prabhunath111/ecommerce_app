import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    super.phone,
    super.address,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name']?.toString() ?? 'Guest User',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      phone: json['phone']?.toString() ?? '+91 98765 43210',
      address: json['address']?.toString() ?? '42 High Street, Bangalore, India',
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'address': address,
      'token': token,
    };
  }

  UserEntity toEntity() => this;
}
