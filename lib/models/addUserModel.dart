class Agent_Add_Model {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool status;
  final String phone;
  final String image;

  Agent_Add_Model({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.phone,
    required this.image,
  });

  factory Agent_Add_Model.fromMap(String id, Map<String, dynamic> data) {
    return Agent_Add_Model(
      id: id,
      name: data["NAME"] ?? "",
      email: data["EMAIL"] ?? "",
      role: data["ROLE"] ?? "",
      status: data["STATUS"] ?? false,
      phone: data["PHONE"] ?? "",
      image: data["IMAGE"] ?? "",
    );
  }
}