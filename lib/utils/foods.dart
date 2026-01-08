// ไฟล์: lib/utils/foods.dart
class Food {
  final String engName;   // ชื่อภาษาอังกฤษ
  final String thaName;   // ชื่อภาษาไทย
  final String foodValue; // ค่าที่จะส่งไปตอนเลือก (เช่น 'pizza')
  final double price;     // ราคา

  // สร้าง Constructor
  Food({
    required this.engName,
    required this.thaName,
    required this.foodValue,
    required this.price,
  });
}