import 'dart:io';
import 'package:student/globals.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //String folderPath = '';
  String selectedFolder = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Tool'),
        backgroundColor: Colors.amberAccent[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300, minWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  height: 50,
                  minWidth: 200,
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectAFolder();
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(8, 10, 8, 10)),
                        // minimumSize:
                        //     MaterialStateProperty<Size>(const Size(200, 50)),
                      ),
                      child: const Text(
                        'Select a folder',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedFolder,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/homeOption')
                          .then((value) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'exit',
        onPressed: () {
          exit(0);
        },
        label: const Text('Exit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.close),
      ),
    );
  }

  void selectAFolder() async {
    String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      globals.folderPath = selectedDirectory; //.replaceAll('\\', '/')
      selectedFolder = globals.folderPath.split('\\').last; //.split('\').last;
      //setState(() {});

      //const HomeOption();
      //print(folderPath);
    }
  }

//   Future<void> copyPath(String from, String to) async {
//   // if (_doNothing(from, to)) {
//   //   return;
//   // }
//   await Directory(to).create(recursive: true);
//   await for (final file in Directory(from).list(recursive: true)) {
//     final copyTo = p.join(to, p.relative(file.path, from: from));
//     if (file is Directory) {
//       await Directory(copyTo).create(recursive: true);
//     } else if (file is File) {
//       await File(file.path).copy(copyTo);
//     } else if (file is Link) {
//       await Link(copyTo).create(await file.target(), recursive: true);
//     }
//   }
// }
}
