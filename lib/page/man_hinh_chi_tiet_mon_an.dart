import 'package:flutter/material.dart';
import '../models/mon_an.dart';

class ChiTietMonAn extends StatelessWidget {
  final MonAn? monAn;

  const ChiTietMonAn({Key? key, this.monAn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayData = monAn ?? MonAn(
      id: 1,
      tenMonAn: 'BÒ KHO TIÊU XANH',
      moTa: 'Món bò kho thơm lừng với nước cốt dừa béo ngậy hòa cùng vị cay nồng của tiêu xanh.',
      chiTiet: "Bước 1: Sơ chế nguyên liệu\nThịt bò rửa sạch, cắt khúc vuông vừa ăn (khoảng 3cm). Trụng sơ qua nước sôi để khử mùi hôi.\n\nBước 2: Ướp thịt\nƯớp thịt bò với gói gia vị kho, hành tím băm, tỏi băm, 1 thìa đường, 1 thìa nước mắm trong 30 phút cho ngấm.\n\nBước 3: Nấu bò kho\nPhi thơm hành tỏi, cho thịt bò vào xào săn lại. Đổ nước dừa tươi vào ngập thịt, thêm tiêu xanh. Hầm lửa nhỏ khoảng 45-60 phút đến khi thịt mềm nhừ.\n\nBước 4: Hoàn thiện\nNêm nếm lại gia vị cho vừa ăn. Múc ra bát, trang trí thêm ngò gai và ăn nóng.",
      thoiGian: 45,
      calo: 450,
      hinhAnh: 'https://cdn.tgdd.vn/Files/2019/01/21/1144883/bi-quyet-nau-bo-kho-tieu-xanh-mem-ngon-dam-da-chuan-vi-nha-hang-202201201452292671.jpg',
      loai: 'Món mặn',
      //List<String>
      dsNguyenLieu: [
        "Thịt bò",
        "Tiêu xanh",
        "Nước dừa tươi",
        "Hành tím & Tỏi",
        "Cà rốt",
        "Gia vị bò kho",
        "Ngò gai"
      ], 
    );

    final primaryGreen = const Color(0xFF7CB342);
    final bgGreen = const Color(0xFFF1F8E9);
    final textGrey = Colors.grey[700];

    return Scaffold(
      backgroundColor: bgGreen,
      body: Stack(
        children: [
          // LỚP CUỘN NỘI DUNG
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // A. HÌNH ẢNH HEADER
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.network(
                    displayData.hinhAnh.isNotEmpty
                        ? displayData.hinhAnh
                        : 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[300], child: const Icon(Icons.image));
                    },
                  ),
                ),

                // B. BODY (Đè lên ảnh)
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgGreen,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Padding bottom lớn cho nút
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. THANH KÉO (Trang trí)
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // 2. TIÊU ĐỀ & THÔNG TIN CƠ BẢN
                        Center(
                          child: Column(
                            children: [
                              Text(
                                displayData.tenMonAn.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Thông tin Calo & Thời gian (Icon nhỏ)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time_filled, size: 16, color: textGrey),
                                  const SizedBox(width: 4),
                                  Text("${displayData.thoiGian} phút", style: TextStyle(color: textGrey)),
                                  const SizedBox(width: 15),
                                  const Text("|", style: TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 15),
                                  Icon(Icons.local_fire_department, size: 16, color: textGrey),
                                  const SizedBox(width: 4),
                                  Text("${displayData.calo} Kcal", style: TextStyle(color: textGrey)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // 3. MÔ TẢ NGẮN
                        Container(
                          width: double.infinity,
                          child: Text(
                            displayData.moTa,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // 4. NGUYÊN LIỆU (CHIPS WRAP - Cập nhật cho List<String>)
                        Row(
                          children: [
                            Icon(Icons.shopping_basket, color: primaryGreen),
                            const SizedBox(width: 10),
                            const Text(
                              "Nguyên liệu",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // Dùng Wrap để hiển thị List<String>
                        Wrap(
                          spacing: 8.0, // Khoảng cách ngang giữa các chip
                          runSpacing: 8.0, // Khoảng cách dọc
                          children: displayData.dsNguyenLieu.map((nguyenLieu) {
                            return Chip(
                              label: Text(nguyenLieu), // Hiển thị trực tiếp String
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.w500),
                              side: BorderSide(color: primaryGreen.withOpacity(0.5)),
                              shape: const StadiumBorder(),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 25),

                        // 5. CÁCH LÀM (BOX LỚN)
                        Row(
                          children: [
                            Icon(Icons.menu_book, color: primaryGreen),
                            const SizedBox(width: 10),
                            const Text(
                              "Hướng dẫn thực hiện",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Text(
                            displayData.chiTiet, // Nội dung hướng dẫn
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              height: 1.6, // Giãn dòng rộng cho dễ đọc
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- NÚT BACK (Giữ nguyên) ---
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Icon(Icons.arrow_back, color: primaryGreen),
              ),
            ),
          ),

          //NÚT YÊU THÍCH
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  print("Đã thích món: ${displayData.tenMonAn}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 10),
                    Text(
                      "Thêm vào yêu thích",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}