import 'package:foodly_ui/models/order_items_model.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  OrderItemsModel? item;

  RxList<TimelineItem> timelineItems = RxList<TimelineItem>([
    TimelineItem(
      title: 'Order Placed',
      description: 'Your order has been received',
      isCompleted: true,
    ),
    TimelineItem(
      title: 'Order Confirmed',
      description: 'Restaurant has confirmed your order',
      isCompleted: true,
    ),
    TimelineItem(
      title: 'Preparing Food',
      description: 'Your food is being prepared',
      isCompleted: false,
    ),
    TimelineItem(
      title: 'Out for Delivery',
      description: 'Your order is on the way',
      isCompleted: false,
    ),
    TimelineItem(
      title: 'Delivered',
      description: 'Order has been delivered',
      isCompleted: false,
    ),
  ]);

  upadteTimeLine(int index) {}

  @override
  void onInit() {
    item = Get.arguments;

    if (item!.status == 'pending') {
      timelineItems[2].isCompleted = false;
    } else if (item!.status == 'cooking') {
      timelineItems[2].isCompleted = true;
    } else if (item!.status == 'delivering') {
      timelineItems[2].isCompleted = true;

      timelineItems[3].isCompleted = true;
    } else if (item!.status == 'delivered') {
      timelineItems[2].isCompleted = true;

      timelineItems[3].isCompleted = true;

      timelineItems[4].isCompleted = true;
    } else {
      timelineItems[2].isCompleted = true;
    }

    super.onInit();
  }
}

class TimelineItem {
  final String title;
  final String description;
  bool isCompleted;

  TimelineItem({
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}
