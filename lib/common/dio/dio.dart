import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final Ref ref;
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage, required this.ref});

  // 1) 요청을 보낼때에
  // 요청이 보내질때마다 만약 요청의 헤더에 'accessToken' : 'true'라는 값이 있으면
  // 해당 accessToken을 삭제하고, 진짜 accessToken을 flutterSecureStorage에서 가져와
  // 'authorization key에 넣어준다. + refreshToken도 마찬가지로..

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // await storage.deleteAll();
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      print('token : $token');

      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      print('token : $token');

      options.headers.addAll({'authorization': 'Bearer $token'});
    }
    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때에
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때에 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면, 다시 새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    //refreshToken이 아예 없으면
    // 당연히 에러를 던진다.
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    // final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401
        // && isPathRefresh
    ) {
      print('here');
      final dio = Dio();
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {
            'authorization': 'Bearer $refreshToken',
          }),
        );
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        // 토큰 변경하기.
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        // 성공에 대한 값을 반환
        return handler.resolve(response);
      } on DioException catch (e) {
        print('heelo');
        ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}
