import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDescription extends StatefulWidget {
  const ImageDescription({
    super.key,
    required this.likes,
    required this.desc,
    required this.url,
  });
  final String url, desc;
  final int likes;

  @override
  State<ImageDescription> createState() => _ImageDescriptionState();
}

class _ImageDescriptionState extends State<ImageDescription> {
  Future<void> _downloadAndSaveImage() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final http.Response response = await http.get(Uri.parse(widget.url));

        if (response.statusCode == 200) {
          const String downloadsPath = '/storage/emulated/0/DCIM/demopictures';
          final File file = File('$downloadsPath/downloaded_image.png');

          await file.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image downloaded and saved to ${file.path}'),
            ),
          );
        } else {
          print('Failed to download image: ${response.statusCode}');
        }
      } else {
        print('Storage permission not granted');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Image Description'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        image: NetworkImage(widget.url), fit: BoxFit.cover),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY:
                              5), // Adjust sigmaX and sigmaY for the desired blur intensity
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 20,
                        blur: 20,
                        alignment: Alignment.bottomCenter,
                        border: 2,
                        linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFffffff).withOpacity(0.1),
                              const Color(0xFFFFFFFF).withOpacity(0.05),
                            ],
                            stops: const [
                              0.1,
                              1,
                            ]),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.5),
                            const Color((0xFFFFFFFF)).withOpacity(0.5),
                          ],
                        ),
                        child: Image.network(widget.url),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(0)),
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_rounded),
                      label: Text('${widget.likes}')),
                ),
                Text(widget.desc),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                  onPressed: () {
                    _downloadAndSaveImage();
                  },
                  child: const Text('Download'))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
