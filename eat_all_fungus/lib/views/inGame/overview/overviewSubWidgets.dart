import 'package:eat_all_fungus/constValues/constValues.dart';
import 'package:eat_all_fungus/controllers/playerController.dart';
import 'package:eat_all_fungus/models/player.dart';
import 'package:eat_all_fungus/providers/streams/newsStream.dart';
import 'package:eat_all_fungus/providers/streams/playerStream.dart';
import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/models/mapTile.dart';
import 'package:eat_all_fungus/views/widgets/constWidgets/panel.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/playerInventory.dart';
import 'package:eat_all_fungus/views/widgets/items/inventories/tileInventory.dart';
import 'package:eat_all_fungus/views/widgets/mapView/mapSubWidgets.dart';
import 'package:eat_all_fungus/views/widgets/newspaper/miniNewspaper.dart';
import 'package:eat_all_fungus/views/widgets/status/statusWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const List<Widget> overviewTiles = <Widget>[
  _BuildToDoList(),
  _BuildTilePreview(),
  OverviewTileInfo(),
  PlayerInventory(),
  OverviewPlayerStatus(),
  OverviewNews()
];

class _BuildToDoList extends HookWidget {
  const _BuildToDoList();

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerStreamProvider);
    if (playerState != null) {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'To-Do:',
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: buildTodoWidget(todoList: playerState.todoList),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }

  Widget buildTodoWidget({required List<String> todoList}) {
    if (todoList.isEmpty) {
      return ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'All done for today!',
            textAlign: TextAlign.center,
          ),
        ),
      ]);
    }
    return ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.crop_square),
              title: Text(todoList[index]),
            ),
          );
        });
  }
}

class _BuildTilePreview extends HookWidget {
  const _BuildTilePreview();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: tileState != null
              ? tilePreview(tile: tileState)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget tilePreview({required MapTile tile}) {
    return Container(
      child: MapTileWidget(tile.copyWith(playersOnTile: 0)),
    );
  }
}

class OverviewInventory extends HookWidget {
  final bool canTap;
  const OverviewInventory({this.canTap = false});

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerControllerProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: playerState.when(
            data: (player) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        'Inventory: ${player.inventory.length}/${player.inventorySize}'),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: buildPlayerInventoryList(canTap: canTap),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Container(),
            error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                )),
      ),
    );
  }
}

class OverviewTileInfo extends HookWidget {
  const OverviewTileInfo();

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    if (tileState != null) {
      if (tileState.townOnTile.isEmpty) {
        final itemWidgetList =
            buildTileInventoryList(tileInventory: tileState.inventory);
        return Panel(
          child: Container(
            color: Colors.grey[colorIntensity],
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Items on Tile:'),
                  Expanded(
                    child: ListView(
                      //shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: itemWidgetList,
                    ),
                  )
                ],
              ),
            )),
          ),
        );
      } else {
        return Panel(
          child: Container(
            color: Colors.grey[colorIntensity],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'A town exists on this tile',
                textAlign: TextAlign.center,
              )),
            ),
          ),
        );
      }
    } else {
      return Panel(
        child: Container(
          color: Colors.grey[colorIntensity],
        ),
      );
    }
  }
}

class OverviewPlayerStatus extends HookWidget {
  const OverviewPlayerStatus();

  @override
  Widget build(BuildContext context) {
    final playerState = useProvider(playerControllerProvider.notifier);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: StreamBuilder(
            stream: playerState.getPlayerStream(),
            builder: (context, player) {
              if (player.connectionState == ConnectionState.active) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Current Statuseffects:'),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: buildPlayerStatusList(
                              statusEffects:
                                  (player.data as Player).statusEffects),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class OverviewNews extends HookWidget {
  const OverviewNews();

  @override
  Widget build(BuildContext context) {
    final newsStream = useProvider(newsStreamProvider);
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: MiniNewspaper(newsInput: newsStream),
        ),
      ),
    );
  }
}
