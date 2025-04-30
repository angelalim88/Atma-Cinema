import 'dart:convert';
import 'package:flutter/rendering.dart';

class Film {
  int? id_film;
  String? judul;
  String? genre;
  int? tahun_rilis;
  String? sutradara;
  String? aktor;
  String? deskripsi;
  String? poster_1;
  String? poster_2;
  String? trailer;
  String? status;
  dynamic rating;

  //ini dihapus nanti
  String? picture;
  String? horizontal_picture;
  // double? ratings;
  String? review;
  int? durasi;

  Film(
      {this.id_film,
      this.judul,
      this.genre,
      this.tahun_rilis,
      this.sutradara,
      this.aktor,
      this.deskripsi,
      this.poster_1,
      this.poster_2,
      this.rating,
      this.trailer,
      this.status,
      this.picture,
      this.horizontal_picture,
      this.review,
      this.durasi});

  factory Film.fromRawJson(String str) => Film.fromJson(json.decode(str));
  factory Film.fromJson(Map<String, dynamic> json) => Film(
      id_film: json["id_film"],
      judul: json["judul"],
      genre: json["genre"],
      tahun_rilis: json["tahun_rilis"],
      sutradara: json["sutradara"],
      aktor: json["aktor"],
      deskripsi: json["deskripsi"],
      poster_1: json["poster_1"],
      poster_2: json["poster_2"],
      rating: json["rating"],
      trailer: json["trailer"],
      status: json["status"]);

  factory Film.fromPenayanganJson(Map<String, dynamic> json) => Film(
        id_film: json["id_film"],
        judul: json["judul"],
        genre: json["genre"],
        tahun_rilis: json["tahun_rilis"],
        poster_1: json["poster_1"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_film": id_film,
        "judul": judul,
        "genre": genre,
        "tahun_rilis": tahun_rilis,
        "sutradara": sutradara,
        "aktor": aktor,
        "deskripsi": deskripsi,
        "poster_1": poster_1,
        "poster_2": poster_2,
        "rating": rating,
        "trailer": trailer,
        "status": status,
      };
}

final List<Film> films = _films
    .map((e) => Film(
          id_film: e['id_film'] as int,
          judul: e['judul'] as String,
          genre: e['genre'] as String,
          tahun_rilis: e['tahun_rilis'] as int,
          sutradara: e['sutradara'] as String,
          aktor: e['aktor'] as String,
          deskripsi: e['deskripsi'] as String,
          picture: e['picture'] as String,
          horizontal_picture: e['horizontal_picture'] as String,
          review: e['review'] as String? ?? 'No reviews available',
          trailer: e['trailer'] as String,
          durasi: e['durasi'] as int,
        ))
    .toList(growable: false);

final List<Map<String, Object>> _films = [
  {
    'id_film': 'F001',
    'judul': 'Inception',
    'genre': 'Sci-Fi',
    'tahun_rilis': '2010',
    'sutradara': 'Christopher Nolan',
    'aktor': 'Leonardo DiCaprio',
    'deskripsi':
        'A thief who enters the dreams of others to steal their secrets.',
    'picture':
        'https://m.media-amazon.com/images/I/919mVr6ikcL.AC_UF1000,1000_QL80.jpg',
    'horizontal_picture':
        'https://filmwonk.net/wp-content/uploads/2011/01/2010glennies-bp-10-inception.jpg?w=848',
    'ratings': 4.8,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': 'https://www.youtube.com/watch?v=YoHD9XEInc0',
    'durasi': 160,
  },
  {
    'id_film': 'F002',
    'judul': 'The Matrix',
    'genre': 'Action',
    'tahun_rilis': '1999',
    'sutradara': 'Wachowskis',
    'aktor': 'Keanu Reeves',
    'deskripsi':
        'A hacker discovers a dystopian reality controlled by intelligent machines.',
    'picture':
        'https://m.media-amazon.com/images/M/MV5BN2NmN2VhMTQtMDNiOS00NDlhLTliMjgtODE2ZTY0ODQyNDRhXkEyXkFqcGc@.V1.jpg',
    'horizontal_picture':
        'https://img.englishcinemakyiv.com/BVZBaq6fsTow7KZmdNWUFoEOT1GThWYfAprhqMDZEi4/resize:fill:800:450:1:0/gravity:sm/aHR0cHM6Ly9leHBhdGNpbmVtYXByb2QuYmxvYi5jb3JlLndpbmRvd3MubmV0L2ltYWdlcy9lMTA1YjhlNi1hOTcyLTQxMmMtYmRiMy0yZmJkYWE1NDA2OWYuanBn.jpg',
    'ratings': 4.8,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 122,
  },
  {
    'id_film': 'F003',
    'judul': 'The Godfather',
    'genre': 'Crime',
    'tahun_rilis': '1972',
    'sutradara': 'Francis Ford Coppola',
    'aktor': 'Marlon Brando',
    'deskripsi':
        'The story of the powerful Italian-American crime family of Don Vito Corleone.',
    'picture':
        'https://m.media-amazon.com/images/M/MV5BYTJkNGQyZDgtZDQ0NC00MDM0LWEzZWQtYzUzZDEwMDljZWNjXkEyXkFqcGc@.V1.jpg',
    'horizontal_picture': 'https://cdn.europosters.eu/image/750/962.jpg',
    'ratings': 4.1,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 148,
  },
  {
    'id_film': 'F004',
    'judul': 'The Shawshank Redemption',
    'genre': 'Drama',
    'tahun_rilis': '1994',
    'sutradara': 'Frank Darabont',
    'aktor': 'Tim Robbins',
    'deskripsi':
        'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    'picture':
        'https://upload.wikimedia.org/wikipedia/id/8/81/ShawshankRedemptionMoviePoster.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/51whqgtGA4L.AC_UF1000,1000_QL80.jpg',
    'ratings': 4.8,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 128,
  },
  {
    'id_film': 'F005',
    'judul': 'The Dark Knight',
    'genre': 'Action',
    'tahun_rilis': '2008',
    'sutradara': 'Christopher Nolan',
    'aktor': 'Christian Bale',
    'deskripsi':
        'When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.',
    'picture':
        'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQabt5_iESscctssvn8VxDbvnV7i9C42UyLOCWkFdqwJQE0VZYeg2qcXEcYYLh8td8Zna3zA5Nrk7s7SDElRyhKYiIf2AwvJ7F3mKVis5c',
    'horizontal_picture':
        'https://rukminim2.flixcart.com/image/850/1000/jbfe7ww0-1/poster/g/k/c/medium-ashd-wall-poster-batman-the-dark-knight-bat-signal-original-imaet2nugm94hvyj.jpeg?q=20&crop=false',
    'ratings': 4.8,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 106,
  },
  {
    'id_film': 'F006',
    'judul': 'Forrest Gump',
    'genre': 'Drama',
    'tahun_rilis': '1994',
    'sutradara': 'Robert Zemeckis',
    'aktor': 'Tom Hanks',
    'deskripsi':
        'The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal, and other historical events unfold through the perspective of an Alabama man with an IQ of 75.',
    'picture':
        'https://m.media-amazon.com/images/I/91++WV6FP4L.AC_UF894,1000_QL80.jpg',
    'horizontal_picture':
        'https://www.gemakeadilan.com/storage/public/posts/images/o2Cw26lTlwGhn4gXDpC9b4SXlHNGHSuPUD3tqYOf.jpg',
    'ratings': 4.9,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 140,
  },
  {
    'id_film': 'F007',
    'judul': 'The Grand Budapest Hotel',
    'genre': 'Comedy, Drama',
    'tahun_rilis': '2014',
    'sutradara': 'Wes Anderson',
    'aktor': 'Ralph Fiennes',
    'deskripsi':
        'A writer encounters the owner of an aging high-class hotel, who tells him of his early years serving as a lobby boy in the hotel\'s glorious years under an exceptional concierge.',
    'picture':
        'https://upload.wikimedia.org/wikipedia/id/a/a4/Grand_Budapest_Hotel_Movie_Poster.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/71JiBJhmqFL.AC_UF1000,1000_QL80.jpg',
    'ratings': 4.0,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 120,
  },
  {
    'id_film': 'F008',
    'judul': 'Parasite',
    'genre': 'Thriller, Drama',
    'tahun_rilis': '2019',
    'sutradara': 'Bong Joon Ho',
    'aktor': 'Song Kang-ho, Lee Sun-kyun',
    'deskripsi':
        'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
    'picture':
        'https://m.media-amazon.com/images/I/81cYnCyFCYL.AC_UF1000,1000_QL80.jpg',
    'horizontal_picture':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIe6fStcXDp9LGWEWihgvJ63CsSLKq0g_BWg&s',
    'ratings': 4.4,
    'review':
        'A mind-bending thriller with stunning visuals and a complex plot.',
    'trailer': '',
    'durasi': 150,
  },
];

final List<Film> comingSoonFilms = _comingSoonFilms
    .map((e) => Film(
          id_film: e['id_film'] as int,
          judul: e['judul'] as String,
          genre: e['genre'] as String,
          tahun_rilis: e['tahun_rilis'] as int,
          sutradara: e['sutradara'] as String,
          aktor: e['aktor'] as String,
          deskripsi: e['deskripsi'] as String,
          picture: e['picture'] as String,
          horizontal_picture: e['horizontal_picture'] as String,
          review: e['review'] as String? ?? 'No reviews available',
          trailer: e['trailer'] as String,
          durasi: e['durasi'] as int,
        ))
    .toList(growable: false);

final List<Map<String, Object>> _comingSoonFilms = [
  {
    'id_film': 'F014',
    'judul': 'Avengers: Endgame',
    'genre': 'Action, Sci-Fi',
    'tahun_rilis': '2019',
    'sutradara': 'Anthony Russo, Joe Russo',
    'aktor': 'Robert Downey Jr., Chris Evans, Mark Ruffalo, Chris Hemsworth',
    'deskripsi':
        'The Avengers assemble once more to undo the damage caused by Thanos and restore balance to the universe.',
    'picture': 'https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_SY679_.jpg',
    'horizontal_picture':
        'https://scontent.fjog4-1.fna.fbcdn.net/v/t1.6435-9/55485863_10157472280527275_7877149838259781632_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=13d280&_nc_ohc=cr1uxX8i_3EQ7kNvgERE7XE&_nc_zt=23&_nc_ht=scontent.fjog4-1.fna&_nc_gid=Al2FDaU5bar9fNt6zihcbWx&oh=00_AYDs3Lfcz2LVjfLHrfMRptmeo3tI0sTXSq1sZU33lWVTyw&oe=67662A11',
    'ratings': 4.9,
    'review': 'An epic conclusion to the Infinity Saga.',
    'trailer': 'https://www.youtube.com/watch?v=TcMBFSGVi1c',
    'durasi': 181,
  },
  {
    'id_film': 'F015',
    'judul': 'Avengers: Infinity War',
    'genre': 'Action, Sci-Fi',
    'tahun_rilis': '2018',
    'sutradara': 'Anthony Russo, Joe Russo',
    'aktor': 'Robert Downey Jr., Chris Hemsworth, Mark Ruffalo, Chris Evans',
    'deskripsi':
        'The Avengers must stop Thanos, a powerful enemy seeking to collect all six Infinity Stones and reshape the universe.',
    'picture': 'https://m.media-amazon.com/images/I/71eHZFw+GlL._AC_SY879_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/71eHZFw+GlL._AC_SY879_.jpg',
    'ratings': 4.8,
    'review': 'A thrilling and emotional rollercoaster.',
    'trailer': 'https://www.youtube.com/watch?v=6ZfuNTqbHE8',
    'durasi': 149,
  },
  {
    'id_film': 'F016',
    'judul': 'Spider-Man: No Way Home',
    'genre': 'Action, Adventure',
    'tahun_rilis': '2021',
    'sutradara': 'Jon Watts',
    'aktor': 'Tom Holland, Zendaya, Benedict Cumberbatch',
    'deskripsi':
        'Peter Parker seeks help from Doctor Strange to restore his secret identity, but the spell unleashes multiverse chaos.',
    'picture': 'https://m.media-amazon.com/images/I/81Fd1jD8DAL._AC_SY879_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/81Fd1jD8DAL._AC_SY879_.jpg',
    'ratings': 4.7,
    'review': 'A nostalgic and action-packed adventure.',
    'trailer': 'https://www.youtube.com/watch?v=JfVOs4VSpmA',
    'durasi': 148,
  },
  {
    'id_film': 'F017',
    'judul': 'Thor: Ragnarok',
    'genre': 'Action, Adventure, Comedy',
    'tahun_rilis': '2017',
    'sutradara': 'Taika Waititi',
    'aktor': 'Chris Hemsworth, Tom Hiddleston, Cate Blanchett',
    'deskripsi':
        'Thor must prevent Ragnarok and save Asgard from Hela, the goddess of death.',
    'picture': 'https://m.media-amazon.com/images/I/A1HBBNzBdxL._AC_SY879_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/A1HBBNzBdxL._AC_SY879_.jpg',
    'ratings': 4.6,
    'review': 'A perfect blend of humor and action.',
    'trailer': 'https://www.youtube.com/watch?v=ue80QwXMRHg',
    'durasi': 130,
  },
  {
    'id_film': 'F018',
    'judul': 'Venom',
    'genre': 'Action, Sci-Fi',
    'tahun_rilis': '2018',
    'sutradara': 'Ruben Fleischer',
    'aktor': 'Tom Hardy, Michelle Williams',
    'deskripsi':
        'A journalist becomes the host for an alien symbiote, gaining extraordinary abilities.',
    'picture':
        'https://upload.wikimedia.org/wikipedia/en/1/10/Venom_%282018_film%29_poster.png',
    'horizontal_picture':
        'https://upload.wikimedia.org/wikipedia/en/1/10/Venom_%282018_film%29_poster.png',
    'ratings': 4.3,
    'review': 'A dark and thrilling anti-hero story.',
    'trailer': 'https://www.youtube.com/watch?v=u9Mv98Gr5pY',
    'durasi': 112,
  },
  {
    'id_film': 'F019',
    'judul': 'Black Panther',
    'genre': 'Action, Sci-Fi',
    'tahun_rilis': '2018',
    'sutradara': 'Ryan Coogler',
    'aktor': 'Chadwick Boseman, Michael B. Jordan, Lupita Nyong\'o',
    'deskripsi':
        'T\'Challa returns to Wakanda as king but faces challenges that put his nation and the world at risk.',
    'picture':
        'https://m.media-amazon.com/images/I/81I4Mp2s-uL._AC_UF1000,1000_QL80_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/81I4Mp2s-uL._AC_UF1000,1000_QL80_.jpg',
    'ratings': 4.7,
    'review': 'A culturally rich and visually stunning masterpiece.',
    'trailer': 'https://www.youtube.com/watch?v=xjDjIWPwcPU',
    'durasi': 134,
  },
  {
    'id_film': 'F020',
    'judul': 'Captain America: Civil War',
    'genre': 'Action, Sci-Fi',
    'tahun_rilis': '2016',
    'sutradara': 'Anthony Russo, Joe Russo',
    'aktor': 'Chris Evans, Robert Downey Jr., Scarlett Johansson',
    'deskripsi':
        'Political pressure divides the Avengers, leading to a clash between Captain America and Iron Man.',
    'picture':
        'https://m.media-amazon.com/images/I/51+6o1NijCL._AC_UF1000,1000_QL80_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/51+6o1NijCL._AC_UF1000,1000_QL80_.jpg',
    'ratings': 4.6,
    'review': 'A gripping battle of ideologies among heroes.',
    'trailer': 'https://www.youtube.com/watch?v=dKrVegVI0Us',
    'durasi': 147,
  },
  {
    'id_film': 'F021',
    'judul': 'Doctor Strange',
    'genre': 'Action, Fantasy',
    'tahun_rilis': '2016',
    'sutradara': 'Scott Derrickson',
    'aktor': 'Benedict Cumberbatch, Rachel McAdams, Chiwetel Ejiofor',
    'deskripsi':
        'A brilliant neurosurgeon discovers the mystical arts after a tragic accident.',
    'picture':
        'https://m.media-amazon.com/images/I/61AiAr03CiL._AC_UF1000,1000_QL80_.jpg',
    'horizontal_picture':
        'https://m.media-amazon.com/images/I/61AiAr03CiL._AC_UF1000,1000_QL80_.jpg',
    'ratings': 4.5,
    'review':
        'A visually stunning exploration of magic and alternate realities.',
    'trailer': 'https://www.youtube.com/watch?v=Lt-U_t2pUHI',
    'durasi': 115,
  },
];
