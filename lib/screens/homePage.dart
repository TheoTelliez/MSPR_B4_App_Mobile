import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:payetonkawa/style/colors.dart';
import 'package:payetonkawa/tools/TabNavigation.dart';

import 'EmailPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/grains.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Paye ton kawa',
                    style: TextStyle(
                        color: AppColors.kawaOne,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RalewaySB'),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'La pause café parfaite',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'RalewayLight',
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToNextPage(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kawaOne,
                      foregroundColor: AppColors.white,
                      fixedSize: const Size(170.0, 50.0),
                    ),
                    child: const Text('Commencer le kawa'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _navigateToNextPage(BuildContext context) async {
    const storage = FlutterSecureStorage();
    // Read value
    String? token = await storage.read(key: 'jwt');
    if (token != null) {
      try {
        Jwt.parseJwt(token);
      } catch (e) {
        await storage.delete(key: 'jwt');
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailPage(
              displayError: false,
            ),
          ),
        );
      }

      var emailToParse = await storage.read(key: 'email');

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabNavigation(
            email: emailToParse,
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailPage(
            displayError: false,
          ),
        ),
      );
    }
  }
}
