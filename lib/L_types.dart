import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp/Home.dart';
import 'package:gp/Levels_View.dart';
import 'package:gp/classes/studentBehavior.dart';
import 'package:gp/myprofile_screen.dart';
import 'package:gp/shared/cubits/cubit/student_behavior_cubit.dart';
import 'package:gp/shared/cubits/cubit/topic_cubit.dart';
import 'package:path/path.dart';
import 'audio_player.dart';
import 'video_player.dart';
import 'package:gp/URL_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'classes/student.dart';
import 'classes/classes.dart';
import 'topic_images.dart';
import 'pdf_view.dart';
import 'Levels_View.dart';

class types extends StatefulWidget {
  final student std;

  // final int LevelNumber;
  // final int TopicNumber;
  final Level_ level;
  final Topic_ topic;

  types(this.std, this.level, this.topic);

  @override
  _typesState createState() => _typesState(std, level, topic);

// @override

}

class _typesState extends State<types> {
  student std;
  Level_ level;
  Topic_ topic;
  // int LevelNumber;
  // int TopicNumber;

  _typesState(this.std, this.level, this.topic);
  late studentBehavior stdBehavior;
  //late TypesForStudent list;
  var cupit;
  bool _video_1st = true;
  // bool _video_1st=false;

  bool _audio_1st = false;
// bool _audio_1st=true;

  bool _text_1st = false;
//  bool _text_1st=true;

  bool _image_1st = false;
  //bool _image_1st=true;

  bool _url_1st = false;
  //bool _url_1st =true;

//Topic_ topic  = Topic_();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 30,
          title: Text("Personalized E-learning System"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => levels_view(std)));
              // _selectedIndex-=2;
            },
          ),
        ),
        body: Builder(builder: (context) {
          StudentBehaviorCubit.get(context)
              .getTimeSpendEveryOnce(std.id, level.id, topic.id);
          return BlocBuilder<StudentBehaviorCubit, StudentBehaviorState>(
              builder: (context, state) {
            if (state is StudentBehaviorLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              var behaviorCubit = StudentBehaviorCubit.get(context);
              stdBehavior = behaviorCubit.value;
              TopicCubit.get(context).getTopicData(topic.id);
              return BlocBuilder<TopicCubit, TopicState>(
                builder: (context, state) {
                  if (state is TopicLoading)
                    return Center(child: CircularProgressIndicator());
                  else {
                    var topicCubit = TopicCubit.get(context);
                    var topic = topicCubit.topic;
                    //stdBehavior = behaviorCubit.std;
                    return Center(
                      child: Container(
                        color: Colors.blue[200],
                        // height: double.infinity,
                        //  height: 620,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                child: Stack(children: [
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        height: 60,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              bottomLeft: Radius.circular(50),
                                            )),
                                      )),
                                  Positioned(
                                    top: 10,
                                    left: 230,
                                    child: Center(
                                        child: Text(
                                      "Last Time Visited: ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )),
                                  ),
                                  Positioned(
                                    top: 30,
                                    left: 230,
                                    child: Center(
                                        child: Text(
                                      stdBehavior.last_time_entered,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )),
                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: 60,
                                        width: 85,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            )),
                                      )),
                                  Positioned(
                                    top: 10,
                                    right: 290,
                                    child: Center(
                                        child: Text(
                                      "Level " + level.id.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )),
                                  ),
                                  Positioned(
                                    top: 30,
                                    right: 290,
                                    child: Center(
                                        child: Text(
                                      "Topic " + topic.id.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )),
                                  )
                                ]),
                              ),
                              GestureDetector(
                                onTap: () => {
                                  _video_1st
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                      video_player(
                                                          std,
                                                          topic.videos[0],
                                                          stdBehavior.forVideo,
                                                          level,
                                                          topic)),
                                        )
                                      : _audio_1st
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                          audio_player(
                                                              std,
                                                              topic.audios[0],
                                                              stdBehavior
                                                                  .forAudio,
                                                              level,
                                                              topic)),
                                            )
                                          : _image_1st
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                              image_view(
                                                                  std,
                                                                  topic.images,
                                                                  stdBehavior
                                                                      .forImage,
                                                                  level,
                                                                  topic)),
                                                )
                                              : _text_1st
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                  pdf_view(
                                                                      std,
                                                                      topic.pdf,
                                                                      stdBehavior
                                                                          .forText,
                                                                      level,
                                                                      topic)),
                                                    )
                                                  : _url_1st
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                      url_view(
                                                                          std,
                                                                          topic
                                                                              .urls,
                                                                          level,
                                                                          topic)),
                                                        )
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                      audio_player(
                                                                          std,
                                                                          topic.audios[
                                                                              0],
                                                                          stdBehavior
                                                                              .forAudio,
                                                                          level,
                                                                          topic)),
                                                        ),
                                },
                                child: Container(
                                  width: 250,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Image(
                                        image: _video_1st
                                            ? AssetImage(
                                                'proj_images/video.png')
                                            : _audio_1st
                                                ? AssetImage(
                                                    'proj_images/audio.png')
                                                : _image_1st
                                                    ? AssetImage(
                                                        'proj_images/image.png')
                                                    : _text_1st
                                                        ? AssetImage(
                                                            'proj_images/Text.png')
                                                        : _url_1st
                                                            ? AssetImage(
                                                                'proj_images/url.jpg')
                                                            : AssetImage(
                                                                'proj_images/video.png'),
                                        height: 250,
                                        width: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(.7),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          _video_1st
                                              ? "Video"
                                              : _audio_1st
                                                  ? 'Audio'
                                                  : _image_1st
                                                      ? 'Image'
                                                      : _text_1st
                                                          ? 'Text'
                                                          : _url_1st
                                                              ? 'URL'
                                                              : 'Video',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //new fun
                              ////////////////////////////////////////////////////////////////
                              //        SingleChildScrollView(
                              //       scrollDirection: Axis.horizontal,
                              //    child:
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 20),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => audio_player(
                                        //           std,
                                        //          topic.audios[0],
                                        //           stdBehavior.forAudio,
                                        //           LevelNumber,
                                        //           TopicNumber)),
                                        // ),
                                        _video_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                            audio_player(
                                                                std,
                                                                topic.audios[0],
                                                                stdBehavior
                                                                    .forAudio,
                                                                level,
                                                                topic)),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                            video_player(
                                                                std,
                                                                topic.videos[0],
                                                                stdBehavior
                                                                    .forVideo,
                                                                level,
                                                                topic)),
                                              ),
                                      },
                                      //print("'Clicked'")},
                                      child: Container(
                                        //   height: 100,

                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Image(
                                              image: _video_1st
                                                  ? AssetImage(
                                                      'proj_images/audio.png')
                                                  : AssetImage(
                                                      'proj_images/video.png'),
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(.7),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                _video_1st ? "Audio" : 'Video',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    //////////////////////////////////////////////////////////////////////
                                    GestureDetector(
                                      onTap: () => {
                                        _video_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                            image_view(
                                                                std,
                                                                topic.images,
                                                                stdBehavior
                                                                    .forImage,
                                                                level,
                                                                topic)),
                                              )
                                            : _audio_1st
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                image_view(
                                                                    std,
                                                                    topic
                                                                        .images,
                                                                    stdBehavior
                                                                        .forImage,
                                                                    level,
                                                                    topic)),
                                                  )
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                audio_player(
                                                                    std,
                                                                    topic.audios[
                                                                        0],
                                                                    stdBehavior
                                                                        .forAudio,
                                                                    level,
                                                                    topic)),
                                                  )
                                      },
                                      child: Container(
                                        //  padding: EdgeInsets.only(top: 10.0),
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Image(
                                              image: _video_1st
                                                  ? AssetImage(
                                                      'proj_images/image.png')
                                                  : _audio_1st
                                                      ? AssetImage(
                                                          'proj_images/image.png')
                                                      : AssetImage(
                                                          'proj_images/audio.png'),
                                              //   height: 250,
                                              //  width: 250,
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(.7),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                _video_1st
                                                    ? "Image"
                                                    : _audio_1st
                                                        ? 'Image'
                                                        : 'Audio',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  children: [
                                    Spacer(),

                                    ///////////////////////////////////////////////////////
                                    GestureDetector(
                                      onTap: () => {
                                        _text_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                  std,
                                                  topic.pdf,
                                                  stdBehavior.forText,
                                                  LevelNumber,
                                                  TopicNumber)*/
                                                            image_view(
                                                                std,
                                                                topic.images,
                                                                stdBehavior
                                                                    .forImage,
                                                                level,
                                                                topic)),
                                              )
                                            : _url_1st
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) => /*pdf_view(
                                                  std,
                                                  topic.pdf,
                                                  stdBehavior.forText,
                                                  LevelNumber,
                                                  TopicNumber)*/
                                                                image_view(
                                                                    std,
                                                                    topic
                                                                        .images,
                                                                    stdBehavior
                                                                        .forImage,
                                                                    level,
                                                                    topic)),
                                                  )
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                                pdf_view(
                                                                    std,
                                                                    topic.pdf,
                                                                    stdBehavior
                                                                        .forText,
                                                                    level,
                                                                    topic)),
                                                  )
                                      },
                                      child: Container(
                                        //  padding: EdgeInsets.only(top: 10.0),
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Image(
                                              image: _text_1st
                                                  ? AssetImage(
                                                      'proj_images/image.png')
                                                  : _url_1st
                                                      ? AssetImage(
                                                          'proj_images/image.png')
                                                      : AssetImage(
                                                          'proj_images/t.png'),
                                              height: 110,
                                              // height: 250,
                                              //    width: 250,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(.7),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                _text_1st
                                                    ? "Image"
                                                    : _url_1st
                                                        ? 'Image'
                                                        : 'Text',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => {
                                        _url_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                            pdf_view(
                                                                std,
                                                                topic.pdf,
                                                                stdBehavior
                                                                    .forText,
                                                                level,
                                                                topic)),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) => /*pdf_view(
                                                    std,
                                                    topic.pdf,
                                                    stdBehavior.forText,
                                                    LevelNumber,
                                                    TopicNumber)*/
                                                            url_view(
                                                                std,
                                                                topic.urls,
                                                                level,
                                                                topic)),
                                              )
                                      },
                                      child: Container(
                                        //  padding: EdgeInsets.only(top: 10.0),
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Image(
                                              image: _url_1st
                                                  ? AssetImage(
                                                      'proj_images/t.png')
                                                  : AssetImage(
                                                      'proj_images/URL.jpg'),
                                              height: 110,
                                              // height: 250,
                                              //    width: 250,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(.7),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                _url_1st ? "Text" : 'URL',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),

                              //),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          });
        }));
  }
}

showlanguageDialogFunc(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            width: 500,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'proj_images/lan.png',
                    width: 90,
                    height: 90,
                  ),
                ),
                Text(
                  "Select Language",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            //call arabic type
                            Navigator.of(context).pop();
                          },
                          child: Text("Arabic",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            //call english type

                            Navigator.of(context).pop();
                          },
                          child: Text("English",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
