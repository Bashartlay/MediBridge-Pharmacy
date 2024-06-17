import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store/api.dart';
import 'package:store/main.dart';
import 'package:store/mstodaat.dart';
import 'package:store/view.dart';

class Order {
  final String orderDate;
  final List<Medicine> medicines;
  final String paymentStatus;
  final String status;

  Order(this.orderDate, this.medicines, this.status, this.paymentStatus);
}

class Medicine {
  final String name;
  final String scientificName;
  final String tradeName;
  final int quantity;

  Medicine(this.name, this.scientificName, this.tradeName, this.quantity);
}

class OrderListPage extends StatefulWidget {
  static List<Order> orders = [];

  final int id;

  OrderListPage({Key? key, required this.id}) : super(key: key);

  @override
  _OrderListPage createState() => _OrderListPage();
}

class _OrderListPage extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    OrderListPage.orders = [];
    var res = await Network().getData('/orders/' + widget.id.toString());
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        for (int i = 0; i < response['data'].length; i++) {
          List<Medicine> med = [];
          for (int j = 0; j < response['data'][i]['medicins'].length; j++) {
            var cur = response['data'][i]['medicins'][j];
            med.add(Medicine(
                'دواء 1', cur['sc_name'], cur['trad_name'], cur['quantity']));
          }
          String status = '';
          if (response['data'][i]['status'] == 0)
            status = "تم الإرسال للمستودع";
          else if (response['data'][i]['status'] == 1)
            status = "قيد التحضير";
          else
            status = "تم الاستلام من قبلك";

          String paymentStatus = "";
          if (response['data'][i]['status'] == 0)
            paymentStatus = "غير مدفوعة";
          else
            paymentStatus = "مدفوعة";

          OrderListPage.orders.add(Order(
              response['data'][i]['order_date'], med, status, paymentStatus));
        }
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'الطلبيات',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF9900),
      ),
      endDrawer: Drawer(
          child: Container(
        color: const Color.fromARGB(255, 247, 231, 92),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Row(
              children: [
                // Container(
                //   width: 60,
                //   height: 60,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(60),
                //     child: Image.network(
                //       "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHwAAAB8CAMAAACcwCSMAAAA/FBMVEX///9ChfQ0qFPqQzX7vATqQDL7wTpWj/VLr2T/+fDx+PP98vHy9f7rV037uQD7twArpk01f/TpNyb74+L+7MgqevM8gvTxjojpLBfpMh/oIgDqPC3//fj+7tH+9N/sXl350tDk8ucUoUHJ5M9elPXk7P3R3/xvnvbV6tmIxpbznpn1r6zvdGvsX1X3xsTwg3z2u7jrUET91X/7vST8zGP947H8x0/80G7925r96L3uamH70Y36wVX94qfrUDb92IvtuhPhR0vgW2Hicnnnn6Xu1tza586q0aN4unZksmROq1NYhN8xpmOeu/htvICOsfeux/tsoOq1271ctXJoFaoCAAADZUlEQVRoge3Y60LaMBgG4NATBwVsB7VY7aBAWVHmBojOnXQnp5uicv/3shRFgaYk7Ivpn7w38PB+SdNQhGRkZGRkZGRkZMRno7vd3a9vpIMfOJZVc5xe95V4e6Ooq1F0a6f3Ni0cx3WKgtvP4Ziv7aeHq6pzKHLrLeFq7VSgvoyrVi9FXLUOU8RV512KuO6KWnYCrlrbKeKqJeiwIeOCqhNx/b2YVSfiaq2eIi5o7mRcF3PMJeAq10Xf9fZw8oy4qnN72PKVvjHQSqWSNhgMjzwW3K3zob3+oFzSZimVtWFll4pbXPB8v/QsP6Y8qtBwLs2PtBg95Y9n5ZNwDms+LJPoaPqatwrnsNvzI2LtR76yCi++qD3TybgLvs0cr7Q1beAl4jXoZeYkab2fqhuJOPSM2aP0jvR+Au4eAIsbVBs/cR4Zd4D/2j7Qhj6tPiTi7qmA4lF1Eu7UYbbHUjxadQIO/tdwQt9u0xhxXHeB9i7b1PHc93pLuA6+N+fZpo7n/vG1vtS7DrRRhRXXPi3irgq20Wdm3FhY81qPw6u0z7jf8KJ/mavtdOH0f+G6tXPA59b4lXns5S86jlvbKXL7EJcfGtSMRsbZ2dmgeH5+/u37j5+btKzD0/Lr4vfl1dVV7k8mk822WllqOuvwq9IIc/7WloLzN5thTPWaD33jT+H1cHPMww6f6Qi3WXEOzRuTOVpRch1m/BZsN5UFW7m8Y8WrAdjeWrSV3K3J2hy62xtLNMbbVTbbbkGL+8u2kisw7jjwfgtjxTE+Zpt7tQ2zm/HiGGebO3jqk3hxjCOmhw2610nFI5ylOrj4DaF4hKNr+qpDV7xBoB9w1KINvgo93e5JU3/A25nVOvydQpz6A44Ce5Vuwl/lueSxY91M1s0W2C4Q7RmONu2kXVe9g9KkY30BR2hcJZU3bfibFKE3NBwFnRhvmmMuNzc6HvG46ewH2KaZHQMf73Vw/NDddrIZO0qmNQ543Vfpa/6UzXYQBG1ucBTKbn/hkN5pwnDCTUIc3vRTxAvE81UQTp67KLxBmrsonFhdGF5IEyddZsThhNuMQDx+zInEC8u6SBwVQj89HKGLhb/ognHUmMx9lBGN43fM7ENYGnj0IW7i+/gX+Dfi7SiF5n0YhikUl5GRkZGRkZGRQf8AacFh6JcqsAgAAAAASUVORK5CYII="),
                //     ),
                //   ),
                Expanded(
                  child: ListTile(
                    title: Text(MyApp.name),
                    subtitle: Text(MyApp.email),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                "مستودعات الأدوية",
                textAlign: TextAlign.right,
              ),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PharmacyWarehousePage()),
                );
              },
            ),
            ListTile(
              title: Text(
                "الأدوية",
                textAlign: TextAlign.right,
              ),
              trailing: Icon(Icons.account_balance_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicineListPage(id: widget.id)),
                );
              },
            ),
            ListTile(
              textColor: Color.fromARGB(255, 6, 102, 9),
              title: Text(
                "الطلبيات",
                textAlign: TextAlign.right,
              ),
              trailing:
                  Icon(Icons.check_box, color: Color.fromARGB(255, 6, 102, 9)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderListPage(id: widget.id)),
                );
              },
            ),
            ListTile(
              textColor: Colors.red,
              title: Text(
                "تسجيل الخروج",
                textAlign: TextAlign.right,
              ),
              trailing: Icon(Icons.exit_to_app, color: Colors.red),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < OrderListPage.orders.length; i++)
              OrderTile(order: OrderListPage.orders[i], orderNumber: i + 1),
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;
  final int orderNumber;

  OrderTile({required this.order, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Color(0xFFFFEB3B), width: 2.0),
      ),
      child: ExpansionTile(
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'طلبية $orderNumber',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                Text(
                  'تاريخ الطلب: ${order.orderDate.toString()}',
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'حالة الطلب: ${order.status.toString()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                Text(
                  'حالة الدفع: ${order.paymentStatus.toString()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < order.medicines.length; i++)
                    Row(
                      children: [
                        MedicineCard(
                            index: i + 1, medicine: order.medicines[i]),
                        SizedBox(width: 10.0),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final int index;
  final Medicine medicine;

  MedicineCard({required this.index, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.red,
      color: Color(0xFFFF9900),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$index _________',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              textDirection: TextDirection.rtl, // قم بتغيير هنا إلى ltr
            ),
            Text(
              'الاسم العلمي: ${medicine.scientificName}',
              textDirection: TextDirection.rtl, // قم بتغيير هنا إلى ltr
            ),
            Text(
              'الاسم التجاري: ${medicine.tradeName}',
              textDirection: TextDirection.rtl, // قم بتغيير هنا إلى ltr
            ),
            Text(
              'الكمية: ${medicine.quantity}',
              textDirection: TextDirection.rtl, // قم بتغيير هنا إلى ltr
            ),
          ],
        ),
      ),
    );
  }
}
