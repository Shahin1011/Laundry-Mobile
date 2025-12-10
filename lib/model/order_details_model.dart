class OrderDetailsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  OrderDetailsModel({this.success, this.status, this.message, this.data});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? status;
  String? paymentStatus;
  String? paymentMethod;
  String? transactionId;
  String? pickupDate;
  String? pickupTime;
  String? dropoffDate;
  String? dropoffTime;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  List<Bags>? bags;
  int? totalWeight;
  int? totalPrice;
  String? createdAt;
  String? updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    paymentMethod = json['paymentMethod'];
    transactionId = json['transactionId'];
    pickupDate = json['pickupDate'];
    pickupTime = json['pickupTime'];
    dropoffDate = json['dropoffDate'];
    dropoffTime = json['dropoffTime'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];

    if (json['bags'] != null) {
      bags = (json['bags'] as List).map((v) => Bags.fromJson(v)).toList();
    }

    totalWeight = json['totalWeight'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Bags {
  String? bagId;
  String? bagsName;
  int? quantity;
  int? pricePerBag;
  int? totalPrice;
  int? kgPerBag;
  int? totalKg;
  int? serviceFee;

  Bags.fromJson(Map<String, dynamic> json) {
    bagId = json['bagId'];
    bagsName = json['bagsName'];
    quantity = json['quantity'];
    pricePerBag = json['pricePerBag'];
    totalPrice = json['totalPrice'];
    kgPerBag = json['kgPerBag'];
    totalKg = json['totalKg'];
    serviceFee = json['serviceFee'];
  }
}
