import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//T를 2번 넣어줘도 됨
class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository})
      : super(
          CursorPaginationLoading(),
        );

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터를 더 가져오기.
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기.
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 킹능성
      // State의 상태
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationloading - 데이터가 로딩중인 상태(현재 캐시가 없음.)
      // 3) CursorPagination Error - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때에
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때에

      // 바로 반환하는 상황
      // 1) hasmore : false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (pState.meta.hasMore == false) {
          return;
        }
      }
      // 2) 로딩중 - fetchMore : true
      //            fetchMore가 아닐 때에는 함수를 실행한다. 새로 데이터를 가지고 오고 있는데에 새로고침의 의도가 있을 때에
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      //PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 가져오는 상황.
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          //아무것도 안넣으면 dynamic형태로 취급된다. last 까지의 응답값이 dynamic -- id가 있겠지~
          //model 일반화에 대한 필요성이 있음.
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한 채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에
        // 새로운 데이터 추가.
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
