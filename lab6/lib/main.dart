import 'package:flutter/material.dart';

// ==========================================================
// LAB 6 - RESPONSIVE MOVIE GENRE BROWSING SCREEN
// Tất cả code nằm trong một file main.dart
// ==========================================================

void main() {
  runApp(const ResponsiveMovieApp());
}

// ==========================================================
// 1. MAIN APP
// ==========================================================

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tắt chữ DEBUG
      debugShowCheckedModeBanner: false,

      title: 'Lab 6 - Responsive Movie App',

      // Theme của ứng dụng
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),

      // Màn hình đầu tiên
      home: const GenreScreen(),
    );
  }
}

// ==========================================================
// 2. MOVIE MODEL
// Lớp dùng để lưu thông tin của một bộ phim
// ==========================================================

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// ==========================================================
// 3. SAMPLE DATA
// Dữ liệu phim tĩnh - không sử dụng API
// ==========================================================

const List<Movie> allMovies = [
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/avengers/400/500',
    rating: 8.4,
  ),

  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/interstellar/400/500',
    rating: 8.7,
  ),

  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/batman/400/500',
    rating: 9.0,
  ),

  Movie(
    title: 'Joker',
    year: 2019,
    genres: ['Drama'],
    posterUrl: 'https://picsum.photos/seed/joker/400/500',
    rating: 8.4,
  ),

  Movie(
    title: 'Deadpool',
    year: 2016,
    genres: ['Action', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/deadpool/400/500',
    rating: 8.0,
  ),

  Movie(
    title: 'Toy Story',
    year: 1995,
    genres: ['Comedy', 'Animation'],
    posterUrl: 'https://picsum.photos/seed/toystory/400/500',
    rating: 8.3,
  ),
];

// ==========================================================
// 4. GENRE SCREEN
// StatefulWidget vì Search, Genre và Sort thay đổi dữ liệu
// ==========================================================

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // ========================================================
  // SEARCH STATE
  // ========================================================

  // Nội dung người dùng nhập vào Search
  String searchQuery = '';

  // Controller để có thể xóa TextField
  final TextEditingController searchController =
  TextEditingController();

  // ========================================================
  // GENRE STATE
  // ========================================================

  // Danh sách các thể loại
  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Animation',
  ];

  // Lưu các genre đang được chọn
  final Set<String> selectedGenres = {};

  // ========================================================
  // SORT STATE
  // ========================================================

  // Mặc định sắp xếp A-Z
  String selectedSort = 'A-Z';

  // ========================================================
  // 5. FILTER + SORT
  // ========================================================

  List<Movie> getVisibleMovies() {
    // ------------------------------------------------------
    // BƯỚC 1: FILTER
    // ------------------------------------------------------

    List<Movie> result = allMovies.where((movie) {
      // Search không phân biệt chữ hoa/chữ thường
      bool matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      // Nếu chưa chọn genre -> tất cả genre đều hợp lệ
      // Nếu đã chọn -> phim phải có ít nhất 1 genre được chọn
      bool matchesGenre =
          selectedGenres.isEmpty ||
              movie.genres.any(
                    (genre) => selectedGenres.contains(genre),
              );

      // Phim phải thỏa cả Search và Genre
      return matchesSearch && matchesGenre;
    }).toList();

    // ------------------------------------------------------
    // BƯỚC 2: SORT
    // ------------------------------------------------------

    // A -> Z
    if (selectedSort == 'A-Z') {
      result.sort(
            (a, b) => a.title.compareTo(b.title),
      );
    }

    // Z -> A
    else if (selectedSort == 'Z-A') {
      result.sort(
            (a, b) => b.title.compareTo(a.title),
      );
    }

    // Năm mới nhất -> cũ nhất
    else if (selectedSort == 'Year') {
      result.sort(
            (a, b) => b.year.compareTo(a.year),
      );
    }

    // Rating cao -> thấp
    else if (selectedSort == 'Rating') {
      result.sort(
            (a, b) => b.rating.compareTo(a.rating),
      );
    }

    return result;
  }

  // ========================================================
  // 6. CLEAR FILTERS
  // ========================================================

  void clearFilters() {
    setState(() {
      // Xóa Search
      searchQuery = '';
      searchController.clear();

      // Bỏ chọn tất cả genre
      selectedGenres.clear();

      // Sort trở về A-Z
      selectedSort = 'A-Z';
    });
  }

  // ========================================================
  // 7. DISPOSE
  // ========================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ========================================================
  // 8. BUILD SCREEN
  // ========================================================

  @override
  Widget build(BuildContext context) {
    // Danh sách sau khi Search + Filter + Sort
    final List<Movie> visibleMovies =
    getVisibleMovies();

    // ------------------------------------------------------
    // MEDIAQUERY
    // Đọc chiều rộng của màn hình
    // ------------------------------------------------------

    final double screenWidth =
        MediaQuery.of(context).size.width;

    return Scaffold(
      // SafeArea tránh camera, notch và status bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // LAB 6.1
              // RESPONSIVE HEADING
              // ==================================================

              Text(
                'Find a Movie',

                style: TextStyle(
                  fontWeight: FontWeight.bold,

                  // Web/Tablet chữ lớn hơn Phone
                  fontSize:
                  screenWidth >= 800 ? 36 : 28,
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // LAB 6.2
              // SEARCH BAR
              // ==================================================

              TextField(
                controller: searchController,

                decoration: InputDecoration(
                  hintText: 'Search movies...',

                  prefixIcon:
                  const Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),

                // Khi nhập chữ -> cập nhật Search
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // ==================================================
              // GENRE TITLE
              // ==================================================

              Row(
                children: [
                  const Text(
                    'Genres',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Bonus:
                  // Hiện số lượng genre đang chọn
                  if (selectedGenres.isNotEmpty)
                    CircleAvatar(
                      radius: 12,

                      child: Text(
                        '${selectedGenres.length}',

                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // ==================================================
              // GENRE CHIPS
              //
              // Wrap giúp các Chip tự động xuống hàng
              // nếu màn hình không đủ chiều rộng
              // ==================================================

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children: genres.map((genre) {
                  // Kiểm tra genre hiện tại có được chọn không
                  final bool isSelected =
                  selectedGenres.contains(genre);

                  return FilterChip(
                    label: Text(genre),

                    selected: isSelected,

                    onSelected: (selected) {
                      setState(() {
                        // Chọn genre
                        if (selected) {
                          selectedGenres.add(genre);
                        }

                        // Bỏ chọn genre
                        else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // SORT BAR
              // ==================================================

              Row(
                children: [
                  const Text(
                    'Sort by:',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Dropdown chọn cách sắp xếp
                  DropdownButton<String>(
                    value: selectedSort,

                    items: const [
                      DropdownMenuItem(
                        value: 'A-Z',
                        child: Text('A-Z'),
                      ),

                      DropdownMenuItem(
                        value: 'Z-A',
                        child: Text('Z-A'),
                      ),

                      DropdownMenuItem(
                        value: 'Year',
                        child: Text('Year'),
                      ),

                      DropdownMenuItem(
                        value: 'Rating',
                        child: Text('Rating'),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSort = value;
                        });
                      }
                    },
                  ),

                  const Spacer(),

                  // Bonus: Clear Filters
                  TextButton(
                    onPressed: clearFilters,

                    child:
                    const Text('Clear filters'),
                  ),
                ],
              ),

              // ==================================================
              // RESULT COUNT
              // ==================================================

              Text(
                '${visibleMovies.length} movies found',
              ),

              const SizedBox(height: 12),

              // ==================================================
              // KHÔNG CÓ KẾT QUẢ
              // ==================================================

              if (visibleMovies.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'No movies found',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // ==================================================
              // CÓ KẾT QUẢ
              // ==================================================

              else
                Expanded(
                  // ==============================================
                  // LAB 6.3
                  // LAYOUTBUILDER RESPONSIVE
                  // ==============================================

                  child: LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      // ------------------------------------------
                      // TABLET / WEB
                      //
                      // >= 800px -> Grid 2 cột
                      // ------------------------------------------

                      if (constraints.maxWidth >= 800) {
                        return GridView.builder(
                          itemCount:
                          visibleMovies.length,

                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,

                            crossAxisSpacing: 16,

                            mainAxisSpacing: 16,

                            // Card dạng ngang
                            childAspectRatio: 2.7,
                          ),

                          itemBuilder:
                              (context, index) {
                            return MovieCard(
                              movie:
                              visibleMovies[index],

                              isWide: true,
                            );
                          },
                        );
                      }

                      // ------------------------------------------
                      // PHONE
                      //
                      // < 800px -> ListView 1 cột
                      // ------------------------------------------

                      return ListView.builder(
                        itemCount:
                        visibleMovies.length,

                        itemBuilder:
                            (context, index) {
                          return Padding(
                            padding:
                            const EdgeInsets.only(
                              bottom: 12,
                            ),

                            child: MovieCard(
                              movie:
                              visibleMovies[index],

                              isWide: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// 9. MOVIE CARD
//
// ĐÂY LÀ PHẦN ĐÃ SỬA LỖI.
//
// Bản cũ dùng height: double.infinity cho Image
// khiến ListView trên điện thoại có thể không hiển thị.
//
// Bản mới đặt chiều cao Card cố định = 140.
// ==========================================================

class MovieCard extends StatelessWidget {
  // Movie cần hiển thị
  final Movie movie;

  // true  = Tablet/Web
  // false = Phone
  final bool isWide;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,

      // ------------------------------------------------------
      // Đặt chiều cao rõ ràng cho Card
      // để ListView hiển thị đúng trên Pixel 6
      // ------------------------------------------------------

      child: SizedBox(
        height: 140,

        child: Row(
          children: [
            // ==================================================
            // POSTER
            // ==================================================

            Image.network(
              movie.posterUrl,

              // Web/Tablet poster rộng hơn
              width: isWide ? 140 : 105,

              // Không dùng double.infinity nữa
              height: 140,

              fit: BoxFit.cover,

              // Nếu mất mạng hoặc ảnh không tải được
              // vẫn hiển thị icon Movie
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: isWide ? 140 : 105,
                  height: 140,

                  color: Colors.grey.shade300,

                  alignment: Alignment.center,

                  child: const Icon(
                    Icons.movie,
                    size: 50,
                  ),
                );
              },
            ),

            // ==================================================
            // MOVIE INFORMATION
            // ==================================================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    // --------------------------------------------
                    // TITLE
                    // --------------------------------------------

                    Text(
                      movie.title,

                      maxLines: 2,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // --------------------------------------------
                    // YEAR
                    // --------------------------------------------

                    Text(
                      'Year: ${movie.year}',
                    ),

                    const SizedBox(height: 5),

                    // --------------------------------------------
                    // RATING
                    // Bonus của Lab
                    // --------------------------------------------

                    Text(
                      '⭐ ${movie.rating}',
                    ),

                    const SizedBox(height: 5),

                    // --------------------------------------------
                    // GENRES
                    // --------------------------------------------

                    Text(
                      movie.genres.join(', '),

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}