import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool active = false;
  String exTitle = "Sport Categories";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) {
            active = !active;
            if (exTitle == "Sport Categories")
              exTitle = "Contract";
            else
              exTitle = "Sport Categories";
            setState(() {});
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return exTitle.text.gray500.make().centered();
                },
                body: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 7,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors.black;
                          },
                        ),
                      ),
                      onPressed: () => null,
                      child: "All".text.make(),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: "Basketball".text.black.make(),
                    ),
                    ElevatedButton(
                        onPressed: null, child: "Football".text.black.make()),
                    ElevatedButton(
                        onPressed: null, child: "Tennis".text.black.make()),
                  ],
                ),
                isExpanded: active,
                canTapOnHeader: true)
          ],
        ),
      ],
    );
  }
}
