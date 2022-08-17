import 'dart:io';

import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              OutlinedButton(
                onPressed: () {
                  selectAFolder();
                },
                child: const Text(
                  'Select a folder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            ],

          )
        ),
      ),
      floatingActionButton: //Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // children: [
        //   const SizedBox(width: 25.0),
          // FloatingActionButton.extended(
          //   heroTag: 'quiz',
          //   onPressed: () {
          //     Navigator.of(context)
          //         .pushNamed('/quiz')
          //         .then((value) => setState(() {}));
          //   },
          //   icon: const Icon(Icons.quiz),
          //   label: const Text('Quiz Test',
          //       style: TextStyle(
          //         fontSize: 18,
          //       )),
          // ),
          
          // const Spacer(),
          FloatingActionButton.extended(
            heroTag: 'exit',
            onPressed: () {
              exit(0);
            },
            label: const Text('Exit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            icon: const Icon(Icons.close),
          ),
        //]//,
      //),
      
    );
  }

  void selectAFolder() async {
    String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

    if (selectedDirectory == null) {
      // User canceled the picker
    } else {
      selectedDirectory.replaceAll('\\', '/');

      // File(selectedDirectory + '/noun.txt').createSync(recursive: true);
      // _write(File(selectedDirectory + '/noun.txt'));
      //copyImage(selectedDirectory);
      // copyAudio(selectedDirectory);
    }
  }
}