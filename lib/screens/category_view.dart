// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryView({super.key, required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ProductModel> productModelList = [];
  bool isLoding = false;

  get categoriesList => null;
  void getCategoyList() async {
    setState(() {
      isLoding = true;
    });
    productModelList = await FirebaseFirestoreHelper.instance
        .productByCategory(widget.categoryModel.id);
    productModelList.shuffle();
    setState(() {
      isLoding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryModel.name)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productModelList.isEmpty
                      ? Center(
                          child: Text('noProduct'.tr),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: productModelList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    crossAxisCount: 2),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  productModelList[index];
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //  color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 12, 6, 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          singleProduct.name!,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: Image.network(
                                              singleProduct.image!,
                                              fit: BoxFit.cover),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        if (singleProduct.discount != 0.0)
                                          FittedBox(
                                            child: Row(
                                              children: [
                                                Text(
                                                  ' ${singleProduct.discount!.toStringAsFixed(2)}',
                                                  // style:
                                                  //     themeData.textTheme.bodySmall
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${(((singleProduct.price! - singleProduct.discount!) / (singleProduct.price!)) * 100).toStringAsFixed(0)} %  ',
                                                  style: TextStyle(
                                                      // color: Colors.green.shade700,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                text(title: 'offset'.tr),
                                              ],
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            text(title: 'price'.tr),
                                            Text(
                                              ' ${singleProduct.price!.toStringAsFixed(2)}  ',
                                              style: TextStyle(
                                                  decoration:
                                                      singleProduct.discount !=
                                                              0.0
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                            ),
                                            text(title: 'etb'.tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            text(title: 'descriptions'.tr),
                                            Flexible(
                                              child: Text(
                                                ' ${singleProduct.description}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            text(title: 'availableItems'.tr),
                                            Text(
                                                '    ${singleProduct.quantity}'),
                                          ],
                                        ),
                                        if (singleProduct.size != 0.0)
                                          // Text(
                                          //     ' ${singleProduct.size} ${singleProduct.measurement} '),
                                          const SizedBox(
                                            height: 6.0,
                                          ),
                                      ],
                                    ),
                                  ),

                                  //  Column(
                                  //   children: [
                                  //     Padding(
                                  //       padding:
                                  //           const EdgeInsets.only(top: 10.0),
                                  //       child: InkWell(
                                  //         onTap: () {
                                  //           Routes.instance.push(
                                  //               widget: ProductDetails(
                                  //                   singleProduct:
                                  //                       singleProduct),
                                  //               context: context);
                                  //         },
                                  //         child: SizedBox(
                                  //           height: 100,
                                  //           width: double.infinity,
                                  //           child: ClipOval(
                                  //             child: Image.network(
                                  //               singleProduct.image,
                                  //               fit: BoxFit.cover,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const SizedBox(
                                  //       height: 12,
                                  //     ),
                                  //     Text(
                                  //       singleProduct.name,
                                  //       style: const TextStyle(
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     Text(
                                  //       'ETB:  ${singleProduct.price.toStringAsFixed(2)}',
                                  //       style: const TextStyle(
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     const SizedBox(
                                  //       height: 6.0,
                                  //     ),
                                  //     SizedBox(
                                  //       height: 40,
                                  //       width: 100,
                                  //       child: CustomButton(
                                  //         onPressed: () {
                                  //           Routes.instance.push(
                                  //               widget: ProductDetails(
                                  //                   singleProduct:
                                  //                       singleProduct),
                                  //               context: context);
                                  //         },
                                  //      //   color: Colors.green,
                                  //         title: 'buy'.tr,
                                  //       ),
                                  //     ), // onPressed: () {}, child: Text('Buy'))
                                  //   ],
                                  // ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
