// device_list_state.dart
part of 'device_list_bloc.dart';

enum DeviceListStatus { idle, loading, success, failure }

class DeviceListState extends Equatable {
  final DeviceListStatus status;
  final List<Device> devices;
  final String? error;

  const DeviceListState({
    this.status = DeviceListStatus.idle,
    this.devices = const [],
    this.error,
  });

  DeviceListState copyWith({
    DeviceListStatus? status,
    List<Device>? devices,
    String? error,
  }) =>
      DeviceListState(
        status: status ?? this.status,
        devices: devices ?? this.devices,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, devices, error];
}
