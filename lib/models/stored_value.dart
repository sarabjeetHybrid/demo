/// Model class for cart items
class StoredValue {
  String key;
  String name;
  String image;
  int qty;
  double price;

  StoredValue({
    required this.key,
    required this.name,
    required this.image,
    required this.qty,
    required this.price,
  });

  @override
  String toString() {
    return 'StoredValue{key: $key, name: $name, image: $image, qty: $qty, price: $price}';
  }
}