// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/primary_button.dart';
import 'package:buyers/constants/routes.dart';
import 'package:buyers/constants/top_titles.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/custom_drawer.dart';
import 'package:buyers/screens/category_view.dart';
import 'package:buyers/screens/product_details.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:buyers/widgets/single_category.dart';
import 'package:buyers/widgets/single_product.dart';
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
      // bottomNavigationBar: CustomBottomBar(),
      drawer: CustomDrawer(),
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
                                  child: SingleCategoryWidget(
                                      categoriesList: categoriesList),
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
                                            return SingleProductWidget(
                                                singleProduct: singleProduct);
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
                                                    mainAxisSpacing: 4,
                                                    crossAxisSpacing: 10,
                                                    crossAxisCount: 2),
                                            itemBuilder: (ctx, index) {
                                              ProductModel singleProduct =
                                                  productModelList[index];
                                              return SingleProductWidget(
                                                  singleProduct: singleProduct);
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
