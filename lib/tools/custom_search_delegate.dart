import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/pages/home_page.dart';
import 'package:whatshop/tools/variables.dart';

import '../bloc_management/favorite_bloc/favorite_cubit.dart';
import 'colors.dart';

class ProductSearchDelegate extends SearchDelegate {

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search bar
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return Center(child: Text("Axtarış üçün mətn daxil edin"));
    }

    return FutureBuilder(
      future: _searchProducts(query),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        int crossAxisCount = getCrossAxisCount(context);
        double childAspectRatio = getChildAspectRatio(context);
        final ScrollController scrollController = ScrollController();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Məhsul tapılmadı"));
        }

        final results = snapshot.data!;
        return GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: childAspectRatio
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];

            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=>DetailedProductPage(
                  product: product,)));
              },
              child: Item(id: product['product_id']??' ',icon: BlocBuilder<FavoriteCubit,List<Map<String,dynamic>>>(
              builder: (context,state){
                return state.any((element) => element['product_id']==product['product_id'])
                    ? Icon(Icons.check_box,color: mainGreen,size: 30,)
                    : Icon(Icons.check_box_outline_blank,size: 30,);
              }
              ),
                  name: product['name'], price: product['price'],
                onPressed: () {
                  context.read<FavoriteCubit>().toggleFavorite(product);
                },
                image: Image.network(product['pic_path'][0]),),
            );

            /*ListTile(
              title: Text(product['name']),

            );*/
          },
        );
      },
    );
  }

  Future<List<dynamic>> _searchProducts(String searchQuery) async {
    String modifiedQuery = searchQuery.split(' ').map((word) => '$word:*').join(' & ');
    final response = await supabase
        .from('products')
        .select()
        .filter('search_index', 'fts', modifiedQuery)
        .limit(10);

    return response;
  }
}
