import 'dart:io';

import 'package:flutter/material.dart';

class HomeOption extends StatefulWidget {
  const HomeOption({super.key});

  @override
  State<HomeOption> createState() => _HomeOptionState();
}

class _HomeOptionState extends State<HomeOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Section'),
        backgroundColor: Colors.amberAccent[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          // width: 400,
          // height: 300,
          //color: Colors.grey[700],
          constraints: const BoxConstraints(maxHeight: 300, minWidth: 400),
          child: Card(
            color: Colors.grey[500],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/noun')
                          .then((value) => setState(() {}));
                    },
                    child: const Text('Noun',
                        style: TextStyle(
                          fontSize: 24,
                        )),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60), elevation: 3),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/verb')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'Verb',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60), elevation: 3),
                    onPressed: () {
                      // With MaterialPageRoute, you can pass data between pages,
                      // but if you have a more complex app, you will quickly get lost.
                      Navigator.of(context)
                          .pushNamed('/association')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'Association',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60), elevation: 3),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/activity')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: 'quiz',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/quiz')
                  .then((value) => setState(() {}));
            },
            icon: const Icon(Icons.quiz),
            label: const Text('Quiz Test',
                style: TextStyle(
                  fontSize: 18,
                )),
          ),
          const Spacer(),
          FloatingActionButton.extended(
            heroTag: 'exit',
            onPressed: () {
              exit(0);
            },
            label: const Text('Exit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}