import 'dart:math';

String getImageURL() {
  int index = Random().nextInt(200) + 1;
  return "https://raw.githubusercontent.com/muhammadkarbalaee/ball-images/master/balls/$index.png";
}