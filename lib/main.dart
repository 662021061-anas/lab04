import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Selection',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        // ไม่กำหนด scaffoldBackgroundColor ปล่อยให้เป็นสีขาวตาม Default
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
  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Pizza', 'th': 'พิซซ่า', 'price': 45},
    {'name': 'Shabu', 'th': 'ชาบู', 'price': 199},
    {'name': 'Steak', 'th': 'สเต็ก', 'price': 149},
    {'name': 'Salad', 'th': 'สลัด', 'price': 40},
    {'name': 'Sanwich', 'th': 'แซนวิช', 'price': 20},
  ];

  final List<String> orderTypes = ['ทานที่ร้าน', 'รับกลับบ้าน'];
  String _orderType = 'ทานที่ร้าน'; 
  String? _selectedRadio; 
  late List<bool> _checkboxStates;

  @override
  void initState() {
    super.initState();
    _checkboxStates = List<bool>.filled(menuItems.length, false);
  }

  int get _calculateTotalPrice {
    int total = 0;
    if (_selectedRadio != null) {
      var radioItem = menuItems.firstWhere((item) => item['name'] == _selectedRadio);
      total += radioItem['price'] as int;
    }
    for (int i = 0; i < menuItems.length; i++) {
      if (_checkboxStates[i]) {
        total += menuItems[i]['price'] as int;
      }
    }
    return total;
  }

  String get _selectedCheckboxNames {
    List<String> selected = [];
    for (int i = 0; i < menuItems.length; i++) {
      if (_checkboxStates[i]) {
        selected.add(menuItems[i]['name']);
      }
    }
    return selected.isEmpty ? '-' : selected.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Order Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // ================= ส่วนที่ 1: Radio List =================
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
                child: Text('เมนูหลัก (เลือก 1 อย่าง)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...List.generate(menuItems.length, (index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Radio<String>(
                    value: item['name'],
                    groupValue: _selectedRadio,
                    activeColor: Colors.orange,
                    onChanged: (value) => setState(() => _selectedRadio = value),
                  ),
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['th']),
                  trailing: Text('${item['price']} ฿', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                  onTap: () => setState(() => _selectedRadio = item['name']),
                );
              }),

              const Divider(thickness: 1, height: 30),

              // ================= ส่วนที่ 2: Checkbox List =================
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 5),
                child: Text('เมนูเสริม (เลือกได้หลายอย่าง)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...List.generate(menuItems.length, (index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: _checkboxStates[index],
                    activeColor: Colors.green,
                    onChanged: (bool? value) => setState(() => _checkboxStates[index] = value!),
                  ),
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['th']),
                  trailing: Text('${item['price']} ฿', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                  onTap: () => setState(() => _checkboxStates[index] = !_checkboxStates[index]),
                );
              }),

              const Divider(thickness: 1, height: 30),

              // ================= ส่วนที่ 3: Dropdown เลือกประเภท =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ประเภทการสั่งซื้อ:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _orderType,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            _orderType = newValue!;
                          });
                        },
                        items: orderTypes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(value == 'ทานที่ร้าน' ? Icons.store : Icons.shopping_bag, size: 20, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 1, height: 30),

              // ================= ส่วนที่ 4: สรุปราคารวม (Footer แบบคลีน) =================
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSummaryRow('สถานะ:', _orderType),
                    const SizedBox(height: 5),
                    _buildSummaryRow('เมนูหลัก:', _selectedRadio ?? '-'),
                    const SizedBox(height: 5),
                    _buildSummaryRow('เมนูเสริม:', _selectedCheckboxNames),
                    
                    const SizedBox(height: 15),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ราคารวมสุทธิ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          '${_calculateTotalPrice} ฿', 
                          style: const TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 16)),
        Expanded(
          child: Text(
            value, 
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}