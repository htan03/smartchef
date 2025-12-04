import 'package:flutter/material.dart';
import '../models/mon_an.dart';
import '../service/api_service.dart';
import '../widgets/monan_card.dart';
import '../page/man_hinh_chi_tiet_mon_an.dart';

class ListMonAn extends StatefulWidget {
  final String? loaiMon;
  final String title;
  // Biến kiểm tra xem đang ở chế độ nào
  final bool isFavoriteMode; 

  final List<String>? inputIngredients;

  const ListMonAn({
    Key? key, 
    this.loaiMon, 
    this.title = "Thực đơn", 
    this.inputIngredients,
    this.isFavoriteMode = false, // Mặc định là false (xem danh sách thường)
  }) : super(key: key);

  @override
  State<ListMonAn> createState() => _ListMonAn();
}

class _ListMonAn extends State<ListMonAn> {
  late Future<List<MonAn>> _futureMonAn;
  List<MonAn> _allRecipes = [];
  List<MonAn> _filteredRecipes = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  void _loadSavedRecipes() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    

    // --- LOGIC CHỌN API ---
    // Nếu có danh sách inputIngredients (tức là đi từ nút Gợi ý sang)
    if (widget.inputIngredients != null && widget.inputIngredients!.isNotEmpty) {
      // Gọi API Gợi ý (Backend lo việc lọc và sắp xếp)
      _futureMonAn = ApiService.fetchGoiY(widget.inputIngredients!);
      
    } else {
      // Ngược lại: Gọi API lấy danh sách thường (Sáng/Trưa/Tối)
      _futureMonAn = ApiService.fetchMonAn(loai: widget.loaiMon);
    }

    // --- XỬ LÝ KẾT QUẢ ---
    _futureMonAn.then((recipes) {
      setState(() {
        _allRecipes = recipes;
        
        _filteredRecipes = recipes; 
        
        _isLoading = false;
        
        if (widget.inputIngredients == null || widget.inputIngredients!.isEmpty) {
          _applyFilters(); 
        }
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        return _searchQuery.isEmpty ||
            recipe.tenMonAn.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF7CB342);
    final bgGreen = const Color(0xFFF1F8E9);

    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: Column(
          children: [
            // 2. CUSTOM HEADER (ĐÃ SỬA LOGIC NÚT BACK)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // --- LOGIC HIỂN THỊ NÚT BACK ---
                  // Nếu KHÔNG PHẢI chế độ yêu thích (!isFavoriteMode) -> Hiện nút Back
                  if (!widget.isFavoriteMode) ...[
                    InkWell(
                      onTap: () => Navigator.pop(context), // Quay lại màn hình trước
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back, color: primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 20), // Khoảng cách giữa nút back và tiêu đề
                  ],
                  
                  // Tiêu đề
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // 3. SEARCH BAR (Giữ nguyên)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Tìm món ăn...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: primaryGreen),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _applyFilters();
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. DANH SÁCH MÓN ĂN (Giữ nguyên)
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryGreen))
                  : _hasError
                      ? Center(child: Text(_errorMessage))
                      : _filteredRecipes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.restaurant,
                                      size: 80, color: Colors.grey[300]),
                                  const SizedBox(height: 10),
                                  Text("Không tìm thấy món ăn nào",
                                      style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              itemCount: _filteredRecipes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: MonAnCard(
                                    monAn: _filteredRecipes[index],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChiTietMonAn(
                                              monAn: _filteredRecipes[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}