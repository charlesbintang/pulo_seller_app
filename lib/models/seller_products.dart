class SellerProducts {
  String productId;
  String productCategory;
  String productDescription;
  String productImage;
  String productName;
  String productPrice;

  SellerProducts({
    required this.productId,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });
}

List<SellerProducts> sellerProducts = [];
