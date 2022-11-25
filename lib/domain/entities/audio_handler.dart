


import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';


Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.tenstages.audio',
      androidNotificationChannelName: 'TenStages Meditation',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler with SeekHandler{
  AssetsAudioPlayer player; 
  
  MyAudioHandler();

  Future openAudio(MediaItem item)async {
    if(player  != null){
      print('player not null disposing');
      player.dispose();
    }

    player = new AssetsAudioPlayer();

    playbackState.add(PlaybackState(
      // Which buttons should appear in the notification now
      controls: [
        MediaControl.play,
      ],
      // Which other actions should be enabled in the notification
      systemActions: const {
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      // Which controls to show in Android's compact view.
      androidCompactActionIndices: const [0],
      // TENGO QUE HACER QUE 
      // Whether audio is ready, buffering, ...
      processingState: AudioProcessingState.buffering,
      // Whether audio is playing
      playing: true,
      // The current position as of this update. You should not broadcast
      // position changes continuously because listeners will be able to
      // project the current position after any elapsed time based on the
      // current speed and whether audio is playing and ready. Instead, only
      // broadcast position updates when they are different from expected (e.g.
      // buffering, or seeking).
      updatePosition: Duration(milliseconds: 0),
      // The current buffered position as of this update
      bufferedPosition: Duration(milliseconds: 0),
      // The current speed
      speed: 1.0,
      // The current queue position
      queueIndex: 0,
    ));

    // PORQUE NO SE AÑADE ???
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.pause],
      processingState: AudioProcessingState.ready,
    ));

    mediaItem.add(item); 

    await player.open(Audio.network(item.id));

    playbackState.add(playbackState.value.copyWith(
      // Keep all existing state the same with only the speed changed:
      processingState: AudioProcessingState.ready,
      updatePosition: Duration(milliseconds: 0),
      // The current buffered position as of this update
      bufferedPosition: Duration(milliseconds: 0),
      controls:[ MediaControl.pause]
    ));
  }

  @override
  Future<void> play() {
    playbackState.add(playbackState.value.copyWith(
      controls:[ MediaControl.pause ]
    ));

    player.play();

  }


  @override
  Future<void> pause() {
    
    playbackState.add(playbackState.value.copyWith(
      controls:[ MediaControl.play]
    ));

    player.pause();  
  }

  @override
  Future<void> setSpeed(double speed) async {
    player.setPlaySpeed(speed);
  }

  @override
  Future<void> stop() async {
    // Release any audio decoders back to the system
    if(player != null &&  player.isPlaying.value){
      player.stop();
      player.dispose();

      // Set the audio_service state to `idle` to deactivate the notification.
      playbackState.add(playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ));
    }
  }

  /*
   PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }*/

  @override
  Future<void> seek(Duration position) => player.seek(position);

  // TODO: Override needed methods
}