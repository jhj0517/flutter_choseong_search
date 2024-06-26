
abstract class ChoseongSearch {
  static const int _hangeulStartUnicdoe = 44032;
  static const int _hangeulEndUnicode = 55203;

  static const List<String> _choSeong = [
    "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
  ];
  static const List<String> _jungSeong = [
    "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"
  ];
  static const List<String> _jongSeong = [
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
  static bool compare({
    required String query,
    required String target,
    bool enableTrim=true
  }) {
    if (enableTrim){
      query = query.trim();
      target = target.trim();
    }

    if (query.length > target.length) return false;

    final List<int> choIndexes = _getChoIndexes(char: query);
    if (choIndexes.isEmpty) return target.contains(query);

    for (int i in choIndexes.reversed) {
      if (query[i] != getChoseong(char: target[i])) {
        return false;
      }
      target = target.substring(0, i) + target.substring(i+1);
      query = query.substring(0, i) + query.substring(i+1);
    }
    return target.contains(query);
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

      if (_choSeong.contains(c)) {
        cho += c;
        continue;
      } else if (_jungSeong.contains(c) || _jongSeong.contains(c)) {
        cho += " ";
        continue;
      }

      int choIndex = (c.codeUnitAt(0) - _hangeulStartUnicdoe) ~/ (_jongSeong.length * _jungSeong.length);
      cho += _choSeong[choIndex];
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

      if (_jungSeong.contains(c)) {
        jung += c;
        continue;
      } else if (_choSeong.contains(c) || _jongSeong.contains(c)) {
        jung += " ";
        continue;
      }

      int joongIndex = (c.codeUnitAt(0) - _hangeulStartUnicdoe) ~/ _jongSeong.length % _jungSeong.length;
      jung += _jungSeong[joongIndex];
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

      if (_jongSeong.contains(c) && !_choSeong.contains(c)) {
        jong += c;
        continue;
      } else if (_choSeong.contains(c) || _jungSeong.contains(c)) {
        jong += " ";
        continue;
      }

      int jongIndex = (c.codeUnitAt(0) - _hangeulStartUnicdoe) % _jongSeong.length;
      jong += _jongSeong[jongIndex];
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
      if (_choSeong.contains(c) || _jungSeong.contains(c) || _jongSeong.contains(c) || c == " ") {
        continue;
      }

      bool isHangeul = c.codeUnitAt(0) >= _hangeulStartUnicdoe && c.codeUnitAt(0) <= _hangeulEndUnicode;
      if (!isHangeul) {
        return false;
      }
    }
    return true;
  }

  /// 입력받은 글자 [char] 로부터 초성의 인덱스를 추출하는 함수입니다.
  ///
  /// [char] 초성의 인덱스를 추출할 문자입니다.
  static List<int> _getChoIndexes({
    required String char
  }) {
    List<int> choIndexes = [];
    for (int i = 0; i < char.length; i++) {
      if (_choSeong.contains(char[i])) {
        choIndexes.add(i);
      }
    }
    return choIndexes;
  }
}
