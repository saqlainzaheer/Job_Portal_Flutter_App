import 'package:flutter/material.dart';
// import 'package:job_portal/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';
import 'intro_page4.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController(initialPage: 0);
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      if (pageController.page == 3) {
        setState(() {
          isLastPage = true;
        });
      } else {
        setState(() {
          isLastPage = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              physics: isLastPage
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              children: const <Widget>[
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
              ],
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 20, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (!isLastPage)
                        SmoothPageIndicator(
                          controller: pageController,
                          count: 3,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 12,
                            spacing: 10,
                            dotColor: Color.fromARGB(255, 191, 170, 255),
                            activeDotColor: Color.fromARGB(255, 181, 163, 232),
                          ),
                          onDotClicked: (index) {
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                      if (!isLastPage)
                        SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (!isLastPage) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Icon(Icons.arrow_forward),
                            shape: CircleBorder(),
                            backgroundColor: Color.fromARGB(255, 238, 234, 251),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
