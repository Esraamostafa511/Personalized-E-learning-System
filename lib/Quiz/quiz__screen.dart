import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/Sidebar/BlockNavigation.dart';
import 'question__model.dart';
import 'bindings_app.dart';
import 'custom_button.dart';
import 'answer_option.dart';
import 'progress_timer.dart';
import 'question_card.dart';
import 'quiz__screen.dart';
import 'quiz_controller.dart';
import 'result_screen.dart';
import 'backButton.dart';
import 'package:gp/classes/student.dart';
import 'package:gp/classes/classes.dart';
class QuizScreen extends StatelessWidget with NavigationStates {
  final int id;
  final student std;
  final String stat;
  List<TopicOfWeakness_>weakness_topics=[];
  List<Question_>questions;
  QuizScreen(this.std, this.id,this.stat,this.weakness_topics,this.questions);
  static const routeName = '/quiz_screen';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height/3*2;
    return Scaffold(
      backgroundColor: Color(0xFF273C5B),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                /*color:Colors.blue[800]*/ ),
          ),
          SafeArea(
            child: GetBuilder<QuizController>(
              init: QuizController(0,std,stat,weakness_topics,questions),
              builder: (controller) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:Container(
                        child:Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " Quiz On "+stat+" "+(id).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Question ',
                                      style: TextStyle(fontSize: 30,color: Colors.orange,fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: controller.numberOfQuestion
                                                .round()
                                                .toString(),
                                            style: TextStyle(fontSize: 30,color: Colors.orange,fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '  /',
                                            style: TextStyle(fontSize: 25,color: Colors.white)),
                                        TextSpan(
                                            text: controller.countOfQuestion.toString(),
                                            style: TextStyle(fontSize: 25,color: Colors.white)),
                                      ]),
                                ),
                                ProgressTimer(),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: height,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => QuestionCard(
                        questionModel: controller.quiz_question[index],
                      ),
                      controller: controller.pageController,
                      itemCount: controller.quiz_question.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GetBuilder<QuizController>(
          init: QuizController(0,std,stat,weakness_topics,questions),
          builder: (controller) =>
              Row(
                children: [
                    SizedBox(width: 25,),
                  backButton(
                      onPressed: () =>
                          controller.previousQuestion(),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  nextButton(
                      onPressed: () => controller.nextQuestion(), total: controller.countOfQuestion, id:controller.numberOfQuestion ,),
                ],
              )
      ),
    );
  }
}