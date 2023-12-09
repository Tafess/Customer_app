// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/primary_button.dart';
import 'package:buyers/constants/routes.dart';
import 'package:buyers/constants/top_titles.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/category_view.dart';
import 'package:buyers/screens/check_out.dart';
import 'package:buyers/screens/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];
  bool isLoding = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoyList();
    // getBestProducts();
    super.initState();
  }

  void getCategoyList() async {
    setState(() {
      isLoding = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();
    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoding = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProduct(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void getBestProducts() async {
    setState(() {
      isLoding = true;
    });

    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    setState(() {
      isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TopTitles(title: '........', subtitle: ''),
      ),
      body: isLoding
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            child: TextFormField(
                              controller: search,
                              onChanged: (String value) {
                                searchProduct(value);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Search products ...',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                            width: double.infinity,
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          categoriesList.isEmpty
                              ? const Center(
                                  child: Text('Category is Empty'),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: categoriesList
                                        .map(
                                          (category) => Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Column(
                                              children: [
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    Routes.instance.push(
                                                        widget: CategoryView(
                                                            categoryModel:
                                                                category),
                                                        context: context);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 35,
                                                    child: Column(children: [
                                                      SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            category.image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(category.name,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .black)),
                                                    ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Products',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          isSearched()
                              ? const Center(
                                  child: Text('No such product found'),
                                )
                              : searchList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GridView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: searchList.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 0.8,
                                                  mainAxisSpacing: 7,
                                                  crossAxisSpacing: 20,
                                                  crossAxisCount: 2),
                                          itemBuilder: (ctx, index) {
                                            ProductModel singleProduct =
                                                searchList[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  Routes.instance.push(
                                                      widget: ProductDetails(
                                                          singleProduct:
                                                              singleProduct),
                                                      context: context);
                                                },
                                                child: Column(children: [
                                                  SizedBox(
                                                    height: 50,
                                                    width: double.infinity,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        singleProduct.image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    singleProduct.name,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   'ETB ${singleProduct.discount.toStringAsFixed(2)}',
                                                  // ),
                                                  Text(
                                                    'ETB ${singleProduct.price.toStringAsFixed(2)}',
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    width: 100,
                                                    child: PrimaryButton(
                                                      onPressed: () {
                                                        Routes.instance.push(
                                                            widget: ProductDetails(
                                                                singleProduct:
                                                                    singleProduct),
                                                            context: context);
                                                        // Routes.instance.push(
                                                        //     widget:
                                                        //         ProductDetails,
                                                        //     context: context);
                                                      },
                                                      title: 'Buy',
                                                    ),
                                                  ), // onPressed: () {}, child: Text('Buy'))
                                                ]),
                                              ),
                                            );
                                          }),
                                    )
                                  : productModelList.isEmpty
                                      ? const Center(
                                          child: Text('No product found'),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GridView.builder(
                                            padding: const EdgeInsets.only(
                                                bottom: 100),
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: productModelList.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.7,
                                                    mainAxisSpacing: 7,
                                                    crossAxisSpacing: 6,
                                                    crossAxisCount: 2),
                                            itemBuilder: (ctx, index) {
                                              ProductModel singleProduct =
                                                  productModelList[index];
                                              return InkWell(
                                                onTap: () {
                                                  Routes.instance.push(
                                                      widget: ProductDetails(
                                                          singleProduct:
                                                              singleProduct),
                                                      context: context);
                                                },
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                12, 12, 6, 6),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 60,
                                                              width: double
                                                                  .infinity,
                                                              child: Image.network(
                                                                  singleProduct
                                                                      .image,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Text(
                                                              singleProduct
                                                                  .name,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            if (singleProduct
                                                                    .discount !=
                                                                0.0)
                                                              Text(
                                                                  'Discount: ETB ${singleProduct.discount.toStringAsFixed(2)}'),
                                                            Text(
                                                              'Price: ETB ${singleProduct.price.toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                  decoration: singleProduct
                                                                              .discount !=
                                                                          0.0
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : null),
                                                            ),
                                                            Text(
                                                              'Description: ${singleProduct.description}',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                                ' ${singleProduct.quantity} items found'),
                                                            if (singleProduct
                                                                    .size !=
                                                                0.0)
                                                              Text(
                                                                  ' ${singleProduct.size} ${singleProduct.measurement} '),
                                                            const SizedBox(
                                                              height: 6.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //   Container(
                                                    //     color: Colors
                                                    //         .deepOrange,
                                                    //     height: 30,
                                                    //     width: 30,
                                                    //     alignment: Alignment
                                                    //         .center,
                                                    //     child: IconButton(
                                                    //         onPressed: () {
                                                    //           Routes.instance.push(
                                                    //               widget: ProductDetails(
                                                    //                   singleProduct:
                                                    //                       singleProduct),
                                                    //               context:
                                                    //                   context);
                                                    //           Routes.instance.push(
                                                    //               widget: CheckOutScreen(
                                                    //                   singleProduct:
                                                    //                       singleProduct),
                                                    //               context:
                                                    //                   context);
                                                    //         },
                                                    //         icon: Icon(
                                                    //             Icons
                                                    //                 .shopping_cart_checkout,
                                                    //             color: Colors
                                                    //                 .white)),
                                                    //   ),
                                                    // ],
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
