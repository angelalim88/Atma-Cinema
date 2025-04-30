import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/client/FilmClient.dart';
import 'package:flutter_application_1/view/movie_view/filmDetail.dart';

// Define Riverpod Provider to fetch films
final filmsProvider = FutureProvider<List<Film>>((ref) async {
  return await FilmClient().fetchAll();
});

class FilmListView extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;

  const FilmListView({super.key, required this.userData});

  @override
  _FilmListViewState createState() => _FilmListViewState();
}

class _FilmListViewState extends ConsumerState<FilmListView> {
  String _filter = 'Now Playing';

  List<Film> _filterFilms(List<Film> films) {
    return _filter == 'Now Playing'
        ? films.where((film) => film.status == 'Now Playing').toList()
        : films.where((film) => film.status == 'Coming Soon').toList();
  }

  @override
  Widget build(BuildContext context) {
    final filmsAsyncValue = ref.watch(filmsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Movies",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: filmsAsyncValue.when(
              data: (films) => _buildFilmLayout(_filterFilms(films)),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  "Error: $error",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: const Color.fromARGB(255, 22, 22, 22),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterButton("Now Playing"),
          const SizedBox(width: 6),
          _buildFilterButton("Coming Soon"),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    bool isSelected = _filter == label;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFFCC434)
            : Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _filter = label;
          });

          // Memicu reload dengan refresh
          ref.refresh(filmsProvider); // Menyegarkan filmsProvider
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white.withOpacity(0.5),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilmLayout(List<Film> films) {
    return Container(
      color: const Color.fromARGB(255, 22, 22, 22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 600
              ? WideLayout(films: films, userData: widget.userData)
              : NarrowLayout(films: films, userData: widget.userData);
        },
      ),
    );
  }
}

class NarrowLayout extends StatelessWidget {
  final List<Film> films;
  final Map<String, dynamic> userData;

  const NarrowLayout({super.key, required this.films, required this.userData});

  @override
  Widget build(BuildContext context) {
    return FilmList(
      films: films,
      onFilmTap: (film) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FilmDetail(film: film, userData: userData),
        ),
      ),
    );
  }
}

class WideLayout extends StatefulWidget {
  final List<Film> films;
  final Map<String, dynamic> userData;

  const WideLayout({super.key, required this.films, required this.userData});

  @override
  State<WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  Film? _selectedFilm;

  void _onFilmSelected(Film film) {
    setState(() => _selectedFilm = film);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: FilmList(films: widget.films, onFilmTap: _onFilmSelected),
        ),
        Expanded(
          flex: 2,
          child: _selectedFilm == null
              ? Center(
                  child:
                      Image.asset('images/logo1.png', width: 500, height: 500))
              : FilmDetail(
                  film: _selectedFilm!,
                  userData: widget.userData,
                ),
        ),
      ],
    );
  }
}

class FilmList extends StatelessWidget {
  final List<Film> films;
  final void Function(Film) onFilmTap;

  const FilmList({super.key, required this.films, required this.onFilmTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];
        return GestureDetector(
          onTap: () => onFilmTap(film),
          child: _buildFilmItem(film),
        );
      },
    );
  }

  Widget _buildFilmItem(Film film) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers all children horizontally
        children: [
          // Film Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              film.poster_1 ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // Adjusted height for poster
            ),
          ),
          const SizedBox(height: 8),

          // Film Title
          Text(
            film.judul ?? '',
            style: const TextStyle(
              color: lightColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center, // Ensures text is centered
          ),
          const SizedBox(height: 8),

          // Ratings Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the row
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                (film.rating ?? 0.0).toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                "(100)", // Placeholder for reviews count
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Film Genre
          Text(
            film.genre ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center, // Ensures text is centered
          ),
        ],
      ),
    );
  }
}
