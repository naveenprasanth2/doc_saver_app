class FileCardModel {
  final String title;
  final String subTitle;
  final String fileUrl;
  final String dateAdded;
  final String fileType;
  final String fileName;
  final String id;

  FileCardModel(
      {required this.title,
      required this.subTitle,
      required this.dateAdded,
      required this.fileType,
      required this.fileUrl,
      required this.fileName,
      required this.id});

  factory FileCardModel.fromJson(Map<dynamic, dynamic> json, String id) {
    return FileCardModel(
        id: id,
        title: json["title"],
        fileName: json["fileName"],
        subTitle: json["note"],
        dateAdded: json["dateAdded"],
        fileType: json["fileType"],
        fileUrl: json["fileUrl"]);
  }
}
