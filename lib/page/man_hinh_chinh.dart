import 'package:flutter/material.dart';
import '../page/man_hinh_list_mon_an.dart'; // <--- Đảm bảo import file ListMonAn của bạn vào đây

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Biến quản lý tab đang chọn (0: Trang chủ, 1: Món ăn, 2: Cài đặt)
  int _selectedIndex = 0;

  // 2. Danh sách các màn hình tương ứng
  // Lưu ý: ListMonAn() là class bạn đã tạo ở bước trước
  final List<Widget> _screens = [
    const HomeContent(),     // Màn hình 0: Giao diện Trang chủ (đã tách ra dưới cùng)
    const ListMonAn(),       // Màn hình 1: Danh sách món ăn
    const Center(child: Text("Màn hình Cài đặt")), // Màn hình 2: Demo
  ];

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF7CB342);

    return Scaffold(
      // 3. BODY: Thay đổi linh hoạt dựa theo _selectedIndex
      // IndexedStack giúp giữ trạng thái của màn hình khi chuyển qua lại (không bị load lại từ đầu)
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // 4. BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed, // Giữ vị trí các nút cố định
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            // Icon này bấm vào sẽ ra ListMonAn
            icon: Icon(Icons.menu_book_rounded), 
            label: "Thực đơn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// ĐÂY LÀ GIAO DIỆN TRANG CHỦ CŨ CỦA BẠN (Đã tách ra riêng)
// ---------------------------------------------------------
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF7CB342);
    final bgGreen = const Color(0xFFF1F8E9);

    return Container(
      color: bgGreen, // Màu nền
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Chào buổi sáng,",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const Text("htan",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: primaryGreen,
                    child: const Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // 2. TEXT DẪN
              const Text("Bạn muốn nấu gì hôm nay?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF33691E))),

              const SizedBox(height: 15),

              // 3. THANH TÌM KIẾM
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm nguyên liệu (cà chua...)",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: primaryGreen),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt, color: primaryGreen),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 4. GỢI Ý (CHIPS)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip("Trứng", primaryGreen),
                    _buildChip("Thịt bò", primaryGreen),
                    _buildChip("Rau muống", primaryGreen),
                    _buildChip("Đậu phụ", primaryGreen),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 5. BANNER
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryGreen, const Color(0xFFAED581)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(Icons.restaurant_menu,
                          size: 150, color: Colors.white.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa biết ăn gì?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Nếu muốn bấm nút này cũng sang trang List
                              // thì cần dùng callback, nhưng tạm thời để trống
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryGreen,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text("Gợi ý ngay"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 6. DANH MỤC
              const Text("Thực đơn theo bữa",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(
                      "Sáng", Icons.wb_twilight, Colors.orangeAccent),
                  _buildCategoryCard(
                      "Trưa", Icons.wb_sunny, Colors.redAccent),
                  _buildCategoryCard(
                      "Tối", Icons.nights_stay, Colors.indigoAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label, style: TextStyle(color: color)),
        backgroundColor: Colors.white,
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color iconColor) {
    return Container(
      width: 100,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}