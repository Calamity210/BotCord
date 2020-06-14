import 'package:discord_bot_account/provider/bot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleWidget extends StatefulWidget {
  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              botProvider.title.text != '' ? botProvider.title.text : 'TITLE',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: botProvider.title,
              style: TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
        )
      ],
    );
  }
}

class DescWidget extends StatefulWidget {
  @override
  _DescWidgetState createState() => _DescWidgetState();
}

class _DescWidgetState extends State<DescWidget> {
  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              botProvider.description.text != '' ? botProvider.description.text : 'Description',
              style:
                  TextStyle(color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: botProvider.description,
              style: TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
        )
      ],
    );
  }
}

class URLWidget extends StatefulWidget {
  @override
  _URLWidgetState createState() => _URLWidgetState();
}

class _URLWidgetState extends State<URLWidget> {
  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              botProvider.url.text != '' ? botProvider.url.text : 'URL',
              style:
                  TextStyle(color: Colors.blue),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: botProvider.url,
              style: TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  hintText: 'URL',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
        )
      ],
    );
  }
}

class FooterWidget extends StatefulWidget {
  @override
  _FooterWidgetState createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  botProvider.footerTextController.text != '' ? botProvider.footerTextController.text : 'Text',
                  style:
                      TextStyle(color: Colors.white),
                ),

                if (botProvider.footerURLController.text.contains('(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)'))
                Image.network(botProvider.footerURLController.text)
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: botProvider.footerTextController,
                  style: TextStyle(color: Colors.white),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                      hintText: 'Text',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),

                TextField(
              controller: botProvider.footerURLController,
              style: TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  hintText: 'Icon Image URL',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),

              ],
            ),
          ),
        )
      ],
    );
  }
}