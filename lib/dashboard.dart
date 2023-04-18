import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  //API dari db untuk melakukan read data
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/get.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NO BANJIR"),
      ),

      //data dari API dimasukkan ke dalam list melalui builder
      drawer: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {

              //data dikirimkan ke class DrawList sebagai parameter
              return DrawList(list: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),

      //data dari API dimasukkan ke dalam list melalui builder
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {

              ///data dikirimkan ke class ItemList sebagai parameter
              return ItemList(list: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}

class DrawList extends StatefulWidget {

  //data dimasukkan ke dalam list
  final List<dynamic> list;
  const DrawList({super.key, required this.list});

  @override
  State<DrawList> createState() => _DrawListState();
}

class _DrawListState extends State<DrawList> {
  @override
  Widget build(BuildContext context) {

    //argumen dari dashboard dimasukkan ke dalam variabel username
    String username = ModalRoute.of(context)!.settings.arguments.toString();
    if (widget.list != null) {

      //membuat sebuah drawer
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(

                        //username dimasukkan ke drawer
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    )
                  ],
                )),
            ListTile(
              leading: Icon(Icons.dashboard),

              //sebuah drawer yang mengarahkan ke halaman dashboard dan
              //mengirimkan argumen berupa username
              title: Text('Dashboard'),
              onTap: () => Navigator.pushNamed(context, '/dashboard',
                  arguments: username),
            ),
            ExpansionTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Grafik'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {

                    //drawer yang berisikan data dari API berupa data lokasi
                    //mengarahkan ke halaman detail untuk grafik
                    //mengirimkan argumen berupa list dari lokasi dan username
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(widget.list[index]['nama_loc']),
                      onTap: () => Navigator.pushNamed(context, '/detail',
                          arguments: [widget.list[index], username]),
                    );
                  },
                )
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.file_copy),
              title: Text('Data'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {

                    ///drawer yang berisikan data dari API berupa data lokasi
                    //mengarahkan ke halaman log untuk tabel
                    //mengirimkan argumen berupa list dari lokasi dan username
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(widget.list[index]['nama_loc']),
                      onTap: () => Navigator.pushNamed(context, '/log',
                          arguments: [widget.list[index], username]),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('Tambah Lokasi'),
              onTap: () =>

              //menavigasi user ke halaman add untuk menambah data lokasi
              //mengirimkan argumen berupa username
                  Navigator.pushNamed(context, '/add', arguments: username),
            )
          ],
        ),
      );
    } else {
      return Text(" No Data");
    }
  }
}

class ItemList extends StatefulWidget {

  //data dari API dimasukkan ke dalam list
  final List<dynamic> list;
  const ItemList({super.key, required this.list});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  //controller untuk googlemaps
  Completer<GoogleMapController> _controller = Completer();

  //inisiasi latlng untuk lokasi utama
  static const LatLng showLocation =
      const LatLng(-1.6260508541637144, 103.63029880957276);

      //set untuk marker
  final Set<Marker> markers = new Set();
  @override
  Widget build(BuildContext context) {

    //argumen dari halaman login dimasukan ke dalam variabel username
    String username = ModalRoute.of(context)!.settings.arguments.toString();

    //menggunakan widget googlemap
    return GoogleMap(
      markers: getmarkers(),
      mapType: MapType.normal,

      //posisi awal kamera pada maps
      initialCameraPosition: CameraPosition(target: showLocation, zoom: 13.00),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }


  //set untuk memasukkan marker
  Set<Marker> getmarkers() {

    //argumen dari dashboard
    String username = ModalRoute.of(context)!.settings.arguments.toString();
    setState(() {

      //perulangan sebagai ganti index untuk memasukkan data dari API ke marker
      for (int i = 0; i < widget.list.length; i++)

      //menambahkan data ke dalam marker dengan fungsi add
        markers.add(Marker(
            markerId: MarkerId(showLocation.toString()),
            position: LatLng(double.parse(widget.list[i]['latitude']),
                double.parse(widget.list[i]['longitude'])),
            infoWindow: InfoWindow(
              title: widget.list[i]['nama_loc'],
              onTap: () => Navigator.pushNamed(context, '/detail',
                  arguments: [widget.list[i], username]),
            ),
            icon: BitmapDescriptor.defaultMarker));
      
    });

    return markers;
  }
}
