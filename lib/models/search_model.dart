class SearchModel{

  bool? status;
  SearchDataModel? data;
  SearchModel.fromJson(Map<String,dynamic>json){
    status =json['status'];
    data = json['data']  !=null ? SearchDataModel.fromJson(json['data']): null;
  }
}

class SearchDataModel{
  int? currentPage;
  List<SearchProductModel> products =[];
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  int? perPage;
  int? to;
  dynamic total;

  SearchDataModel.fromJson(Map<String,dynamic>json){
    currentPage =json['current_page'];
    if(json['data'] !=null) {
      products = <SearchProductModel>[];
      json['data'].forEach((element) {
        products.add(SearchProductModel.fromJson(element));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class SearchProductModel{
  int? id;
  dynamic price;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;
  SearchProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}