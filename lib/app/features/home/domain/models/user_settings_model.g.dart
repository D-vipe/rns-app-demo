// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPortalSettingsAdapter extends TypeAdapter<UserPortalSettings> {
  @override
  final int typeId = 2;

  @override
  UserPortalSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPortalSettings(
      taskSortonAddOrder: fields[0] as bool,
      taskNewSortOnAddInSystem: fields[1] as bool,
      taskReestrPaging: fields[2] as bool,
      timesheetPaging: fields[3] as bool,
      timesheetExecutorNotSelected: fields[4] as bool,
      autoSortTimesheet: fields[5] as bool,
      viewAllProjects: fields[6] as bool,
      countDaysDefaultInMessageFilter: fields[7] as String,
      countDaysDefaultInEmailFilter: fields[8] as String,
      taskNotifyOverdraftHours: fields[9] as String,
      candidateDefaultSorting: fields[10] as String,
      taskNotifyOverdraftDistinctByEmployee: fields[11] as bool,
      taskStatusChangeOnTimerStart: fields[12] as bool,
      taskFilterDefaultWithoutExecutor: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPortalSettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.taskSortonAddOrder)
      ..writeByte(1)
      ..write(obj.taskNewSortOnAddInSystem)
      ..writeByte(2)
      ..write(obj.taskReestrPaging)
      ..writeByte(3)
      ..write(obj.timesheetPaging)
      ..writeByte(4)
      ..write(obj.timesheetExecutorNotSelected)
      ..writeByte(5)
      ..write(obj.autoSortTimesheet)
      ..writeByte(6)
      ..write(obj.viewAllProjects)
      ..writeByte(7)
      ..write(obj.countDaysDefaultInMessageFilter)
      ..writeByte(8)
      ..write(obj.countDaysDefaultInEmailFilter)
      ..writeByte(9)
      ..write(obj.taskNotifyOverdraftHours)
      ..writeByte(10)
      ..write(obj.candidateDefaultSorting)
      ..writeByte(11)
      ..write(obj.taskNotifyOverdraftDistinctByEmployee)
      ..writeByte(12)
      ..write(obj.taskStatusChangeOnTimerStart)
      ..writeByte(13)
      ..write(obj.taskFilterDefaultWithoutExecutor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPortalSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
