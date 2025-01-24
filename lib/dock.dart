import 'package:flutter/material.dart';

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.09,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: ReorderableListView(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        onReorder: _onReorder,
        shrinkWrap: true,
        onReorderStart: (index) {
          setState(
            () => _items[index] = _items[index],
          );
        },
        proxyDecorator: (child, index, animation) {
          return AnimatedScale(
            scale: 1.1,
            curve: Curves.linear,
            duration: const Duration(
              milliseconds: 300,
            ),
            child: Material(
              key: ValueKey(index),
              color: Colors.transparent,
              child: _buildBox(_items.elementAt(index)),
            ),
          );
        },
        children: _items.map(
          (item) {
            // return _buildBox(item);
            final index = _items.indexOf(item);
            return ReorderableDragStartListener(
              key: Key(index.toString()),
              index: _items.indexOf(item),
              child: _buildBox(item),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildBox(T item) {
    return Container(
      key: ValueKey(item),
      constraints: const BoxConstraints(
        minWidth: 48,
      ),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.primaries[_items.indexOf(item) % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          item as IconData,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final T item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
      },
    );
  }
}
