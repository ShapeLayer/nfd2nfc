import 'dart:collection';

class NFD2NFC {
  static const int hangulCodeBase = 0xAC00;
  static const int choseongCodeBase = 0x1100;
  static const int jungseongCodeBase = 0x1161;
  static const int jongseongCodeBase = 0x11A7;

  static const int choseongCodeLength = 19;
  static const int jungseongCodeLength = 21;
  static const int jongseongCodeLength = 28;

  final StringBuffer _output = StringBuffer();
  final Queue<int> _buffer = Queue<int>();

  static int combine(int choseongCode, int jungseongCode, int jongseongCode) {
    int choseongIndex  = choseongCode  != -1 ? choseongCode  - choseongCodeBase  : 0;
    int jungseongIndex = jungseongCode != -1 ? jungseongCode - jungseongCodeBase : 0;
    int jongseongIndex = jongseongCode != -1 ? jongseongCode - jongseongCodeBase : 0;

    int completeCode = hangulCodeBase + 
      (choseongIndex * (jungseongCodeLength * jongseongCodeLength)) +
      (jungseongIndex * jongseongCodeLength) +
      jongseongIndex;
    
    return completeCode;
  }

  void _combineAndFlushToOutputBuffer() {
    if (_buffer.isEmpty) return;
    int choseongCode  = _buffer.isNotEmpty ? _buffer.first : -1; _buffer.isNotEmpty ? _buffer.removeFirst() : -1;
    int jungseongCode = _buffer.isNotEmpty ? _buffer.first : -1; _buffer.isNotEmpty ? _buffer.removeFirst() : -1;
    int jongseongCode = _buffer.isNotEmpty ? _buffer.first : -1; _buffer.isNotEmpty ? _buffer.removeFirst() : -1;
    int completeCode = combine(choseongCode, jungseongCode, jongseongCode);
    _output.writeCharCode(completeCode);
  }

  String _normalize(String input) {
    bool isChoseongBuffered = false;
    for (int i = 0; i < input.length; i++) {
      int charCode = input.codeUnitAt(i);

      if (choseongCodeBase <= charCode && charCode < choseongCodeBase + choseongCodeLength) {
        if (isChoseongBuffered) {
          _combineAndFlushToOutputBuffer();
          isChoseongBuffered = false;
        }
        _buffer.add(charCode);
        isChoseongBuffered = true;
      } else if (jungseongCodeBase <= charCode && charCode < jungseongCodeBase + jungseongCodeLength) {
        _buffer.add(charCode);
      } else if (jongseongCodeBase <= charCode && charCode < jongseongCodeBase + jongseongCodeLength) {
        _buffer.add(charCode);
      } else {
        _combineAndFlushToOutputBuffer();
        // Executed when character is not hangul.
        _output.writeCharCode(charCode);
      }
    }
    _combineAndFlushToOutputBuffer();

    return _output.toString();
  }

  String get output => _output.toString();

  static String normalize(String input) {
    NFD2NFC nfd2nfc = NFD2NFC();
    nfd2nfc._normalize(input);
    return nfd2nfc.output;
  }
}
