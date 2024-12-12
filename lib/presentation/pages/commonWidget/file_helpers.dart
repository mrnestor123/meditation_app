
// ESTO NO DEBERÍA ESTAR EN PRESENTATION ??

bool isAudio(String path){
  return path.toLowerCase().contains(RegExp('aud|m4a|mp3'));
}



bool isVideo(String path){
  return path.toLowerCase().contains(RegExp('mp4'));
}


bool isImage(String path){
  return path.contains(RegExp('jpg|png'));
}



