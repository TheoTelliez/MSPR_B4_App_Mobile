import 'package:flutter/material.dart';
import 'package:payetonkawa/models/products.dart';
import 'package:payetonkawa/screens/ItemPage.dart';
import 'package:payetonkawa/service/revendeurService.dart';
import 'package:payetonkawa/style/colors.dart';

import '../models/retailers.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => ProductsPageState();
}

enum SortOption {
  priceHighToLow,
  priceLowToHigh,
  nameAscending,
  nameDescending,
}

class ProductsPageState extends State<ProductsPage> {
  Retailers? retailer;
  List<Products>? products;
  List<Products>? filteredProducts;
  TextEditingController _searchController = TextEditingController();
  SortOption? selectedSortOption;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchInfoProducts() async {
    products = await revendeurService.getProducts();
    setState(() {
      products!.sort((a, b) => b.stock!.compareTo(a.stock!));
    });
    filteredProducts = await revendeurService.getProducts();
    setState(() {
      filteredProducts!.sort((a, b) => b.stock!.compareTo(a.stock!));
    });
  }

  @override
  void initState() {
    fetchInfoProducts();
    super.initState();
  }

  void _sortItems(SortOption? option) {
    setState(() {
      selectedSortOption = option;

      switch (option) {
        case SortOption.priceHighToLow:
          filteredProducts!
              .sort((a, b) => b.price!.compareTo(a.price!));
          break;
        case SortOption.priceLowToHigh:
          filteredProducts!
              .sort((a, b) => a.price!.compareTo(b.price!));
          break;
        case SortOption.nameAscending:
          filteredProducts!.sort((a, b) => a.name!.compareTo(b.name!));
          break;
        case SortOption.nameDescending:
          filteredProducts!.sort((a, b) => b.name!.compareTo(a.name!));
          break;
        default:
          filteredProducts!.sort((a, b) => b.stock!.compareTo(a.stock!));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kawaThree,
      body:  SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20,
                top: 28),
                child: Text(
                  'Nos machines',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontFamily: 'RalewaySB',
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        filteredProducts = products!.toList();
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      filteredProducts = products!
                          .where((product) => product.name!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      filteredProducts = products!.toList();
                    }
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children:[

            DropdownButton<SortOption>(
              value: selectedSortOption,
              hint: const Text("Filtrer les machines"),
              icon: const Icon(Icons.filter_list_alt),
              iconSize: 24,
              elevation: 16,
              isExpanded: false,
              onChanged: (SortOption? value) {
                _sortItems(value!);
              },
              items: const [
                DropdownMenuItem(
                  value: SortOption.priceLowToHigh,
                  child: Text('Prix le plus bas'),
                ),
                DropdownMenuItem(
                  value: SortOption.priceHighToLow,
                  child: Text('Prix le plus haut'),
                ),
                DropdownMenuItem(
                  value: SortOption.nameAscending,
                  child: Text('Nom par ordre croissant'),
                ),
                DropdownMenuItem(
                  value: SortOption.nameDescending,
                  child: Text('Nom par ordre décroissant'),
                ),
              ],
            ),
            ]
            ),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  children: List.generate(
                    filteredProducts?.length ?? 0,
                    (index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: 125,
                            height: 125,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemPage(
                                      id: filteredProducts![index].uid,
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
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${filteredProducts?[index].couleur} ',
                                        style: const TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'RalewayLight'),
                                      ),
                                      Image(
                                        width: 100,
                                        height: 100,
                                        image: Image.network(
                                                '${filteredProducts?[index].image}')
                                            .image,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${filteredProducts?[index].name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RalewaySB',
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            '${filteredProducts?[index].price} €',
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
          ],
        ),
      ),
      ),
    );
  }
}
