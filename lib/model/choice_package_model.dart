class ChoicePackageModel {
  bool? success;
  int? status;
  String? message;
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  List<Data>? data;

  ChoicePackageModel({
    this.success,
    this.status,
    this.message,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.data,
  });

  factory ChoicePackageModel.fromJson(Map<String, dynamic> json) {
    return ChoicePackageModel(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((x) => Data.fromJson(x)))
          : [],
    );
  }
}

class Data {
  String? id;
  String? packageName;
  String? description;
  String? packageImage;
  BagCategory? bagCategory;
  String? estimatedDeliveryTime;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.packageName,
    this.description,
    this.packageImage,
    this.bagCategory,
    this.estimatedDeliveryTime,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      packageName: json['packageName'],
      description: json['description'],
      packageImage: json['packageImage'],
      bagCategory: json['bagCategory'] != null
          ? BagCategory.fromJson(json['bagCategory'])
          : null,
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class BagCategory {
  List<Small>? small;
  List<Medium>? medium;
  List<Large>? large;

  BagCategory({
    this.small,
    this.medium,
    this.large,
  });

  factory BagCategory.fromJson(Map<String, dynamic> json) {
    return BagCategory(
      small: json['small'] != null
          ? List<Small>.from(json['small'].map((x) => Small.fromJson(x)))
          : [],
      medium: json['medium'] != null
          ? List<Medium>.from(json['medium'].map((x) => Medium.fromJson(x)))
          : [],
      large: json['large'] != null
          ? List<Large>.from(json['large'].map((x) => Large.fromJson(x)))
          : [],
    );
  }
}

class Small {
  String? id;
  double? price;
  String? description;
  int? kg;
  String? deliveryTime;
  double? serviceFee;

  Small({
    this.id,
    this.price,
    this.description,
    this.kg,
    this.deliveryTime,
    this.serviceFee,
  });

  factory Small.fromJson(Map<String, dynamic> json) {
    return Small(
      id: json['_id'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      kg: json['kg'],
      deliveryTime: json['deliveryTime'],
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
    );
  }
}

class Medium {
  String? id;
  double? price;
  String? description;
  int? kg;
  String? deliveryTime;
  double? serviceFee;

  Medium({
    this.id,
    this.price,
    this.description,
    this.kg,
    this.deliveryTime,
    this.serviceFee,
  });

  factory Medium.fromJson(Map<String, dynamic> json) {
    return Medium(
      id: json['_id'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      kg: json['kg'],
      deliveryTime: json['deliveryTime'],
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
    );
  }
}

class Large {
  String? id;
  double? price;
  String? description;
  int? kg;
  String? deliveryTime;
  double? serviceFee;

  Large({
    this.id,
    this.price,
    this.description,
    this.kg,
    this.deliveryTime,
    this.serviceFee,
  });

  factory Large.fromJson(Map<String, dynamic> json) {
    return Large(
      id: json['_id'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      kg: json['kg'],
      deliveryTime: json['deliveryTime'],
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
    );
  }
}
