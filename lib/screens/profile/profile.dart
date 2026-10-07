import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        
          children: [
            Padding(padding: EdgeInsets.only(top: 20),
            child: Row(
           
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo/LogoM1.png',width: 50,),
                Text("angaTsu",style: TextStyle(
                  fontFamily: 'Tilt',color: Colors.black,fontSize: 30             ),)
              ],
            )
            ,),
            
          ],
        ),
      ),
    );
  }
}