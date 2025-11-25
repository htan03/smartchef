import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Color(0xFF7CB342); 
    final bgGreen = Color(0xFFF1F8E9); 

    return Scaffold(
      backgroundColor: bgGreen, 
      
      // --- BODY ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER: Chào hỏi + Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Chào buổi sáng,", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      Text("htan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: primaryGreen,
                    child: Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // 2. TEXT DẪN
              Text("Bạn muốn nấu gì hôm nay?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF33691E))),

              const SizedBox(height: 15),

              // 3. THANH TÌM KIẾM 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm nguyên liệu (cà chua...)",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: primaryGreen),
                    // Nút Camera nằm bên phải
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

              // 5. BANNER / NÚT GỢI Ý 
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primaryGreen, Color(0xFFAED581)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20, bottom: -20,
                      child: Icon(Icons.restaurant_menu, size: 150, color: Colors.white.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Chưa biết ăn gì?", style: TextStyle(color: Colors.white, fontSize: 18)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryGreen,
                              shape: StadiumBorder(),
                            ),
                            child: Text("Gợi ý ngay"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 6. DANH MỤC (SÁNG / TRƯA / TỐI)
              Text("Thực đơn theo bữa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard("Sáng", Icons.wb_twilight, Colors.orangeAccent),
                  _buildCategoryCard("Trưa", Icons.wb_sunny, Colors.redAccent),
                  _buildCategoryCard("Tối", Icons.nights_stay, Colors.indigoAccent),
                ],
              ),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Yêu thích"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
        ],
      ),
    );
  }

  // Widget con để vẽ các nút Tag nhỏ (Chip)
  Widget _buildChip(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label, style: TextStyle(color: color)),
        backgroundColor: Colors.white,
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: StadiumBorder(),
      ),
    );
  }

  // Widget con để vẽ 3 cái thẻ Sáng/Trưa/Tối
  Widget _buildCategoryCard(String title, IconData icon, Color iconColor) {
    return Container(
      width: 100,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: iconColor),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}