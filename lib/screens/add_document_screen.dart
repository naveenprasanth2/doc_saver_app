import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/widgets/custom_floating_action_button.dart';
import 'package:doc_saver_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doc_saver_app/screens/home_screen.dart';

class AddDocumentScreen extends StatefulWidget {
  static String routeName = "/addDocumentScreen";

  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final DocumentProvider provider =
        Provider.of<DocumentProvider>(context, listen: false);
    return Form(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Document"),
          centerTitle: true,
        ),
        floatingActionButton:
            Consumer<DocumentProvider>(builder: (context, provider, child) {
          return provider.isFileUploading
              ? const CircularProgressIndicator()
              : CustomFloatingActionButton(
                  title: "Upload",
                  iconData: Icons.check,
                  onTap: () {
                    if (_globalKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      provider.sendDocumentData(
                          context: context);
                    }
                  });
        }),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Consumer<DocumentProvider>(
                builder: (context, provider, child) {
                  return CustomTextField(
                      controller: provider.titleController,
                      hintText: "Title",
                      labelText: "Please enter the title",
                      prefixIconData: Icons.title,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter a valid document title";
                        } else {
                          return null;
                        }
                      },
                      obscureText: false);
                }
              ),
              SizedBoxHelper.sizedBox20,
              Consumer<DocumentProvider>(
                builder: (context, provider, child) {
                  return CustomTextField(
                      controller: provider.noteController,
                      hintText: "Note",
                      labelText: "Please enter the note",
                      prefixIconData: Icons.note,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter a valid document note";
                        } else {
                          return null;
                        }
                      },
                      obscureText: false);
                }
              ),
              SizedBoxHelper.sizedBox20,
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  provider.pickDocument(context: context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<DocumentProvider>(
                          builder: (context, provider, child) {
                        return Text(provider.selectedFileName);
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.grey,
                          ),
                          Text(
                            "Upload File",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
