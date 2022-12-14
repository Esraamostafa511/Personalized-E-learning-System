import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';

import 'package:gp/Home.dart';
import 'package:gp/L_types.dart';
import 'package:gp/Learning_analytics_screen.dart';
import 'package:gp/edit_profile%20screen.dart';
//import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
//import 'lib.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'Course_evaluation_screens/Courses_evaluations.dart';
import 'Levels_View.dart';
import 'Sidebar/BlockNavigation.dart';
import 'classes/student.dart';

class MyProfileScreen extends StatefulWidget with NavigationStates {
  final student std;
  MyProfileScreen(this.std);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState(std);
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final student std;
  _MyProfileScreenState(this.std);
  int _selectedIndex = 3;
  // int _selectedIndex = 2;
  static List<Widget> _pages = <Widget>[];

  void addTOList() {
    _pages.add(levels_view(std));
    _pages.add(Learning_analytics_screen(std));
    _pages.add(Course_evual_categories(std, "CSW150"));
    _pages.add(MyProfileScreen(std));
  }

  void _onItemTapped(int index) {
    setState(
      () {

        _selectedIndex = index;

        //   print("index = ${widget.ind} ");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => moveToPage(index)));
      },
    );
  }

  Widget moveToPage(int index) {

    return _pages.elementAt(_selectedIndex);
  }

  // double _progressValue=0;
  @override
  Widget build(BuildContext context) {
    addTOList();
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("My Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home(std)));
            _selectedIndex -= 3;
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,

        selectedItemColor: Color(0xFF1565C0),
        selectedFontSize: 16,

        unselectedItemColor: Colors.grey,
        // unselectedFontSize: 11,
        unselectedFontSize: 16,

        //    currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            //backgroundColor: Colors.blue,
            //   backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            //  icon: Icon(Icons.up),
            label: 'Analytics',

            // backgroundColor: Colors.blue,
            //     backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer_outlined),
            label: 'Evaluation',
            //  backgroundColor: Colors.blue
            //    backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Dashboard',
            //   backgroundColor: Colors.blue
            //     backgroundColor: Colors.blue,
          )
        ],
        // onTap: (index){
        //   print("index = ${widget.ind} ");
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context)=>moveToPage(index)));
        //
        //
        //
        // },
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(std.profile_picture),
                        //  backgroundImage: NetworkImage('https://png.pngtree.com/element_our/png_detail/20181208/male-student-icon-png_265268.jpg'),
                        radius: 55,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_sharp,
                          color: Color(0xFF1565C0),
                          size: 40,
                        ),
                        //    alignment: Alignment.bottomRight,

                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Edit_Proile_Screen(std)));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        std.name,
                        style: TextStyle(
                          fontSize: 32,
                          //   color : Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Student,Ain-Shams University",
                        style: TextStyle(
                          fontSize: 12,
                          // color : Colors.blue[300],
                          // fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        std.id.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          //color : Colors.blue[300],
                          //fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ), //Edit && Info

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    hintStyle: TextStyle(
                      fontSize: 20,
                      //color : Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      // fontStyle: FontStyle.italic,
                    ),
                    //alignLabelWithHint: ,
                    hintText: std.name,
                    //alignLabelWithHint:true,
                  ),
                ),
              ), //name info
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "ID",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      //color : Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    ),
                    //alignLabelWithHint: ,
                    hintText: std.id.toString(),

                    //alignLabelWithHint:true,
                  ),
                ),
              ), //id info
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "E-mail",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    ),
                    //alignLabelWithHint: ,
                    hintText: std.email,
                    //alignLabelWithHint:true,
                  ),
                ),
              ), //e-mail info
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "Date Of Birth",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    ),
                    //alignLabelWithHint: ,
                    hintText: std.birthdate,
                    //alignLabelWithHint:true,
                  ),
                ),
              ), //birth info
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "Academic Year",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    ),
                    //alignLabelWithHint: ,
                    hintText: std.academic_year.toString(),
                    //alignLabelWithHint:true,
                  ),
                ),
              ), // level info
            ],
          ),
        ),
      ),
    );
  }
}
