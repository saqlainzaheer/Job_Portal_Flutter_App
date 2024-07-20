import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 255, 255, 253),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: screenHeight * 0.66,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/page3.png"))),
                ),

                // Image.asset('images/page1.png'),
                SizedBox(height: screenHeight * 0.03),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      'We help you find your dream job according to your skillset location and preference to build your career',
                      style: TextStyle(
                          fontSize: screenHeight * 0.022,
                          color: Color.fromARGB(255, 161, 161, 163),
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.4,
                          wordSpacing: 1.2,
                          height: 1.5),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
