import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/order/orders_controller.dart';
import '../../utils/app_colors.dart';
import '../myOrder/widgets/my_order_card.dart';

class MyOrderScreen extends StatelessWidget {
  final OrdersController c = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            color: AppColors.mainAppColor,
            alignment: Alignment.center,
            child: Text(
              "My Orders",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (c.errorMessage.isNotEmpty) {
                return Center(child: Text(c.errorMessage.value));
              }

              if (c.orders.isEmpty) {
                return Center(child: Text("No orders found"));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: c.orders.length,
                itemBuilder: (context, index) {
                  final order = c.orders[index];
                  return MyOrderCard(
                    updatedDate: DateFormat('yyyy-MM-dd')
                        .format(order.updatedAt ?? DateTime.now()),
                    price: order.totalPrice?.toString() ?? "0",
                    status: order.status ?? "",
                    orderId: order.id ?? "",
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
