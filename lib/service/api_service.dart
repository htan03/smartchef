import 'dart:convert'; // Dùng để giải mã JSON
import 'package:http/http.dart' as http; // Thư viện kết nối mạng
import 'package:smartchef/config/api_config.dart'; // File chứa IP máy
import '../models/mon_an.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Hàm lấy danh sách món ăn
  // static: Để có thể gọi hàm này ở bất cứ đâu mà không cần khởi tạo class (new ApiService)
  // Future: Hứa hẹn sẽ trả về dữ liệu trong tương lai (vì mạng có thể chậm)
  static Future<List<MonAn>> fetchMonAn({String? loai}) async {
    
    // 1. Xác định địa chỉ (Endpoint)
    // Nếu có truyền loại (vd: 'sang') thì gọi API lọc, nếu không thì gọi API lấy hết
    String endpoint = loai != null ? '/api/mon-an/$loai/' : '/api/mon-an/';
    
    // 2. Ghép thành đường dẫn hoàn chỉnh
    // Kết quả sẽ là: http://192.168.1.5:8000/api/mon-an/
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    try {
      // 3. Gửi yêu cầu GET (Giống như bấm nút Send trong Postman)
      // await: Bảo app "Hãy đợi một chút cho server trả lời"
      final response = await http.get(url);

      // 4. Kiểm tra kết quả
      if (response.statusCode == 200) {
        // --- XỬ LÝ DỮ LIỆU ---
        
        // B1: Giải mã Bytes thành String có dấu tiếng Việt (UTF-8)
        // Nếu dùng json.decode(response.body) ngay thì chữ 'Phở' sẽ bị lỗi font
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        
        // B2: Biến String JSON thành List thô (List<dynamic>)
        List<dynamic> listJson = json.decode(bodyUtf8);
        
        // B3: Đưa từng cục JSON thô vào khuôn đúc (Model) để thành Object MonAn
        List<MonAn> dsMonAn = listJson.map((json) => MonAn.fromJson(json)).toList();
        
        return dsMonAn;
      } else {
        throw Exception('Server trả về lỗi: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt lỗi nếu mất mạng hoặc sai IP
      print('Lỗi kết nối: $e');
      // Trả về list rỗng để App không bị crash
      return []; 
    }
  }
  // Hàm gọi API Gợi ý từ Backend
  static Future<List<MonAn>> fetchGoiY(List<String> ingredients) async {
    // 1. Nối danh sách thành chuỗi: ["Trứng", "Hành"] -> "Trứng,Hành"
    String paramValue = ingredients.join(',');

    // 2. Tạo URL với tham số query
    // Endpoint: /api/mon-an/goi-y/?nguyen_lieu=...
    // Uri sẽ tự động mã hóa tiếng Việt (ví dụ: Trứng -> Tr%E1%BB%A9ng)
    final url = Uri.parse('${ApiConfig.baseUrl}/api/mon-an/goi-y/').replace(
      queryParameters: {'nguyen_lieu': paramValue}
    );

    try {
      print("Đang gọi API: $url"); // Log ra để debug xem đường dẫn đúng không

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã UTF-8 để không lỗi font tiếng Việt
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        List<dynamic> listJson = json.decode(bodyUtf8);
        
        // Map sang Model MonAn
        return listJson.map((json) => MonAn.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối API Gợi ý: $e');
      return []; // Trả về rỗng nếu lỗi
    }
  }


  // API yêu thích món ăn
  static Future<bool> toggleLike(int monAnId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/yeu-thich/toggle/$monAnId/');
    
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token", // Gửi Token đi
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Lấy danh sách yêu thích của người dùng 
  static Future<List<MonAn>> fetchMyFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_token');

    // Nếu chưa có token (chưa đăng nhập), trả về danh sách rỗng
    if (token == null) {
      print("Chưa đăng nhập, không thể lấy danh sách yêu thích.");
      return [];
    }
    final url = Uri.parse('${ApiConfig.baseUrl}/api/yeu-thich/my-list/');

    try {
      print("Đang lấy danh sách yêu thích: $url");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
      );
      if (response.statusCode == 200) {
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        List<dynamic> listJson = json.decode(bodyUtf8);
        List<MonAn> dsYeuThich = listJson.map((json) => MonAn.fromJson(json)).toList();
        
        print("Đã lấy được ${dsYeuThich.length} món yêu thích.");
        return dsYeuThich;
      } else {
        print('Lỗi Server khi lấy yêu thích: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối API Yêu thích: $e');
      return [];
    }
  }


  // API đăng nhập 
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/login/');
    
    try {
      print("Đang đăng nhập: $url");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Đăng nhập thành công, trả về Map chứa token (access, refresh)
        return jsonDecode(response.body);
      } else {
        // Đăng nhập thất bại (Sai pass hoặc lỗi khác)
        print('Đăng nhập thất bại: ${response.statusCode} - ${response.body}');
        return null; 
      }
    } catch (e) {
      print('Lỗi kết nối khi đăng nhập: $e');
      return null;
    }
  }

  // API đăng ký tài khoản
  static Future<String?> register(String username, String password, String email) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/register/');
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
        }),
      );

      // 201 Created = Thành công
      if (response.statusCode == 201) {
        return null; // Không có lỗi -> Thành công
      } 
      // 400 Bad Request = Lỗi nhập liệu (Trùng tên, sai email...)
      else if (response.statusCode == 400) {
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        Map<String, dynamic> errors = jsonDecode(bodyUtf8);

        if (errors.containsKey('username')) {
          // Lấy dòng lỗi đầu tiên trong mảng
          return errors['username'][0]; 
        }
        if (errors.containsKey('email')) {
          return errors['email'][0];
        }
        
        return "Thông tin đăng ký không hợp lệ.";
      } else {
        return "Lỗi Server: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối mạng: $e";
    }
  }

  // Hàm lấy thông tin người dùng (Profile)
  static Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      // 1. Lấy token từ bộ nhớ
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('user_token');

      if (token == null) return null; // Chưa đăng nhập

      final url = Uri.parse('${ApiConfig.baseUrl}/api/profile/');
      
      // 2. Gọi API với Header chứa Token
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // <--- Key
        },
      );

      if (response.statusCode == 200) {
        // Giải mã UTF-8 để hiển thị tên tiếng Việt không lỗi font
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        return jsonDecode(bodyUtf8);
      } else {
        print('Lỗi lấy profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối profile: $e');
      return null;
    }
  }
}