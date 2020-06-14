import 'dart:async';
import 'dart:core';

import 'package:discord_bot_account/provider/drawers_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyxx/Vm.dart';
import 'package:nyxx/nyxx.dart';
import 'package:provider/provider.dart';

class BotProvider with ChangeNotifier {
  /// Instance of bot client
  Nyxx _bot;

  /// Guilds the bot is currently joined
  List<Widget> _guilds = List<Widget>();
  Guild _selectedGuild;

  /// Text Channels and Categories within a guild
  List<Widget> _textChannels = List<Widget>();
  Map<String, List<Widget>> _channelCategories = Map<String, List<Widget>>();

  /// currently selected channel and list of channels in current guild
  List<Widget> _channels = List<Widget>();
  Channel _selectedChannel;
  MessageChannel chan;

  Future<List<Widget>> _messages;

  /// UTILS
  double width = 0.0;
  bool _loading = false;

  /// TextStyles
  TextStyle selectedStyle = TextStyle(
    color: Colors.white,
    backgroundColor: Color(0XFF393c43),
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  TextStyle channelStyle = TextStyle(
    color: const Color(0XFF606266),
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  /// ______________________________________________________________________________________________
  /// Embeds Form Utils
  ///
  /// Embed Color
  Color _selectedColor = Colors.purple;

  /// Current Page
  int _curPage = 0;

  /// [TextEditingController]s for embed form
  ///
  /// Title controller
  TextEditingController _titleController = TextEditingController();

  /// Description Controller
  TextEditingController _descController = TextEditingController();

  /// URL Controller
  TextEditingController _urlController = TextEditingController();

  /// Footer Controllers
  ///
  /// Footer Text Controller
  TextEditingController _footerTextController = TextEditingController();

  /// Footer Icon Image URL Controller
  TextEditingController _footerURLController = TextEditingController();

  /// instance of Nyxx Client
  Nyxx get bot => _bot;

  /// All guilds the bot is a part of
  List<Widget> get guilds => _guilds;

  /// Current selected guild
  Guild get selectedGuild => _selectedGuild;

  List<Widget> get channels => _channels;
  Channel get selectedChannel => _selectedChannel;

  bool get loading => _loading;

  Future<List<Widget>> get messages => _messages;

  /// Embeds Form Utils
  ///
  /// Embed Color
  Color get selectedColor => _selectedColor;
  set selectedColor(color) => _selectedColor = color;

  // Current Page
  int get curPage => _curPage;
  set curPage(page) => _curPage = page;

  /// [TextEditingController]s for embed form
  TextEditingController get title => _titleController;
  TextEditingController get description => _descController;
  TextEditingController get url => _urlController;

  /// [TextEditingController]s for embed footer
  TextEditingController get footerTextController => _footerTextController;
  TextEditingController get footerURLController => _footerURLController;

  void initBot(String token) {
    _messages = getMessages();
    configureNyxxForVM();
    _bot = Nyxx(token);

    _bot.onReady.listen((_) {
      try {
        print('Logged in as ${bot.self.tag}');
        notifyListeners();
      } catch (e) {
        print('Invalid Token');
      }
    });

    _bot.onMessageReceived.listen((event) {
      notifyListeners();
    });

    _bot.onChannelCreate.listen((event) {
      notifyListeners();
    });

    _bot.onChannelDelete.listen((event) {
      notifyListeners();
    });

    _bot.onMessageUpdate.listen((event) {
      notifyListeners();
    });

    _bot.onMessageDelete.listen((event) {
      notifyListeners();
    });

    _bot.onMessageDeleteBulk.listen((event) {
      notifyListeners();
    });
  }

  // @override
  // void dispose() {
  //   _streamController.close();
  //   super.dispose();
  // }

  void selectGuild(Guild g) {
    _selectedGuild = g;
    print(g.name);
    notifyListeners();
  }

  Future<void> selectChannel(Channel c, BuildContext context) async {

    _selectedChannel = c;
    chan = await _bot.getChannel(_selectedChannel.id);
    _messages = getMessages();

    notifyListeners();
    Provider.of<DrawersProvider>(context, listen: false).close();
  }

  List<Widget> getGuilds() {
    _loading = true;
   
    _guilds.clear();
    _bot.guilds.forEach((key, g) {
      if (g.iconURL() == null) {
        _guilds.add(
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: () => selectGuild(g),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF2F3136),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(bottom: 4),
                child: Center(
                  child: Text(g.name.substring(0, 1)),
                ),
              ),
            ),
          ),
        );
      } else {
        _guilds.add(
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: () => selectGuild(g),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      g.iconURL(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      // notifyListeners();
    });

    if (_bot.guilds.values.length >= 1)
      _selectedGuild =
          _bot.guilds.values.elementAt(_bot.guilds.values.length - 1);

    // notifyListeners();

    return _guilds;
  }

  // Channel Types:
  // 0 = text
  // 1 = voice
  // 4 = category
  List<Widget> getChannels(Guild g, double widthNew, BuildContext context) {
    width = widthNew + 22;
    _channels.clear();
    _channelCategories.clear();
    _textChannels.clear();

    if (g != null) {
      g.channels.forEach((key, c) async {
        bool isSelected =
            selectedChannel != null ? c.id == _selectedChannel.id : false;

        var parent = c.parentChannel;
        var name = c.name;

        if (c.type != 2) {
          if (c.type == 4) {
            _channelCategories.putIfAbsent(
                c.name,
                () => [
                      SizedBox(height: 15),
                      name.length < 25
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15.0, left: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${name.toUpperCase()}',
                                      textAlign: TextAlign.start,
                                      style: isSelected
                                          ? selectedStyle
                                          : channelStyle,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15.0, left: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${name.substring(0, 25).toUpperCase()}...',
                                    textAlign: TextAlign.start,
                                    style: isSelected
                                        ? selectedStyle
                                        : channelStyle,
                                  ),
                                ],
                              ),
                            )
                    ]);

            _channels.add(Column(
              children: _channelCategories[c.name],
            ));
          } else if (parent != null) {
            _channelCategories.putIfAbsent(
              parent.name,
              () => [
                SizedBox(height: 15),
                parent.name.length < 25
                    ? Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${parent.name.toUpperCase()}',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${parent.name.substring(0, 25).toUpperCase()}...',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      )
              ],
            );

            _channelCategories[parent.name].add(
              name.length < 25
                  ? GestureDetector(
                      onTap: () {
                        selectChannel(c, context);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '# $name',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        selectChannel(c, context);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '# ${name.substring(0, 25)}...',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      )),
            );
          } else if (c.type == 0 && parent == null) {
            _textChannels.add(
              name.length < 25
                  ? GestureDetector(
                      onTap: () {
                        selectChannel(c, context);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '# $name',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        selectChannel(c, context);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '# ${name.substring(0, 25)}...',
                              textAlign: TextAlign.start,
                              style: isSelected ? selectedStyle : channelStyle,
                            ),
                          ],
                        ),
                      )),
            );
          }
        }
        // notifyListeners();
      });
      _channels.addAll(_textChannels);

      if (_selectedChannel == null)
        selectChannel(
                g.channels.values.firstWhere((element) => element.type == 0),
                context)
            .then((value) => getMessages());
    }

    _loading = false;

    return _channels;
  }

  // Future<List<Widget>> getStream() {
  //   return getMessages();
  //   // return _streamController.stream;
  // }

  Future<List<Widget>> getMessages() async {
    var msgs = await chan.getMessages(limit: 100);

    return List<Widget>.generate(msgs.values.length, (i) {
      var createdAt = msgs.values.elementAt(i).createdAt.toLocal();
      var timestamp = '${createdAt.month}/${createdAt.day}/${createdAt.year}';
      var nickname =
          _selectedGuild.members[msgs.values.elementAt(i).author.id] != null &&
                  _selectedGuild.members[msgs.values.elementAt(i).author.id]
                          .nickname !=
                      null
              ? _selectedGuild
                  .members[msgs.values.elementAt(i).author.id].nickname
              : msgs.values.elementAt(i).author.username;

      int r;
      int g;
      int b;

      try {
        var color = _selectedGuild
            .members[msgs.values.elementAt(i).author.id].highestRole.color;

        r = color.r;
        g = color.G;
        b = color.B;
      } catch (e) {}

      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 15.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(msgs.values
                                    .elementAt(i)
                                    .author
                                    .avatar !=
                                null
                            ? 'https://cdn.discordapp.com/avatars/${msgs.values.elementAt(i).author.id.id}/${msgs.values.elementAt(i).author.avatar}.png'
                            : 'https://cdn.discordapp.com/embed/avatars/${msgs.values.elementAt(i).author.discriminator}.png')),
                  ),
                ),
              ),
              Container(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nickname.length >= 25
                              ? nickname.substring(0, 25)
                              : nickname,
                          style: TextStyle(
                            color: r != null
                                ? Color.fromARGB(255, r, g, b)
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            timestamp,
                            style: TextStyle(
                              color: Color(0xFF72767d),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      msgs.values.elementAt(i).content,
                      style: TextStyle(color: Color(0xFFdcddde)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void notify() {
    notifyListeners();
  }

  void sendMessage(String text) {
    _bot.sendMessage(text, _selectedChannel);
    notifyListeners();
  }

  void sendEmbed(BuildContext context) {
    Map<String, dynamic> embedMap = Map<String, dynamic>();

    if (_titleController.text.isNotEmpty)
      embedMap['title'] = _titleController.text;
    if (_descController.text.isNotEmpty)
      embedMap['description'] = _descController.text;
    if (_urlController.text.isNotEmpty)
      embedMap['url'] = _urlController.text;
    if (_selectedColor != null) {
      var clr = _selectedColor
          .toString()
          .replaceAll('Color(0xff', '0x')
          .replaceAll('MaterialColor(primary value: 0x', '0x')
          .replaceAll(')', '');
          print(clr);
      embedMap['color'] = int.parse(clr);
    }
    if (_footerTextController.text.isNotEmpty ||
        _footerURLController.text.isNotEmpty) {
      Map<String, dynamic> footerMap = Map<String, dynamic>();

      if (_footerTextController.text.isNotEmpty)
        footerMap['text'] = _footerTextController.text;

      if (_footerURLController.text.isNotEmpty)
        footerMap['icon_url'] = _footerURLController.text;


      embedMap['footer'] = footerMap;
      print(embedMap.toString());
    }

    

    _bot.sendEmbedMessage(embedMap, _selectedChannel);
    curPage = 0;
    Navigator.of(context).pop();
  }
}
