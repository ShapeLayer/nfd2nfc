import 'package:test/test.dart';
import 'package:nfd2nfc/nfd2nfc.dart';

void main() {
  test('제1장 컴퓨터시스템 개요', () {
    expect(NFD2NFC.normalize('제1장 컴퓨터시스템 개요'), '제1장 컴퓨터시스템 개요');
  });

  test('제2장 CPU의 구조와 기능', () {
    expect(NFD2NFC.normalize('제2장 CPU의 구조와 기능'), '제2장 CPU의 구조와 기능');
  });
}
