import 'package:discord_bot_account/Widgets/embed_form.dart';
import 'package:discord_bot_account/provider/bot_provider.dart';
import 'package:discord_bot_account/provider/drawers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  final _textController = TextEditingController();
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF23272A),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            Provider.of<DrawersProvider>(context, listen: false).toggle();
          },
        ),
        title: Text(
            '# ${Provider.of<BotProvider>(context).selectedChannel?.name ?? "Loading Channel"}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.people, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF2F3136),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 925,
              child: Container(
                child: Provider.of<BotProvider>(context).selectedChannel !=
                            null &&
                        !Provider.of<BotProvider>(context).loading
                    ? FutureBuilder(
                        future: Provider.of<BotProvider>(context).messages,
                        builder:
                            (context, AsyncSnapshot<List<Widget>> snapshot) {
                          if (snapshot.hasData && !Provider.of<BotProvider>(context).loading) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return snapshot.data[index];
                              },
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // TODO: GESTURE DETECTOR FOR ONTAP
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Color(0xFF23272A), shape: BoxShape.circle),
                          child: Icon(
                            Icons.camera_alt,
                            color: Color(0xFFd1d1d1),
                          ),
                        ),

                        // TODO: GESTURE DETECTOR FOR ONTAP
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: StatefulBuilder(
                                  builder: (context, setState) => Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    color: Color(0xFF2F3136),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: botProvider.selectedColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                        ),
                                        Expanded(
                                          child: Container(
                                            color: Color(0xFF2F3136),
                                            child: PageView(
                                              physics: NeverScrollableScrollPhysics(),
                                              controller: _controller,
                                              children: <Widget>[
                                                Center(
                                                  child: CircleColorPicker(
                                                    initialColor: botProvider
                                                        .selectedColor,
                                                    onChanged: (color) {
                                                      setState(() => botProvider
                                                              .selectedColor =
                                                          color);
                                                    },
                                                    size: const Size(250, 250),
                                                    strokeWidth: 4,
                                                    thumbSize: 36,
                                                  ),
                                                ),
                                                TitleWidget(),
                                                DescWidget(),
                                                URLWidget(),
                                                FooterWidget()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      botProvider.curPage = 0;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: botProvider.curPage != 4
                                        ? Text('Next')
                                        : Text('Send'),
                                    onPressed: () {
                                      botProvider.curPage == 4
                                          ? botProvider.sendEmbed(context)
                                          : _controller
                                              .nextPage(
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease)
                                              .then((value) {
                                                botProvider.curPage++;
                                                print(botProvider.curPage);
                                              });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFF23272A),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.photo,
                              color: Color(0xFFd1d1d1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 50.0,
                      minWidth: MediaQuery.of(context).size.width - 115.0,
                      maxWidth: MediaQuery.of(context).size.width - 115.0,
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF23272A),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: (MediaQuery.of(context).size.width - 115) *
                                  0.86,
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _textController,
                                maxLengthEnforced: true,
                                maxLength: 2000,
                                minLines: 1,
                                maxLines: 5,
                                style: TextStyle(color: Color(0xFFd1d1d1)),
                                onSubmitted: (_) {
                                  Provider.of<BotProvider>(context,
                                          listen: false)
                                      .sendMessage(_textController.text);
                                  _textController.clear();
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: 'Message' +
                                      (Provider.of<BotProvider>(context)
                                                  .selectedChannel !=
                                              null
                                          ? ' #${Provider.of<BotProvider>(context).selectedChannel.name.length >= 10 ? Provider.of<BotProvider>(context).selectedChannel.name.substring(0, 10) + "..." : Provider.of<BotProvider>(context).selectedChannel.name}'
                                          : ''),
                                  hintStyle: TextStyle(
                                    color: Color(0xFFd1d1d1),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<BotProvider>(context, listen: false)
                                    .sendMessage(_textController.text);
                                _textController.clear();
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                width:
                                    (MediaQuery.of(context).size.width - 115) *
                                        0.14,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Icon(
                                    Icons.send,
                                    color: Color(0xFFd1d1d1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
