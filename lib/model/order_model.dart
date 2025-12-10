class OrderSummary {
  final bool? success;
  final int? status;
  final String? message;
  final SummaryData? data;

  OrderSummary({this.success, this.status, this.message, this.data});

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      success: json["success"],
      status: json["status"],
      message: json["message"],
      data: json["data"] != null ? SummaryData.fromJson(json["data"]) : null,
    );
  }
}

class SummaryData {
  final List<Order>? orders;
  final int? total;
  final int? page;
  final int? pages;

  SummaryData({this.orders, this.total, this.page, this.pages});

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      orders: json["orders"] != null
          ? (json["orders"] as List).map((e) => Order.fromJson(e)).toList()
          : [],
      total: json["total"],
      page: json["page"],
      pages: json["pages"],
    );
  }
}

class Order {
  final String? id;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? pickupDate;
  final String? pickupTime;
  final String? dropoffDate;
  final String? dropoffTime;

  final String? fullName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;

  final List<Bag>? bags;

  final int? totalWeight;
  final int? totalPrice;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.pickupDate,
    this.pickupTime,
    this.dropoffDate,
    this.dropoffTime,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.bags,
    this.totalWeight,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["_id"],
      status: json["status"],
      paymentStatus: json["paymentStatus"],
      paymentMethod: json["paymentMethod"],

      pickupDate: json["pickupDate"],
      pickupTime: json["pickupTime"],
      dropoffDate: json["dropoffDate"],
      dropoffTime: json["dropoffTime"],

      fullName: json["fullName"],
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      zipCode: json["zipCode"],

      bags: json["bags"] != null
          ? (json["bags"] as List).map((b) => Bag.fromJson(b)).toList()
          : [],

      totalWeight: json["totalWeight"],
      totalPrice: json["totalPrice"],

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

class Bag {
  final String? bagId;
  final String? bagsName;
  final int? quantity;
  final int? pricePerBag;
  final int? totalPrice;
  final int? kgPerBag;
  final int? totalKg;
  final int? serviceFee;

  Bag({
    this.bagId,
    this.bagsName,
    this.quantity,
    this.pricePerBag,
    this.totalPrice,
    this.kgPerBag,
    this.totalKg,
    this.serviceFee,
  });

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      bagId: json["bagId"],
      bagsName: json["bagsName"],
      quantity: json["quantity"],
      pricePerBag: json["pricePerBag"],
      totalPrice: json["totalPrice"],
      kgPerBag: json["kgPerBag"],
      totalKg: json["totalKg"],
      serviceFee: json["serviceFee"],
    );
  }
}
