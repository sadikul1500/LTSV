import 'package:flutter/material.dart';
// import 'package:kids_learning_tool/Quiz/ActivityScheduling/options.dart';
// import 'package:kids_learning_tool/Quiz/Jigsaw/imageSelection.dart';
//import 'package:flutter/services.dart';

class Quiz extends StatefulWidget {
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    //print('called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('কুইজ পরীক্ষা'), //'Quiz Test'),
        backgroundColor: Colors.amberAccent[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 300,
          //color: Colors.grey[700],
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
                          .pushNamed('/matching')
                          .then((value) => setState(() {}));
                    },
                    child: const Text('MCQ কুইজ', //'Matching',
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
                          .pushNamed('/drag')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'ড্র্যাগ ও ড্রপ', //'Drag & Drop',
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
                          .pushNamed('/activityScheduling')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'কর্মধারা পরীক্ষা', //'Activity Scheduling',
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
                          .pushNamed('/jigsaw')
                          .then((value) => setState(() {}));
                    },
                    child: const Text(
                      'ছবির ধাঁধা', //'Jigsaw Puzzle',
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
      // floatingActionButton: FloatingActionButton.extended(
      //   heroTag: 'btn1',
      //   onPressed: () {
      //     Navigator.of(context)
      //         .pushNamed('/reward')
      //         .then((value) => setState(() {}));
      //   },
      //   //icon: const Icon(Icons.add),
      //   label: const Text('Set Reward',
      //       style: TextStyle(
      //         fontSize: 18,
      //       )),
      // ),
    );
  }
}
