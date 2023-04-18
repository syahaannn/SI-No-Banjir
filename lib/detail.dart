import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  //API dari db untuk proses read data lokasi
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/get.php"));
    return json.decode(response.body);
  }

  //API dari db untuk proses read data detail
  Future<List<dynamic>> getDetail(String nodeid) async {
    final response = await http
        .get(Uri.parse("http://10.0.2.2/no-banjir/detail.php?node_id=$nodeid"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {

    //argumen berupa data list lokasi dimasukkan ke dalam list
    dynamic list = ModalRoute.of(context)!.settings.arguments;
    String node = list[0]['node_id'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("NO BANJIR"),
      ),
      //data dimasukkan ke dalam list
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


//class drawlist berisi data lokasi dari API yang dimasukkan ke dalam drawer
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

//class untuk inisiasi tipe data dari chart
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {

    //data dari curah hujan dimasukkan ke dalam chart pertama
    final List<ChartData> chartData = [
      for (int i = 0; i < (widget.detail.length); i++)
        ChartData(widget.detail[i]['tanggal'],
            double.parse(widget.detail[i]['curah_hujan']))
    ];

    //data dari tinggi air dimasukkan ke dalam chart kedua
    final List<ChartData> chartData2 = [
      for (int i = 0; i < (widget.detail.length); i++)
        ChartData(widget.detail[i]['tanggal'],
            double.parse(widget.detail[i]['tinggi_air']))
    ];
    if (widget.detail.length != 0) {
      //jika data tidak kosong maka lakukan
      return Scaffold(
          body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.topLeft,
              child: Text(
                (widget.detail[0]['nama_loc']).toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Data Terkini',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),

                //container berikut berfungsi menampung 
                //data tinggi air yang terakhir
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1),
                            right: BorderSide(color: Colors.grey, width: 1),
                            left: BorderSide(color: Colors.grey, width: 1)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            'Ketinggian Air',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.detail[widget.detail.length - 1]
                                ['tinggi_air'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),

                  //container berikut berfungsi menampung 
                  //data curah hujan yang terakhir
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1),
                            right: BorderSide(color: Colors.grey, width: 1),
                            left: BorderSide(color: Colors.grey, width: 1)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            'Curah Hujan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.detail[widget.detail.length - 1]
                                ['curah_hujan'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //container untuk membuat legenda pada chart
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red[100],
                                border: Border(
                                    top:
                                        BorderSide(color: Colors.red, width: 1),
                                    bottom:
                                        BorderSide(color: Colors.red, width: 1),
                                    right:
                                        BorderSide(color: Colors.red, width: 1),
                                    left: BorderSide(
                                        color: Colors.red, width: 1))),
                            child: SizedBox(
                              height: 10,
                              width: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            'Ketinggian Air',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.blue, width: 1),
                                    bottom: BorderSide(
                                        color: Colors.blue, width: 1),
                                    right: BorderSide(
                                        color: Colors.blue, width: 1),
                                    left: BorderSide(
                                        color: Colors.blue, width: 1))),
                            child: SizedBox(
                              height: 10,
                              width: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text('Curah Hujan',
                              style: TextStyle(fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 300,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: SfCartesianChart(
                          trackballBehavior: TrackballBehavior(
                              lineType: TrackballLineType.none,
                              enable: true,
                              tooltipSettings: InteractiveTooltip(
                                  enable: true, color: Colors.black)),
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries<ChartData, String>>[
                            // Renders column chart

                            //chart pertama untuk melakukan visualisasi data
                            //dari tinggi air
                            LineSeries<ChartData, String>(
                              markerSettings: MarkerSettings(
                                  height: 6,
                                  width: 6,
                                  isVisible: true,
                                  color: Colors.blue),
                              color: Colors.blue,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                            ),

                            //chart kedua untuk melakukan visualisasi data 
                            //dari curah hujan
                            LineSeries<ChartData, String>(
                                markerSettings: MarkerSettings(
                                    height: 6,
                                    width: 6,
                                    isVisible: true,
                                    color: Colors.red),
                                color: Colors.red,
                                dataSource: chartData2,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y),
                          ])),
                )),
          ],
        ),
      ));
    } else {
      return Center(
        //jika data kosong
        child: Text('Data Kosong'),
      );
    }
  }
}
