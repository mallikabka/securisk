import 'package:flutter/material.dart';
import 'package:loginapp/ClientList/TabBar.dart';
import 'package:loginapp/CreateLocation/CreateLocation.dart';
import 'package:loginapp/Forgot.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'package:loginapp/FreshPolicyFields/CoverageDetails.dart';
import 'package:loginapp/FreshPolicyFields/PolicyTerms.dart';
import 'package:loginapp/IntermediaryDetails/intermediary_insurer_list.dart';
import 'package:loginapp/Login1.dart';
import 'package:loginapp/MainDashboard.dart';
import 'package:loginapp/ChangePassword.dart';
import 'package:loginapp/Roles/roles.dart';
import 'package:loginapp/SideBarComponents/AllRFQEx.dart';
import 'package:loginapp/FreshPolicyFields/CreateRFQ.dart';
import 'package:loginapp/Templates/TemplatesTabar.dart';
import 'LandingPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      initialRoute: '/',
      routes: {
        '/landing_Page': (context) => LandingPage(),
        '/policy_page': (context) => PolicyTerms(),
        // '/login_page': (context) =>  Login(),
        '/login_page': (context) => LoginPage(),
        '/AllRfq_page': (context) {
          return AllRFQEx(
            onCreateRFQ: () {},
          );
        },
        '/dashboard_page': (context) {
          return MainDashboard();
        },
        '/location_page': (context) => CreateLocation(),
        '/reset_password': (context) => ResetPassword(),
        '/forgot_page': (context) => Forgot(),
        '/reset_page': (context) => ResetPassword(),
        '/createRfq_page': (context) => CreateRFQ(),
        '/corporate_page': (context) => CorporateDetails(),
        '/coverage_page': (context) => CoverageDetails(),
        '/client_list_page': (context) => ClientListTabBar(),
        '/Insurer_template_page': (context) => TemplateTabar(),
        '/roles': (context) => ChangeNotifierProvider(
              create: (context) => DataGridProvider(),
              child: Roles(),
            ),
          '/change_password_page': (context) => ResetPassword(),
          '/intermediate_page':(context) => IntermediaryInsurerList()
      },
    );
  }
}
