# Demo 
데모 앱입니다.

![example](https://github.com/jhj0517/flutter_choseong_search/blob/master/screenshots/example.gif)

## Usage in Dart
다음 예시와 같이 쿼리와 함께 리스트를 필터링 할 수 있습니다.
```dart
List<String> filterList(String query, List<String> fullList) {
  List<String> filteredList = [];

  if (query.isEmpty) {
    filteredList.addAll(fullList);
  } else {
    for (final item in fullList) {
      // `item` 과 `query` 비교에 패키지 사용 
      if (ChoseongSearch.compare(query: query, target: item)){
        filteredList.add(item);
      }
    }
  }
  
  return filteredList;
}
```
