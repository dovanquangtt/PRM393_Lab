
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class ApiService {
  // Cho phép truyền http.Client vào để dễ kiểm thử
  final http.Client _client;

  ApiService({http.Client? client})
      : _client = client ?? http.Client();

  // Lấy danh sách bài viết từ API
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    );

    try {
      final response = await _client
          .get(url)
          .timeout(const Duration(seconds: 15));

      // Kiểm tra API trả về thành công hay không
      if (response.statusCode == 200) {
        // Chuyển JSON thành danh sách
        final List<dynamic> jsonList =
        json.decode(response.body);

        // Chuyển từng phần tử JSON thành Post
        return jsonList.map((json) {
          return Post.fromJson(json);
        }).toList();
      } else {
        throw Exception(
          'Không thể tải dữ liệu. Mã lỗi: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Ném lỗi để giao diện xử lý
      rethrow;
    }
  }

  // Đóng client khi không còn sử dụng
  void dispose() {
    _client.close();
  }
}
