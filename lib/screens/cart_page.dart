import 'package:flutter/material.dart';
import 'package:plant_app/const/constants.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/widgets/plant_widget.dart';

class CartPage extends StatefulWidget {
  final List<Plant> cartPlants;
  const CartPage({
    Key? key,
    required this.cartPlants,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Plant> cartPlants;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    // Verifica se a lista de plantas no carrinho está vazia
    if (widget.cartPlants.isEmpty) {
      cartPlants = Plant.addedToCartPlants().toSet().toList();
    } else {
      cartPlants = widget.cartPlants;
    }
    // Calcula o preço total
    totalPrice = calculateTotalPrice();
  }

  int calculateTotalPrice() {
    int total = 0;
    for (var i = 0; i < cartPlants.length; i++) {
      total += cartPlants[i].price;
    }
    return total;
  }

  void completePurchase(BuildContext context) {
    // Lógica para finalizar a compra aqui
    print('Compra completa');
    print('Total: ${(totalPrice).toStringAsFixed(2)}');

    // Exibir SnackBar
    final snackBar = SnackBar(
      content: Text('Compra Completa\nTotal: ${(totalPrice).toStringAsFixed(2)}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return widget.cartPlants.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset('assets/images/add-cart.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'O carrinho de compras está vazio',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'iranSans',
                    color: Constants.blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.cartPlants.length,
                      itemBuilder: (context, index) {
                        return NewPlantWidget(
                          plantList: widget.cartPlants,
                          index: index,
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                child: Image.asset('assets/images/euro.png'),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${(totalPrice).toStringAsFixed(2)}', // Exibe o preço dividido por 100 para converter centavos em euros
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lalezar',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => completePurchase(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900], // Cor verde escuro
                            ),
                            child: Text(
                              'Comprar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
