import 'package:equatable/equatable.dart';

class RecentMenuState extends Equatable {
  const RecentMenuState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingRecentMenu extends RecentMenuState {}

class RecentlyViewedLoadSuccess extends RecentMenuState {
  final List<dynamic> recentlyviewed;

  const RecentlyViewedLoadSuccess([this.recentlyviewed = const []]);

  @override
  List<Object> get props => [recentlyviewed];
}

class RecentlyViewedLoadFailure extends RecentMenuState {}
