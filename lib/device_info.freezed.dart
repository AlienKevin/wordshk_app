// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'android':
      return AndroidInfo.fromJson(json);
    case 'ios':
      return IosInfo.fromJson(json);
    case 'other':
      return OtherInfo.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'DeviceInfo',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$DeviceInfo {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String release, int sdkInt, String manufacturer, String model)
        android,
    required TResult Function(String systemName, String version) ios,
    required TResult Function() other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult? Function(String systemName, String version)? ios,
    TResult? Function()? other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult Function(String systemName, String version)? ios,
    TResult Function()? other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AndroidInfo value) android,
    required TResult Function(IosInfo value) ios,
    required TResult Function(OtherInfo value) other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AndroidInfo value)? android,
    TResult? Function(IosInfo value)? ios,
    TResult? Function(OtherInfo value)? other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AndroidInfo value)? android,
    TResult Function(IosInfo value)? ios,
    TResult Function(OtherInfo value)? other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
          DeviceInfo value, $Res Function(DeviceInfo) then) =
      _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AndroidInfoImplCopyWith<$Res> {
  factory _$$AndroidInfoImplCopyWith(
          _$AndroidInfoImpl value, $Res Function(_$AndroidInfoImpl) then) =
      __$$AndroidInfoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String release, int sdkInt, String manufacturer, String model});
}

/// @nodoc
class __$$AndroidInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$AndroidInfoImpl>
    implements _$$AndroidInfoImplCopyWith<$Res> {
  __$$AndroidInfoImplCopyWithImpl(
      _$AndroidInfoImpl _value, $Res Function(_$AndroidInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? release = null,
    Object? sdkInt = null,
    Object? manufacturer = null,
    Object? model = null,
  }) {
    return _then(_$AndroidInfoImpl(
      null == release
          ? _value.release
          : release // ignore: cast_nullable_to_non_nullable
              as String,
      null == sdkInt
          ? _value.sdkInt
          : sdkInt // ignore: cast_nullable_to_non_nullable
              as int,
      null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AndroidInfoImpl implements AndroidInfo {
  const _$AndroidInfoImpl(
      this.release, this.sdkInt, this.manufacturer, this.model,
      {final String? $type})
      : $type = $type ?? 'android';

  factory _$AndroidInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AndroidInfoImplFromJson(json);

  @override
  final String release;
  @override
  final int sdkInt;
  @override
  final String manufacturer;
  @override
  final String model;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DeviceInfo.android(release: $release, sdkInt: $sdkInt, manufacturer: $manufacturer, model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AndroidInfoImpl &&
            (identical(other.release, release) || other.release == release) &&
            (identical(other.sdkInt, sdkInt) || other.sdkInt == sdkInt) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, release, sdkInt, manufacturer, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AndroidInfoImplCopyWith<_$AndroidInfoImpl> get copyWith =>
      __$$AndroidInfoImplCopyWithImpl<_$AndroidInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String release, int sdkInt, String manufacturer, String model)
        android,
    required TResult Function(String systemName, String version) ios,
    required TResult Function() other,
  }) {
    return android(release, sdkInt, manufacturer, model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult? Function(String systemName, String version)? ios,
    TResult? Function()? other,
  }) {
    return android?.call(release, sdkInt, manufacturer, model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult Function(String systemName, String version)? ios,
    TResult Function()? other,
    required TResult orElse(),
  }) {
    if (android != null) {
      return android(release, sdkInt, manufacturer, model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AndroidInfo value) android,
    required TResult Function(IosInfo value) ios,
    required TResult Function(OtherInfo value) other,
  }) {
    return android(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AndroidInfo value)? android,
    TResult? Function(IosInfo value)? ios,
    TResult? Function(OtherInfo value)? other,
  }) {
    return android?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AndroidInfo value)? android,
    TResult Function(IosInfo value)? ios,
    TResult Function(OtherInfo value)? other,
    required TResult orElse(),
  }) {
    if (android != null) {
      return android(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AndroidInfoImplToJson(
      this,
    );
  }
}

abstract class AndroidInfo implements DeviceInfo {
  const factory AndroidInfo(final String release, final int sdkInt,
      final String manufacturer, final String model) = _$AndroidInfoImpl;

  factory AndroidInfo.fromJson(Map<String, dynamic> json) =
      _$AndroidInfoImpl.fromJson;

  String get release;
  int get sdkInt;
  String get manufacturer;
  String get model;
  @JsonKey(ignore: true)
  _$$AndroidInfoImplCopyWith<_$AndroidInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IosInfoImplCopyWith<$Res> {
  factory _$$IosInfoImplCopyWith(
          _$IosInfoImpl value, $Res Function(_$IosInfoImpl) then) =
      __$$IosInfoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String systemName, String version});
}

/// @nodoc
class __$$IosInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$IosInfoImpl>
    implements _$$IosInfoImplCopyWith<$Res> {
  __$$IosInfoImplCopyWithImpl(
      _$IosInfoImpl _value, $Res Function(_$IosInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = null,
    Object? version = null,
  }) {
    return _then(_$IosInfoImpl(
      null == systemName
          ? _value.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IosInfoImpl implements IosInfo {
  const _$IosInfoImpl(this.systemName, this.version, {final String? $type})
      : $type = $type ?? 'ios';

  factory _$IosInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$IosInfoImplFromJson(json);

  @override
  final String systemName;
  @override
  final String version;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DeviceInfo.ios(systemName: $systemName, version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IosInfoImpl &&
            (identical(other.systemName, systemName) ||
                other.systemName == systemName) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, systemName, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IosInfoImplCopyWith<_$IosInfoImpl> get copyWith =>
      __$$IosInfoImplCopyWithImpl<_$IosInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String release, int sdkInt, String manufacturer, String model)
        android,
    required TResult Function(String systemName, String version) ios,
    required TResult Function() other,
  }) {
    return ios(systemName, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult? Function(String systemName, String version)? ios,
    TResult? Function()? other,
  }) {
    return ios?.call(systemName, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult Function(String systemName, String version)? ios,
    TResult Function()? other,
    required TResult orElse(),
  }) {
    if (ios != null) {
      return ios(systemName, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AndroidInfo value) android,
    required TResult Function(IosInfo value) ios,
    required TResult Function(OtherInfo value) other,
  }) {
    return ios(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AndroidInfo value)? android,
    TResult? Function(IosInfo value)? ios,
    TResult? Function(OtherInfo value)? other,
  }) {
    return ios?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AndroidInfo value)? android,
    TResult Function(IosInfo value)? ios,
    TResult Function(OtherInfo value)? other,
    required TResult orElse(),
  }) {
    if (ios != null) {
      return ios(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IosInfoImplToJson(
      this,
    );
  }
}

abstract class IosInfo implements DeviceInfo {
  const factory IosInfo(final String systemName, final String version) =
      _$IosInfoImpl;

  factory IosInfo.fromJson(Map<String, dynamic> json) = _$IosInfoImpl.fromJson;

  String get systemName;
  String get version;
  @JsonKey(ignore: true)
  _$$IosInfoImplCopyWith<_$IosInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtherInfoImplCopyWith<$Res> {
  factory _$$OtherInfoImplCopyWith(
          _$OtherInfoImpl value, $Res Function(_$OtherInfoImpl) then) =
      __$$OtherInfoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OtherInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$OtherInfoImpl>
    implements _$$OtherInfoImplCopyWith<$Res> {
  __$$OtherInfoImplCopyWithImpl(
      _$OtherInfoImpl _value, $Res Function(_$OtherInfoImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$OtherInfoImpl implements OtherInfo {
  const _$OtherInfoImpl({final String? $type}) : $type = $type ?? 'other';

  factory _$OtherInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtherInfoImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DeviceInfo.other()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OtherInfoImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String release, int sdkInt, String manufacturer, String model)
        android,
    required TResult Function(String systemName, String version) ios,
    required TResult Function() other,
  }) {
    return other();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult? Function(String systemName, String version)? ios,
    TResult? Function()? other,
  }) {
    return other?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String release, int sdkInt, String manufacturer, String model)?
        android,
    TResult Function(String systemName, String version)? ios,
    TResult Function()? other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AndroidInfo value) android,
    required TResult Function(IosInfo value) ios,
    required TResult Function(OtherInfo value) other,
  }) {
    return other(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AndroidInfo value)? android,
    TResult? Function(IosInfo value)? ios,
    TResult? Function(OtherInfo value)? other,
  }) {
    return other?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AndroidInfo value)? android,
    TResult Function(IosInfo value)? ios,
    TResult Function(OtherInfo value)? other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OtherInfoImplToJson(
      this,
    );
  }
}

abstract class OtherInfo implements DeviceInfo {
  const factory OtherInfo() = _$OtherInfoImpl;

  factory OtherInfo.fromJson(Map<String, dynamic> json) =
      _$OtherInfoImpl.fromJson;
}
