
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/screens/category_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleCategoryWidget extends StatelessWidget {
  const SingleCategoryWidget({
    super.key,
    required this.categoriesList,
  });

  final List<CategoryModel> categoriesList;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child:
                                  Image.network(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
