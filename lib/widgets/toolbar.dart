import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  final VoidCallback onAddTextBlock;
  final VoidCallback onAddImageBlock;

  const Toolbar({
    super.key,
    required this.onAddTextBlock,
    required this.onAddImageBlock,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: onAddTextBlock,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: onAddImageBlock,
          ),
        ],
      ),
    );
  }
}