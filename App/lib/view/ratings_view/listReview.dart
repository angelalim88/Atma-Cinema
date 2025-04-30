import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/client/ReviewClient.dart'; // Fetch data review
import 'package:flutter_application_1/data/review.dart';
import 'package:flutter_application_1/client/TicketClient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewsProvider = StateNotifierProvider<ReviewsNotifier, List<Review>>(
  (ref) => ReviewsNotifier(),
);

class ReviewsNotifier extends StateNotifier<List<Review>> {
  ReviewsNotifier() : super([]);

  Future<void> fetchReviewsByFilmId(int filmId) async {
    final reviews = await ReviewClient().fetchByFilmId(filmId);
    state = reviews;
  }

  void addReview(Review review) {
    state = [...state, review];
  }
}

class RatingsAndReviewsView extends StatefulWidget {
  final Film film;
  final Map<String, dynamic> userData;

  const RatingsAndReviewsView({
    super.key,
    required this.film,
    required this.userData,
  });

  @override
  _RatingsAndReviewsViewState createState() => _RatingsAndReviewsViewState();
}

class _RatingsAndReviewsViewState extends State<RatingsAndReviewsView> {
  int? tiketId;
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  late Future<List<Review>> _futureReviews;

  @override
  void initState() {
    super.initState();
    _futureReviews = ReviewClient().fetchByFilmId(widget.film.id_film!);
    fetchUserTicketAndPenayangan(widget.userData["id_user"]);
  }

  Future<void> fetchUserTicketAndPenayangan(int userId) async {
    try {
      final tickets = await TicketClient().fetchOnlyUsers(userId);

      for (var ticket in tickets) {
        if (ticket.penayangan?.status == "Not Available" &&
            ticket.penayangan?.id_film == widget.film.id_film) {
          setState(() {
            tiketId = ticket.idTiket;
          });
          break;
        }
      }
    } catch (error) {
      debugPrint("Error fetching tickets: $error");
    }
  }

  // Function to create the star widgets based on rating
  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      Icon icon;
      if (rating >= i + 1) {
        icon = Icon(Icons.star, color: lightColor, size: 30);
      } else if (rating > i && rating < i + 1) {
        icon = Icon(Icons.star_half, color: lightColor, size: 30);
      } else {
        icon = Icon(Icons.star_border, color: lightColor, size: 30);
      }

      stars.add(
        GestureDetector(
          onTapDown: (details) {
            setState(() {
              // Hitung posisi tap pada bintang
              final tapPosition = details.localPosition.dx;
              final starWidth = 30.0; // Lebar bintang dalam piksel

              if (tapPosition < starWidth / 2) {
                // Ketukan di setengah kiri bintang
                _userRating = i + 0.5;
              } else {
                // Ketukan di setengah kanan bintang
                _userRating = i + 1.0;
              }
            });
          },
          child: icon,
        ),
      );
    }
    return stars;
  }

  // Function to build review card
  Widget _buildReviewCard(Review review) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900], // Warna gelap untuk card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              review.user!.profie_picture ?? '',
              width: 50, // Full-width image
              height: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user?.username ??
                        "Anonymous", // Menampilkan username
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Warna teks untuk mode gelap
                    ),
                  ),
                  Row(
                      children:
                          _buildStarRating(review.rating?.toDouble() ?? 0.0)),
                  const SizedBox(height: 8),
                  Text(
                    review.komentar ?? "No comments provided.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Warna teks lebih terang
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings & Reviews"),
        backgroundColor: darkColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Film title
                    Text(
                      widget.film.judul ?? "Movie Title",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Star rating widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildStarRating(_userRating),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_userRating.toStringAsFixed(1)} / 5.0",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Add review input field
                    TextField(
                      controller: _reviewController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Add a review",
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: const Color(0xFF222222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 32),

                    // Display all reviews section
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "All Reviews",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fetch and display reviews
                    StatefulBuilder(
                      builder: (context, setState) {
                        return FutureBuilder<List<Review>>(
                          future: _futureReviews,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${snapshot.error}",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No reviews available.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            final reviews = snapshot.data!;
                            return Column(
                              children: reviews
                                  .map((review) => _buildReviewCard(review))
                                  .toList(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Publish review button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: tiketId != null
                  ? () async {
                      if (_reviewController.text.isNotEmpty) {
                        try {
                          final isSuccess = await ReviewClient().postReview(
                            tiketId!,
                            _userRating,
                            _reviewController.text,
                          );

                          if (isSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review added successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Gunakan setState untuk memicu refresh
                            setState(() {
                              _reviewController.clear(); // Kosongkan komentar
                              _userRating = 0.0; // Reset rating
                              _futureReviews = ReviewClient().fetchByFilmId(
                                  widget.film.id_film!); // Refresh review
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to post review: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please write a review before publishing!"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: tiketId != null ? lightColor : Colors.grey,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Publish Review",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: darkColor,
    );
  }
}
