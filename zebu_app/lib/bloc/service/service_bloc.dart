import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/service/service_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/repository/service_repository.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;

  ServiceBloc({required this.serviceRepository}) : super(LoadingService());

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    if (event is AllServiceLoad) {
      yield LoadingService();
      try {
        final allService = await serviceRepository.getAllService();
        if (allService.isEmpty) {
          yield const AllServiceEmpltyFailure(
              message: "No Service Items Found");
        } else {
          yield AllServiceLoadSuccess(allService);
        }
      } catch (error) {
        print(error);
        yield AllServiceLoadFailure();
      }
    }
  }
}
