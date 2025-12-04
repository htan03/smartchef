import 'package:flutter/material.dart';
import '../page/man_hinh_list_mon_an.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Biến quản lý tab đang chọn (0: Trang chủ, 1: Món ăn, 2: Cài đặt)
  int _selectedIndex = 0;

  // 2. Danh sách các màn hình tương ứng
  final List<Widget> _screens = [
    const HomeContent(),    // Màn hình 0: Giao diện Trang chủ
    const ListMonAn(        // Màn hình 1: Danh sách yêu thích (Cố định)
      title: "Món ăn Yêu Thích",
      isFavoriteMode: true,
    ),    
    const Center(child: Text("Màn hình Cài đặt")), // Màn hình 2: Demo
  ];  

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF7CB342);

    return Scaffold(
      // 3. BODY: Thay đổi linh hoạt dựa theo _selectedIndex
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Yêu thích",
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

// GIAO DIỆN TRANG CHỦ
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // 1. Controller để quản lý văn bản trong ô nhập
  final TextEditingController _controller = TextEditingController();
  
  // 2. Danh sách lưu các nguyên liệu người dùng đã nhập
  final List<String> _selectedIngredients = [];

  // Hàm thêm nguyên liệu
  void _addIngredient(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        // Thêm vào danh sách và xóa khoảng trắng thừa
        _selectedIngredients.add(value.trim()); 
        // Xóa chữ trong ô nhập để nhập món tiếp theo
        _controller.clear(); 
      });
    }
  }

  // Hàm xóa nguyên liệu
  void _removeIngredient(String value) {
    setState(() {
      _selectedIngredients.remove(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF7CB342);
    final bgGreen = const Color(0xFFF1F8E9);

    return Container(
      color: bgGreen,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER (Giữ nguyên)
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

              // 3. THANH TÌM KIẾM & NHẬP LIỆU [ĐÃ SỬA]
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
                  controller: _controller,
                  // Sự kiện khi nhấn Enter trên bàn phím
                  onSubmitted: (value) => _addIngredient(value),
                  decoration: InputDecoration(
                    hintText: "Nhập nguyên liệu rồi nhấn Enter...",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    border: InputBorder.none,
                    icon: Icon(Icons.add_circle_outline, color: primaryGreen),
                    // Nút xóa nhanh text đang nhập
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () => _controller.clear(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 4. KHU VỰC HIỂN THỊ CHIPS [ĐÃ SỬA]
              // Nếu danh sách rỗng thì hiện text gợi ý, ngược lại hiện Chips
              _selectedIngredients.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Ví dụ: Trứng, Cà chua, Hành...",
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[500]),
                      ),
                    )
                  : Wrap(
                      spacing: 8.0, // Khoảng cách ngang giữa các chip
                      runSpacing: 4.0, // Khoảng cách dọc giữa các dòng
                      children: _selectedIngredients.map((ingredient) {
                        return Chip(
                          label: Text(
                            ingredient,
                            style: TextStyle(color: primaryGreen),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: primaryGreen.withOpacity(0.5)),
                          shape: const StadiumBorder(),
                          // Nút xóa (X) trên Chip
                          deleteIcon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                          onDeleted: () => _removeIngredient(ingredient),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 30),

              // 5. BANNER & NÚT GỢI Ý [ĐÃ SỬA LOGIC NÚT]
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
                          const Text("Đã chọn nguyên liệu xong?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Kiểm tra nếu chưa nhập gì thì báo lỗi nhẹ hoặc không làm gì
                              if (_selectedIngredients.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Hãy nhập ít nhất 1 nguyên liệu!")),
                                );
                                return;
                              }

                              // Chuyển sang màn hình List và GỬI DANH SÁCH đi
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListMonAn(
                                    title: "Gợi ý món ăn",
                                    // Truyền danh sách nguyên liệu sang bên kia
                                    inputIngredients: _selectedIngredients,
                                    isFavoriteMode: false,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryGreen,
                              shape: const StadiumBorder(),
                            ),
                            child: Text("Gợi ý ngay (${_selectedIngredients.length})"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 6. DANH MỤC (Giữ nguyên code cũ của bạn)
              const Text("Thực đơn theo bữa",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard("Sáng", Icons.wb_twilight, Colors.orangeAccent, () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const ListMonAn(loaiMon: 'sang', title: "Món ăn Sáng")));
                  }),
                  _buildCategoryCard("Trưa", Icons.wb_sunny, Colors.redAccent, () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const ListMonAn(loaiMon: 'trua', title: "Món ăn Trưa")));
                  }),
                  _buildCategoryCard("Tối", Icons.nights_stay, Colors.indigoAccent, () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const ListMonAn(loaiMon: 'toi', title: "Món ăn Tối")));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con giữ nguyên
  Widget _buildCategoryCard(String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}