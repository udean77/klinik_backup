import 'package:flutter/material.dart';
import './ui/beranda.dart';
import './ui/login.dart';
import './helpers/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserInfo userInfo = UserInfo();
  var token = await userInfo.getToken();
  print(token);
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key, this.token});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik App',
      debugShowCheckedModeBanner: false,
      home: token == null ? Login() : Beranda(),
    );
  }
}
