import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/tools/colors.dart';

import '../bloc_management/d_product_bloc/d_product_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_events.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../bloc_management/vendor_cubit/vendor_cubit.dart';
import '../bloc_management/vendor_cubit/vendor_state.dart';
import 'home_page.dart';

class VendorProfilePage extends StatefulWidget {
  final String vendorId;

  const VendorProfilePage({super.key, required this.vendorId});

  @override
  _VendorProfilePageState createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<VendorCubit>().fetchVendor(widget.vendorId);

    context.read<VendorCubit>().fetchVendorProducts(widget.vendorId);
  }


  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCubit, VendorState>(
        builder: (context, state) {
          if(state is VendorLoading){
            return CircularProgressIndicator();
          }
          else if (state is VendorLoaded){
            return Scaffold(
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      leading: GestureDetector(
                        onTap: (){
                          if(Navigator.of(context).canPop()){
                            Navigator.of(context).pop();
                          }
                          else{
                            context.go('/home');
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(

                              color: Colors.white60,
                              child: Icon(Icons.arrow_back_ios,size: 20,)),
                        ),
                      ),
                      expandedHeight: 250.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          title: Container(
                              color: Colors.white38,
                              child: Text(state.vendor.shopName, style: TextStyle(
                                  color: primaryTextColor, fontSize: 22))),
                          background: Image.network(
                              loadingBuilder: (context,child,loadingProgress){
                                if(loadingProgress==null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Icon(Icons.broken_image));
                              },

                              state.vendor.shopImage
                          )),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: "Haqqında"),
                            Tab(text: "Məhsullar"),

                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutTab(state.vendor),
                    _buildProductsTab(state.vendor),

                  ],
                ),
              ),
             /* floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Action for contacting vendor
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.chat),
              ),*/
            );
          }
          else{
            return Text('error');
          }
        }
    );
  }

  Widget _buildProductsTab(Vendor state) {
    final List<Product> products = state.products;
    if(products.isEmpty){
      return Text('bombos');
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 350,
      ),
      itemCount: products.length, // Add this
      itemBuilder: (BuildContext context, int index) {
        final product = products[index]; // Use local variable

        return GestureDetector(
          onTap: () => context.push('/product/${product.productId}'),
          child: Item(
            id: product.productId,
            cartIcon: GestureDetector(
              onTap: () => chooseOpts(context, product.productId),
              child: const Icon(Icons.shopping_cart_sharp),
            ),
            image: product.images.isNotEmpty
                ? Image.network(product.images[0])
                : Placeholder(),
            name: product.name,
            price: product.sizeOptions[0].price,
            icon: GestureDetector(
            onTap: (){
        context
            .read<FavoriteBloc>()
            .add(ToggleFavoriteEvent(favoriteObject: FavoriteObject(
        avgRating: product.avgRating,
        name: product.name,
        price: product.sizeOptions[0].price,
        image: product.images[0],
        productId: product.productId)));


        },
              child: BlocBuilder<FavoriteBloc, FavoriteStates>(
                  builder: (context, state) {
                    if (state is FavoriteLoadedState) {
                      final updatedFavorites = state.favorites;
                      final isFavorite = updatedFavorites.any((fav) => fav.productId == product.productId);
                      //isFavorite?Icon(Icons.favorite,color: primaryColor, size: 24,):Icon(Icons.favorite_border_outlined,color: primaryColor, size: 24,);

                      return Icon(isFavorite?Icons.favorite:Icons.favorite_border_outlined,color: primaryColor, size: 24,);

                    }
                    else {
                      return Icon(Icons.favorite_border_outlined);
                    }
                  }
              ),)
          ),
        );
      },
    );
  }


  Widget _buildAboutTab(Vendor state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,

                child: Image.network(state.picPath),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),

                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 4),
                      Text(state.address),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            "Magaza Haqqında",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            state.description,
            style: TextStyle(height: 1.5),
          ),
          SizedBox(height: 16),
          SizedBox(height: 16),
          Text(
            "Əlaqə Məlumatları",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildContactItem(Icons.phone, state.phone),
          _buildContactItem(Icons.email, state.email),
          SizedBox(height: 24),

        ],
      ),
    );
  }


  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}