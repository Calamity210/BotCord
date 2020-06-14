import 'package:discord_bot_account/provider/bot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<BotProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        color: Color(0xFF2F3136),
        child: appState.bot == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    color: Color(0XFF1f1f21),
                    width: 60,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: appState.getGuilds(),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 24.0),
                              child: Text(
                                appState.selectedGuild != null ?
                                (appState.selectedGuild.name.length <= 22
                                    ? appState.selectedGuild.name
                                    : appState.selectedGuild.name
                                            .substring(0, 19) +
                                        '...') : 'Loading Guild',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: SingleChildScrollView(
                                child: Container(
                              width:
                                  (MediaQuery.of(context).size.width * 0.85) -
                                      60,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: appState.getChannels(
                                    appState.selectedGuild,
                                    MediaQuery.of(context).size.width * 0.7,
                                    context,
                                  )),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
