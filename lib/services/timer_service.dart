import 'package:shared_preferences/shared_preferences.dart';

class TimerService {

Future saveLockTime(
String value)
async{

final prefs=
await SharedPreferences
.getInstance();

prefs.setString(
"locktime",
value
);

}

Future<String?>
getLockTime()
async{

final prefs=
await SharedPreferences
.getInstance();

return prefs.getString(
"locktime"
);

}

}