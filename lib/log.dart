import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

  //API dari db untuk read data lokasi
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/get.php"));
    return json.decode(response.body);
  }

  //API dari db untuk read data detail
  Future<List<dynamic>> getDetail(String nodeid) async {
    final response = await http
        .get(Uri.parse("http://10.0.2.2/no-banjir/detail.php?node_id=$nodeid"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {

    //argumen list lokasi dimasukkan ke dalam list
    dynamic list = ModalRoute.of(context)!.settings.arguments;
    String node = list[0]['node_id'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("NO BANJIR"),
      ),
      drawer: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {
              return DrawList(list: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
      body: FutureBuilder<List>(
        future: getDetail(node),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {
              return ItemList(detail: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}

//class drawlist berfungsi untuk membuat drawer yang berisi data dari lokasi
//yang akan diarahkan ke halaman log dan detail
class DrawList extends StatefulWidget {
  final List<dynamic> list;
  const DrawList({super.key, required this.list});

  @override
  State<DrawList> createState() => _DrawListState();
}

class _DrawListState extends State<DrawList> {
  @override
  Widget build(BuildContext context) {
    dynamic list = ModalRoute.of(context)!.settings.arguments;
    String username = list[1].toString();
    if (widget.list != null) {
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
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(widget.list[index]['nama_loc']),
                      onTap: () => Navigator.pushNamed(context, '/log',
                          arguments: [widget.list[index], username]),
                    );
                  },
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('Tambah Lokasi'),
              onTap: () =>
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
  final List<dynamic> detail;
  const ItemList({Key? key, required this.detail}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    if (widget.detail.length != 0) {
      //jika data tidak kosong
      return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                (widget.detail[0]['nama_loc']).toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Data Log',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    headingRowHeight: 34,
                    dataRowHeight: 28,
                    border: TableBorder(
                      borderRadius: BorderRadius.circular(5),
                      right: BorderSide(width: 1, color: Colors.grey),
                      left: BorderSide(width: 1, color: Colors.grey),
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 1, color: Colors.grey),
                      verticalInside: BorderSide(width: 1, color: Colors.grey),
                      horizontalInside:
                          BorderSide(width: 1, color: Colors.grey),
                    ),
                    columns: <DataColumn>[
                      DataColumn(
                          label: Text(
                        'No',
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(label: Center(child: Text('Tanggal'))),
                      DataColumn(
                          label: Center(child: Text('Ketinggian Air (cm)'))),
                      DataColumn(label: Center(child: Text('Curah Hujan'))),
                    ],
                    rows: <DataRow>[
                      //perulangan untuk index
                      for (int i = 0; i < widget.detail.length; i++)
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                                  //perulangan untuk kolom no
                              (i + 1).toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                            DataCell(Center(
                              //data tanggal dimasukkan ke dalam row
                                child: Text(widget.detail[i]['tanggal']))),
                            DataCell(Center(
                              //data tinggi air dimasukkan ke dalam row
                                child: Text(widget.detail[i]['tinggi_air']))),
                            DataCell(Center(
                              //data curah hujan dimasukkan ke dalam row
                                child: Text(widget.detail[i]['curah_hujan']))),
                          ],
                        ),
                    ])),
          ],
        ),
      );
    } else {
      return Center(
        //jika data kosong
        child: Text('Data Kosong'),
      );
    }
  }
}
