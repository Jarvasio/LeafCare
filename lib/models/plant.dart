// NABEGHEHA.COM

class Plant {
  final int plantId;
  final int price;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant({
    required this.plantId,
    required this.price,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.decription,
    required this.isSelected,
  });

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
      plantId: 0,
      price: 22,
      category: 'Recomendado',
      plantName: 'sansevieria',
      size: 'Pequeno',
      rating: 4.5,
      humidity: 34,
      temperature: '23 - 34',
      imageURL: 'assets/images/plant-one.png',
      isFavorated: false,
      decription:
          'Esta planta é uma das melhores plantas. Ela cresce na maioria das regiões do mundo e pode sobreviver mesmo nos climas mais adversos',
      isSelected: false,
    ),
    Plant(
      plantId: 1,
      price: 11,
      category: 'Ambiente de trabalho',
      plantName: 'filodendro',
      size: 'Médio',
      rating: 4.8,
      humidity: 56,
      temperature: '19 - 22',
      imageURL: 'assets/images/plant-two.png',
      isFavorated: false,
      decription:
          'Filodendro é um género botânico pertencente à família das aráceas. Os frutos do filodendro dão pelo nome comum banana-ananás, são bagas que se desenvolvem a partir de uma espata.',
      isSelected: false,
    ),
    Plant(
      plantId: 2,
      price: 18,
      category: 'Apartamento',
      plantName: 'Margarida da Praia',
      size: 'grande',
      rating: 4.7,
      humidity: 34,
      temperature: '22 - 25',
      imageURL: 'assets/images/plant-three.png',
      isFavorated: false,
      decription:
          'A espécie Bellis perennis, também designada pelos nomes populares margarida da praia, contém muitas variedades híbridas, utilizadas em floricultura, com lígulas brancas, rosadas, vermelhas ou roxas, de forma simples ou dobrada.',
      isSelected: false,
    ),
    Plant(
      plantId: 3,
      price: 30,
      category: 'Ambiente de trabalho',
      plantName: 'بلوستم بزرگ',
      size: 'Pequeno',
      rating: 4.5,
      humidity: 35,
      temperature: '23 - 28',
      imageURL: 'assets/images/plant-one.png',
      isFavorated: false,
      decription:
          'این گیاه یکی از بهترین گیاهان است. در بیشتر مناطق جهان رشد می کند و می تواند حتی در سخت ترین شرایط آب و هوایی نیز زنده بماند.',
      isSelected: false,
    ),
    Plant(
      plantId: 4,
      price: 24,
      category: 'Recomendado',
      plantName: 'Night-Blooming Jasmine',
      size: 'grande',
      rating: 4.1,
      humidity: 66,
      temperature: '12 - 16',
      imageURL: 'assets/images/plant-four.png',
      isFavorated: false,
      decription:
          'Night-Blooming Jasmine é uma espécie de planta da família da batata Solanaceae. É nativo das Índias Ocidentais, mas naturalizado no Sul da Ásia.',
      isSelected: false,
    ),
    Plant(
      plantId: 5,
      price: 24,
      category: 'Ambiente de Trabalho',
      plantName: 'Sábio',
      size: 'Médio',
      rating: 4.4,
      humidity: 36,
      temperature: '15 - 18',
      imageURL: 'assets/images/plant-five.png',
      isFavorated: false,
      decription:
          'O sábio é uma planta não muito alta e com folhas muito aromáticas. É bem conhecido por suas propriedades medicinais e por seu reconhecimento culinário, embora seja recomendável usá-lo sozinho.',
      isSelected: false,
    ),
    Plant(
      plantId: 6,
      price: 19,
      category: 'Jardim',
      plantName: 'Plumbago',
      size: 'Pequeno',
      rating: 4.2,
      humidity: 46,
      temperature: '23 - 26',
      imageURL: 'assets/images/plant-six.png',
      isFavorated: false,
      decription:
          'Plumbago auriculata, também conhecido como "plumbago", é uma planta de jardim perene que produz flores azuis brilhantes.',
      isSelected: false,
    ),
    Plant(
      plantId: 7,
      price: 23,
      category: 'Jardim',
      plantName: 'Tritônia',
      size: 'Médio',
      rating: 4.5,
      humidity: 34,
      temperature: '21 - 24',
      imageURL: 'assets/images/plant-seven.png',
      isFavorated: false,
      decription:
          'A tritônia é uma planta rasteira e florífera híbrida desenvolvida para decorar jardins. Ela é apreciada principalmente em canteiros e vasos baixos. Em algumas regiões, como no Sul e no Sudeste do Brasil.',
      isSelected: false,
    ),
    Plant(
      plantId: 8,
      price: 46,
      category: 'Recomendado',
      plantName: 'Tritônia',
      size: 'Médio',
      rating: 4.7,
      humidity: 46,
      temperature: '21 - 25',
      imageURL: 'assets/images/plant-eight.png',
      isFavorated: false,
      decription:
          'این گیاه یکی از بهترین گیاهان است. در بیشتر مناطق جهان رشد می کند و می تواند حتی در سخت ترین شرایط آب و هوایی نیز زنده بماند.',
      isSelected: false,
    ),
  ];

  get id => null;

  //Get the favorated items
  static List<Plant> getFavoritedPlants() {
    List<Plant> travelList = Plant.plantList;
    return travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants() {
    List<Plant> selectedPlants = Plant.plantList;
    return selectedPlants
        .where((element) => element.isSelected == true)
        .toList();
  }
}
