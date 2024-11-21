class User {
  String id;
  String name;
  String email;
  String? phoneNumber;
  List<String>? cart;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    List<String>? cart,
  }) : this.cart = cart ?? [];

  // fromMap function to create a User object from a map
  factory User.fromMap(Map<String, dynamic> mapp) {
    final map = mapp['user'];
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      cart: List<String>.from(map['cart'] ?? []),
    );
  }

  // toMap function to convert a User object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'cart': cart,
    };
  }
}
