import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/device.dart';
import '../../3_device_control/bloc/device_control_bloc.dart';
import '../../3_device_control/bloc/device_control_event.dart';
import '../../3_device_control/bloc/device_control_state.dart';
import '../widgets/device_widgets.dart';

class IconPaths {
  static const status = 'assets/icons/ic_status.svg';
  static const controls = 'assets/icons/ic_controls.svg';
  static const bulb = 'assets/icons/ic_bulb.svg';
  static const drop = 'assets/icons/drop.svg';
  static const vent = 'assets/icons/vent.svg';
  static const lamp = 'assets/icons/light.svg';
  static const humidifier = 'assets/icons/vent_icon.svg';
  static const fan = 'assets/icons/ic_fan.svg';
  static const temp = 'assets/icons/ic_temp.svg';
  static const humidity = 'assets/icons/vent_icon.svg';
  static const clock = 'assets/icons/clock_icon.svg';
  static const mode = 'assets/icons/mode.svg';
}

Widget _svg(String path, {double size = 20, Color? color}) => SvgPicture.asset(
  path,
  height: size,
  width: size,
  colorFilter:
  color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
);

class VivariumDetailPage extends StatelessWidget {
  final Device device;
  const VivariumDetailPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DeviceControlBloc>();
    if (bloc.state.device?.id != device.id || !bloc.state.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text("خطا در اتصال")),
        body: const Center(
          child: Text("دستگاه انتخاب شده، دستگاه متصل فعلی نیست."),
        ),
      );
    }

    return const _VivariumDetailView();
  }
}

class _VivariumDetailView extends StatefulWidget {
  const _VivariumDetailView();

  @override
  State<_VivariumDetailView> createState() => _VivariumDetailViewState();
}

class _VivariumDetailViewState extends State<_VivariumDetailView> {
  double _mistOnCycleLocal = 5;
  double _mistOffCycleLocal = 60;
  double _lowerTempLocal = 22;
  double _upperTempLocal = 28;

  @override
  void initState() {
    super.initState();
    final initialState = context.read<DeviceControlBloc>().state;
    _mistOnCycleLocal =
        (initialState.extras['mistOnCycle'] as int? ?? 5).toDouble();
    _mistOffCycleLocal =
        (initialState.extras['mistOffCycle'] as int? ?? 60).toDouble();
    _lowerTempLocal = initialState.lowerTemp.toDouble();
    _upperTempLocal = initialState.upperTemp.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    final textPri = theme.textTheme.bodyLarge?.color ?? cs.onBackground;
    final textSec = textPri.withOpacity(0.70);

    return BlocConsumer<DeviceControlBloc, DeviceControlState>(
      listenWhen: (prev, current) {
        if (!current.isConnected) return true;

        return prev.statusMessage != current.statusMessage ||
            prev.extras['mistOnCycle'] != current.extras['mistOnCycle'] ||
            prev.extras['mistOffCycle'] != current.extras['mistOffCycle'] ||
            prev.lowerTemp != current.lowerTemp ||
            prev.upperTemp != current.upperTemp;
      },
      listener: (context, state) {
        if (!state.isConnected) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('اتصال قطع شد.')),
          );
          return;
        }

        if (state.statusMessage != null && state.statusMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.statusMessage!),
              duration: const Duration(seconds: 2),
            ));
        }

        setState(() {
          _mistOnCycleLocal =
              (state.extras['mistOnCycle'] as int? ?? 5).toDouble();
          _mistOffCycleLocal =
              (state.extras['mistOffCycle'] as int? ?? 60).toDouble();
          _lowerTempLocal = state.lowerTemp.toDouble();
          _upperTempLocal = state.upperTemp.toDouble();
        });
      },
      builder: (context, state) {
        final d = state.device!;
        String _tempText() => state.reading?.temperature != null
            ? '${state.reading!.temperature!.toStringAsFixed(1)} °C'
            : '--';
        String _humText() => state.reading?.humidity != null
            ? '${state.reading!.humidity!.toStringAsFixed(0)} %'
            : '--';

        final bool lightOnUI = state.extras['lightOn'] as bool? ?? false;
        final bool mistOnUI = state.extras['mistOn'] as bool? ?? false;
        final bool fanOnUI = state.extras['fanOn'] as bool? ?? false;
        final bool autoMode = state.extras['autoMode'] as bool? ?? true;

        return Scaffold(
          body: Container(
            decoration: AppDecor.background(context),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0E8AC0), Color(0xFF0F8F7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(loc.appTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(loc.appSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Row(
                      children: [
                        BackBtn(onTap: () => Navigator.pop(context)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: textPri,
                                      fontWeight: FontWeight.w800)),
                              Text('${loc.vivarium} · ${d.serial}',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: textSec)),
                            ],
                          ),
                        ),
                        ConnDot(
                            connected: state.isConnected,
                            onlineText: loc.online,
                            offlineText: loc.offline),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        DeviceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                  iconPath: IconPaths.status,
                                  title: loc.statusTitle),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                      child: _MetricWithIcon(
                                          iconPath: IconPaths.temp,
                                          value: _tempText(),
                                          label: loc.temperature,
                                          color: cs.secondary)),
                                  Expanded(
                                      child: _MetricWithIcon(
                                          iconPath: IconPaths.humidity,
                                          value: _humText(),
                                          label: loc.humidity,
                                          color: cs.secondary)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _StatusLine(
                                  iconPath: IconPaths.lamp,
                                  label: loc.light,
                                  isOn: lightOnUI,
                                  onColor: cs.secondary,
                                  onText: loc.on,
                                  offText: loc.off),
                              _StatusLine(
                                  iconPath: IconPaths.humidifier,
                                  label: loc.humidifier,
                                  isOn: mistOnUI,
                                  onColor: cs.secondary,
                                  onText: loc.on,
                                  offText: loc.off),
                              _StatusLine(
                                  iconPath: IconPaths.vent,
                                  label: loc.ventilation,
                                  isOn: fanOnUI,
                                  onColor: cs.secondary,
                                  onText: loc.on,
                                  offText: loc.off),
                              _StatusLine(
                                  iconPath: IconPaths.mode,
                                  label: loc.mode,
                                  isOn: autoMode,
                                  onColor: cs.secondary,
                                  onText: loc.autoMode,
                                  offText: loc.manualMode),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        DeviceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                  iconPath: IconPaths.controls,
                                  title: loc.controlsTitle),
                              const SizedBox(height: 8),
                              SwitchRow(
                                leading: _svg(IconPaths.bulb,
                                    color: theme.colorScheme.primary),
                                label: loc.lighting,
                                value: lightOnUI,
                                onChanged: (v) => context
                                    .read<DeviceControlBloc>()
                                    .add(DevicePowerOverrideRequested(
                                    deviceId: 1, value: v ? 1 : 0)),
                              ),
                              SwitchRow(
                                leading: _svg(IconPaths.fan,
                                    color: theme.colorScheme.primary),
                                label: loc.humiditySystem,
                                value: mistOnUI,
                                onChanged: (v) => context
                                    .read<DeviceControlBloc>()
                                    .add(DevicePowerOverrideRequested(
                                    deviceId: 2, value: v ? 1 : 0)),
                              ),
                              SwitchRow(
                                leading: _svg(IconPaths.fan,
                                    color: theme.colorScheme.primary),
                                label: loc.ventilationSystem,
                                value: fanOnUI,
                                onChanged: (v) => context
                                    .read<DeviceControlBloc>()
                                    .add(DevicePowerOverrideRequested(
                                    deviceId: 3, value: v ? 1 : 0)),
                              ),
                              SwitchRow(
                                leading: _svg(IconPaths.fan,
                                    color: theme.colorScheme.primary),
                                label: loc.mode,
                                value: autoMode,
                                onChanged: (v) => context
                                    .read<DeviceControlBloc>()
                                    .add(DeviceSetModeRequested(autoMode: v)),
                              ),
                            ],
                          ),
                        ),
                        DeviceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                iconPath: IconPaths.clock,
                                title: loc.lightTimer,
                              ),
                              _TimePickerRow(
                                label: loc.lightOnTime,
                                time: state.lightOnTime,
                                onTimeChanged: (newOnTime) {
                                  context.read<DeviceControlBloc>().add(
                                    DeviceSetLightTimerRequested(
                                      onHour: newOnTime.hour,
                                      offHour: state.lightOffTime.hour,
                                    ),
                                  );
                                },
                              ),
                              _TimePickerRow(
                                label: loc.lightOffTime,
                                time: state.lightOffTime,
                                onTimeChanged: (newOffTime) {
                                  context.read<DeviceControlBloc>().add(
                                    DeviceSetLightTimerRequested(
                                      onHour: state.lightOnTime.hour,
                                      offHour: newOffTime.hour,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        DeviceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                iconPath: IconPaths.drop,
                                title: loc.mistCycleSettings,
                              ),
                              const SizedBox(height: 8),
                              _CustomSlider(
                                label: loc.mistOnCycle,
                                value: _mistOnCycleLocal,
                                min: 1,
                                max: 60,
                                unit: loc.minutesUnit,
                                onChanged: (v) =>
                                    setState(() => _mistOnCycleLocal = v),
                                onChangeEnd: (val) {
                                  context
                                      .read<DeviceControlBloc>()
                                      .add(DeviceSetMistCycleRequested(
                                    onMinutes: val.toInt(),
                                    offMinutes: _mistOffCycleLocal.toInt(),
                                  ));
                                },
                              ),
                              const SizedBox(height: 8),
                              _CustomSlider(
                                label: loc.mistOffCycle,
                                value: _mistOffCycleLocal,
                                min: 1,
                                max: 360,
                                unit: loc.minutesUnit,
                                onChanged: (v) =>
                                    setState(() => _mistOffCycleLocal = v),
                                onChangeEnd: (val) {
                                  context
                                      .read<DeviceControlBloc>()
                                      .add(DeviceSetMistCycleRequested(
                                    onMinutes: _mistOnCycleLocal.toInt(),
                                    offMinutes: val.toInt(),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                        DeviceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                  iconPath: IconPaths.vent,
                                  title: loc.ventilationSettings),
                              const SizedBox(height: 8),
                              _CustomSlider(
                                label: loc.lowerTempLimit,
                                value: _lowerTempLocal,
                                min: 1,
                                max: 50,
                                unit: '°C',
                                onChanged: (v) =>
                                    setState(() => _lowerTempLocal = v),
                                onChangeEnd: (val) {
                                  context
                                      .read<DeviceControlBloc>()
                                      .add(DeviceSetThresholdsRequested(
                                    lowerTemp: val.toInt(),
                                    upperTemp: _upperTempLocal.toInt(),
                                    lowerHumidity: 30,
                                    upperHumidity: 60,
                                  ));
                                },
                              ),
                              const SizedBox(height: 8),
                              _CustomSlider(
                                label: loc.upperTempLimit,
                                value: _upperTempLocal,
                                min: 1,
                                max: 50,
                                unit: '°C',
                                onChanged: (v) =>
                                    setState(() => _upperTempLocal = v),
                                onChangeEnd: (val) {
                                  context
                                      .read<DeviceControlBloc>()
                                      .add(DeviceSetThresholdsRequested(
                                    lowerTemp: _lowerTempLocal.toInt(),
                                    upperTemp: val.toInt(),
                                    lowerHumidity: 30,
                                    upperHumidity: 60,
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                        DeviceCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: _PrimaryButton(
                                  label: loc.syncTime,
                                  onTap: () {
                                    context
                                        .read<DeviceControlBloc>()
                                        .add(const DeviceSyncTimeRequested());
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _PrimaryButton(
                                  label: loc.saveSettings,
                                  onTap: () {
                                    context
                                        .read<DeviceControlBloc>()
                                        .add(const DeviceSaveSettingsRequested());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CustomSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const _CustomSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedValue = value.clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text(
              '${clampedValue.toInt()} $unit',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: clampedValue,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: clampedValue.toInt().toString(),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.iconPath, required this.title});
  final String iconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final text = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    return Row(
      children: [
        _svg(iconPath, size: 22, color: color),
        const SizedBox(width: 8),
        Text(title, style: text),
      ],
    );
  }
}

class _MetricWithIcon extends StatelessWidget {
  const _MetricWithIcon({
    required this.iconPath,
    required this.value,
    required this.label,
    required this.color,
  });

  final String iconPath;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(.8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _svg(iconPath, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: .4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: labelStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.iconPath,
    required this.label,

    required this.isOn,
    required this.onColor,
    required this.onText,
    required this.offText,
  });

  final String iconPath;
  final String label;
  final bool isOn;
  final Color onColor;
  final String onText;
  final String offText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cc = theme.colorScheme;
    final dotColor = isOn ? const Color(0xFF22C55E) : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? cc.surfaceVariant.withOpacity(.35)
            : Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? cc.outlineVariant.withOpacity(.4)
              : Colors.white24,
        ),
      ),
      child: Row(
        children: [
          _svg(iconPath, size: 18, color: onColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            isOn ? onText : offText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isOn ? cc.primary : Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePickerRow extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final Function(TimeOfDay) onTimeChanged;

  const _TimePickerRow({
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      onTimeChanged(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
            theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: () => _pickTime(context),
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              time.format(context),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}