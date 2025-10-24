// device_list_event.dart
part of 'device_list_bloc.dart';

abstract class DeviceListEvent extends Equatable {
  const DeviceListEvent();
  @override
  List<Object?> get props => [];
}

class DeviceListRequested extends DeviceListEvent {}

// Event حذف یک دستگاه
class DeviceListDeviceDeleted extends DeviceListEvent {
  final int deviceId;
  const DeviceListDeviceDeleted(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}
