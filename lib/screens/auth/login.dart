import 'package:flutter/material.dart';
import 'package:project_manga/screens/auth/signup.dart';
import 'package:project_manga/screens/home/home.dart';
import 'package:project_manga/services/auth_session.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Icon con = Icon(Icons.visibility_off);
  Icon conK = Icon(Icons.visibility_off);
  bool secure = true;

  TextEditingController idCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController pswCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Text(
                  "Login",
                  style: TextStyle(fontFamily: 'Tilt', fontSize: 50),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo/LogoM1.png', width: 50),
                Text(
                  "angaTsu",
                  style: TextStyle(fontFamily: 'Tilt', fontSize: 50),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, right: 255.0),

              child: Text(
                "ID",
                style: TextStyle(fontFamily: 'Tilt', fontSize: 30),
              ),
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: idCtr,

                  decoration: InputDecoration(
                    hintText: 'Masukkan ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 220.0, top: 10.0),

              child: Text(
                "Email",
                style: TextStyle(fontFamily: 'Tilt', fontSize: 30),
              ),
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCtr,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 155.0, top: 10.0),

              child: Text(
                "Password",
                style: TextStyle(fontFamily: 'Tilt', fontSize: 30),
              ),
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  obscureText: secure,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (!secure) {
                            con = Icon(Icons.visibility_off);
                            secure = !secure;
                          } else {
                            con = Icon(Icons.visibility);
                            secure = !secure;
                          }
                        });
                      },
                      icon: con,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(right: 75.0, bottom: 5.0),

              child: TextButton(
                onPressed: () {
                  AuthSession.login();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
                child: Text(
                  "Belum punya akun? Klik disini !",
                  style: TextStyle(
                    fontFamily: 'Tilt',
                    color: Color.fromRGBO(46, 97, 184, 100.0),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 150,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Beranda()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Tilt',
                        color: Colors.black,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
