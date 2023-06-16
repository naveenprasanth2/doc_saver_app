import 'package:doc_saver_app/models/file_card_model.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/screens/document_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:provider/provider.dart';

class FileCard extends StatelessWidget {
  final FileCardModel fileCardModel;

  const FileCard({super.key, required this.fileCardModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 4)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  fileCardModel.fileType == "pdf"
                      ? "assets/icon_pdf_type.png"
                      : "assets/icon_image_type.png",
                  width: 60,
                ),
                SizedBoxHelper.sizedBox_10,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileCardModel.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(fileCardModel.subTitle,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                          "Date Added : ${fileCardModel.dateAdded.substring(0, 10)}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey))
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: AlertDialog(
                                backgroundColor: Colors.red,
                                title: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(fileCardModel.fileName,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Consumer<DocumentProvider>(
                                      builder: (context, provider, _) {
                                    return TextButton(
                                        onPressed: () {
                                          provider
                                              .deleteDocument(
                                                  fileCardModel.id,
                                                  "files_info/${provider.userId}",
                                                  fileCardModel.fileName,
                                                  context)
                                              .then((value) =>
                                                  Navigator.of(context).pop());
                                        },
                                        child: const Text("Ok",
                                            style: TextStyle(
                                                color: Colors.white)));
                                  }),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, DocumentViewScreen.routeName,
                        arguments: DocumentViewScreenArguments(
                            fileUrl: fileCardModel.fileUrl,
                            fileName: fileCardModel.fileName,
                            fileType: fileCardModel.fileType));
                  },
                  child: Text(
                    "View",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
