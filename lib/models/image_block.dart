import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageBlock extends StatefulWidget {
  final String? imageUrl;

  const ImageBlock({super.key, this.imageUrl});

  @override
  _ImageBlockState createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  String? _imageUrl;
  bool _isLoading = false;
  double _imageHeight = 100;
  Alignment _alignment = Alignment.center;

  String? get imageUrl => _imageUrl;

  void _showAddImageDialog() {
    TextEditingController imageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insert Image URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(hintText: 'Enter image URL'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Insert'),
              onPressed: () {
                Navigator.of(context).pop();
                _insertImage(imageUrlController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _insertImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _imageUrl = imageUrl;
          _isLoading = false;
        });
      } else {
        _showSnackBar('Image cannot be found');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Image cannot be found');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showImageOptionsDialog() {
    TextEditingController newImageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Height'),
              Slider(
                value: _imageHeight,
                min: 50,
                max: 300,
                divisions: 50,
                label: _imageHeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _imageHeight = value;
                  });
                },
              ),
              DropdownButton<Alignment>(
                value: _alignment,
                items: const [
                  DropdownMenuItem(
                    value: Alignment.centerLeft,
                    child: Text('Left'),
                  ),
                  DropdownMenuItem(
                    value: Alignment.center,
                    child: Text('Center'),
                  ),
                  DropdownMenuItem(
                    value: Alignment.centerRight,
                    child: Text('Right'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _alignment = value!;
                  });
                },
              ),
              TextField(
                controller: newImageUrlController,
                decoration: const InputDecoration(hintText: 'Enter new image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (newImageUrlController.text.isNotEmpty) {
                  _insertImage(newImageUrlController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _imageUrl == null
          ? GestureDetector(
              onTap: _showAddImageDialog,
              child: Container(
                color: Colors.grey,
                height: 100,
                width: double.infinity,
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Insert image'),
                ),
              ),
            )
          : GestureDetector(
              onTap: _showImageOptionsDialog,
              child: Container(
                height: _imageHeight,
                alignment: _alignment,
                child: Image.network(_imageUrl!),
              ),
            ),
    );
  }
}
