import 'dart:developer';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:payetonkawa/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:payetonkawa/style/colors.dart';
import 'package:payetonkawa/tools/TabNavigation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.yellow,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        if (result != null) {
          controller.stopCamera();

          const storage = FlutterSecureStorage();
          var currentJwt = result!.code.toString();
          var jwtInStorage = await storage.read(key: 'tempjwt');
          var emailToParse = await storage.read(key: 'email');

          
          if (currentJwt == jwtInStorage) {
            await storage.write(key: 'jwt', value: result!.code.toString());

            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabNavigation(
                        email: emailToParse,
                      )),
            );
          } else {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(
                        displayError: true,
                      )),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginPage(
                      displayError: true,
                    )),
          );
        }
      });
    });
  }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
