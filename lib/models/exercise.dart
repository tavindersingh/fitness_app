class Exercise {
  final String name;
  final String bodyPart;
  final String tool;
  final String? imageUrl;

  Exercise({
    required this.name,
    required this.bodyPart,
    required this.tool,
    this.imageUrl,
  });
}
