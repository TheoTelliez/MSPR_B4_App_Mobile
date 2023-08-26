import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payetonkawa/models/products.dart';
import 'package:payetonkawa/screens/ItemPage.dart';
import 'package:payetonkawa/service/revendeurService.dart';
import 'package:payetonkawa/style/colors.dart';
import 'package:payetonkawa/screens/emailPage.dart';
import 'package:payetonkawa/screens/loginPage.dart';
import 'package:payetonkawa/screens/homePage.dart';

import '../models/retailers.dart';

class MainPage extends StatefulWidget {
  final String? email;
  const MainPage({super.key, required this.email});
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Retailers? retailer;
  List<Products>? products;

  void fetchInfoRetailers(email) async {
    retailer = await revendeurService.getRetailerbyEmail(email);
  }

  void fetchInfoProducts() async {
    products = await revendeurService.getProducts();
    setState(() {
      products!.sort((a, b) => b.stock!.compareTo(a.stock!));
    });
  }

  @override
  void initState() {
    fetchInfoRetailers(widget.email);
    fetchInfoProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Container(
              width: 300.0,
              height: 50.0,
              margin: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 15.0, top: 0
              ),
              padding: const EdgeInsets.all(3.0),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.secondary, width: 1)),
              ),
              child: const Text(
                'Accueil',
                style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'RalewaySB',
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Bonjour${retailer?.name != null ? ' ${retailer?.name} !' : ''}',
              style: const TextStyle(
                fontSize: 26.0,
                fontFamily: 'RalewaySB',
                color: AppColors.secondary,
              ),
            ),
            // disconnect button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    await storage.delete(key: 'jwt');
                   // ignore: use_build_context_synchronously
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage(
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.secondary,
                      maximumSize: const Size(120, 40.0)),
                  child: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'RalewaySB',
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Derniers ajouts",
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'RalewayRegular',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(
              width: 90,
              child: Divider(
                color: AppColors.secondary,
                thickness: 1.0,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: 180,
                child: GridView.count(
                  childAspectRatio: 2.5 / 2,
                  crossAxisCount: 1,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    3,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemPage(
                                    id: products![index].uid,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.secondary,
                                maximumSize: const Size(120, 140.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${products?[index].couleur} ',
                                      style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RalewayLight'),
                                    ),
                                    Image(
                                      width: 100,
                                      height: 110,
                                      image: Image.network(products?[index].image != null ? '${products?[index].image}' : 'https://upload.wikimedia.org/wikipedia/commons/2/25/Carré_blanc.jpg').image,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${products?[index].name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RalewaySB',
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            '${products?[index].price} €',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RalewayRegular',
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            const Text(
              "Les promos du moment",
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'RalewayRegular',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(
              width: 90,
              child: Divider(
                color: AppColors.secondary,
                thickness: 1.0,
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 180,
                child: GridView.count(
                  childAspectRatio: 2.5 / 2,
                  crossAxisCount: 1,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    3,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemPage(
                                    id: products![index].uid,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.secondary,
                                maximumSize: const Size(120, 140.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${products?[index].couleur} ',
                                      style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RalewayLight'),
                                    ),
                                    Image(
                                      width: 100,
                                      height: 110,
                                      image: Image.network(products?[index].image != null ? '${products?[index].image}' : 'https://upload.wikimedia.org/wikipedia/commons/2/25/Carré_blanc.jpg').image,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${products?[index].name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RalewaySB',
                              color: AppColors.secondary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(                           
                                '${products?[index].price} €',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12.0, 
                                  fontFamily: 'RalewayRegular',
                                  color: AppColors.secondary,
                                ),
                              ),
                              SizedBox(width: 5),  // Espace entre les deux prix
                              Text(
                                '${((products?[index].price ?? 0) * 1.1).toStringAsFixed(2)} €',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'RalewayRegular',
                                  color: AppColors.darkred,
                                  decoration: TextDecoration.lineThrough,  // Barrer le texte
                                ),
                              ),
                            ],
                          )

                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
