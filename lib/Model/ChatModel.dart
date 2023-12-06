class ChatModel {
  String? name; // Puede ser nulo
  String? icon; // Puede ser nulo
  String? time; // Puede ser nulo
  String? currentMessage; // Puede ser nulo
  String phone; // Número de teléfono del contacto

  ChatModel({
    this.name,
    this.icon,
    this.currentMessage,
    this.time,
    required this.phone,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['contact_name'] ?? '', 
      icon: json['icon'] ?? '', 
      time: json['time'] ?? '',
      currentMessage: json['currentMessage'] ??
          '', 
      phone:
          json['contact_phone'] ?? '',
    );
  }
}
