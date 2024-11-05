import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pokemon API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> pokemonDetails = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'));
    final Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> results = data['results'];
    print(data);

    List<Map<String, dynamic>> detailsList = [];

    // Iterate over the results with a for loop
    for (int i = 0; i < results.length; i++) {
      String url = results[i]['url'];
      var pokemonDetail = await fetchPokemonDetail(url);
      if (pokemonDetail != null) {
        detailsList.add(pokemonDetail);
      }
    }

    setState(() {
      pokemonDetails = detailsList;
      isLoading = false; // Set loading to false after fetching
    });
  }

  Future<Map<String, dynamic>?> fetchPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(
            34,
          ),
          child: Column(
            children: [
              const Text(
                "App Displaying Pokemon using API using Flutter to search Pokemon",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pokemonDetails.map(
                    (pokemon) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 182, 32, 179),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  pokemon['sprites']['back_default'] ?? '',
                                  width: 150,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    pokemon['name'],
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    pokemon['types'].length > 1
                                        ? "${pokemon['types'][0]['type']['name']}, ${pokemon['types'][1]['type']['name']}"
                                        : "${pokemon['types'][0]['type']['name']}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: isLoading
      //     ? const Column(
      //         children: [
      //           Text(
      //             "App Displaying Pokemon using API using Flutter to search Pokemon",
      //             style: TextStyle(
      //               fontSize: 34,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           CircularProgressIndicator(),
      //         ],
      //       ) // Show loading indicator
      //     : SingleChildScrollView(
      //         scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: pokemonDetails.map(
      //             (pokemon) {
      //               return Column(
      //                 children: [
      //                   Container(
      //                     decoration: BoxDecoration(
      //                       border: Border.all(
      //                         color: const Color.fromARGB(255, 182, 32, 179),
      //                         width: 1,
      //                       ),
      //                       borderRadius: const BorderRadius.all(
      //                         Radius.circular(20),
      //                       ),
      //                     ),
      //                     margin: const EdgeInsets.symmetric(
      //                         vertical: 30, horizontal: 16),
      //                     child: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Image.network(
      //                           pokemon['sprites']['back_default'] ?? '',
      //                           width: 150,
      //                           height: 100,
      //                           fit: BoxFit.cover,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(20.0),
      //                           child: Text(
      //                             pokemon['name'],
      //                             style: const TextStyle(fontSize: 28),
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.all(16.0),
      //                           child: Text(
      //                             pokemon['types'].length > 1
      //                                 ? "${pokemon['types'][0]['type']['name']}, ${pokemon['types'][1]['type']['name']}"
      //                                 : "${pokemon['types'][0]['type']['name']}",
      //                             style: const TextStyle(fontSize: 20),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             },
      //           ).toList(),
      //         ),
      //       ),
    );
  }
}
