import 'package:bloc/bloc.dart';
import 'nav_drawer_event.dart';
import 'nav_drawer_state.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc() : super(Menu());

  @override
  Stream<NavDrawerState> mapEventToState(
    NavDrawerEvent event,
  ) async* {
    if (event is MenuPageEvent) {
      yield Menu();
    } else if (event is BookingPageEvent) {
      yield Booking();
    } else if (event is FeedbackPageEvent) {
      yield FeedbackState();
    } else if (event is AnnouncementPageEvent) {
      yield Announcement();
    } else if (event is LogoutPageEvent) {
      yield LoggedOutNavState();
    } else if (event is MyBookingPageEvent) {
      yield MyBooking();
    } else if (event is MyOrderPageEvent) {
      yield MyOrder();
    }
    
    
  }
}
