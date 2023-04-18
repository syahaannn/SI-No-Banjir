import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //future list getdata() berfungsi sebagai API dari database
  //untuk mengambil data melalui json
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/login.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),

      // data dari getdata() dimasukkan ke dalam sebuah builder
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {
              return Login(list: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}

class Login extends StatefulWidget {

  //data dari builder dimasukkan ke sebuah list dynamic dengan nama list
  final List<dynamic> list;
  const Login({super.key, required this.list});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //untuk menampung username dan password
  TextEditingController textControllerUsername = TextEditingController();
  TextEditingController textControllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: textControllerUsername,
                decoration: InputDecoration(
                    hintText: 'Inputkan Username', icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan username';
                  }
                },
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: textControllerPassword,
                decoration: InputDecoration(
                    hintText: 'Inputkan Password', icon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan password';
                  }
                },
              )),
          ElevatedButton(
              onPressed: () {

                //proses login, jika username dan password sama dengan yang ada
                //di db, user akan dinavigasi ke halaman dashboard
                for (int i = 0; i < widget.list.length; i++)
                  if ((widget.list[i]['username']) ==
                          textControllerUsername.text &&
                      (widget.list[i]['password']) ==
                          textControllerPassword.text) {

                            //argumen username dikirimkan ke halaman dashboard
                    Navigator.pushNamed(context, '/dashboard',
                        arguments: widget.list[i]['username']);
                  } else {}
              },
              child: Text('Login')),

              //sebuah tombol untuk mengarahkan user ke halaman register
          Container(
            margin: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: (() => Navigator.pushNamed(context, '/register')),
                child: Text('Registration Page')),
          )
        ],
      ),
    );
  }
}
