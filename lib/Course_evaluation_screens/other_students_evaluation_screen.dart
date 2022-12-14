import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp/Course_evaluation_screens/Courses_evaluations.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gp/Dashboard_screen.dart';
import 'package:gp/shared/cubits/cubit/student_behavior_cubit.dart';
import '../analysis_controller.dart';
import '../classes/student.dart';

class Other_students_evaluation_screen extends StatefulWidget {
  final student std;
  Other_students_evaluation_screen(this.std);
  @override
  State<Other_students_evaluation_screen> createState() =>
      _Other_students_evaluation_screenState(std);
}

List<int> listForAll = [];
List<int> listForOne = [];
List<int> listForOneGrades = [];
List<int> listForAllGrades = [];
List<int> listForOneGradesForGraph = [];
List<rank> listForRank = [];
top6 top = top6();
Map<String, List<String>> clusterLearninigTypes = {};
List<int?> clustersLength = [];

class _Other_students_evaluation_screenState
    extends State<Other_students_evaluation_screen> {
  student std;

  _Other_students_evaluation_screenState(this.std);

  Text yourProgress(List<int> you, List<int> other) {
    if (you[0] == 0) {
      return Text(
        "You have to start",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      );
    } else if ((you[1] == 0 && you[0] > other[0]) ||
        (you[2] == 0 && you[1] > other[1]) ||
        (you[3] == 0 && you[2] > other[2]) ||
        (you[3] == 0 && you[2] > other[2]) ||
        (you[4] == 0 && you[3] > other[3]) ||
        (you[4] > other[4])) {
      return Text(
        "Your Progress in this level is Awesome",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 20.0,
        ),
      );
    } else if ((you[1] == 0 && you[0] < other[0]) ||
        (you[2] == 0 && you[1] < other[1]) ||
        (you[3] == 0 && you[2] < other[2]) ||
        (you[3] == 0 && you[2] < other[2]) ||
        (you[4] == 0 && you[3] < other[3]) ||
        (you[4] < other[4])) {
      return Text(
        "You have to improve your Progress",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontSize: 20.0,
        ),
      );
    } else {
      return Text(
        "Your Progress is Normal",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
          fontSize: 18.0,
        ),
      );
    }
  }

  Text yourGrades(List<int> you, List<int> other) {
    if (you[0] == 0) {
      return Text(
        "You have to start",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      );
    } else if ((you[1] == 0 && you[0] > other[0]) ||
        (you[2] == 0 && you[1] > other[1]) ||
        (you[3] == 0 && you[2] > other[2]) ||
        (you[3] == 0 && you[2] > other[2]) ||
        (you[4] == 0 && you[3] > other[3]) ||
        (you[4] > other[4])) {
      return Text(
        "Your Grades in this level is Awesome",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 20.0,
        ),
      );
    } else if ((you[1] == 0 && you[0] < other[0]) ||
        (you[2] == 0 && you[1] < other[1]) ||
        (you[3] == 0 && you[2] < other[2]) ||
        (you[3] == 0 && you[2] < other[2]) ||
        (you[4] == 0 && you[3] < other[3]) ||
        (you[4] < other[4])) {
      return Text(
        "You have to improve your Grades",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontSize: 20.0,
        ),
      );
    } else {
      return Text(
        "Your Grades is Normal",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
          fontSize: 18.0,
        ),
      );
    }
  }

  bool me = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Courses Evaluation"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashboard_screen(std)));
          },
        ),
      ),
      body: Builder(builder: (context) {
        StudentBehaviorCubit.get(context).fetchStudentGrades(std);
        StudentBehaviorCubit.get(context).fetchAllStudentGrades(std);
        StudentBehaviorCubit.get(context).getTimeTokenForEachLevel(std);
        StudentBehaviorCubit.get(context).fetchEachStudentGrades();
        StudentBehaviorCubit.get(context)
            .getTimeTokenForEachLevelForAllStudents(std);
        StudentBehaviorCubit.get(context).cluster_students_by_behavior(3);
        return BlocBuilder<StudentBehaviorCubit, StudentBehaviorState>(
          builder: (context, state) {
            if (state is StudentBehaviorLoading)
              return Center(child: CircularProgressIndicator());
            else {
              var studentCubit = StudentBehaviorCubit.get(context);
              for (int i = 0; i < 6; i++) {
                top.names.add("Adham Bekair");
                top.picture.add(std.profile_picture);
                top.scores.add(50 + i);
              }
              // clusterLearninigTypes = studentCubit.clusterLearninigTypes;
              // clustersLength.add(clusterLearninigTypes["visual"]?.length);
              // clustersLength.add(clusterLearninigTypes["auditory"]?.length);
              // clustersLength.add(clusterLearninigTypes["reading"]?.length);
              List<String> list = [];
              clusterLearninigTypes["visual"] = list;
              clusterLearninigTypes["auditory"] = list;
              clusterLearninigTypes["reading"] = list;
              clustersLength.add(0);
              clustersLength.add(0);
              clustersLength.add(0);
              try {
                listForAll = studentCubit.timesForStudents;
                listForOne = studentCubit.times;
                listForOneGrades = studentCubit.gradesStudent;
                listForAllGrades = studentCubit.gradesAllStudent;
                top = studentCubit.top;
                clusterLearninigTypes = studentCubit.clusterLearninigTypes;
                clustersLength[0] = clusterLearninigTypes["visual"]?.length;
                clustersLength[1] = clusterLearninigTypes["auditory"]?.length;
                clustersLength[2] = clusterLearninigTypes["reading"]?.length;
                //   print("/////////////");
                //   print(clusterLearninigTypes["visual"]?.length);
                //   print(clusterLearninigTypes["auditory"]?.length);
                //   print(clusterLearninigTypes["reading"]?.length);
              } catch (e) {
                for (int i = 0; i < 5; i++) {
                  listForAll.add(1);
                  listForOne.add(1);
                  listForOneGrades.add(1);
                  listForAllGrades.add(1);
                }
                for (int i = 0; i < 6; i++) {
                  top.names.add("Adham Bekair");
                  top.picture.add(std.profile_picture);
                  top.scores.add(50 + i);
                }
                List<String> list = [];
                clusterLearninigTypes["visual"] = list;
                clusterLearninigTypes["auditory"] = list;
                clusterLearninigTypes["reading"] = list;
                clustersLength.add(0);
                clustersLength.add(0);
                clustersLength.add(0);
              }
              listForRank = [
                rank(top.names[0], top.scores[0], top.picture[0]),
                rank(top.names[1], top.scores[1], top.picture[1]),
                rank(top.names[2], top.scores[2], top.picture[2]),
                rank(top.names[3], top.scores[3], top.picture[3]),
                rank(top.names[4], top.scores[4], top.picture[4]),
                rank(top.names[5], top.scores[5], top.picture[5])
              ];
              listForOneGradesForGraph.add(0);
              listForOneGradesForGraph.add(0);
              listForOneGradesForGraph.add(0);
              listForOneGradesForGraph.add(0);
              listForOneGradesForGraph.add(0);
              for (int i = 0; i < 5; i++) {
                listForOneGradesForGraph[i] = listForOneGrades[i];
                listForOneGradesForGraph[i] -= listForAllGrades[i];
              }
              print("/////////////");
              print(clustersLength[0]);
              print(clustersLength[1]);
              print(clustersLength[2]);
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),

                      Text(
                        "Score Of Students",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ), //Score Of Students word
                      SizedBox(
                        height: 40,
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          // Spacer(),
                          // SizedBox(width: 30,),
                          //     Spacer(),
                          Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(listForRank[2].pic),
                                  //image
                                ),
                                Container(
                                  height: 20,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: FittedBox(
                                    child: Text(
                                      "3rd",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    listForRank[2].name == std.name
                                        ? "Me"
                                        : listForRank[2].name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        listForRank[2].score.toString() +
                                            " pts",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 15,
                                      //   backgroundColor: Colors.white,
                                      //   backgroundImage:
                                      //       AssetImage('proj_images/p.jfif'),
                                      // ), //
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), //3rd info
                          //Spacer(),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      NetworkImage(listForRank[0].pic),
                                  //image
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: FittedBox(
                                  child: Text(
                                    "1st",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                // fit: BoxFit.fill,
                                child: Text(
                                  listForRank[0].name == std.name
                                      ? "Me"
                                      : listForRank[0].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      listForRank[0].score.toString() + " pts",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    //   CircleAvatar(
                                    //     radius: 15,
                                    //     backgroundColor: Colors.white,
                                    //     backgroundImage:
                                    //         AssetImage('proj_images/p.jfif'),
                                    //   ), //
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //1st info
                          // Spacer(),
                          Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(listForRank[1].pic),
                                  //image
                                ),
                                Container(
                                  height: 20,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: FittedBox(
                                    child: Text(
                                      "2nd",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: Text(
                                    listForRank[1].name == std.name
                                        ? "Me"
                                        : listForRank[1].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        listForRank[1].score.toString() +
                                            " pts",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 15,
                                      //   backgroundColor: Colors.white,
                                      //   backgroundImage:
                                      //       AssetImage('proj_images/p.jfif'),
                                      // ), //
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), //2nd info
                          // Spacer(),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ), //first 3

                      Container(
                        height: 180,
                        // width: 500,
                        child: ListView.builder(
                            itemCount: listForRank.length - 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Container(
                                  height:
                                      listForRank[index + 3].name == std.name
                                          ? 65
                                          : 40,
                                  decoration: BoxDecoration(
                                    color:
                                        listForRank[index + 3].name == std.name
                                            ? Colors.cyan
                                            : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        (index + 4).toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            listForRank[index + 3].pic),
                                        //image
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          listForRank[index + 3].name ==
                                                  std.name
                                              ? "Me"
                                              : listForRank[index + 3].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          listForRank[index + 3]
                                                  .score
                                                  .toString() +
                                              " pts",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 18),
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 13,
                                      //   backgroundColor: Colors.white,
                                      //   backgroundImage:
                                      //       AssetImage('proj_images/p.jfif'),
                                      // ), //
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ), //score list

                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "Your Progress VS Other Students Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "(By time spent in each level)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      yourProgress(listForOne, listForAll),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          child: StackedAreaLineChart.withSampleData(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Text(
                        "Your Progress is the Green color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Other Student Progress is the Blue color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 16.0,
                        ),
                      ), // compare graph
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Your Progress VS Other Students Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "(By Grades in each quiz)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      yourGrades(listForOneGrades, listForAllGrades),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          child: StackedAreaLineChart1.withSampleData(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Text(
                        "Your Grades is the Green color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Other Student Grades is the Blue color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 16.0,
                        ),
                      ), // compare graph
                      // SizedBox(
                      //   height: 50,
                      // ),
                      SizedBox(
                        height: 80,
                      ),

                      Text(
                        "Number of student in each learning style cluster",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                            height: 300,
                            width: double.infinity,
                            child: SimpleBarChart.withSampleData()),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }
}

class StackedAreaLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory StackedAreaLineChart.withSampleData() {
    return new StackedAreaLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(_createSampleData(),
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<compare_progress, int>> _createSampleData() {
    final myFakeDesktopData = [
      new compare_progress(0, 0),
      new compare_progress(1, listForAll[0]),
      new compare_progress(2, listForAll[1]),
      new compare_progress(3, listForAll[2]),
      new compare_progress(4, listForAll[3]),
      new compare_progress(5, listForAll[4]),
      //new compare_progress(5, 75),
    ];

    var myFakeTabletData = [
      new compare_progress(0, 0),
      new compare_progress(1, listForOne[0]),
      new compare_progress(2, listForOne[1]),
      new compare_progress(3, listForOne[2]),
      new compare_progress(4, listForOne[3]),
      new compare_progress(5, listForOne[4]),
      // new compare_progress(5, 75),
    ];

    return [
      new charts.Series<compare_progress, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (compare_progress sales, _) => sales.level,
        measureFn: (compare_progress sales, _) => sales.compelted,
        data: myFakeDesktopData,
      ),
      new charts.Series<compare_progress, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (compare_progress sales, _) => sales.level,
        measureFn: (compare_progress sales, _) => sales.compelted,
        data: myFakeTabletData,
      ),
    ];
  }
}

class StackedAreaLineChart1 extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart1(this.seriesList, {required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory StackedAreaLineChart1.withSampleData() {
    return new StackedAreaLineChart1(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(_createSampleData(),
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<compare_progress1, int>> _createSampleData() {
    // print(listForOneGrades[0]);
    // print(listForAllGrades[0]);
    // print(listForOneGrades[1]);
    // print(listForAllGrades[1]);
    final myFakeDesktopData1 = [
      new compare_progress1(0, 0),
      new compare_progress1(1, listForAllGrades[0]),
      new compare_progress1(2, listForAllGrades[1]),
      new compare_progress1(3, listForAllGrades[2]),
      new compare_progress1(4, listForAllGrades[3]),
      new compare_progress1(5, listForAllGrades[4]),
      //new compare_progress(5, 75),
    ];

    var myFakeTabletData1 = [
      new compare_progress1(0, 0),
      new compare_progress1(1, listForOneGradesForGraph[0]),
      new compare_progress1(2, listForOneGradesForGraph[1]),
      new compare_progress1(3, listForOneGradesForGraph[2]),
      new compare_progress1(4, listForOneGradesForGraph[3]),
      new compare_progress1(5, listForOneGradesForGraph[4]),
      // new compare_progress(5, 75),
    ];

    return [
      new charts.Series<compare_progress1, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (compare_progress1 sales, _) => sales.level,
        measureFn: (compare_progress1 sales, _) => sales.compelted,
        data: myFakeDesktopData1,
      ),
      new charts.Series<compare_progress1, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (compare_progress1 sales, _) => sales.level,
        measureFn: (compare_progress1 sales, _) => sales.compelted,
        data: myFakeTabletData1,
      ),
    ];
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {required this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }
  static List<charts.Series<dynamic, String>> _createSampleData() {
    final data = [
      new quiz_grades('Visual', clustersLength[0]!),
      new quiz_grades('Auditory', clustersLength[1]!),
      new quiz_grades('Reading', clustersLength[2]!),
    ];

    return [
      new charts.Series<quiz_grades, String>(
        id: 'Cluster',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (quiz_grades quiz, _) => quiz.quiz,
        measureFn: (quiz_grades quiz, _) => quiz.precent,
        data: data,
        // labelAccessorFn: (add_quiz quiz, _) => quiz.precent.toString(),
        //  overlaySeries: true
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
    );
  }
}

class quiz_grades {
  final String quiz;
  final int precent;

  quiz_grades(this.quiz, this.precent);
}

class compare_progress1 {
  final int level;
  final int compelted;

  compare_progress1(this.level, this.compelted);
}

class compare_progress {
  final int level;
  final int compelted;

  compare_progress(this.level, this.compelted);
}

class rank {
  String name;
  int score;
  String pic;

  rank(this.name, this.score, this.pic);
}
