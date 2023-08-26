import 'package:flutter/material.dart';
import 'package:payetonkawa/screens/loginPage.dart';
import 'package:payetonkawa/style/colors.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  // page affichant les produits favoris

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 28.0),
            Container(
              width: 300.0,
              height: 54.0,
              margin: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 15.0, top: 44.0
              ),
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.secondary, width: 1)),
              ),
              child: const Text(
                'Produits favoris',
                style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Vous n\'avez pas de produits favoris',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'RalewayLight',
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const LoginPage(
                displayError: false,
              )),
    );
  }