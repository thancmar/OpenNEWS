part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize extends PlayerEvent {
  Initialize();
}

class OpenPlayer extends PlayerEvent {
  // final String idMagazinePublication;
  // final String pageNo;
  // OpenPlayer({required this.idMagazinePublication, required this.pageNo});
  OpenPlayer();
}
