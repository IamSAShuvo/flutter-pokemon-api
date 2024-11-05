import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'API Integration'),
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
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'));
    final Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> results = data['results'];

    print("The results of api $results");
    print("length = ${results.runtimeType}");

    List<Map<String, dynamic>> detailsList = [];

    // Iterate over the results with a for loop
    for (int i = 0; i < results.length; i++) {
      String url = results[i]['url'];
      var pokemonDetail = await fetchPokemonDetail(url);
      if (pokemonDetail != null) {
        detailsList.add(pokemonDetail);
      }
    }

    // for (var result in results) {
    //   if (result is Map<String, dynamic>) {
    //     String url = result['url'];
    //     // print("URL ====> $url & ${url.runtimeType}");
    //     // Fetch the Pokémon details
    //     var pokemonDetail = await fetchPokemonDetail(url);
    //     if (pokemonDetail != null) {
    //       detailsList.add(pokemonDetail);
    //     }
    //   }
    // }

    // print("########################################################");
    // print(detailsList.runtimeType);
    // print("########################################################");

    // Update the state with the fetched details
    setState(() {
      pokemonDetails = detailsList;
      isLoading = false; // Set loading to false after fetching
    });

    // print("********************************************************");
    // print(pokemonDetails);
    // print("********************************************************");

    // print("########################################################");
    // print(pokemonUrls);
    // print("########################################################");

    // for (var url in pokemonUrls) {
    //   print(url);
    // }
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
      // body: ListView.builder(
      //   itemCount: pokemonDetails.length,
      //   itemBuilder: (context, index) {
      //     final pokemon = pokemonDetails[index];
      //     return Card(
      //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //       child: ListTile(
      //         leading: Image.network(
      //           pokemon['image'],
      //           width: 50,
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: ListView.builder(
        itemCount: pokemonDetails.length,
        itemBuilder: (context, index) {
          final pokemon = pokemonDetails[index];
          // return ListTile(
          //   title: Text(
          //     pokemon['sprites']['back_default'],
          //   ),

          // );
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(
                pokemon['sprites']['back_default'],
                width: 100,
                fit: BoxFit.cover,
              ),
              title: Text(
                pokemon['name'],
              ),
            ),
          );
        },
      ),
    );
  }
}
