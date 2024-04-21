import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});


  static String get routeName => 'splash';
  // initstate는 await할 수가 없다.. 왜?
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // deleteToken();
  //   checkToken();
  // }
  //
  // void deleteToken() async {
  //   final storage = ref.read(secureStorageProvider);
  //   await storage.deleteAll();
  // }
  //
  // void checkToken() async {
  //   final storage = ref.read(secureStorageProvider);
  //
  //   final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
  //   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //
  //   try {
  //     final dio = Dio();
  //     final resp = await dio.post(
  //       "http://$ip/auth/token",
  //       options: Options(
  //         headers: {
  //           'authorization': 'Bearer $refreshToken',
  //         },
  //       ),
  //     );
  //     await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
  //     final authorization = await storage.read(key: ACCESS_TOKEN_KEY);
  //     print('authorization : ${authorization}');
  //     print(resp.data);
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (_) => RootTab(),
  //         ),
  //         (route) => false);
  //   } catch (e) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (_) => LoginScreen(),
  //         ),
  //         (route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
