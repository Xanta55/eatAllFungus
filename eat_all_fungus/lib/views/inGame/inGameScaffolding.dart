import 'package:eat_all_fungus/controllers/profileController.dart';
import 'package:eat_all_fungus/controllers/worldController.dart';
import 'package:eat_all_fungus/providers/inGameNavigationProvider.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/services/authRepository.dart';
import 'package:eat_all_fungus/views/inGame/map/mapWidget.dart';
import 'package:eat_all_fungus/views/inGame/overview/overviewWidget.dart';
import 'package:eat_all_fungus/views/inGame/town/townWidget.dart';
import 'package:eat_all_fungus/views/widgets/buttons/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InGameScaffolding extends HookWidget {
  const InGameScaffolding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationState = useProvider(navStateProvider);
    final tileStream = useProvider(mapTileStreamProvider);
    final worldState = useProvider(worldControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(navigationState.toUpperCase()),
        actions: [
          buildLogoutButton(context),
          IconButton(
              onPressed: () {
                final profile =
                    context.read(profileControllerProvider).data?.value;
                if (profile != null) {
                  context
                      .read(worldControllerProvider.notifier)
                      .removePlayerFromWorld();
                } else {
                  print('LeaveWorldButton - no current profile found!');
                }
              },
              icon: Icon(Icons.warning))
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              _buildDrawerButton(context, 'Overview'),
              _buildDrawerButton(context, 'Map'),
              (tileStream != null && tileStream.townOnTile != '')
                  ? _buildDrawerButton(context, 'Town')
                  : Container(),
              _buildDrawerButton(context, 'Player'),
              _buildDrawerButton(context, 'Radio'),
              Divider(color: Colors.amber[200]),
              SizedBox(height: 16.0),
              _buildDrawerButton(context, 'World'),
              _buildDrawerButton(context, 'Profile'),
              Divider(color: Colors.amber[200]),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  context.read(navStateProvider.notifier).setRoute('overview');
                  context.read(authRepositoryProvider).signOut();
                },
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(navigationState),
    );
  }

  Widget _buildDrawerButton(BuildContext context, String navigation) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(navigation),
            onTap: () {
              context
                  .read(navStateProvider.notifier)
                  .setRoute(navigation.toLowerCase());
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildBody(String route) {
    switch (route) {
      case 'overview':
        return OverviewWidget();
      case 'player':
        return Container(
          child: Center(
            child: Text('Player'),
          ),
        );
      case 'map':
        return MapWidget();
      case 'town':
        return TownWidget();
      case 'radio':
        return Container(
          child: Center(
            child: Text('Radio'),
          ),
        );
      case 'world':
        return Container(
          child: Center(
            child: Text('World'),
          ),
        );
      case 'profile':
        return Container(
          child: Center(
            child: Text('Profile'),
          ),
        );
    }

    return Container(
      child: Center(
        child: Text('Huch'),
      ),
    );
  }
}
