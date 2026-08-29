import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

final List<BannerOffer> bannerOffers = [
  BannerOffer(
    image: Assets.images.specialOffer1.path,
    title: 'Cookies 50% Off',
    category: 'Cookies',
  ),
  BannerOffer(
    image: Assets.images.specialOffer2.path,
    title: 'Chocolate Cake 50% Off',
    category: 'Birthday cake',
  ),
  BannerOffer(
    image: Assets.images.specialOffer3.path,
    title: 'Roulette 50% Off',
    category: 'Roulette',
  ),
  BannerOffer(
    image: Assets.images.specialOffer4.path,
    title: 'Donut 50% Off',
    category: 'Donut',
  ),
];

final List<String> imagesOfCategories = [
  Assets.images.cupcakeIllustration.path,
  Assets.images.donutIllustration.path,
  Assets.images.cakeIllustration.path,
  Assets.images.pastryIllustration.path,
  Assets.images.chocolateChipCookie.path,
  Assets.images.roulette.path,
];

final List<String> titlesOfCategories = [
  'Cupcake',
  'Donut',
  'Birthday cake',
  'Pastry',
  'Cookies',
  'Roulette',
];

List<String> titleOfTheListOfProducts = [
  'Featured products',
  'New products',
  'Popular products',
  'Online products',
];

List<String> productsName = [
  'Red Velvet Cake',
  'Chocolate Cake',
  'Red Velvet Cake',
  'Chocolate Cake',
];

List<String> productsImage = [
  Assets.images.redVelvetCakeWithFruit.path,
  Assets.images.strawberryChocolateCake.path,
  Assets.images.redVelvetCakeWithFruit.path,
  Assets.images.strawberryChocolateCake.path,
];

List<String> categoryProductsImage = [
  Assets.images.donutCategory1.path,
  Assets.images.donutCategory2.path,
  Assets.images.donutCategory3.path,
  Assets.images.cupcakeCategory1.path,
  Assets.images.cupcakeCategory2.path,
  Assets.images.cupcakeCategory3.path,
  Assets.images.birthdayCakeCategory1.path,
  Assets.images.birthdayCakeCategory2.path,
  Assets.images.birthdayCakeCategory3.path,
];

// List<String> categoryProductsName = [
//   'Sponge donut',
//   'Chocolate donut',
//   'Donuts',
//   'Strawberry cake',
//   'blackberry cake',
//   'Chocolate cake',
//   'Birthday cake',
//   'Birthday cake',
//   'Birthday cake',
// ];

// final String productDescription =
//     'Our chocolate cake is made with a combination of the finest ingredients, from premium chocolate and cocoa to the freshest eggs and pure butter. With a soft, moist texture and rich chocolate flavor, this cake will give you an unforgettable experience.\nEach slice is a celebration of pure indulgence, crafted to delight your senses.\nDiscover the difference that quality and care make in every single bite.';

final List<String> weights = ['0.5 kg', '1 kg', '1.5 kg', '2 kg', '4 kg'];

const _defaultSeller = Seller(
  name: 'Luna Fisher',
  imagePath:
      'assets/images/profile-image.png', // Assets.images.profileImage.path
);

final List<Product> localProducts = [
  Product(
    id: 'local_1',
    name: 'Red Velvet Cake',
    image: Assets.images.redVelvetCakeWithFruit.path,
    //detailImage: Assets.images.redVelvetCakeWithFruit.path,
    category: 'Birthday cake',
    price: 45.0,
    rating: 9.2,
    description:
        'Our red velvet cake is made with the finest cocoa, buttermilk, and '
        'a hint of vanilla, finished with rich cream cheese frosting. Soft, '
        'moist, and topped with fresh fruit for a delicate balance of '
        'sweetness in every bite.',
    seller: _defaultSeller,
    isFeatured: true,
    isNew: false,
    isPopular: true,
  ),
  Product(
    id: 'local_2',
    name: 'Chocolate Cake',
    image: Assets.images.strawberryChocolateCake.path,
    //detailImage: Assets.images.strawberryChocolateCake.path,
    category: 'Birthday cake',
    price: 50.0,
    discountPercentage: 50,
    rating: 9.1,
    description:
        'Our chocolate cake is made with a combination of the finest '
        'ingredients, from premium chocolate and cocoa to the freshest '
        'eggs and pure butter. With a soft, moist texture and rich '
        'chocolate flavor, this cake will give you an unforgettable '
        'experience. Each slice is a celebration of pure indulgence.',
    seller: _defaultSeller,
    isFeatured: true,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_3',
    name: 'Sponge Donut',
    image: Assets.images.donutCategory1.path,
    category: 'Donut',
    price: 12.5,
    discountPercentage: 50,
    rating: 8.7,
    description:
        'Light, airy sponge donuts glazed with a delicate sugar coating. '
        'Freshly baked every morning for the softest bite.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: true,
    isPopular: false,
  ),
  Product(
    id: 'local_4',
    name: 'Chocolate Donut',
    image: Assets.images.donutCategory2.path,
    category: 'Donut',
    price: 13.0,
    discountPercentage: 50,
    rating: 8.9,
    description:
        'Classic donuts dipped in smooth chocolate glaze and topped with '
        'chocolate shavings — rich, indulgent, and always a favorite.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: true,
    isPopular: true,
  ),
  Product(
    id: 'local_5',
    name: 'Donuts',
    image: Assets.images.donutCategory3.path,
    category: 'Donut',
    price: 11.0,
    discountPercentage: 50,
    rating: 8.5,
    description:
        'A mixed box of our best-selling donuts, freshly fried and glazed '
        'daily. Perfect for sharing or treating yourself.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: true,
    isPopular: false,
  ),
  Product(
    id: 'local_6',
    name: 'Strawberry Cake',
    image: Assets.images.cupcakeCategory1.path,
    category: 'Cupcake',
    price: 18.0,
    rating: 9.0,
    description:
        'Fluffy vanilla cupcakes topped with fresh strawberry buttercream '
        'and a slice of real strawberry — light, fruity, and refreshing.',
    seller: _defaultSeller,
    isFeatured: true,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_7',
    name: 'Blackberry Cake',
    image: Assets.images.cupcakeCategory2.path,
    category: 'Cupcake',
    price: 19.0,
    rating: 8.8,
    description:
        'Moist cupcakes swirled with blackberry compote and finished with '
        'a tangy-sweet blackberry frosting.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_8',
    name: 'Chocolate Cake',
    image: Assets.images.cupcakeCategory3.path,
    category: 'Cupcake',
    price: 17.5,
    discountPercentage: 50,
    rating: 9.0,
    description:
        'Mini chocolate cupcakes packed with cocoa flavor and topped with '
        'silky chocolate ganache.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: false,
    isPopular: true,
  ),
  Product(
    id: 'local_9',
    name: 'Birthday Cake',
    image: Assets.images.birthdayCakeCategory1.path,
    //detailImage: Assets.images.bigCake.path,
    category: 'Birthday cake',
    price: 55.0,
    rating: 9.3,
    description:
        'A festive layered birthday cake with buttercream frosting and '
        'colorful decorations — customizable for any celebration.',
    seller: _defaultSeller,
    isFeatured: true,
    isNew: false,
    isPopular: true,
  ),
  Product(
    id: 'local_10',
    name: 'Birthday Cake',
    image: Assets.images.birthdayCakeCategory2.path,
    //detailImage: Assets.images.bigCake.path,
    category: 'Birthday cake',
    price: 58.0,
    rating: 9.1,
    description:
        'A rich vanilla sponge birthday cake with smooth fondant finish, '
        'perfect for making any birthday memorable.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_11',
    name: 'Birthday Cake',
    image: Assets.images.birthdayCakeCategory3.path,
    //detailImage: Assets.images.bigCake.path,
    category: 'Birthday cake',
    price: 52.0,
    rating: 8.9,
    description:
        'A classic two-tier birthday cake with fresh cream frosting and '
        'seasonal fruit toppings.',
    seller: _defaultSeller,
    isFeatured: false,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_12',
    name: 'Butter Cookies',
    image:
        Assets.images.chocolateChipCookie.path, // TODO: real cookie image asset
    category: 'Cookies',
    price: 15.0,
    discountPercentage: 50,
    rating: 8.6,
    description:
        'Crisp, buttery cookies baked to golden perfection — a timeless '
        'classic treat for any time of day.',
    seller: _defaultSeller,
    availableWeights: const [],
    isFeatured: false,
    isNew: true,
    isPopular: false,
  ),
  Product(
    id: 'local_13',
    name: 'Chocolate Chip Cookies',
    image:
        Assets.images.chocolateChipCookie.path, // TODO: real cookie image asset
    category: 'Cookies',
    price: 16.0,
    discountPercentage: 50,
    rating: 8.8,
    description:
        'Soft-baked cookies loaded with rich chocolate chips in every bite.',
    seller: _defaultSeller,
    availableWeights: const [],
    isFeatured: false,
    isNew: false,
    isPopular: false,
  ),
  Product(
    id: 'local_14',
    name: 'Chocolate Roulette Cake',
    image: Assets.images.roulette.path, // TODO: real roulette image asset
    category: 'Roulette',
    price: 40.0,
    discountPercentage: 50,
    rating: 8.9,
    description:
        'A rolled sponge cake swirled with silky chocolate cream — light, '
        'elegant, and beautifully spiraled in every slice.',
    seller: _defaultSeller,
    availableWeights: const [],
    isFeatured: true,
    isNew: false,
    isPopular: false,
  ),
];
