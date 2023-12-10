import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

@freezed
sealed class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo.android(
          String release, int sdkInt, String manufacturer, String model) =
      AndroidInfo;
  const factory DeviceInfo.ios(
      String systemName, String version, String name, String model) = IosInfo;
  const factory DeviceInfo.other() = OtherInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}

Future<DeviceInfo> getDeviceInfo() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    // Android 9 (SDK 28), Xiaomi Redmi Note 7
    // 'Android $release (SDK $sdkInt), $manufacturer $model'
    return DeviceInfo.android(release, sdkInt, manufacturer, model);
  } else if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    var name = iosInfo.name;
    var model = iosInfo.model;
    // iOS 13.1, iPhone 11 Pro Max iPhone
    // '$systemName $version, $name $model'
    return DeviceInfo.ios(systemName, version, name, model);
  } else {
    return const DeviceInfo.other();
  }
}
