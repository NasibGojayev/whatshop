import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';
import '../bloc_management/favorite_bloc/favorite_cubit.dart';
import '../bloc_management/favorite_bloc/share_cubit.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Seçdiyin məhsulları paylaş"),
            IconButton(
              onPressed: () async {
                final favoriteState = context.read<FavoriteCubit>().state;
                context.read<ShareCubit>().captureProducts(favoriteState);
              },
              icon: Icon(Icons.send, size: 30, color: mainGreen),
            ),
          ],
        ),
      ),
      body: BlocBuilder<FavoriteCubit, List<Map<String, dynamic>>>(
        builder: (context, favoriteState) {
          context.read<ShareCubit>().initializeKeys(favoriteState);

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemCount: favoriteState.length,
            itemBuilder: (context, index) {
              var product = favoriteState[index];

              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: widthSize,
                  child: Card(
                    color: lightPrimaryColor,
                    child: ListTile(
                      leading: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedProductPage(product: product),
                            ),
                          );
                        },
                        child: RepaintBoundary(
                          key: context.read<ShareCubit>().getKey(index), // Get key from Cubit
                          child: Stack(
                            children: [
                              Image.network(
                                product['pic_path'][0],
                                width: 70,
                                height: 70,
                                fit: BoxFit.fitHeight,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                  child: Text(
                                    'ID: ${product['product_id']}',
                                    style: TextStyle(
                                      fontSize: 3,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      title: Text("${product['name']}"),
                      subtitle: Text('${product['price']} AZN'),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          context.read<FavoriteCubit>().removeFavorite(product['product_id']);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



