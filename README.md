# Flutter Choseong Search
한글 초성 검색 플러터 패키지 입니다.

## Installation
`flutter pub add choseong_search` 를 터미널에 실행하시거나, `pubspec.yaml` 에 수동으로 패키지를 추가하세요.
```yaml
dependencies:
  choseong_search: 1.0.0
```
그 다음 코드 내에서 패키지를 추가하세요 :
```dart
import 'package:choseong_search/choseong_search.dart';
```

## Usage
1. 초성 검색
```dart
import 'package:choseong_search/choseong_search.dart';

ChoseongSearch.search(query: "ㅇㄴㅎㅅㅇ", target: "안녕하세요") // returns true
ChoseongSearch.search(query: "ㅇ녕하ㅅㅇ", target: "안녕하세요") // returns true
ChoseongSearch.search(query: "ㅇ녕하ㅅ염", target: "안녕하세요") // returns false
```
검색어 `query` 와 검색 대상어 `target`을 비교해 `bool` 값을 리턴합니다.

2. 초성, 중성, 종성 추출하기
```dart
import 'package:choseong_search/choseong_search.dart';

ChoseongSearch.getChoseong(char: "안녕하세요ㅋㅋ") // returns "ㅇㄴㅎㅅㅇㅋㅋ"
ChoseongSearch.getJungseong(char: "안녕하세요ㅋㅋ") // returns "ㅏㅕㅏㅔㅛ  "
ChoseongSearch.getJongseong(char: "안녕하세요ㅋㅋ") // returns "ㄴㅇ     "
```
문자 `char` 을 입력 받아 초성, 중성, 종성을 추출할 수 있습니다.
대상 음절이 추출 되지 않은 인덱스 에는 공백 " " 이 들어갑니다.



