import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store/api.dart';
import 'package:store/main.dart';
import 'package:store/orderes.dart';
import 'package:store/view.dart';

class PharmacyWarehousePage extends StatefulWidget {
  static List<PharmacyWarehouse> pharmacyWarehouses = [];
  static List<PharmacistAccount> notification = [
    PharmacistAccount(content: 'john.doe@example.com'),
    // Add more accounts as needed
  ];

  @override
  _PharmacyWarehousePage createState() => _PharmacyWarehousePage();
}

class _PharmacyWarehousePage extends State<PharmacyWarehousePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchNotification();
  }

  fetchNotification() async {
    PharmacyWarehousePage.notification = [];
    var res = await Network().getData('/getNotification/');
    print(res.body);
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        for (int i = 0; i < response['data'].length; i++) {
          var cur = response['data'][i];
          PharmacyWarehousePage.notification
              .add(PharmacistAccount(content: cur['content']));
        }
        setState(() {});
      }
    }
  }

  fetchData() async {
    PharmacyWarehousePage.pharmacyWarehouses = [];
    var res = await Network().getData('/storeNames/');
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        for (int i = 0; i < response['data'].length; i++) {
          var cur = response['data'][i];
          PharmacyWarehousePage.pharmacyWarehouses.add(PharmacyWarehouse(
              name: cur['name'], id: cur['id'], email: cur['email']));
        }
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'مستودعات الأدوية',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 16),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () async {
                    await showPharmacistAccountsDialog(context);
                  },
                  alignment: Alignment.centerLeft,
                ),
                if (PharmacyWarehousePage.notification.length > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        PharmacyWarehousePage.notification.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
                textColor: Colors.red,
                title: Text(
                  "تسجيل الخروج",
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: PharmacyWarehousePage.pharmacyWarehouses.length,
        itemBuilder: (context, index) {
          return PharmacyWarehouseCard(
              pharmacyWarehouse:
                  PharmacyWarehousePage.pharmacyWarehouses[index]);
        },
      ),
    );
  }
}

class PharmacyWarehouseCard extends StatelessWidget {
  final PharmacyWarehouse pharmacyWarehouse;

  const PharmacyWarehouseCard({Key? key, required this.pharmacyWarehouse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.red,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(pharmacyWarehouse.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${pharmacyWarehouse.email}'),
          ],
        ),
        onTap: () {
          // الانتقال إلى صفحة عرض الأدوية مع تمرير المستودع كوسيط
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicineListPage(id: pharmacyWarehouse.id),
            ),
          );
        },
      ),
    );
  }
}

Future<void> showPharmacistAccountsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.yellow,
        shadowColor: Colors.red,
        title: Text('الإشعارات'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: PharmacyWarehousePage.notification.map((account) {
            return ListTile(
              title: Text(
                account.content,
                textAlign: TextAlign.right,
              ), // HUMAM: make it in center
              // subtitle: Text(account.email),
              onTap: () {
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderListPage(id: widget.id)),
                  );*/
              },
            );
          }).toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shadowColor: Colors.red,
              minimumSize: Size(30, 40),
            ),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

class PharmacyWarehouse {
  final String name;
  final int id;
  final String email;

  PharmacyWarehouse(
      {required this.name, required this.id, required this.email});
}

class PharmacistAccount {
  final String content;
  PharmacistAccount({required this.content});
}
