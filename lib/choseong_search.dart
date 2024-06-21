library choseong_search;

class ChoseongSearch {
  static const int hangeulStartUnicdoe = 44032;
  static const int hangeulEndUnicode = 55203;

  static const List<String> choSeong = [
    "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
  ];
  static const List<String> jungSeong = [
    "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"
  ];
  static const List<String> jongSeong = [
    " ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
  ];

  /// [target] 에 대해서 [query] 와 비교해 일치하는 초성이 있으면 true, 없으면 false 를 리턴합니다.
  /// 예시 : search(query: "안녕ㅎㅅㅇ", target: "안녕하세요") returns true
  /// 예시:  search(query: "안녕ㅎㅅ염", target: "안녕하세요") returns false
  ///
  /// [query] 입력될 검색어입니다.
  ///
  /// [target] `query` 와 비교할 대상입니다.
  ///
  /// [enableTrim] `query` 와 `target` 을 비교 시 공백을 제외하고 비교할 지를 정합니다. 기본값은 true 입니다.
  static bool search({
    required String query,
    required String target,
    bool enableTrim=true
  }) {
    if (enableTrim){
      query = query.trim();
      target = target.trim();
    }

    if (query.length > target.length) {
      return false;
    }

    final List<int> choIndexes = _getChoIndexes(char: query);

    if (choIndexes.isEmpty) return target.contains(query);

    for (int i in choIndexes) {
      String targetChar = target[i];
      String targetCho = getChoseong(char: targetChar);
      if (query[i] != targetCho) {
        return false;
      }
    }

    String filteredTarget = choIndexes.map((i) => target.substring(i)).join();
    String filteredQuery = choIndexes.map((i) => query.substring(i)).join();

    return filteredTarget.contains(filteredQuery);
  }

  /// 한글 문자 [char] 를 입력받아 초성을 추출합니다. 해당 인덱스에 초성이 아예 존재하지 않으면, 공백 " "을 추출합니다.
  /// 예시 : getChoseong(char: "헤헤 ㅋㅋ") returns "ㅎㅎ ㅋㅋ"
  ///
  /// [char] 초성을 추출할 한글 문자입니다.
  static String getChoseong({
    required String char
  }) {
    String cho = "";
    for (String c in char.split('')) {
      if (!isHangeul(char: c)) {
        cho += " ";
        continue;
      }

      if (choSeong.contains(c)) {
        cho += c;
        continue;
      } else if (jungSeong.contains(c) || jongSeong.contains(c)) {
        cho += " ";
        continue;
      }

      int choIndex = (c.codeUnitAt(0) - hangeulStartUnicdoe) ~/ (jongSeong.length * jungSeong.length);
      cho += choSeong[choIndex];
    }
    return cho;
  }

  /// 한글 문자 [char] 를 입력받아 중성을 추출합니다. 해당 인덱스에 중성이 아예 존재하지 않으면, 공백 " "을 추출합니다.
  /// 예시 : getJungseong(char: "헤헤 ㅋㅋ") returns "ㅔㅔ   "
  ///
  /// [char] 중성을 추출할 한글 문자입니다.
  static String getJungseong({
    required String char
  }) {
    String jung = "";
    for (String c in char.split('')) {
      if (!isHangeul(char: c)) {
        jung += " ";
        continue;
      }

      if (jungSeong.contains(c)) {
        jung += c;
        continue;
      } else if (choSeong.contains(c) || jongSeong.contains(c)) {
        jung += " ";
        continue;
      }

      int joongIndex = (c.codeUnitAt(0) - hangeulStartUnicdoe) ~/ jongSeong.length % jungSeong.length;
      jung += jungSeong[joongIndex];
    }
    return jung;
  }

  /// 한글 문자 [char] 를 입력받아 종성을 추출합니다. 해당 인덱스에 종성이 아예 존재하지 않으면, 공백 " "을 추출합니다.
  /// 예시 : getJongseong(char: "헐개웃겨ㅋ") returns "ㄹ ㅅ  "
  ///
  /// [char] 종성을 추출할 한글 문자입니다.
  static String getJongseong({
    required String char
  }) {
    String jong = "";
    for (String c in char.split('')) {
      if (!isHangeul(char: c)) {
        jong += " ";
        continue;
      }

      if (jongSeong.contains(c) && !choSeong.contains(c)) {
        jong += c;
        continue;
      } else if (choSeong.contains(c) || jungSeong.contains(c)) {
        jong += " ";
        continue;
      }

      int jongIndex = (c.codeUnitAt(0) - hangeulStartUnicdoe) % jongSeong.length;
      jong += jongSeong[jongIndex];
    }
    return jong;
  }

  /// 입력받은 글자 [char]이 한글인지 아닌지 유니코드 범위를 검사하여 bool 값을 리턴합니다.
  /// 중간에 한글이 아닌 값이 섞여 있다면 false 를 리턴합니다.
  /// 예시 : isHangeul(char: "헤헤ㅋㅋ LMAO") returns false
  ///
  /// [char] 한글인지 판별할 문자입니다.
  static bool isHangeul({
    required String char
  }) {
    for (String c in char.split('')) {
      if (choSeong.contains(c) || jungSeong.contains(c) || jongSeong.contains(c) || c == " ") {
        continue;
      }

      bool isHangeul = c.codeUnitAt(0) >= hangeulStartUnicdoe && c.codeUnitAt(0) <= hangeulStartUnicdoe;
      if (!isHangeul) {
        return false;
      }
    }
    return true;
  }

  /// 입력받은 글자 [char] 로부터 초성의 인덱스를 추출하는 유틸리티용 함수입니다.
  ///
  /// [char] 초성의 인덱스를 추출할 문자입니다.
  static List<int> _getChoIndexes({
    required String char
  }) {
    List<int> choIndexes = [];
    for (int i = 0; i < char.length; i++) {
      if (choSeong.contains(char[i])) {
        choIndexes.add(i);
      }
    }
    return choIndexes;
  }
}
