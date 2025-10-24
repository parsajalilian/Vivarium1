import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/device.dart';
import '../../../data/repositories/device_repository.dart';

part 'device_list_event.dart';
part 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  final DeviceRepository repo;
  DeviceListBloc(this.repo) : super(const DeviceListState()) {
    on<DeviceListRequested>(_onRequested);
  }

  Future<void> _onRequested(DeviceListRequested e, Emitter emit) async {
    emit(state.copyWith(status: DeviceListStatus.loading));
    try {
      final items = await repo.fetchDevices();
      emit(state.copyWith(status: DeviceListStatus.success, devices: items));
    } catch (err) {
      emit(state.copyWith(status: DeviceListStatus.failure, error: '$err'));
    }
  }
}
