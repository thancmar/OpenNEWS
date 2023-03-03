part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize extends MapEvent {
  Initialize();
}

// class GetMapOffer extends MapEvent {
//   final Place loc;
//   GetMapOffer({required this.loc});
//   List<Object> get props => [];
// }