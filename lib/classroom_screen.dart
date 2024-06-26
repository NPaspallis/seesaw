import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'main.dart';

const baseUrl = 'https://npaspallis.github.io/seesaw';

class ClassroomScreen extends StatefulWidget {

  const ClassroomScreen({super.key});

  @override
  State createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {

  String? _classroomName;
  String? _classroomUUID;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seesaw App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: preparedPrimaryColor),
          primaryColor: preparedPrimaryColor,
          splashColor: preparedSecondaryColor,
          // fontFamily: 'Open Sans',
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: preparedPrimaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: preparedWhiteColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              color: preparedPrimaryColor,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                    ),
                    body: _classroomName != null ? getClassroomSharingWidget() : getClassroomCreationWidget(),
                  )
              ),
            )
        )
    );
  }

  Widget getClassroomCreationWidget() {
    return Center(
        child: Form(
          child: Column(
            children: [
              const Text(
                "Please enter a name to create a classroom",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),

              const Gap(30),

              // Classroom name field
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter classroom name",
                    hintStyle: TextStyle(
                      color: Colors.teal.shade100,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                ),
              ),

              const Gap(30),

              //Ok button
              ElevatedButton(
                child: const Text("OK", style: TextStyle(fontSize: 30),),
                onPressed: () {
                  createClassroom();
                },
              ),

              const Gap(50),

              const Text('Note that all classroom spaces and their responses are deleted after 30 days', style: TextStyle(fontSize: 18, color: preparedWhiteColor))
            ],
          ),
        ),
      );
  }

  Widget getClassroomSharingWidget() {

    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('A custom space has been created for your classroom', style: TextStyle(fontSize: 24, color: preparedWhiteColor)),
            const Gap(30),
            Text('$_classroomName', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: preparedWhiteColor)),
            const Gap(30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: goToClassroom,
                    child: Text(
                        getClassroomUrl(),
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white
                        )
                    )
                ),
                const Gap(10),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  color: preparedWhiteColor,
                  onPressed: copyUrl,
                )
              ],
            ),
            const Gap(30),
            InkWell(
                onTap: goToClassroom,
                child:  Container(
                  padding: const EdgeInsets.all(20),
                  child: QrImageView(
                    data: '$baseUrl/#/class?uuid=$_classroomUUID',
                    version: QrVersions.auto,
                    size: 400.0,
                    backgroundColor: Colors.white,
                  ),
                )
            )
          ],
        )
    );
  }

  void createClassroom() {
    String name = _nameController.text;
    //todo check name is valid
    final String longUuid = const Uuid().v4();  // create random uuid
    final uuid = longUuid.substring(longUuid.length - 8); // keep last 8 chars
    // todo save to firebase: name & uuid

    setState(() {
      _classroomName = name;
      _classroomUUID = uuid;
    });
  }

  void createClassroomOnFirebase({required String name, required String uuid}) {
    // firebase must:
    // 1. delete all classrooms created

  }

  void goToClassroom() async {
    final Uri url = Uri.parse(getClassroomUrl());
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void copyUrl() async {
    Clipboard.setData(ClipboardData(text: getClassroomUrl())).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'))); // todo figure out why snack doesnt show up
    });
  }

  String getClassroomUrl() {
    // return '${Uri.base}#/class?uuid=$_classroomUUID';
    return '${Uri.base}?uuid=$_classroomUUID&name=$_classroomName';
  }
}