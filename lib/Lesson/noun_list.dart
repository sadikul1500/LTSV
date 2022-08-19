//read from folder /files and store here
//array of title, meaning, imageList, audio
//start.....
class NounList {
  String title = '';
  String meaning = '';
  List<String> imagePath = [];
  String audio = '';
  String line;

  NounList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() {
    List<String> values = line.split("; ");
    title = values[0];
    meaning = values[1];
    imagePath = getImagePaths(values[2].split('/').last);
    audio = values[3].split('/').last;
  }

  getImagePaths(String folderName) {}
}
