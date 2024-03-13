import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository{

  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;
  //
  // @GET('/')
  // pagenate();
  
  @GET('/{id}')
  @Headers({'authorization' : 'Bearer'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
});
}