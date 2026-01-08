import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FoodSelectionPage(),
    );
  }
}

class FoodSelectionPage extends StatefulWidget {
  const FoodSelectionPage({super.key});

  @override
  State<FoodSelectionPage> createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends State<FoodSelectionPage> {
  // 1. ข้อมูลเมนูอาหาร (Data Model)
  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Pizza', 'th': 'พิซซ่า', 'price': 45},
    {'name': 'Shabu', 'th': 'ชาบู', 'price': 199},
    {'name': 'Steak', 'th': 'สเต็ก', 'price': 149},
    {'name': 'Salad', 'th': 'สลัด', 'price': 40},
    {'name': 'Sanwich', 'th': 'แซนวิช', 'price': 20}, // สะกดตามภาพต้นฉบับ
  ];

  // 2. ตัวแปรสำหรับเก็บค่า State
  String? _selectedRadio; // เก็บค่า Radio ที่เลือก
  // สร้าง List เก็บสถานะ True/False ของ Checkbox แต่ละตัว
  late List<bool> _checkboxStates;

  @override
  void initState() {
    super.initState();
    // เริ่มต้นให้ Checkbox ทุกตัวเป็น false (ยังไม่เลือก)
    _checkboxStates = List<bool>.filled(menuItems.length, false);
  }

  // ฟังก์ชันช่วยดึงชื่อเมนูที่ติ๊ก Checkbox
  String get _selectedCheckboxNames {
    List<String> selected = [];
    for (int i = 0; i < menuItems.length; i++) {
      if (_checkboxStates[i]) {
        selected.add(menuItems[i]['name']);
      }
    }
    // ถ้าไม่มีการเลือก ให้คืนค่าว่าง หรือข้อความอื่นตามต้องการ
    return selected.isEmpty ? '' : selected.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Selection'),
        backgroundColor: Colors.blue[300], // ปรับสีให้คล้ายภาพ
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- ส่วนที่ 1: Radio List ---
            ...List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              return ListTile(
                leading: Radio<String>(
                  value: item['name'],
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      _selectedRadio = value;
                    });
                  },
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  item['th'],
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  '${item['price']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // ทำให้กดที่แถวแล้วเลือก Radio ได้ด้วย
                  setState(() {
                    _selectedRadio = item['name'];
                  });
                },
              );
            }),

            const Divider(thickness: 1), // เส้นคั่น

            // --- ส่วนที่ 2: Checkbox List ---
            ...List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing, // เอา Checkbox ไว้ขวา
                title: Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16),
                ),
                value: _checkboxStates[index],
                onChanged: (bool? value) {
                  setState(() {
                    _checkboxStates[index] = value!;
                  });
                },
              );
            }),

            const Divider(thickness: 1),

            // --- ส่วนที่ 3: สรุปผล (Footer) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Radio เลือก: ${_selectedRadio ?? ""}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Checkbox เลือก: $_selectedCheckboxNames',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}