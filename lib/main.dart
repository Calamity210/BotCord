import 'package:discord_bot_account/Widgets/navigation_drawer.dart';
import 'package:discord_bot_account/pages/login_screen.dart';
import 'package:discord_bot_account/pages/messages_page.dart';
import 'package:discord_bot_account/provider/bot_provider.dart';
import 'package:discord_bot_account/provider/drawers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();

  // ignore: non_constant_identifier_names
  final BOT_TOKEN = prefs.getString('BOT_TOKEN') ?? '';

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  // Check if a bot is signed in
  BOT_TOKEN == ''
      ? runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BotProvider()),
            ],
            child: LoginScreen(),
          ),
        )
      : runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => BotProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => DrawersProvider(),
              ),
            ],
            child: MyApp(),
          ),
        );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Discord Bot',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final double maxSlide = 300.0;

  @override
  void initState() {
    // Initialize the bot
    initBot();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<DrawersProvider>(context, listen: false).dispose();
    super.dispose();
  }

  Future<void> initBot() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('BOT_TOKEN');
    Provider.of<BotProvider>(context, listen: false).initBot(token);
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<DrawersProvider>(context, listen: false)
            .animationController ==
        null) {
      Provider.of<DrawersProvider>(context, listen: false).setController(
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 250)),
      );
    }

    var drawersProvider = Provider.of<DrawersProvider>(context);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: GestureDetector(
          onHorizontalDragStart: drawersProvider.onDragStart,
          onHorizontalDragUpdate: (details) =>
              drawersProvider.onDragUpdate(details, maxSlide),
          onHorizontalDragEnd: (details) =>
              drawersProvider.onDragEnd(details, context),
          child: AnimatedBuilder(
            animation: drawersProvider.animationController,
            builder: (context, _) {
              double slide =
                  maxSlide * drawersProvider.animationController.value;
              return Stack(
                children: <Widget>[
                  NavigationDrawer(),
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(slide),
                    alignment: Alignment.centerLeft,
                    child: MessagesPage(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
