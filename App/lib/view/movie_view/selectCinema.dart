import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/component/formComponent.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/data/bioskop.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/client/BioskopClient.dart';
import 'package:flutter_application_1/view/movie_view/selectSeat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCinema extends StatefulWidget {
  final Film film;
  final Map<String, dynamic> userData;
  const SelectCinema({super.key, required this.film, required this.userData});

  @override
  State<SelectCinema> createState() => _SelectCinemaState();
}

class _SelectCinemaState extends State<SelectCinema> {
  int selectedCinema = 0;
  Bioskop? bioskop = null;
  Future<List<Bioskop>> cinema = BioskopClient().fetchBioskops();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Nearby Cinema', style: textStyle7),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: FutureBuilder<List<Bioskop>>(
                future: cinema,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Tampilkan indikator loading saat Future belum selesai
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Tampilkan pesan error jika Future gagal
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Tampilkan pesan jika tidak ada data
                    return Center(
                      child: Text(
                        'No cinemas available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final cinemas = snapshot.data!;
                  bioskop = cinemas[0];

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(cinemas.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCinema = index;
                              bioskop = cinemas[index];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: (selectedCinema == index
                                    ? Color.fromRGBO(151, 118, 7, 0.479)
                                    : Color.fromRGBO(31, 31, 31, 1)),
                                border: Border(
                                  top: BorderSide(
                                    color: (selectedCinema == index
                                        ? Colors.amber
                                        : const Color.fromARGB(
                                            0, 0, 0, 0)), // Warna border
                                    width: 1.0, // Ketebalan border
                                  ),
                                  bottom: BorderSide(
                                    color: (selectedCinema == index
                                        ? Colors.amber
                                        : const Color.fromARGB(
                                            0, 0, 0, 0)), // Warna border
                                    width: 1.0, // Ketebalan border
                                  ),
                                  right: BorderSide(
                                    color: (selectedCinema == index
                                        ? Colors.amber
                                        : const Color.fromARGB(
                                            0, 0, 0, 0)), // Warna border
                                    width: 1.0, // Ketebalan border
                                  ),
                                  left: BorderSide(
                                    color: (selectedCinema == index
                                        ? Colors.amber
                                        : const Color.fromARGB(
                                            0, 0, 0, 0)), // Warna border
                                    width: 1.0, // Ketebalan border
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cinemas[index].namaBioskop}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${5}km | ${cinemas[index].alamat}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
          ),
        ),
        bottomNavigationBar: Container(
          child: BottomAppBar(
            color: Colors.black,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectSeat(
                        film: widget.film, // Akses langsung properti film
                        bioskop: bioskop!,
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
