import 'package:flutter/material.dart';
import 'package:choseong_search/choseong_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '한글 초성 검색'),
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

  final List<String> hangeulWords = [
    '가방',
    '가지',
    '가위',
    '가을',
    '나무늘보',
    '노트북',
    '눈사람',
    '넥타이',
    '가사',
    '가장',
    '바나나',
    '사과나무',
    '자동차',
    '주머니',
    '초콜릿',
  ];

  final TextEditingController searchBarController = TextEditingController();
  List<String> _filteredList = [];

  void _filterList(String query) {
    List<String> filteredList = [];

    if (query.isEmpty) {
      filteredList.addAll(hangeulWords);
    } else {
      for (final item in hangeulWords) {
        if (ChoseongSearch.compare(query: query, target: item)){
          filteredList.add(item);
        }
      }
    }

    setState(() {
      _filteredList = filteredList;
    });
  }

  @override
  void initState() {
    _filterList("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: searchBarController,
              onChanged: (query) {
                setState(() {
                  _filterList(query);
                });
              },
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 3
                ),
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  final item = _filteredList[index];
                  return Center(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
