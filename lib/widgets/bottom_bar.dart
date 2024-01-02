import 'package:buyers/screens/custom_drawer.dart';
import 'package:buyers/screens/cart_screen.dart';
import 'package:buyers/screens/favorite_screen.dart';
import 'package:buyers/screens/home.dart';
import 'package:buyers/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    final Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final PersistentTabController _controller = PersistentTabController();
  final bool _hideNavBar = false;

  List<Widget> _buildScreens() => [
        const Home(),
        const CartScreen(),
        const OrderScreen(),
        // const AccountScreen(),
        // const FavoriteScreen(),

        //  ProfileScreen(),
        //OrderScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          inactiveIcon: const Icon(Icons.home_outlined, size: 20),
          title: 'home'.tr,
          //  activeColorPrimary: Theme.of(context).colorScheme.background,
          // inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
          //  inactiveColorSecondary: Colors.purple
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          inactiveIcon: const Icon(Icons.shopping_cart_outlined, size: 20),
          title: 'cart'.tr,
          //  activeColorPrimary: Colors.blue,
          //   inactiveColorPrimary: Colors.black54,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.circle),
          inactiveIcon: const Icon(Icons.circle_outlined, size: 20),
          title: 'orders'.tr,
          //  activeColorPrimary: Colors.blue,
          //  inactiveColorPrimary: Colors.black54
        ),
        // PersistentBottomNavBarItem(
        //   icon: const Icon(Icons.person),
        //   inactiveIcon: const Icon(Icons.person_2_outlined, size: 20),
        //   title: 'Profile',
        //   activeColorPrimary: Colors.blue,
        //   inactiveColorPrimary: Colors.deepOrange,
        // ),
        // PersistentBottomNavBarItem(
        //   icon: Icon(Icons.settings_applications),
        //   inactiveIcon: const Icon(Icons.settings, size: 20),
        //   title: 'Settings',
        //   activeColorPrimary: Colors.blue,
        //   inactiveColorPrimary: Colors.deepOrange,
        // )
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: false,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,
          backgroundColor: Theme.of(context).colorScheme.secondary,

          hideNavigationBar: _hideNavBar,
          decoration: const NavBarDecoration(),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 10),
            curve: Curves.bounceIn,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
          ),
          navBarStyle:
              NavBarStyle.style9, // Choose the nav bar style with this property
        ),
      );
}
