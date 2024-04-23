// import 'package:flutter/material.dart';

// class HRPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('HR Page'),
//       // ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40.0),
//           // padding:  const EdgeInsets.only(left: 100.0,right:100,top:30),
//           child: Container(
//                alignment: Alignment.topCenter, //
//               //  height:300,
//               //  width:300,
//             child: Card(
//               elevation: 5,
//               child: Padding(
//               //  padding: const EdgeInsets.all(20.0),
//                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
               
//                 child: Row(
//                   children: [
//                     // Expanded(
//                     //   flex: 2,
//                     //   child: CircleAvatar(
//                     //     radius: 20,
//                     //     backgroundColor: Colors.blue,
//                     //     child: Icon(
//                     //       Icons.person,
//                     //       size: 50,
//                     //       color: Colors.white,
//                     //     ),
//                     //   ),
//                     // ),
//                     Padding(
//                       padding:  const EdgeInsets.only(left: 100.0),
//                       child: Container(
//                                     height: MediaQuery.of(context).size.width >= 30
//                                         ? screenHeight * 0.1
//                                         : screenHeight * 0.1,
//                                     // height:100,
//                                     // width:100,
//                                     child: Image.asset(
//                                      "assets/images/Template2.png",
                      
//                                       fit: BoxFit.cover,
//                                       height: double.infinity,
//                                     ),
//                                   ),
//                     ),
            
//                      SizedBox(width:300),
//                     Expanded(
//                       flex: 15,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           _buildProfileCard('       Account Manager    '),
//                           SizedBox(width:20),
//                           SizedBox(height: 5),
//                           _buildProfileCard('        Employee         '),
//                           SizedBox(height: 5),
                          
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//  Widget _buildProfileCard(String title) {
//   return Card(
//     elevation: 3,
//     child: Padding(
//     //  padding: const EdgeInsets.all(8.0),
//        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.blue,
//             child: Icon(
//               Icons.person,
//               size: 30,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }
import 'package:flutter/material.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Productsdashboard.dart';
import 'package:loginapp/HR_Employee/EmployeeLogin/EmployeeLoginCards.dart';


class HRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width >= 30
                            ? screenHeight * 0.1
                            : screenHeight * 0.1,
                        child: Image.asset(
                          "assets/images/Template2.png",
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(width: 300),
                    Expanded(
                      flex: 15,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                               // MaterialPageRoute(builder: (context) => AccountManagerPage()),
                               MaterialPageRoute(builder: (context) => 
                               Dashboard(productNameVar:"GHI",productIdvar:"1001",clientId:1552,clientNameVar:"Bajaj Insurance",tpaNameVar :"ICICI",insuranceCompanyVar:"12")),
                              );
                            },
                            child: _buildProfileCard('       Account Manager    '),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmployeeLoginCardsPage()),
                              );
                            },
                            child: _buildProfileCard('        Employee         '),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(String title) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Manager Page'),
      ),
      body: Center(
        child: Text('This is the Account Manager Page'),
      ),
    );
  }
}

// class EmployeePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Employee Page'),
//       ),
//       body: Center(
//         child: Text('This is the Employee Page'),
//       ),
//     );
//   }
// }

