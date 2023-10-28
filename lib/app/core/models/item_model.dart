class ItemModel {
  ItemModel({
    this.image = '',
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.amount = 0,
  });

  final String image;
  final String name;
  final String description;
  final double price;
  final int amount;

  Map<String, dynamic> toJson(ItemModel itemModel) => {
        'image': itemModel.image,
        'name': itemModel.name,
        'description': itemModel.description,
        'price': itemModel.price,
        'amount': itemModel.amount,
      };
}
