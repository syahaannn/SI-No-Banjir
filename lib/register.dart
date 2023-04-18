import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //untuk menampung semua teks
  TextEditingController textControllerUsername = TextEditingController();
  TextEditingController textControllerPassword = TextEditingController();
  TextEditingController textControllerPasswordConfirm = TextEditingController();

  //API dari db untuk melakukan proses input data username dan password
  void tambahData(String username, String password) async {
    String sql =
        "http://10.0.2.2/no-banjir/register.php?username=$username&password=$password";
    await http.get(Uri.parse(sql));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registration Page'),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: textControllerUsername,
                    decoration: InputDecoration(
                        hintText: 'Inputkan Username',
                        icon: Icon(Icons.person)),
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
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: textControllerPasswordConfirm,
                    decoration: InputDecoration(
                        hintText: 'Inputkan Konfirmasi Password',
                        icon: Icon(Icons.lock)),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inputkan password';
                      }
                    },
                  )),
              ElevatedButton(
                  onPressed: () {
                    // validasi, jika password yang diinput sama dengan
                    // password konfirmasi, maka data masuk ke db
                    if (textControllerPassword.text ==
                        textControllerPasswordConfirm.text) {
                      tambahData(textControllerUsername.text,
                          textControllerPassword.text);
                      Navigator.pushNamed(context, '/login');
                    } else {
                      //snackbar jika password konfirmasi salah
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password Konfirmasi Salah')));
                    }
                  },
                  child: Text('Register')),

                  //tombol jika user ingin ke halaman login
              Container(
                margin: EdgeInsets.only(right: 30),
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: (() => Navigator.pushNamed(context, '/login')),
                    child: Text('Login Page')),
              )
            ],
          ),
        )));
  }
}
