class MessageModel {
  final String message;
  final String translatedMessage;
  final String sourcePhone;
  final String targetPhone;

  MessageModel({
    required this.message,
    required this.translatedMessage,
    required this.sourcePhone,
    required this.targetPhone,
  });

factory MessageModel.fromJson(Map<String, dynamic> json) {
  return MessageModel(
    message: json['message'] ?? '', // Si 'message' falta, establece un valor predeterminado vacío
    translatedMessage: json['translatedMessage'] ?? json['message'], // Usa 'message' si 'translatedMessage' falta
    sourcePhone: json['from'] ?? '', // Si 'from' falta, establece un valor predeterminado vacío
    targetPhone: json['to'] ?? '', // Si 'to' falta, establece un valor predeterminado vacío
  );
}

}

