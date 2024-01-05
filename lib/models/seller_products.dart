class SellerProducts {
  String productId;
  String sellerId;
  String productCategory;
  String productDescription;
  String productImage;
  String productName;
  int productPrice;
  int productStock;

  SellerProducts({
    this.productId = "",
    this.sellerId = "",
    this.productCategory = "",
    this.productDescription = "",
    this.productImage = "",
    this.productName = "",
    this.productPrice = 0,
    this.productStock = 0,
  });
}

List<SellerProducts> sellerProducts = [];
