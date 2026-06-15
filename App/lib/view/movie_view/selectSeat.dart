import 'package:flutter_application_1/client/PenayanganClient.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/data/penayangan.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/data/bioskop.dart';
import 'package:flutter_application_1/view/movie_view/payment.dart';

class SelectSeat extends StatefulWidget {
  final Film film;
  final Bioskop bioskop;
  final Map<String, dynamic> userData;

  const SelectSeat(
      {super.key,
      required this.film,
      required this.bioskop,
      required this.userData});

  @override
  State<SelectSeat> createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  int price = 50000;
  final formatter = NumberFormat('#,###');

  DateTime? selectedDate;
  int? selectedSesiId;
  late int id_film;
  late int id_bioskop;
  int? activePenayanganId;

  List<dynamic> statusSeat = List.filled(100, 'available');
  List<int> selectedSeats = [];

  late Future<List<Penayangan>> penayangan;
  Penayangan? usedPenayangan;

  @override
  void initState() {
    super.initState();
    penayangan = PenayanganClient().fetchByFilm(widget.film.id_film!);
    id_film = widget.film.id_film!;
    id_bioskop = widget.bioskop.idBioskop!;
    statusSeat = List.filled(100, 'available');
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatSessionTime(String? time) {
    if (time == null || time.length < 5) {
      return '--:--';
    }

    return time.substring(0, 5);
  }

  Penayangan? searchPenayangan(List<Penayangan> datas, int id_bioskop,
      int id_film, int id_sesi, DateTime tanggal_tayang) {
    final normalizedSelectedDate = _normalizeDate(tanggal_tayang);

    for (var i = 0; i < datas.length; i++) {
      if (datas[i].bioskop!.idBioskop == id_bioskop &&
          datas[i].id_film == id_film &&
          datas[i].id_sesi == id_sesi &&
          datas[i].tanggal_tayang != null &&
          _normalizeDate(datas[i].tanggal_tayang!) == normalizedSelectedDate) {
        return datas[i];
      }
    }

    return null;
  }

  void refreshSeat() {
    statusSeat = [];
    selectedSeats = [];
    statusSeat = List.filled(100, 'available');
  }

  List<Penayangan> _availableScreenings(List<Penayangan> datas) {
    final screenings = datas.where((item) {
      return item.bioskop?.idBioskop == id_bioskop &&
          item.status == 'Available';
    }).toList();

    screenings.sort((a, b) {
      final dateCompare = a.tanggal_tayang!.compareTo(b.tanggal_tayang!);
      if (dateCompare != 0) {
        return dateCompare;
      }

      return (a.id_sesi ?? 0).compareTo(b.id_sesi ?? 0);
    });

    return screenings;
  }

  void _ensureSelection(List<Penayangan> screenings) {
    if (screenings.isEmpty) {
      usedPenayangan = null;
      activePenayanganId = null;
      refreshSeat();
      return;
    }

    final availableDates = screenings
        .map((item) => _normalizeDate(item.tanggal_tayang!))
        .fold<List<DateTime>>([], (dates, date) {
      final exists = dates.any((item) => item == date);
      if (!exists) {
        dates.add(date);
      }
      return dates;
    });

    if (selectedDate == null ||
        !availableDates.any((date) => date == _normalizeDate(selectedDate!))) {
      selectedDate = availableDates.first;
    }

    final sessionsForDate = screenings
        .where((item) =>
            _normalizeDate(item.tanggal_tayang!) ==
            _normalizeDate(selectedDate!))
        .toList();

    if (selectedSesiId == null ||
        !sessionsForDate.any((item) => item.id_sesi == selectedSesiId)) {
      selectedSesiId = sessionsForDate.first.id_sesi;
    }

    usedPenayangan = searchPenayangan(
      screenings,
      id_bioskop,
      id_film,
      selectedSesiId!,
      selectedDate!,
    );

    if (usedPenayangan?.id_penayangan != activePenayanganId) {
      activePenayanganId = usedPenayangan?.id_penayangan;
      refreshSeat();

      if (usedPenayangan != null &&
          usedPenayangan!.nomor_kursi_terpakai != null &&
          usedPenayangan!.nomor_kursi_terpakai!.isNotEmpty) {
        final userSeat = usedPenayangan!.nomor_kursi_terpakai!
            .split(',')
            .where((seat) => seat.isNotEmpty)
            .map((seat) => int.parse(seat))
            .toList();

        for (int i = 1; i <= 100; i++) {
          if (userSeat.contains(i)) {
            statusSeat[i - 1] = 'reserved';
          }
        }
      }
    }

    price = (usedPenayangan?.harga_tiket ?? 50000).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('${widget.bioskop.namaBioskop}', style: textStyle7),
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
            child: FutureBuilder<List<Penayangan>>(
                future: penayangan,
                builder: (context, PenayanganSnapshot) {
                  if (PenayanganSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (PenayanganSnapshot.hasError) {
                    print('Error: ${PenayanganSnapshot.error}');
                    return Center(
                        child: Text(
                      'Error: ${PenayanganSnapshot.error}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Asumsikan whiteColor adalah Colors.white
                      ),
                      softWrap: true, // Properti ini pada widget Text
                      overflow: TextOverflow.visible,
                    ));
                  } else if (!PenayanganSnapshot.hasData) {
                    return Center(
                        child: Text(
                      'No data available.',
                      style: TextStyle(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ));
                  } else if (PenayanganSnapshot.hasData) {
                    final List<Penayangan> PenayanganData =
                        PenayanganSnapshot.data!;
                    final screenings = _availableScreenings(PenayanganData);
                    _ensureSelection(screenings);

                    return _mainWidget(screenings);
                  } else {
                    return Center(
                        child: Text(
                      'Unknown Error',
                      style: TextStyle(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ));
                  }
                }),
          ),
          bottomNavigationBar: _bottomWidget()),
    );
  }

  Widget _bottomWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey, // Warna border
            width: 1.0, // Ketebalan border
          ),
        ),
      ),
      child: BottomAppBar(
        color: Colors.black,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \nRp. ${formatter.format(statusSeat.where((seat) => seat == 'selected').length * price)}.00',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed:
                    statusSeat.where((seat) => seat == 'selected').length > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Payment(
                                    usedPenayangan: usedPenayangan!,
                                    seats: selectedSeats,
                                    userData: widget.userData),
                              ),
                            );
                          }
                        : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (statusSeat.where((seat) => seat == 'selected').length > 0
                          ? Colors.amber
                          : Colors.grey),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Buy Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainWidget(dataPenayangan) {
    final List<Penayangan> screenings = List<Penayangan>.from(dataPenayangan);
    final availableDates = screenings
        .map((item) => _normalizeDate(item.tanggal_tayang!))
        .fold<List<DateTime>>([], (dates, date) {
      final exists = dates.any((item) => item == date);
      if (!exists) {
        dates.add(date);
      }
      return dates;
    });
    final sessionsForDate = screenings
        .where((item) =>
            selectedDate != null &&
            _normalizeDate(item.tanggal_tayang!) ==
                _normalizeDate(selectedDate!))
        .toList();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.amber, // Warna border
                      width: 3.0, // Ketebalan border
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text("\n"),
                  ],
                )),
            SizedBox(height: 24),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (usedPenayangan != null)
                      ? (Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 310,
                              child: GridView.count(
                                crossAxisCount: 5,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                children: List.generate(50, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Jika kursi available, ubah menjadi selected
                                        if (statusSeat[(10 * (index ~/ 5) +
                                                (index % 5))] ==
                                            'available') {
                                          statusSeat[(10 * (index ~/ 5) +
                                              (index % 5))] = 'selected';
                                          selectedSeats.add((10 * (index ~/ 5) +
                                                  (index % 5)) +
                                              1);
                                        } else if (statusSeat[
                                                (10 * (index ~/ 5) +
                                                    (index % 5))] ==
                                            'selected') {
                                          // Jika kursi selected, ubah kembali ke available
                                          statusSeat[(10 * (index ~/ 5) +
                                              (index % 5))] = 'available';
                                          selectedSeats.remove(
                                              (10 * (index ~/ 5) +
                                                      (index % 5)) +
                                                  1);
                                        }
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 13,
                                      height: 13,
                                      decoration: BoxDecoration(
                                        color: (statusSeat[(10 * (index ~/ 5) +
                                                    (index % 5))] ==
                                                'available'
                                            ? (Color.fromARGB(255, 55, 55, 55))
                                            : (statusSeat[(10 * (index ~/ 5) +
                                                        (index % 5))] ==
                                                    'reserved'
                                                ? Color.fromRGBO(
                                                    243, 198, 49, 0.604)
                                                : Colors.amber)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Text(
                                          '${String.fromCharCode(65 + (index ~/ 5))}${(index % 5) + 1}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: (statusSeat[
                                                        (10 * (index ~/ 5) +
                                                            (index % 5))] ==
                                                    'available'
                                                ? Colors.white
                                                : Colors.black),
                                          )),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 310,
                              child: GridView.count(
                                crossAxisCount: 5,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                children: List.generate(50, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Jika kursi available, ubah menjadi selected
                                        if (statusSeat[(10 * (index ~/ 5) +
                                                    (index % 5)) +
                                                5] ==
                                            'available') {
                                          statusSeat[(10 * (index ~/ 5) +
                                                  (index % 5)) +
                                              5] = 'selected';
                                          selectedSeats.add((10 * (index ~/ 5) +
                                                  (index % 5)) +
                                              5 +
                                              1);
                                        } else if (statusSeat[
                                                (10 * (index ~/ 5) +
                                                        (index % 5)) +
                                                    5] ==
                                            'selected') {
                                          // Jika kursi selected, ubah kembali ke available
                                          statusSeat[(10 * (index ~/ 5) +
                                                  (index % 5)) +
                                              5] = 'available';
                                          selectedSeats.remove(
                                              (10 * (index ~/ 5) +
                                                      (index % 5)) +
                                                  5 +
                                                  1);
                                        }
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 13,
                                      height: 13,
                                      decoration: BoxDecoration(
                                        color: (statusSeat[(10 * (index ~/ 5) +
                                                        (index % 5)) +
                                                    5] ==
                                                'available'
                                            ? (Color.fromARGB(255, 55, 55, 55))
                                            : (statusSeat[(10 * (index ~/ 5) +
                                                            (index % 5)) +
                                                        5] ==
                                                    'reserved'
                                                ? Color.fromRGBO(
                                                    243, 198, 49, 0.604)
                                                : Colors.amber)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Text(
                                          '${String.fromCharCode(65 + (index ~/ 5))}${(index % 5) + 6}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: (statusSeat[
                                                        (10 * (index ~/ 5) +
                                                                (index % 5)) +
                                                            5] ==
                                                    'available'
                                                ? Colors.white
                                                : Colors.black),
                                          )),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ))
                      : (Center(
                          child: Text(
                          'Penayangan sedang tidak tersedia!',
                          style: TextStyle(
                            fontSize: 20,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            color: Color.fromRGBO(97, 97, 97, 1),
                          ),
                          SizedBox(width: 5),
                          Text("Available",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            color: Color.fromRGBO(243, 198, 49, 0.604),
                          ),
                          SizedBox(width: 5),
                          Text("Reserved",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 5),
                          Text("Selected",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Select Date & Time", style: textStyle7),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(availableDates.length, (index) {
                        final date = availableDates[index];
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = date;
                                  refreshSeat();
                                  selectedSesiId = null;
                                  activePenayanganId = null;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    top: 10, left: 3, right: 3, bottom: 3),
                                decoration: BoxDecoration(
                                  color: (selectedDate != null &&
                                          _normalizeDate(selectedDate!) == date
                                      ? Colors.amber
                                      : Color.fromARGB(255, 44, 44, 44)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateFormat('MMM').format(date),
                                        style: TextStyle(
                                          color: (selectedDate != null &&
                                                  _normalizeDate(
                                                          selectedDate!) ==
                                                      date
                                              ? Colors.black
                                              : Colors.white),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(height: 15),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (selectedDate != null &&
                                                _normalizeDate(selectedDate!) ==
                                                    date
                                            ? const Color.fromARGB(
                                                255, 32, 30, 30)
                                            : Color.fromARGB(255, 81, 81, 81)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      child: Text(DateFormat('dd').format(date),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10)
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(sessionsForDate.length, (index) {
                        final screening = sessionsForDate[index];
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  refreshSeat();
                                  selectedSesiId = screening.id_sesi;
                                  activePenayanganId = null;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: (selectedSesiId == screening.id_sesi
                                      ? Colors.amber
                                      : Color.fromARGB(255, 44, 44, 44)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Text(
                                    "${_formatSessionTime(screening.sesi?.jam_mulai)} - ${_formatSessionTime(screening.sesi?.jam_selesai)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          (selectedSesiId == screening.id_sesi
                                              ? Colors.black
                                              : Colors.white),
                                      fontSize: 12,
                                    )),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        );
                      }),
                    ),
                  ),
                  // _debugText(dataPenayangan),
                ],
              ),
            ),
            // layar
            // kursi
            // keterangan
          ],
        ),
      ),
    );
  }
}

class NarrowLayout extends StatelessWidget {
  const NarrowLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
