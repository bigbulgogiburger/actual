import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/repository/auth_repository.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_me_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
} );

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();
}