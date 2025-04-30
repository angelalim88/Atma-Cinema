import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:flutter_application_1/client/TicketClient.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/view/ticket_view/ticketPDF.dart';

final listTicketProvider =
    FutureProvider.family<List<Ticket>, int>((ref, userId) async {
  return await TicketClient().fetchOnlyUsers(userId);
});

class TicketView extends ConsumerStatefulWidget {
  const TicketView({super.key, required this.data});

  final Map<String, dynamic> data; // data contains the user ID

  @override
  _TicketViewState createState() => _TicketViewState();
}


class _TicketViewState extends ConsumerState<TicketView> {
  String _filter = 'Available';
   late int userId;
   
   void initState() {
    super.initState();
    userId = widget.data['id_user'];
    _refreshPage(); // Call this method to refresh on access
  }

  void _refreshPage() {
    // Assign a unique key to force widget rebuild
    setState(() {
      ref.refresh(listTicketProvider(userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.data['id_user'];
    final ticketsAsync = ref.watch(listTicketProvider(userId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildTicketLayout(ticketsAsync)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _filter = 'Available';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _filter == 'Available' ? lightColor : darkColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ongoing',
                style: TextStyle(
                  color: _filter == 'Available' ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _filter = 'Not Available';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _filter == 'Not Available' ? lightColor : darkColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'History',
                style: TextStyle(
                  color:
                      _filter == 'Not Available' ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketLayout(AsyncValue<List<Ticket>> ticketsAsync) {
  return ticketsAsync.when(
    data: (tickets) {
      // Filter tickets based on the current filter
      final filteredTickets = tickets.where((ticket) {
        final status = ticket.penayangan?.status ?? 'Unknown';
        if (_filter == 'Available') {
          return status == 'Available';
        } else {
          return status == 'Not Available';
        }
      }).toList();

      return ListView.builder(
        itemCount: filteredTickets.length,
        itemBuilder: (context, index) {
          final ticket = filteredTickets[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color.fromARGB(255, 30, 30, 30),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketPdfPage(ticket: ticket),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: Image.network(
                            ticket.film?.poster_1 ?? 'https://via.placeholder.com/100x150',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Ticket Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Title
                            Text(
                              ticket.film?.judul ?? 'Unknown Movie',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: lightColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Genre
                            Text(
                              ticket.film?.genre ?? 'Unknown Genre',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Cinema Name
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.white70),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '${ticket.bioskop?.namaBioskop}' ?? 'Unknown Cinema',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.theaters, size: 14, color: Colors.white70),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '${ticket.studio!.nama_studio}, ${ticket.nomorKursi}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Date and Time
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                                const SizedBox(width: 5),
                                Text(
                                  '${ticket.penayangan?.tanggal_tayang.toString().substring(0, 10) ?? 'Unknown Date'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  ticket.sesi?.jam_mulai ?? 'Unknown Time',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Status
                           Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ticket.penayangan?.status == 'Available'
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ticket.penayangan?.status == 'Available' ? 'Ongoing' : 'Watched',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) => Center(child: Text('Error: $error')),
  );
}

}
