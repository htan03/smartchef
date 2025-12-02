import 'package:flutter/material.dart';
import '../models/mon_an.dart';
import '../service/api_service.dart';
import '../widgets/monan_card.dart';
import '../utils/constants.dart';

class ListMonAn extends StatefulWidget {
  const ListMonAn({Key? key}) : super(key: key);

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
    
    _futureMonAn = ApiService.fetchMonAn();
    
    _futureMonAn.then((recipes) {
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
        _applyFilters();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Danh Sach Mon An',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tim kiem mon an...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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

          // RECIPE LIST (ListView cho 1 cột)
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _hasError
                    ? _buildErrorState()
                    : _filteredRecipes.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            // Padding xung quanh toàn bộ danh sách
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: _filteredRecipes.length,
                            itemBuilder: (context, index) {
                              return MonAnCard(
                                monAn: _filteredRecipes[index],
                                onTap: () {
                                  print('Tapped: ${_filteredRecipes[index].tenMonAn}');
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryGreen),
    );
  }

  Widget _buildErrorState() {
    return Center(child: Text(_errorMessage));
  }

  Widget _buildEmptyState() {
    return Center(child: Text("Khong tim thay mon an"));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}