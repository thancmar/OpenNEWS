part of 'player_bloc.dart';

@immutable
abstract class PlayerState extends Equatable {}

class Initialized extends PlayerState {
  Initialized() : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class PlayerOpened extends PlayerState {
  PlayerOpened() : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}
