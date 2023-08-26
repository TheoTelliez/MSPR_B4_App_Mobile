import 'package:flutter/material.dart';
import 'package:payetonkawa/style/colors.dart';
import 'package:payetonkawa/tools/qrCode.dart';

class LoginPage extends StatelessWidget {
  final bool displayError;
  const LoginPage({super.key, required this.displayError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree, // Couleur d'arrière-plan identique à la page 1
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Container(
              width: 300.0,
              height: 54.0,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.secondary, width: 1)),
              ),
              child: const Text(
                'Me connecter',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (displayError)
              Container(
                width: 350.0,
                height: 40.0,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.red, // Couleur d'erreur identique à la page 1
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  'Scan du QR code échoué, veuillez réessayer',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const Center(
              heightFactor: 1.3,
              child: Image(
                width: 250,
                height: 250,
                image: AssetImage('assets/images/qr-code-scan.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 0,
                bottom: 0,
              ),
              child: Text(
                'Pour vous connecter, vous devez scanner le QR code reçu à l\'instant par mail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.white, // Couleur de texte en blanc
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 50,
                bottom: 0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToNextPage(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kawaOne, // Couleur de bouton identique à la page 1
                    foregroundColor: AppColors.white,
                    fixedSize: const Size(280.0, 50.0)),
                child: const Text(
                  'Scanner mon code',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCode()),
    );
  }
}
