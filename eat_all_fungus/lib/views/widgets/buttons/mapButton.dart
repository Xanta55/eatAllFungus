import 'package:eat_all_fungus/providers/streams/tileStream.dart';
import 'package:eat_all_fungus/views/widgets/buttons/digButton.dart';
import 'package:eat_all_fungus/views/widgets/buttons/townButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapButton extends HookWidget {
  const MapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileState = useProvider(mapTileStreamProvider);
    return tileState?.townOnTile.isEmpty ?? false ? DigButton() : TownButton();
  }
}
