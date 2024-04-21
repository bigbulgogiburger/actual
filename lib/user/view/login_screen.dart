import 'dart:convert';
import 'dart:io';

import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Center(
                  child: Image.asset(
                    'asset/img/misc/logo.png',
                    width: (MediaQuery.of(context).size.width) / 3 * 2,
                  ),
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obsecureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: state is UserModelLoading? null : () async {
                    ref.read(userMeProvider.notifier).login(
                          username: username,
                          password: password,
                        );
                    // final rawString = '$username:$password';
                    //
                    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    //
                    // String token = stringToBase64.encode(rawString);
                    // // emulator localhost
                    // // 10.0.0.2
                    // // simulator는 local 과 vm이 같음.
                    // // 127.0.0.1
                    // final resp = await dio.post(
                    //   "http://$ip/auth/login",
                    //   options: Options(
                    //     headers: {
                    //       'authorization': 'Basic $token',
                    //     },
                    //   ),
                    // );
                    // final refreshToken = resp.data['refreshToken'];
                    // final accessToken = resp.data['accessToken'];
                    //
                    // final storage = ref.read(secureStorageProvider);
                    // storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    // storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => RootTab(),
                    //   ),
                    // );
                  },
                  child: Text(
                    '로그인',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () async {},
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
