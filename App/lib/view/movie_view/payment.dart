import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/formComponent.dart';
import 'package:flutter_application_1/data/penayangan.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/view/movie_view/paymentSuccess.dart';
import 'package:intl/intl.dart';

class Payment extends StatefulWidget {
  final Penayangan usedPenayangan;
  final List<int> seats;
  final Map<String, dynamic> userData;

  const Payment({super.key, required this.usedPenayangan, required this.seats, required this.userData});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController DiscountCodeController = TextEditingController();
  final formatter = NumberFormat('#,###');

  List<Map<String, String>> payment = [
    {
      "image": "images/gopay.png",
      "name": "Gopay",
      "details": "",
    },
    {
      "image": "images/dana.png",
      "name": "Dana",
      "details": "",
    },
    {
      "image": "images/shopeepay.png",
      "name": "Shopee Pay",
      "details": "",
    }
  ];

  String? selectedPayment = "Gopay";

  List<String>? listSeat;

  List<String> convertSeatNumbers(List<int> seats) {
    return seats.map((seat) {
      if (seat < 10) {
        return 'A${seat + 1}'; // Kursi A dimulai dari A1, bukan A0
      } else {
        // Hitung karakter baris berdasarkan hasil pembagian seat dengan 10
        final row = String.fromCharCode(65 + (seat ~/ 10));
        final column = (seat % 10); // Kolom dimulai dari 1
        return '$row$column';
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Pastikan `widget.seats` adalah List<int> dan tidak null
    listSeat = convertSeatNumbers(widget.seats.whereType<int>().toList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Payment', style: textStyle7),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 54, 54, 54),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network("${widget.usedPenayangan.film!.poster_1}",
                              width: 100, height: 140),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.usedPenayangan.film!.judul}',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.movie_creation_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text("${widget.usedPenayangan.film!.genre}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_city_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        "${widget.usedPenayangan.bioskop!.namaBioskop}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        "${widget.usedPenayangan.tanggal_tayang}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order ID",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                          SizedBox(width: 30),
                          Text("2202987203803",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Seat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                          SizedBox(width: 30),
                          Expanded(
                            child: Text(
                              "${listSeat.toString()}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true, // Properti ini pada widget Text
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(255, 58, 58, 58),
                              iconColor: Colors.white,
                              prefixIcon: Icon(Icons.discount,
                                  color: Colors.white, size: 16),
                              hintText: 'Masukkan kode diskon',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.white), // Warna garis bawah saat tidak fokus
                              // ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),

                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0), // Warna border saat fokus
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Sesuaikan nilai radius
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 17, horizontal: 20),
                          ),
                          onPressed: () {
                            // Proses kode diskon
                          },
                          child: Text('Apply',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white, // Warna border
                            width: 1.0, // Ketebalan border
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                          Text(
                              "Rp. ${formatter.format(widget.seats.length * widget.usedPenayangan.harga_tiket)}",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Payment Method",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    SizedBox(height: 10),
                    Column(
                      children: List.generate(payment.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPayment = payment[index]["name"];
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: (selectedPayment ==
                                            payment[index]["name"]
                                        ? Color.fromRGBO(151, 118, 7, 0.479)
                                        : const Color.fromARGB(
                                            255, 51, 51, 51)),
                                    border: Border(
                                      top: BorderSide(
                                        color: (selectedPayment ==
                                                payment[index]["name"]
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                0, 0, 0, 0)), // Warna border
                                        width: 1.0, // Ketebalan border
                                      ),
                                      bottom: BorderSide(
                                        color: (selectedPayment ==
                                                payment[index]["name"]
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                0, 0, 0, 0)), // Warna border
                                        width: 1.0, // Ketebalan border
                                      ),
                                      right: BorderSide(
                                        color: (selectedPayment ==
                                                payment[index]["name"]
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                0, 0, 0, 0)), // Warna border
                                        width: 1.0, // Ketebalan border
                                      ),
                                      left: BorderSide(
                                        color: (selectedPayment ==
                                                payment[index]["name"]
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                0, 0, 0, 0)), // Warna border
                                        width: 1.0, // Ketebalan border
                                      ),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            '${payment[index]["image"]}',
                                            width: 100,
                                            height: 50,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (payment[index]["details"] !=
                                                  "") ...[
                                                Text(
                                                    '${payment[index]["name"]}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    )),
                                                Text(
                                                    '${payment[index]["details"]}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ))
                                              ] else ...[
                                                Text(
                                                    '${payment[index]["name"]}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ))
                                              ]
                                            ],
                                          )
                                        ],
                                      ),
                                      Icon(Icons.navigate_next,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(223, 87, 73, 37),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Complete your payment in",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute).add(Duration(minutes: 15)))}",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
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
                    builder: (context) => PaymentSuccess(
                        listSeats: listSeat,
                        penayangan: widget.usedPenayangan,
                        userData: widget.userData,
                        seats: widget.seats,
                        metode_pembayaran: selectedPayment,
                        nominal_pembayaran: (widget.usedPenayangan.harga_tiket.toDouble()*widget.seats.length),),
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
    ));
  }
}
