
enum OrderType { normal, vip }

enum OrderStatus { pending, processing, complete,  }

class Order {
  int id;
  OrderType orderType;
  OrderStatus orderStatus;

  // ignore: sort_constructors_first
  Order(
    this.id, 
    this.orderType,
    {
    this.orderStatus = OrderStatus.pending,
  });
}
