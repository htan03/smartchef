import 'package:flutter/material.dart';
import '../models/mon_an.dart';
import '../utils/constants.dart';

class MonAnCard extends StatelessWidget {
  final MonAn monAn;
  final VoidCallback onTap;

  const MonAnCard({
    Key? key,
    required this.monAn,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // THÊM MARGIN DƯỚI ĐỂ TẠO KHOẢNG CÁCH GIỮA CÁC THẺ
        margin: const EdgeInsets.only(bottom: 20), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HINH ANH
            _buildImage(),
            
            // NOI DUNG
            Padding(
              padding: const EdgeInsets.all(16), // Tăng padding nội dung lên chút cho thoáng
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TEN MON AN
                  Text(
                    monAn.tenMonAn,
                    style: const TextStyle(
                      fontSize: 18, // Font to hơn vì thẻ giờ rộng hơn
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12), // Tăng khoảng cách
                  
                  // Row chứa Thời gian và Calo nằm ngang
                  Row(
                    children: [
                      _buildInfoRow(
                        Icons.access_time_rounded,
                        '${monAn.thoiGian} phut',
                        Colors.orange,
                      ),
                      const SizedBox(width: 24), // Khoảng cách giữa 2 info
                      _buildInfoRow(
                        Icons.local_fire_department_rounded,
                        '${monAn.calo} Kcal',
                        Colors.redAccent,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16), // Tăng khoảng cách tới nút
                  
                  // NUT XEM CHI TIET
                  _buildDetailButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Image.network(
            monAn.hinhAnh,
            width: double.infinity,
            height: 180, // Tăng chiều cao ảnh lên vì thẻ 1 cột rất rộng
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 180,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getLoaiColor(),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              _getLoaiText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Xem chi tiet',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getLoaiColor() {
    switch (monAn.loai.toLowerCase()) {
      case 'sang': return Colors.orange;
      case 'trua': return Colors.blue;
      case 'toi': return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _getLoaiText() {
    return monAn.loai.toUpperCase();
  }
}