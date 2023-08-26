import 'package:flutter/material.dart';
import 'package:payetonkawa/screens/MainPage.dart';
import 'package:payetonkawa/screens/favPage.dart';
import 'package:payetonkawa/screens/productsPage.dart';
import 'package:payetonkawa/style/colors.dart';

void main() => runApp(const TabNavigation(
      email: '',
    ));

class TabNavigation extends StatelessWidget {
  final String? email;
  const TabNavigation({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(
        email: email,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String? email;
  const MyStatefulWidget({super.key, required this.email});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Classes permettant de gérer la navigation entre les pages
      body: Center(
        child: [
          MainPage(
            email: widget.email,
          ),
          const ProductsPage(),
          const FavPage(),
        ][_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/home.png"),
                size: 25,
              ),
              label: "Accueil"),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/coffee-machine.png"),
                size: 25,
              ),
              label: "Nos machines"),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/heart.png"),
              size: 25,
            ),
            label: "Favoris",
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors.secondary,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.tabColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
