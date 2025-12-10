import 'package:shared_preferences/shared_preferences.dart';
import '../service/jsonbin_service.dart';

class JsonbinConfig {
  static const _binKeyPref = 'jsonbin_bin_id';
  static const _masterKeyPref = 'jsonbin_master_key';

  // Default values
  static const _defaultBinId = '69392ee0d0ea881f401f088c';
  static const _defaultMasterKey =
      r'$2a$10$PFEa8Ezdrm5.1go2N.2pwu8HcrxMHx2VPy0IelVczMnmXV8Yds8mG';

  static Future<void> setBinId(String binId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_binKeyPref, binId);
  }

  static Future<void> setMasterKey(String masterKey) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_masterKeyPref, masterKey);
  }

  static Future<String?> getBinId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_binKeyPref) ?? _defaultBinId;
  }

  static Future<String?> getMasterKey() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_masterKeyPref) ?? _defaultMasterKey;
  }

  /// returns a JsonbinService if both keys are present, otherwise null
  static Future<JsonbinService?> getService() async {
    final binId = await getBinId();
    final masterKey = await getMasterKey();
    if (binId == null ||
        masterKey == null ||
        binId.isEmpty ||
        masterKey.isEmpty)
      return null;
    return JsonbinService(binId: binId, masterKey: masterKey);
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_binKeyPref);
    await sp.remove(_masterKeyPref);
  }
}
