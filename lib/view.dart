import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store/api.dart';
import 'package:store/main.dart';
import 'package:store/mstodaat.dart';
import 'package:store/orderes.dart';

class MedicineListPage extends StatefulWidget {
  static List<Category> categories = [];
  static Map<int, int> medicineAdded = {};
  final int id;
  static int favPreview = 0;

  MedicineListPage({Key? key, required this.id}) : super(key: key);

  @override
  _MedicineListPage createState() => _MedicineListPage();
}

class _MedicineListPage extends State<MedicineListPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MedicineListPage.medicineAdded.clear();
    MedicineListPage.categories.clear();
    fetchData();
  }

  previewData(res) {
    MedicineListPage.categories = [];
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        print(response);
        for (int i = 0; i < response['data'].length; i++) {
          List<Medicine> medicines = [];
          for (int j = 0; j < response['data'][i]['medicins'].length; j++) {
            var cur = response['data'][i]['medicins'][j];
            if (MedicineListPage.favPreview == 0 ||
                (MedicineListPage.favPreview == cur['isFavourit']))
              medicines.add(Medicine(
                  id: cur['id'],
                  category: response['data'][i]['category'],
                  scientificName: cur['sc_name'],
                  commercialName: cur['trad_name'],
                  manufacturer: cur['manufacturer'],
                  quantity: cur['quantity'],
                  expirationDate: cur['finish_date'],
                  price: cur['price'],
                  favourit: cur['isFavourit']));
          }
          if (medicines.length > 0)
            MedicineListPage.categories.add(Category(
                name: response['data'][i]['category'], medicines: medicines));
        }
        setState(() {});
      }
    }
  }

  fetchData() async {
    var res = await Network().postData({"store_id": widget.id}, '/medicins/');
    previewData(res);
  }

  @override
  void dispose() {
    super.dispose();
  }

  search() async {
    var res = await Network().postData(
        {"store_id": widget.id, 'trad_name': searchController.text},
        '/searchMedNamePhar/');
    previewData(res);
  }

  sendOrder() async {
    var order = [];
    for (var x in MedicineListPage.medicineAdded.keys) {
      order.add({
        'medicin_id': x,
        'quantity': MedicineListPage.medicineAdded[x],
      });
    }

    var res = await Network()
        .postData({"medicins": order, 'store_id': widget.id}, '/order/add/');
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة الطلبية بنجاح',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20.0)),
            backgroundColor: Colors.green,
          ),
        );
        MedicineListPage.medicineAdded.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderListPage(id: widget.id)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'],
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20.0)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(
          MedicineListPage.favPreview == 1
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          MedicineListPage.favPreview = 1 - MedicineListPage.favPreview;
          setState(() {
            fetchData();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'الأدوية',
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
                trailing: Icon(
                  Icons.home,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PharmacyWarehousePage()),
                  );
                },
              ),
              ListTile(
                textColor: Color.fromARGB(255, 6, 102, 9),
                title: Text(
                  "الأدوية",
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.account_balance_rounded,
                  color: const Color.fromARGB(255, 6, 102, 9),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicineListPage(id: widget.id)),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "الطلبيات",
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(Icons.check_box),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40.0, // ارتفاع حقل البحث
              width: 300.0, // عرض حقل البحث
              margin: EdgeInsets.only(top: 8.0, right: 0.0),
              decoration: BoxDecoration(
                color: Colors.white, // تعيين لون الحقل كاملاً
                borderRadius:
                    BorderRadius.circular(10.0), // يمكنك تعديل هذا حسب الحاجة
              ),
              child: TextField(
                controller: searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: ' ابحث عن الدواء أو التصنيف... ',
                  hintTextDirection: TextDirection.rtl,
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, color: Color(0xFFFF9900)),
                        onPressed: () {
                          // قم بتحديث الحالة أو تنفيذ البحث هنا
                          print("تم الضغط على زر البحث");
                          search();
                        },
                      ),
                      SizedBox(width: 8.0), // تضع مسافة بين الأيقونة وحقل النص
                    ],
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Color(0xFFFF9900)),
                    onPressed: () {
                      // مسح حقل البحث
                      searchController.clear();
                    },
                  ),
                ),
                onChanged: (value) {
                  // يمكنك استخدام قيمة value لتحديث نتائج البحث
                },
              ),
            ),
          ),

          // update the expand to make each one of them contains multiple cards of medicine with a title of one category
          Expanded(
            child: ListView(
              children: MedicineListPage.categories.map((category) {
                return MedicineCard(category: category);
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (MedicineListPage.medicineAdded.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('يرجى إضافة طلبية ',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 20.0)),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                sendOrder();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFB800),
              shadowColor: Colors.yellow,
              minimumSize: Size(30, 40),
            ),
            child: Text('إرسال الطلبية',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class Category {
  String name;
  List<Medicine> medicines;

  Category({required this.name, required this.medicines});
}

class Medicine {
  int id;
  String category;
  String scientificName;
  String commercialName;
  String manufacturer;
  int quantity;
  String expirationDate;
  int price;
  int favourit;

  Medicine({
    required this.id,
    required this.category,
    required this.scientificName,
    required this.commercialName,
    required this.manufacturer,
    required this.quantity,
    required this.expirationDate,
    required this.price,
    required this.favourit,
  });
}

class MedicineCard extends StatefulWidget {
  final Category category;

  MedicineCard({
    required this.category,
  });

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  late BuildContext originalContext; // السياق الأصلي
  Map<String, bool> medicineAdded = {};

  changeFavourites(var id) async {
    var res = await Network().postData({"id": id}, '/favourit/');
    print(res.body);
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response['error'] == false) {
        if (response['data']['fav'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة الدواء إلى المفضلة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20.0)),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إزالة الدواء من المفضلة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20.0)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'],
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20.0)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              widget.category.name,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.black),
            ),
            children: [
              Card(
                color: Color(0xFF151515),
                elevation: 5,
                shadowColor: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 310,
                    child: ListView.builder(
                      itemCount: widget.category.medicines.length,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final medicine = widget.category.medicines[index];
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(
                                  color: Color(0xFFFFEB3B), width: 2.0),
                            ),
                            color:
                                medicineAdded[medicine.scientificName] == true
                                    ? Colors.yellow
                                    : Colors.white,
                            shadowColor: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          medicine.favourit == 1
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            widget.category.medicines[index]
                                                    .favourit =
                                                1 -
                                                    widget
                                                        .category
                                                        .medicines[index]
                                                        .favourit;
                                            changeFavourites(widget
                                                .category.medicines[index].id);
                                          });
                                        },
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                          'الاسم العلمي: ${medicine.scientificName}',
                                          textDirection: TextDirection.rtl),
                                    ],
                                  ),
                                  Text(
                                      'الاسم التجاري: ${medicine.commercialName}',
                                      textDirection: TextDirection.rtl),
                                  Divider(),
                                  Text(
                                      'الشركة المصنعة: ${medicine.manufacturer}',
                                      textDirection: TextDirection.rtl),
                                  Divider(),
                                  Text(
                                      'تاريخ انتهاء الصلاحية: ${medicine.expirationDate}',
                                      textDirection: TextDirection.rtl),
                                  Divider(),
                                  Text('السعر: ${medicine.price} ل.س',
                                      textDirection: TextDirection.rtl),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            medicineAdded[medicine
                                                .scientificName] = false;
                                          });
                                        },
                                        child: Text(
                                          'إلغاء',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: originalContext,
                                            builder: (context) {
                                              int quantity = 0;

                                              return AlertDialog(
                                                title: Text('إضافة الكمية'),
                                                content: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    quantity =
                                                        int.tryParse(value) ??
                                                            0;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: 'الكمية',
                                                  ),
                                                ),
                                                actions: [
                                                  if (quantity < 1)
                                                    Text(
                                                      'يرجى إدخال كمية صحيحة أكبر من 1',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (quantity >= 1) {
                                                        MedicineListPage
                                                                .medicineAdded[
                                                            medicine
                                                                .id] = quantity;
                                                        setState(() {
                                                          medicineAdded[medicine
                                                                  .scientificName] =
                                                              true;
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      'تأكيد',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'إضافة',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    originalContext = context; // حفظ السياق الأصلي عند تهيئة الحالة
  }
}
