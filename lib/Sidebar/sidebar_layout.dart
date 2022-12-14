import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp/Home.dart';
import 'package:gp/Sidebar/hom.dart';
import 'package:gp/classes/student.dart';
import 'package:gp/login_screen.dart';

import 'BlockNavigation.dart';
import 'package:gp/Sidebar/sidebar.dart';

class side_layout extends StatelessWidget with NavigationStates {
  final student std;
  side_layout(this.std);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<Navigationn>(
        create: (context) => Navigationn(Home(std), std),
        child: Stack(
          children: <Widget>[
            BlocBuilder<Navigationn, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            sidebar(std),
          ],
        ),
      ),
    );
  }
}
