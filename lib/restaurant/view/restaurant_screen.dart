import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  // final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(RestaurantDetailScreen.routeName,pathParameters: {'rid' : model.id},);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => RestaurantDetailScreen(
            //       id: model.id,
            //     ),
            //   ),
            // );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
    // final data = ref.watch(restaurantProvider);
    //
    // // 완전 처음 로딩일 떄에
    // if (data is CursorPaginationLoading) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    //
    // // 에러
    // if (data is CursorPaginationError) {
    //   return Center(
    //     child: Text(data.message),
    //   );
    // }
    //
    // // CursorPagination 및 그의 자식들
    // // CursorPaginationFetchingmore
    // // CursorPaginationRefetching
    //
    // final cp = data as CursorPagination;
    //
    // print('hello');
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //   child: ListView.separated(
    //     controller: scrollController,
    //     itemCount: cp.data.length + 1,
    //     itemBuilder: (_, index) {
    //       if (index == cp.data.length) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Center(
    //             child: data is CursorPaginationFetchingMore
    //                 ? CircularProgressIndicator()
    //                 : Text('마지막 테이터 입니다 ㅠㅠ'),
    //           ),
    //         );
    //       }
    //       final pItem = cp.data[index];
    //       return GestureDetector(
    //           onTap: () {
    //             Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (_) => RestaurantDetailScreen(
    //                   id: pItem.id,
    //                 ),
    //               ),
    //             );
    //           },
    //           child: RestaurantCard.fromModel(model: pItem));
    //     },
    //     separatorBuilder: (_, index) {
    //       return const SizedBox(height: 16.0);
    //     },
    //   ),
    // );
  }
}
