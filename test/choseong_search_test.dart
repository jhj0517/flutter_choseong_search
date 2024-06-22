import 'package:flutter_test/flutter_test.dart';

import 'package:choseong_search/src/choseong_search.dart';

void main() {
  test('초성검색 테스트', () {

    // 쿼리 검색 테스트
    expect(ChoseongSearch.compare(query: "ㅇㄴㅎㅅㅇ", target: "안녕하세요"), true);
    expect(ChoseongSearch.compare(query: "안녕ㅎㅅ요", target: "안녕하세요"), true);
    expect(ChoseongSearch.compare(query: "안녕ㅎㅅ요", target: "안녕하세여"), false);

    // 초성 추출 테스트
    expect(ChoseongSearch.getChoseong(char: "안녕하세요~"), "ㅇㄴㅎㅅㅇ ");
    // 중성 추출 테스트
    expect(ChoseongSearch.getJungseong(char: "안녕하세요~"), "ㅏㅕㅏㅔㅛ ");
    // 종성 추출 테스트
    expect(ChoseongSearch.getJongseong(char: "안녕하세요~"), "ㄴㅇ    ");
  });
}
