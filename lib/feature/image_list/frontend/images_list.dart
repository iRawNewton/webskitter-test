import 'package:flutter/material.dart';
import 'package:flutter_machine_test/feature/description/frontend/image_desc.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';

import '../model/datamodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Access Key: 8fZZLAtYG6LkkNbNsa7-_35CESYO-62CM5zQfc_-Nas
  late Future futureVariable;
  List<DataModel> getImagesData = [];

  Future<List<DataModel?>?> getImagesFunc() async {
    final uri = Uri.parse('https://api.unsplash.com/photos');
    final headers = {
      'Authorization': 'Client-ID 8fZZLAtYG6LkkNbNsa7-_35CESYO-62CM5zQfc_-Nas',
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
      setState(() {
        getImagesData = dataModelFromJson(response.body);
      });
      return getImagesData;
    } else {
      return getImagesData;
    }
  }

  @override
  void initState() {
    futureVariable = getImagesFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Unsplash Clone'),
          backgroundColor: Colors.amber,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(20),
                FutureBuilder(
                  future: futureVariable,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: getImagesData.length,
                          itemBuilder: (context, index) {
                            // return Text(getImagesData[index].id);
                            return InkWell(
                              onTap: () {
                                // image, desc, number of likes,
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageDescription(
                                      likes: getImagesData[index].likes,
                                      desc: getImagesData[index].altDescription,
                                      url: getImagesData[index].urls.small,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Image.network(
                                        getImagesData[index].urls.small,
                                        fit: BoxFit.contain),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text(
                                          getImagesData[index].altDescription),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('Oops, an error occurred!');
                      }
                    } else {
                      return const Text('Try again later');
                    }
                  },
                ),
                // Align(
                //     alignment: Alignment.bottomRight,
                //     child: ElevatedButton(
                //         onPressed: () {}, child: const Text('Next Page')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
