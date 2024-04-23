
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Grid Cards Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:loginapp/ClientList/ActiveClientList.dart';

class EmployeeLoginCardsPage extends StatefulWidget {
  @override
  _EmployeeLoginCardsPageState createState() => _EmployeeLoginCardsPageState();
}

class _EmployeeLoginCardsPageState extends State<EmployeeLoginCardsPage> {
  List<String> items = [
    "Policy Details",
    "Member Details",
    "Member Details ",
    "Member Details ",
    "Member Details ",
    "Member Details ",
    "Member Details",
    "Member Details ",
    "Member Details ",
    "Member Details ",
    "Member Details ",
  ]; // List of items for each card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("claims settled"),
      // ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center align the content
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(' Claims\n Setteled', style: TextStyle(fontSize: 15)),
            Spacer(), // This widget will create space between the text widgets
            Text(' Claims\n Pending', style: TextStyle(fontSize: 15)),
            Spacer(), // Another spacer for even space distribution
            Text(' Claims\n Rejected', style: TextStyle(fontSize: 15)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: GridView.builder(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3, // Two cards per row
        //   //childAspectRatio: 1.0, // Aspect ratio of 1.0 makes each child square
        // ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Increase to 4 for smaller width per card
          childAspectRatio:
              1 / 1, // Adjusted for slightly taller than wide cards
          crossAxisSpacing: 30, // Spacing between items along the cross axis
          mainAxisSpacing: 10, // Spacing between items along the main axis
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return CardWidget(item: items[index], index: index);
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String item;
  final int index;

  CardWidget({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.person), // Person icon
              onPressed: () {
                // Action to perform on icon press
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: ActiveClientList(),
                    //Text('Icon on $item pressed!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(item),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Button on $item pressed!'),
                //     duration: Duration(seconds: 2),
                //   ),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActiveClientList()),
                );
              },
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}
