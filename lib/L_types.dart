import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp/DatabaseManager.dart';
import 'package:gp/classes/studentBehavior.dart';
import 'package:gp/shared/cubits/cubit/student_behavior_cubit.dart';
import 'package:gp/shared/cubits/cubit/topic_cubit.dart';
import 'package:path/path.dart';
import 'Quiz/go_to_quiz.dart';
import 'dialogs/languageDialog.dart';
import 'Topic_View.dart';
import 'classes/student.dart';
import 'classes/classes.dart';
import 'audio_player.dart';
import 'video_player.dart';
import 'package:gp/URL_view.dart';
import 'topic_images.dart';
import 'pdf_view.dart';

class types extends StatefulWidget {
  final student std;
  final Level_ level;
  final Topic_ topic;
  final bool collaborative;
  types(this.std, this.level, this.topic, this.collaborative);
  @override
  _typesState createState() => _typesState(std, level, topic, collaborative);
}

class _typesState extends State<types> {
  student std;
  Level_ level;
  Topic_ topic;
  String? selectedLanguage;
  Video_? video_;
  Audio_? audio_;
  bool collaborative;

  _typesState(this.std, this.level, this.topic, this.collaborative);
  late studentBehavior stdBehavior;
  DatabaseManager db = DatabaseManager();
  List<double> weight = [];
  //late TypesForStudent list;
  var cupit;
  bool _video_1st = true;
// bool _video_1st=false;

  bool _audio_1st = false;
// bool _audio_1st=true;

  bool _text_1st = false;
// bool _text_1st=true;

  bool _image_1st = false;
// bool _image_1st=true;

  bool _url_1st = false;
// bool _url_1st =true;

  void setContentType(List<double> weight) {
    setState(() {
      if (weight[0] > weight[1] &&
          weight[0] > weight[2] &&
          weight[0] > weight[3]) {
        _video_1st = true;
        _audio_1st = false;
        _image_1st = false;
        _text_1st = false;
        _url_1st = false;
      } else if (weight[1] > weight[0] &&
          weight[1] > weight[2] &&
          weight[1] > weight[3]) {
        _video_1st = false;
        _audio_1st = true;
        _image_1st = false;
        _text_1st = false;
        _url_1st = false;
      } else if (weight[2] > weight[0] &&
          weight[2] > weight[1] &&
          weight[2] > weight[3]) {
        _video_1st = false;
        _audio_1st = false;
        _image_1st = true;
        _text_1st = false;
        _url_1st = false;
      } else {
        _video_1st = false;
        _audio_1st = false;
        _image_1st = false;
        _text_1st = true;
        _url_1st = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(collaborative);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 30,
          title: Text(
            "Personalized E-learning System",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => topic_view(std, level)));
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
              if (collaborative == true) {
                TopicCubit.get(context).collaborative_filtering(
                    std.id, level.id.toString(), topic.id.toString());
              } else {
                TopicCubit.get(context)
                    .getTimeTokenForEachContentType(std, stdBehavior);
              }
              TopicCubit.get(context).getTopicData(topic.id);
              return BlocBuilder<TopicCubit, TopicState>(
                builder: (context, state) {
                  if (state is TopicLoading)
                    return Center(child: CircularProgressIndicator());
                  else {
                    var topicCubit = TopicCubit.get(context);
                    Topic_ topic = Topic_();
                    try {
                      topic = topicCubit.topic;
                      weight = topicCubit.weight;
                      setContentType(weight);
                    } catch (e) {
                      topic = topicCubit.topic;
                    }
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
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              Text(
                                                "Last Time Visited: ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[800]),
                                              ),
                                              Spacer(),
                                              Text(
                                                stdBehavior.last_time_entered,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[800]),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: 60,
                                        width: 125,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            )),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              Text(
                                                level.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[800]),
                                              ),
                                              Spacer(),
                                              Text(
                                                topic.name,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue[800]),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      )),
                                ]),
                              ),
                              GestureDetector(
                                onTap: () => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          languageDialog()).then((value) {
                                    //    print("////" + value + "////");
                                    if (value == "Arabic") {
                                      audio_ = topic.audios[1];
                                      video_ = topic.videos[1];
                                    } else if (value == "English") {
                                      audio_ = topic.audios[0];
                                      video_ = topic.videos[0];
                                    }
                                    _video_1st
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    video_player(
                                                        std,
                                                        video_!,
                                                        stdBehavior.forVideo,
                                                        level,
                                                        topic)),
                                          )
                                        : _audio_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
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
                                                        builder: (context) =>
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
                                                            builder: (context) =>
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
                                                                builder: (context) =>
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
                                                                builder: (context) =>
                                                                    audio_player(
                                                                        std,
                                                                        audio_!,
                                                                        stdBehavior
                                                                            .forAudio,
                                                                        level,
                                                                        topic)),
                                                          );
                                  }),
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
                                                        'proj_images\image.png')
                                                    : _text_1st
                                                        ? AssetImage(
                                                            'proj_images\Text.png')
                                                        : _url_1st
                                                            ? AssetImage(
                                                                'proj_images\URL.png')
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
                              ), //first_btn
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
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                languageDialog()).then((value) {
                                          if (value == "Arabic") {
                                            audio_ = topic.audios[1];
                                            video_ = topic.videos[1];
                                          } else if (value == "English") {
                                            audio_ = topic.audios[0];
                                            video_ = topic.videos[0];
                                          }
                                          // else{
                                          //   showDialog(
                                          //       context: context,
                                          //       builder: (BuildContext context) => languageDialog())
                                          //       .then((value){
                                          //     if(value == "Arabic") {
                                          //       audio_ = topic.audios[0];
                                          //       video_ = topic.videos[0];
                                          //     }
                                          //     else if(value == "English"){
                                          //       audio_ = topic.audios[1];
                                          //       video_ = topic.videos[1];
                                          //     }
                                          //
                                          //   });
                                          // }

                                          _video_1st
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          audio_player(
                                                              std,
                                                              audio_!,
                                                              stdBehavior
                                                                  .forAudio,
                                                              level,
                                                              topic)),
                                                )
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          video_player(
                                                              std,
                                                              video_!,
                                                              stdBehavior
                                                                  .forVideo,
                                                              level,
                                                              topic)));
                                        }),
                                      },
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
                                    ), //second_btn
                                    Spacer(),
                                    //////////////////////////////////////////////////////////////////////
                                    GestureDetector(
                                      onTap: () => {
                                        _video_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
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
                                                        builder: (context) =>
                                                            image_view(
                                                                std,
                                                                topic.images,
                                                                stdBehavior
                                                                    .forImage,
                                                                level,
                                                                topic)),
                                                  )
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            audio_player(
                                                                std,
                                                                audio_!,
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
                                    ), //third_btn
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
                                                    builder: (context) =>
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
                                                        builder: (context) =>
                                                            image_view(
                                                                std,
                                                                topic.images,
                                                                stdBehavior
                                                                    .forImage,
                                                                level,
                                                                topic)),
                                                  )
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
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
                                    ), //fourth_btn
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => {
                                        _url_1st
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        pdf_view(
                                                            std,
                                                            topic.pdf,
                                                            stdBehavior.forText,
                                                            level,
                                                            topic)),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
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
                                    ), //fifth_btn
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 30),
                                child: Container(
                                    width: 200,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                //builder: (context) => Levels(1, std))),
                                                builder: (context) =>
                                                    go_to_quiz(std, topic.id,
                                                        "Topic")));
                                      },
                                      child: Text(
                                        "Quiz for Topic",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(-4, -4),
                                          ),
                                        ])),
                              ), //

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
