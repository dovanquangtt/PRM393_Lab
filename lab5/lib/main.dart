import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================
// MAIN APP
// =====================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}

// =====================================================
// MOVIE MODEL
// =====================================================
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// =====================================================
// SAMPLE DATA
// Static data - No API
// =====================================================
final List<Movie> movies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl: 'https://picsum.photos/seed/dune/800/500',
    overview:
    'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      'Official Trailer #1',
      'IMAX Sneak Peek',
    ],
  ),

  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://picsum.photos/seed/deadpool/800/500',
    overview:
    'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      'Red Band Trailer',
      'Behind the Scenes',
    ],
  ),

  Movie(
    id: 3,
    title: 'Interstellar',
    posterUrl: 'https://picsum.photos/seed/interstellar/800/500',
    overview:
    'A team of explorers travels through space in an attempt to ensure humanity survives.',
    genres: ['Sci-Fi', 'Adventure'],
    rating: 8.7,
    trailers: [
      'Official Trailer',
      'Behind the Scenes',
    ],
  ),
];

// =====================================================
// HOME SCREEN
// =====================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Scrollable movie list
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,

        itemBuilder: (context, index) {
          final movie = movies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),

            child: InkWell(
              borderRadius: BorderRadius.circular(12),

              onTap: () {
                // Navigate to Detail Screen
                // and pass Movie object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailScreen(movie: movie),
                  ),
                );
              },

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Row(
                  children: [
                    // Movie poster
                    Hero(
                      tag: 'movie-${movie.id}',

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child: Image.network(
                          movie.posterUrl,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              width: 95,
                              height: 95,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.movie,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Movie information
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '★ ${movie.rating} • '
                                '${movie.genres.join(", ")}',
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// MOVIE DETAIL SCREEN
// =====================================================
class MovieDetailScreen extends StatefulWidget {
  // Movie object received from HomeScreen
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() =>
      _MovieDetailScreenState();
}

class _MovieDetailScreenState
    extends State<MovieDetailScreen> {

  // Favorite state
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),

      // Scrollable detail screen
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================================
            // HERO BANNER
            // Image + Gradient + Title
            // =========================================
            Hero(
              tag: 'movie-${movie.id}',

              child: SizedBox(
                height: 240,
                width: double.infinity,

                child: Stack(
                  fit: StackFit.expand,

                  children: [
                    Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.movie,
                            size: 80,
                          ),
                        );
                      },
                    ),

                    // Gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.transparent,
                            Colors.black87,
                          ],
                        ),
                      ),
                    ),

                    // Movie title
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,

                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // =====================================
                  // GENRES
                  // =====================================
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // =====================================
                  // RATING
                  // =====================================
                  Text(
                    '★ Rating: ${movie.rating}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =====================================
                  // OVERVIEW
                  // =====================================
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =====================================
                  // ACTION BUTTONS
                  // Favorite / Rate / Share
                  // =====================================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,

                    children: [
                      actionButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        text: 'Favorite',

                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),

                      actionButton(
                        icon: Icons.star,
                        text: 'Rate',

                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Rate button clicked',
                              ),
                            ),
                          );
                        },
                      ),

                      actionButton(
                        icon: Icons.share,
                        text: 'Share',

                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Share button clicked',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =====================================
                  // TRAILERS
                  // =====================================
                  const Text(
                    'Trailers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ListView.builder inside scroll view
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),

                    itemCount: movie.trailers.length,

                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,

                        leading: const Icon(
                          Icons.play_circle_fill,
                        ),

                        title: Text(
                          movie.trailers[index],
                        ),

                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Playing ${movie.trailers[index]}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // Reusable action button
  // ===================================================
  Widget actionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 30,
        ),

        Text(text),
      ],
    );
  }
}