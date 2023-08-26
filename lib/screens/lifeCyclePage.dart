import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:payetonkawa/screens/emailPage.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  const LifeCycleManager({Key? key, required this.child}) : super(key: key);
  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      const storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'jwt');
      if (token != null) {
        if (true) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EmailPage(
                      displayError: true,
                      textError: "Session expirée, veuillez vous reconnecter",
                    )),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
