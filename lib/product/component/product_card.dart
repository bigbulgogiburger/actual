import 'package:actual/common/const/colors.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Image.asset(
// 'asset/img/food/ddeok_bok_gi.jpg',
// width: 110,
// height: 110,
// fit: BoxFit.cover,
// )
class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final String id;
  final int price;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({required this.name,
    required this.detail,
    required this.image,
    required this.price,
    this.onSubtract,
    this.onAdd,
    required this.id,
    super.key});

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      name: model.name,
      detail: model.detail,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd!,
    );
  }

  factory ProductCard.fromRestaurantProductModel(
      {required RestaurantProductModel model,
        VoidCallback? onSubtract,
        VoidCallback? onAdd,
      }) {
    return ProductCard(
      id: model.id,
      name: model.name,
      detail: model.detail,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    // intrinsicHeight하면 내부의 있는 모든 위젯이 최대로 같은 높이를 가진다.
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      '${price}원',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          _Footer(
            total: (basket.firstWhere((e) => e.product.id == id).count *
                basket.firstWhere((e) => e.product.id == id).product.price)
                .toString(),
            count: basket.firstWhere((e) => e.product.id == id).count,
            onSubtract: onSubtract!,
            onAdd: onAdd!,
          )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.onSubtract,
    required this.onAdd,
    required this.total,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 $total원',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onSubtract),
            Text(
              count.toString(),
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            renderButton(icon: Icons.add, onTap: onAdd),
          ],
        )
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          )),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
