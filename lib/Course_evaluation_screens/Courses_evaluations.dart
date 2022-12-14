import 'package:flutter/material.dart';
import 'package:gp/Course_evaluation_screens/My_Evaluation_screen.dart';
import 'package:gp/Course_evaluation_screens/other_students_evaluation_screen.dart';

import '../Dashboard_screen.dart';
import '../Home.dart';
import '../Info.dart';
import '../Last_quizzes.dart';
import '../Learning_analytics_screen.dart';
import '../Levels_View.dart';
import '../classes/student.dart';
import '../myprofile_screen.dart';
import 'quiz_evaluation_screen.dart';

class Course_evual_categories extends StatefulWidget {
  //final student std;
  final student std;
  final String courseCode;
  Course_evual_categories(this.std, this.courseCode);

  @override
  State<Course_evual_categories> createState() =>
      _Course_evual_categoriesState(std, courseCode);
}

class _Course_evual_categoriesState extends State<Course_evual_categories> {
  student std;
  String courseCode;
  _Course_evual_categoriesState(this.std, this.courseCode);
  int _selectedIndex = 2;
  static List<Widget> _pages = <Widget>[];

  void addTOList() {
    _pages.add(Dashboard_screen(std));
    _pages.add(levels_view(std));
 //   _pages.add(Course_evual_categories(std, courseCode));
    _pages.add(lastQuizzes(std, courseCode));
    _pages.add(INFO(std, courseCode));

  }

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
        // _selectedIndex%=3;

        //   print("index = ${widget.ind} ");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => moveToPage(index)));
      },
    );
  }

  Widget moveToPage(int index) {
    _selectedIndex %= 4;
    return _pages.elementAt(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    addTOList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Evaluation"),
        leading: Icon(Icons.equalizer_outlined),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   showUnselectedLabels: true,
      //
      //   selectedItemColor: Colors.blue,
      //   selectedFontSize: 18,
      //
      //   unselectedItemColor: Colors.grey,
      //   unselectedFontSize: 16,
      //
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //       //   backgroundColor: Colors.blue
      //       //     backgroundColor: Colors.blue,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.keyboard_double_arrow_up),
      //       label: 'Levels',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.equalizer_outlined),
      //       label: 'Evaluation',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.quiz),
      //       label: 'Quizzes',
      //     ),
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       label: 'Info',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex, //New
      //   onTap: _onItemTapped,
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 50),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ), //course word

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => My_Evaluation(std)));
              },
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.0)),
                // padding: const EdgeInsets.only(
                //     left: 10, top: 30.0, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Evaluation ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Other_students_evaluation_screen(std)));
              },
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.0)),
                // padding: const EdgeInsets.only(
                //     left: 10, top: 30.0, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "    ME VS Other Students",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => quiz_evaluation_screen(std)));
              },
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.0)),
                // padding: const EdgeInsets.only(
                //     left: 10, top: 30.0, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Quiz Evaluation ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
