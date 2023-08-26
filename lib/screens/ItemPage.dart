import 'package:flutter/material.dart';
import 'package:payetonkawa/models/products.dart';
import 'package:payetonkawa/service/revendeurService.dart';
import 'package:payetonkawa/style/colors.dart';

import '../tools/localAndWebObjectsView.dart';

class ItemPage extends StatefulWidget {
  final String? id;
  const ItemPage({super.key, this.id});
  @override
  State<ItemPage> createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage> with SingleTickerProviderStateMixin {
  Products? product;
  int stock = 0;
  bool isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _zoomAnimation;

  void fetchInfoProducts(uid) async {
    // Appeler le service pour récupérer les informations du produit par son ID
    var getProduct = await revendeurService.getProductsbyUid(uid);
    setState(() {
      // Mettre à jour l'état pour afficher les informations du produit
      product = getProduct;
      stock = product!.stock!;
    });
  }

 @override
  void initState() {
    fetchInfoProducts(widget.id);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Afficher la partie supérieure de l'écran avec l'image et le titre
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bouton de retour
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            // Naviguer vers la page précédente lors du clic sur le bouton de retour
                            Navigator.pop(context);
                          },
                          child: Ink(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                'assets/images/back.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35.0),
                      Center(
                        child: Image(
                          image: Image.network(product?.image != null ? '${product?.image}' : 'https://upload.wikimedia.org/wikipedia/commons/2/25/Carré_blanc.jpg').image,
                          height: 150, // Change the height of the image here
                        ),
                      ),
                    ],
                  ),
                ),
                // Afficher les informations du produit
                Padding(
                  padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 0,
                  bottom: 15,
                ),
                  child: product != null  // vérifie si 'product' n'est pas nul
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      // Afficher le titre du produit et l'état du stock
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product?.name != null ? '${product?.name}' : '',
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontFamily: 'RalewaySB',
                              color: AppColors.secondary,
                            ),
                          ),
                          // Bouton "Ajouter au favoris"
                          if (isFavorite)
                            GestureDetector(
                              onTap: () {
                                _toggleFavorite();
                              },
                              child: ScaleTransition(
                                scale: _zoomAnimation,
                                child: Image.asset(
                                  'assets/images/heart-red.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          if (!isFavorite)
                            GestureDetector(
                              onTap: () {
                                _toggleFavorite();
                              },
                              child: ScaleTransition(
                                scale: _zoomAnimation,
                                child: Image.asset(
                                  'assets/images/heart-white.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10.0),
                      // Afficher le prix du produit
                      Text(
                        product?.price != null ? '${product?.price} €' : '',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'RalewayRegular',
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Description :',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'RalewaySB',
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      // Afficher la description du produit
                      Text(
                        product?.description != null ? '${product?.description}' : '',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'RalewayRegular',
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Text(
                            'Couleur : ',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RalewayMedium',
                              color: AppColors.secondary,
                            ),
                          ),
                          // Afficher la couleur du produit
                          Text(
                            product?.couleur != null ? '${product?.couleur}' : '',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RalewayRegular',
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),

                      // Afficher la disponibilité du produit
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          const Text(
                            'Disponibilité : ',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RalewayMedium',
                              color: AppColors.secondary,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0, color: AppColors.white),
                                  color: stock > 0
                                      ? AppColors.green
                                      : AppColors.darkred,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                            ],
                          ),
                          // Afficher le stock du produit
                          Text(
                            stock > 0 ? 'En stock' : 'Rupture de stock',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RalewayRegular',
                              color: AppColors.kawaOne,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                )
              ],
            ),
            // Bouton "Voir en réalité augmentée" positionné en bas de l'écran
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToNextPage(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 45.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/augmented-reality.png'),
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Voir en réalité augmentée',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'RalewayRegular',
                          color: AppColors.kawaOne,
                        ),
                      ),
                    ],
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
    // Naviguer vers la page suivante lors du clic sur le bouton "Voir en réalité augmentée"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ObjectsOnPlanesWidget()),
    );
  }

  void _toggleFavorite() {
      setState(() {
        isFavorite = !isFavorite;
        if (isFavorite) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
}
