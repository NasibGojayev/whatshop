import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_events.dart';
import 'package:whatshop/bloc_management/share_cubit.dart';
import 'package:whatshop/bloc_management/vendor_cubit/vendor_cubit.dart';
import 'package:whatshop/bloc_management/vendor_cubit/vendor_state.dart';
import 'package:whatshop/tools/variables.dart';
import '../bloc_management/cart_bloc/cart_bloc.dart';
import '../bloc_management/cart_bloc/cart_event.dart';
import '../bloc_management/comment_bloc/comment_bloc.dart';
import '../bloc_management/comment_bloc/comment_event.dart';
import '../bloc_management/comment_bloc/comment_state.dart';
import '../bloc_management/d_product_bloc/d_product_event.dart';
import '../bloc_management/d_product_bloc/d_product_state.dart';
import '../bloc_management/favorite_bloc/favorite_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../tools/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailedProductPage extends StatefulWidget {
  final String productId;
  const DetailedProductPage({
    super.key,
    required this.productId,
  });

  @override
  State<DetailedProductPage> createState() => _DetailedProductPageState();
}

class _DetailedProductPageState extends State<DetailedProductPage> {

  @override
  void initState(){
    super.initState();
    BlocProvider.of<ProductIdBloc>(context).add(FetchProductIdEvent(widget.productId));

  }
  @override
  void dispose(){
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    late Product product;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ətraflı',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/home'); // və ya istədiyin default route
                }
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  Share.share('https://whatshop.az/product/${widget.productId}');
                },
                icon: Icon(Icons.share)),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  //context.read<FavoriteBloc>().add(CaptureProductsEvent());
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BlocProvider(
                          create: (_) => ShareCubit(product.images.length),
                          child: BlocBuilder<ShareCubit,
                                  List<SelectedImageObject>>(
                              builder: (context, state) {
                            return Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Paylashmaq istediyin sekilleri sec'),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                        width: widthSize,
                                        height: 700,
                                        child: Wrap(spacing: 10, children: [
                                          for (int i = 0;
                                              i < product.images.length;
                                              i++)
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<ShareCubit>()
                                                    .toggleSelectImage(
                                                        SelectedImageObject(
                                                      imagePath:
                                                          product.images[i],
                                                      index: i,
                                                    ));
                                              },
                                              child: Stack(
                                                children: [
                                                  RepaintBoundary(
                                                    key: context
                                                        .read<ShareCubit>()
                                                        .getKey(i),
                                                    child: Stack(
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          height: 120,
                                                          child: Image.network(
                                                              product
                                                                  .images[i]),
                                                        ),
                                                        Positioned(
                                                            top: 5,
                                                            left: 5,
                                                            child: Container(
                                                              color: Colors
                                                                  .black54,
                                                              child: Text(
                                                                'id: ${product.productId}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 4,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 10,
                                                      left: 5,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: state.any((element) =>
                                                                element
                                                                    .imagePath ==
                                                                product
                                                                    .images[i])
                                                            ? Icon(
                                                                Icons.check_box,
                                                                color:
                                                                    mainGreen)
                                                            : Icon(
                                                                Icons
                                                                    .check_box_outline_blank,
                                                                color:
                                                                    mainGreen,
                                                              ),
                                                      ))
                                                ],
                                              ),
                                            )
                                        ])),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (state.isNotEmpty) {
                                      context
                                          .read<ShareCubit>()
                                          .shareImages(product.productId);
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Şəkil seçmədiniz'), // The message to display
                                        duration: Duration(
                                            milliseconds:
                                                2300), // How long to show the snackbar (optional)
                                      ));
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    width: widthSize * 0.95,
                                    color: state.isNotEmpty
                                        ? primaryColor
                                        : Colors.grey,
                                    child: Center(
                                        child: Text(
                                      'Şəkil kimi Paylaş',
                                      style: TextStyle(
                                        color: state.isNotEmpty
                                            ? Colors.white
                                            : primaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                        );
                      });
                },
                icon: Icon(Icons.ios_share)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        backgroundColor: bozumsu,
        body: SafeArea(
          child: BlocBuilder<ProductIdBloc, ProductIdState>(
              builder: (context, state) {
            if (state is ProductIdErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/error');
              });
              return const SizedBox.shrink();
            } else if (state is ProductIdLoadingState) {
              return LinearProgressIndicator();
            } else if (state is ProductIdFetchedState) {
              product = state.product;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // appbar(widthSize: widthSize, heightSize: heightSize, product: product),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: bozumsu,
                                height: 400,
                                child: AnotherCarousel(
                                  images: [
                                    for (var i in product.images)
                                      InstaImageViewer(
                                        child:
                                            ClipRRect(child: Image.network(i)),
                                      )
                                  ],
                                  dotSize: 7,
                                  autoplay: false,
                                ),

                                //child: Image.network(product['pic_path'][0],),
                              )),

                          BuildDescription(
                            widthSize: widthSize,
                            state: state,
                            heightSize: heightSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomButtons(
                      heightSize: heightSize,
                      widthSize: widthSize,
                      state: state),
                ],
              );
            } else if (state is ProductIdLoadingState) {
              return LinearProgressIndicator();
            } else if (state is ProductIdErrorState) {
              return Text(state.error);
            } else {
              return Text('unexpected error');
            }
          }),
        ));
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons(
      {super.key,
      required this.heightSize,
      required this.widthSize,
      required this.state});

  final double heightSize;
  final double widthSize;
  final ProductIdState state;

  @override
  Widget build(BuildContext context) {
    final stat = state as ProductIdFetchedState;
    final product = stat.product;
    bool isSelected =
        (stat.colorOption.color != '' && stat.sizeOption.size != '');

    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
          color: Colors.black12, // Sərhədin rəngi
          width: 2.0, // Sərhədin qalınlığı
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: widthSize * 0.20,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                context.read<FavoriteBloc>().add(ToggleFavoriteEvent(
                    favoriteObject: FavoriteObject(
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
                  final isFavorite = updatedFavorites
                      .any((fav) => fav.productId == product.productId);
                  //isFavorite?Icon(Icons.favorite,color: primaryColor, size: 24,):Icon(Icons.favorite_border_outlined,color: primaryColor, size: 24,);

                  return Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: primaryColor,
                    size: 24,
                  );
                } else {
                  return Icon(Icons.favorite_border_outlined);
                }
              }),
            ),
          ),
          TextButton(
            onPressed: () {
              if (stat.colorOption.color == '' || stat.sizeOption.size == '') {
                //chooseOpts(context, product.productId);
                return;
              }

              context.read<CartBloc>().add(AddCartEvent(
                    product: product,
                    sizeOption: SizeOption(
                        price: stat.sizeOption.price,
                        size: stat.sizeOption.size,
                        isAvailable: true),
                    colorOption: ColorOption(
                        color: stat.colorOption.color, isAvailable: true),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Mehsul sebete elave olundu !'), // The message to display
                  duration: Duration(
                      milliseconds:
                          2300), // How long to show the snackbar (optional)
                  action: SnackBarAction(
                    // An optional action button
                    label: 'Sebete get',
                    onPressed: () {
                      context.push('/cart');
                    },
                  ),
                ),
              );
            },
            child: Container(
                width: widthSize * 0.7,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isSelected ? mainGreen : Colors.grey,
                ),
                child: Center(
                  child: Text(
                    'Sebete Elave et',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class BuildDescription extends StatelessWidget {
  const BuildDescription({
    super.key,
    required this.widthSize,
    required this.state,
    required this.heightSize,
  });

  final double widthSize;
  final ProductIdFetchedState state;
  final double heightSize;

  @override
  Widget build(BuildContext context) {
    final stat = state;
    final Product product = stat.product;
    return Container(
      width: widthSize,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: bozumsu,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        height: 90,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                RatingBar(
                                  ignoreGestures: true,
                                  itemSize: 17,
                                  initialRating: stat.product.avgRating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: primaryColor,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: primaryColor,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: primaryColor,
                                    ),
                                  ),
                                  onRatingUpdate: (_) {},
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${stat.product.avgRating}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () => _showCommentSheet(context,stat.product.productId),
                                child: Text('Yorumlar'))
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: widthSize,
                    child: Text(
                      '${stat.sizeOption.price} AZN',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          BuildVendorProfile(stat: stat,),
          SizedBox(
            height: 15,
          ),
          Container(
            width: widthSize,
            padding: EdgeInsets.only(left: 14),
            color: bozumsu,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reng Secin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC1E1E1E),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: [
                    for (var i in product.colorOptions)
                      GestureDetector(
                          onTap: () {
                            if (i.isAvailable == true) {
                              context
                                  .read<ProductIdBloc>()
                                  .add(SelectColorEvent(color: i.color));
                            }
                          },
                          child: Stack(
                            children: [
                              // Size Option Container
                              Container(
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: i.isAvailable
                                      ? (stat.colorOption.color == i.color
                                          ? mainGreen
                                          : Colors.white)
                                      : Colors.redAccent.withValues(
                                          alpha:
                                              0.7), // Slightly transparent when unavailable
                                  border: Border.all(
                                    color: stat.colorOption.color == i.color
                                        ? mainGreen
                                        : Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      4), // Added subtle rounding
                                ),
                                child: Center(
                                  child: Padding(
                                    // Using Padding instead of Container for margins
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    child: Text(
                                      i.color,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: stat.colorOption.color == i.color
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // "Not Available" Badge
                              if (!i.isAvailable) // More efficient than ternary with Positioned
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.block,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ))
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: widthSize,
            padding: EdgeInsets.only(left: 14),
            color: bozumsu,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olcu Secin (qiymet ferqlilik gostere biler)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC1E1E1E),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: [
                    for (var i in product.sizeOptions)
                      GestureDetector(
                          onTap: () {
                            if (i.isAvailable == true) {
                              context.read<ProductIdBloc>().add(SelectSizeEvent(
                                  size: i.size, price: i.price));
                            }
                          },
                          child: Stack(
                            children: [
                              // Size Option Container
                              Container(
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: i.isAvailable
                                      ? (stat.sizeOption.size == i.size
                                          ? mainGreen
                                          : Colors.white)
                                      : Colors.redAccent.withValues(alpha: 0.7), // Slightly transparent when unavailable
                                  border: Border.all(
                                    color: stat.sizeOption.size == i.size
                                        ? mainGreen
                                        : Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      4), // Added subtle rounding
                                ),
                                child: Center(
                                  child: Padding(
                                    // Using Padding instead of Container for margins
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    child: Text(
                                      i.size,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: stat.sizeOption.size == i.size
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // "Not Available" Badge
                              if (!i.isAvailable) // More efficient than ternary with Positioned
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.block,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: bozumsu, //height: 120,
            width: widthSize,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Məhsul Məlumatları',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () =>
                            _showDescriptionModal(context, product.description),
                        child: Text(
                          'Tam Göstər ->',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: widthSize * 0.88,
                    //height: 65,
                    child: Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xA51E1E1E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

        ],
      ),
    );
  }

  void _showDescriptionModal(BuildContext context, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: controller,
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildVendorProfile extends StatelessWidget {
  final ProductIdFetchedState stat;
  const BuildVendorProfile({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    context.read<VendorCubit>().fetchVendor(stat.product.vendorId);
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context,state) {
        if(state is VendorLoaded){
          return ElevatedButton(
            onPressed: () {
              context.push('/vendor/${state.vendor.vendorId}');
            },
            child: Container(
              width: getWidthSize(context),
              height: 60,
              color: bozumsu,
              child: Row(children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(state.vendor.picPath),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          state.vendor.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.verified,
                          color: CupertinoColors.activeBlue,
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        child: Text(state.vendor.address))
                  ],
                )
              ]),
            ),
          );
        }else{
          return CircularProgressIndicator();
        }
      }
    );
  }
}

class BuildComments extends StatelessWidget {


   BuildComments({super.key, required this.comment, required this.userId, required this.time});

   final String comment;
   final String userId;
   final DateTime time;
   final commentController = TextEditingController();

   final bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Image.asset('assets/images/greenGirl.png'),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('$userId | ${time.toString().substring(0,16)}')),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {},
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    onTap: () {

                    },
                    child: const Text('Uyğunsuz rəyi bildir !'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Comment text with expandable functionality
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: comment,
                    style: const TextStyle(fontSize: 16),
                  ),
                  maxLines: 3,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                final needsExpansion = textPainter.didExceedMaxLines;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    if (needsExpansion)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            /*setState(() {
                              isExpanded = !isExpanded;
                            });*/
                          },
                          child: Text(
                            isExpanded ? 'Daha az göstər' : 'Daha çox göstər',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showCommentSheet(BuildContext context, String productId) {
  TextEditingController commentController = TextEditingController();
  context.read<CommentBloc>().add(FetchCommentsEvent(productId));


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (_, controller) => Container(
            color: bozumsu,
            width: getWidthSize(context),
            child: SafeArea( // makes sure the bottom doesn't overlap system UI
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<CommentBloc, CommentState>(
                      builder: (context, state) {
                        if (state is CommentLoadedState) {
                          return ListView.builder(
                            controller: controller,
                            itemCount: state.comments.length,
                            itemBuilder: (context, index) {
                              return BuildComments(
                                comment: state.comments[index].comment,
                                userId: state.comments[index].userId,
                                time: state.comments[index].time,
                              );
                            },
                          );
                        } else if (state is CommentLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is CommentErrorState) {
                          return Center(child: Text(state.error.toString()));
                        } else {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.comment_outlined, size: 100),
                                Text('Hələki komment yoxdur ..'),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Yorumunuz',
                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            context.read<CommentBloc>().add(
                              AddCommentEvent(
                                productId: productId,
                                comment: commentController.text,
                                time: DateTime.now(),
                              ),
                            );
                            commentController.clear();
                          },
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

}

