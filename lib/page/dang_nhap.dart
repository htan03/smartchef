import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(0xFFAED581); 
    final linkColor = Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- PHẦN LOGO ---
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F8E9), 
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80, 
                    errorBuilder: (context, error, stackTrace) {
                      // Du phong neu chua co logo
                      return Column(
                        children: const [
                          Icon(Icons.restaurant, size: 50, color: Colors.brown),
                          Text("Smart Chef", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // --- TIÊU ĐỀ ---
                Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),

                const SizedBox(height: 40),

                // --- Ô NHẬP USERNAME ---
                _buildTextField(hintText: "Tên đăng nhập"),

                const SizedBox(height: 20),

                // --- Ô NHẬP PASSWORD ---
                _buildTextField(hintText: "Mật khẩu", isPassword: true),

                const SizedBox(height: 30),

                // --- HÀNG CUỐI: Link & Nút bấm ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cột bên trái: Đăng ký & Quên MK
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text("Đăng ký", style: TextStyle(color: linkColor, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {},
                          child: Text("Quên mật khẩu?", style: TextStyle(color: linkColor)),
                        ),
                      ],
                    ),

                    // Nút Đăng nhập bên phải
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF758C73), // Màu xanh rêu đậm của nút
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5, // Độ nổi của nút (bóng đổ)
                      ),
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget con để vẽ ô nhập liệu cho gọn code
  Widget _buildTextField({required String hintText, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: isPassword, // Ẩn chữ nếu là mật khẩu
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}