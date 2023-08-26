import 'package:flutter/material.dart';
import 'package:payetonkawa/models/jwtResponse.dart';
import 'package:payetonkawa/style/colors.dart';
import 'package:payetonkawa/service/revendeurService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/retailers.dart';

import 'loginPage.dart';
class EmailPage extends StatefulWidget {
  final bool displayError;
  final String? textError;
  const EmailPage({super.key, required this.displayError, this.textError});

  @override
  State<EmailPage> createState() => _EmailPageFormState();
}

class _EmailPageFormState extends State<EmailPage> {
  final myController = TextEditingController();
  List<Retailers>? retailers;
  bool showMailImage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
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
                'Envoi du QR Code',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.displayError)
              Container(
                width: 350.0,
                height: 35.0,
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.textError!,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (showMailImage)
              const Center(
                child: Image(
                  width: 200,
                  height: 80,
                  image: AssetImage('assets/images/mail.png'),
                ),
              ),
            if (!showMailImage)
              const Center(
                child: Image(
                  width: 200,
                  height: 80,
                  image: AssetImage('assets/images/mailok.png'),
                ),
              ),
            const SizedBox(height: 50.0),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 0,
                bottom:0,
              ),
              child: Text(
                'Bienvenue sur l’application \n“Paye ton Kawa”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.white,
                ),
              ),
            ),
            Center(
              heightFactor: 1.4,
              child: Container(
                width: 298.0,
                height: 50.0,
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: 20,
                ),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kawaOne, width: 2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: TextField(
                  controller: myController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Entrez votre email...',
                    hintStyle: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'RalewaySB',
                      color: AppColors.kawaOne,
                    ),
                  ),
                  cursorColor: AppColors.kawaOne,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.kawaOne,
                  ),
                  textAlign: TextAlign.center, // Center the text horizontally and vertically
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  _sendmail(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kawaOne,
                    foregroundColor: AppColors.white,
                    fixedSize: const Size(300.0, 50.0)),
                child: const Text(
                  'Recevoir mon QR Code',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendmail(BuildContext context) async {
    try {
      setState(() {
            showMailImage = false;
      });

      var email = myController.text;
      JwtResponse userInfo = await revendeurService.login(email);
      if (userInfo != null) {
          setState(() {
            showMailImage = true;
          });

          await Future.delayed(const Duration(seconds: 1), () => "1");

        // ignore: use_build_context_synchronously
        _navigateToNextPage(context);

        // store jwt in secure storage
        const storage = FlutterSecureStorage();
        await storage.write(key: 'tempjwt', value: userInfo.token);

        // store email in secure storage
        await storage.write(key: 'email', value: email);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmailPage(
                    displayError: true,
                    textError: "Email non trouvé",
                  )),
        );
      }
    } catch (ex) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EmailPage(
                  displayError: true,
                  textError: "Un problème est survenu, veuillez réessayer",
                )),
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
}