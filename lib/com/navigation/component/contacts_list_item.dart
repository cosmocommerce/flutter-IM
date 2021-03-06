import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/com/navigation/models/contacts_list_model.dart';
import 'package:flutter_app/com/navigation/page/subpage/chart_dialog.dart';
import 'package:flutter_app/com/navigation/netwok/socket_handler.dart'
    as handler;

class ContactItem extends StatefulWidget {
  final Entry entry;

  ContactItem(this.entry);

  @override
  ContactItemState createState() => ContactItemState();
}

class ContactItemState extends State<ContactItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty)
      return FadeTransition(
        opacity: _drawerContentsOpacity,
        child: ListTile(
          title: getPerson(root.title),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChartDialog(
                        messages: handler.getChatRecorder(root.title),
                        name: root.title,
                      ),
                ),
              ),
        ),
      );
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: getGroup(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.entry);
  }

  getGroup(String title) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 22.0),
            ),
          ],
        ),
      ],
    );
  }

  getPerson(String name) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage("assets/images/icon.png"),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 20.0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
