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
    return FilmGrid(
      films: films,
      onFilmTap: (film) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FilmDetail(film: film, userData: userData),
        ),
      ),
    );
  }
}

class FilmGrid extends StatelessWidget {
  final List<Film> films;
  final void Function(Film) onFilmTap;

  const FilmGrid({super.key, required this.films, required this.onFilmTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.52,
      ),
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];
        return GestureDetector(
          onTap: () => onFilmTap(film),
          child: _FilmCard(film: film),
        );
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];
        return GestureDetector(
          onTap: () => onFilmTap(film),
          child: _FilmCard(
            film: film,
            posterHeight: 250,
            titleFontSize: 16,
          ),
        );
      },
    );
  }
}

class _FilmCard extends StatelessWidget {
  final Film film;
  final double posterHeight;
  final double titleFontSize;

  const _FilmCard({
    required this.film,
    this.posterHeight = 220,
    this.titleFontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 26, 26, 26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                film.poster_1 ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: posterHeight,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFFCC434),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.movie_creation_outlined,
                    color: Colors.black,
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            film.judul ?? '',
            style: TextStyle(
              color: lightColor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                (film.rating ?? 0.0).toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            film.genre ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
