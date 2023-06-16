import 'dart:async';

import 'package:doc_saver_app/models/file_card_model.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/screens/add_document_screen.dart';
import 'package:doc_saver_app/widgets/custom_floating_action_button.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doc_saver_app/widgets/custom_home_appbar.dart';
import 'package:doc_saver_app/widgets/file_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "/homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  StreamController<DatabaseEvent> streamController = StreamController();

  setStream() {
    FirebaseDatabase.instance
        .ref()
        .child(
            "files_info/${Provider.of<DocumentProvider>(context, listen: false).userId}")
        .orderByChild("title")
        .startAt(searchController.text)
        .endAt("${searchController.text}" "\uf8ff")
        .onValue
        .listen((event) {
      streamController.add(event);
    });
  }

  @override
  void initState() {
    setStream();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: CustomFloatingActionButton(
          title: "Add file",
          iconData: Icons.add,
          onTap: () {
            Navigator.pushNamed(context, AddDocumentScreen.routeName);
          },
        ),
        appBar: CustomHomeAppBar(
          controller: searchController,
          onSearch: () {
            setStream();
          },
        ),
        body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<DatabaseEvent>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    List<FileCardModel> list = [];
                    (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                        .forEach((key, value) {
                      list.add(FileCardModel.fromJson(value, key));
                    });
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: list
                          .map((e) => FileCard(
                                fileCardModel: FileCardModel(
                                  id: e.id,
                                  title: e.title,
                                  fileName: e.fileName,
                                  subTitle: e.subTitle,
                                  dateAdded: e.dateAdded,
                                  fileType: e.fileType,
                                  fileUrl: e.fileUrl,
                                ),
                              ))
                          .toList(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon_no_file.png",
                          width: 100,
                        ),
                        const Text("No data found"),
                      ],
                    ));
                  }
                }),
          ),
        ),
      ),
    );
  }
}
