class SellerProducts {
  String productId;
  String productCategory;
  String productDescription;
  String productImage;
  String productName;
  String productPrice;
  String productStock;

  SellerProducts({
    required this.productId,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productStock,
  });
}

List<SellerProducts> sellerProducts = [];
