import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 213, 196, 248),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/page2.png"))),
                ),

                // Image.asset('images/page1.png'),

                Container(
                  width: double.infinity,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
                    child: Text(
                      'Sign In For Your Career',
                      style: TextStyle(
                          fontSize: screenHeight * 0.043,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PassionOne"),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      'We help you find your dream job according to your skillset location and preference to build your career',
                      style: TextStyle(
                          fontSize: screenHeight * 0.023,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          wordSpacing: 1.2,
                          height: 1.5),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
