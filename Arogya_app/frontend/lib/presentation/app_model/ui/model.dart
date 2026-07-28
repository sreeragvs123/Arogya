import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/appbar.dart';
import 'package:frontend/common/bottom_navigator.dart';
import 'package:frontend/presentation/app_model/bloc/app_model_bloc.dart';
import 'package:frontend/presentation/healthLog/pages/prescription_log_page.dart';
import 'package:frontend/presentation/home/pages/hompage.dart';
import 'package:frontend/presentation/meds/pages/meds_schedule_page.dart';
import 'package:frontend/presentation/profile/pages/profile_page.dart';

class AppModel extends StatefulWidget {
  const AppModel({super.key});

  @override
  State<AppModel> createState() => _AppModelState();
}

class _AppModelState extends State<AppModel> {
  late int _selectedIdx;
  final pages = [HomePage(),PrescriptionLog(),MedsSchedulePage(),ProfilePage()];

  @override
  void initState() {
    super.initState();
    _selectedIdx = 0;
  }

  void onTap(int idx) {
    setState(() {
      _selectedIdx = idx;
    });
  }

  void appBarOnTap(){
    setState(() {
      _selectedIdx = pages.length-1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppModelBloc, AppModelState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 247, 252, 251),
          appBar: ArogyaAppBar(
            title: "Arogya",
            profileImage: AssetImage("assets/images/sreerag.jpg"),
            onTap: appBarOnTap,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: pages[_selectedIdx],
          ),
          bottomNavigationBar: ArogyaBottomNavigatorBar(
            currIndex: _selectedIdx,
            onTap: onTap,
          ),
        );
      },
    );
  }
}
