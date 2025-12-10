import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Bus {
  final String nama;
  final String rute;
  final String jam;
  final String harga;
  final int kursi;

  Bus({
    required this.nama,
    required this.rute,
    required this.jam,
    required this.harga,
    required this.kursi,
  });
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Bus> _buses = [
    Bus(
      nama: 'Sinar Jaya',
      rute: 'Jakarta - Bandung',
      jam: '08:00 - 10:30',
      harga: 'Rp 150.000',
      kursi: 42,
    ),
    Bus(
      nama: 'Haryanto',
      rute: 'Jakarta - Surabaya',
      jam: '20:00 - 08:00',
      harga: 'Rp 350.000',
      kursi: 46,
    ),
    Bus(
      nama: 'Cipaganti',
      rute: 'Bandung - Yogyakarta',
      jam: '09:00 - 15:30',
      harga: 'Rp 200.000',
      kursi: 40,
    ),
  ];

  final List<String> _bookings = [];
  final TextEditingController _nameController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _bookBus(Bus bus) {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _bookings.add('${_nameController.text} - ${bus.nama} (${bus.rute})');
        _nameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pemesanan ${bus.nama} berhasil!')),
      );
    }
  }

  void _cancelBooking(int index) {
    setState(() {
      _bookings.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Halaman Beranda
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_bus, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang di\nAplikasi Pemesanan Tiket Bus',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesan tiket bus Anda sekarang!')),
                );
              },
              child: const Text('Mulai Pesan'),
            ),
          ],
        ),
      ),
      // Halaman Daftar Bus
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Daftar Bus Tersedia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _buses.length,
                itemBuilder: (context, index) {
                  final bus = _buses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.directions_bus, 
                        color: Colors.orange, size: 40),
                      title: Text(
                        bus.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bus.rute),
                          Text('${bus.jam}'),
                          Text(
                            bus.harga,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Pesan ${bus.nama}'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Nama Penumpang',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _bookBus(bus);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Pesan'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Pesan'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Halaman Pemesanan Saya
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pemesanan Saya',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _bookings.isEmpty
                  ? const Center(
                      child: Text('Belum ada pemesanan'),
                    )
                  : ListView.builder(
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: const Icon(Icons.check_circle, 
                              color: Colors.green),
                            title: Text(_bookings[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => _cancelBooking(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Booking App'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Bus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'Pemesanan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}