import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memorama/models/card_item.dart';

class MemoViewModel with ChangeNotifier {
  final List<IconData> _icons = [
    Icons.star, Icons.favorite, Icons.lightbulb, Icons.ac_unit,
    Icons.anchor, Icons.whatshot, Icons.camera_alt, Icons.pets,
  ];

  List<CardItem> _cards = [];
  CardItem? _firstSelection;
  CardItem? _secondSelection;

  double _score = 0.0;
  int _attempts = 0;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isGameActive = false;
  bool _isHelpActive = false;
  bool _isGameStarted = false;

  bool _shouldShowDialog = false;

  List<CardItem> get cards => _cards;
  double get score => _score;
  int get attempts => _attempts;
  int get secondsElapsed => _secondsElapsed;
  bool get isGameFinished => _cards.isNotEmpty && _cards.every((c) => c.status == CardStatus.matched);
  bool get isGameStarted => _isGameStarted;
  bool get didPlayerWin => isGameFinished && _score >= 60;
  bool get shouldShowDialog => _shouldShowDialog;

  MemoViewModel() {
    _setupBoard();
  }

  void _setupBoard() {
    _cards.clear();
    List<CardItem> cardPairs = [];
    for (int i = 0; i < _icons.length; i++) {
      cardPairs.add(CardItem(id: i, icon: _icons[i]));
      cardPairs.add(CardItem(id: i, icon: _icons[i]));
    }
    cardPairs.shuffle();
    _cards = cardPairs;
  }

  void startGame() {
    _isGameStarted = true;
    _isGameActive = true;
    _startTimer();
    notifyListeners();
  }

  void resetGame() {
    _stopTimer();
    _setupBoard();
    _score = 0.0;
    _attempts = 0;
    _secondsElapsed = 0;
    _isGameActive = false;
    _isGameStarted = false;
    _shouldShowDialog = false;
    _clearSelections();
    notifyListeners();
  }

  void dialogWasShown() {
    _shouldShowDialog = false;
  }

  void onCardPressed(CardItem card) {
    if (!_isGameActive || !_isGameStarted || card.status != CardStatus.hidden || _isHelpActive) return;

    if (_firstSelection == null) {
      _firstSelection = card;
      _updateCardStatus(card, CardStatus.visible);
    } else if (_secondSelection == null) {
      _secondSelection = card;
      _updateCardStatus(card, CardStatus.visible);
      _attempts++;
      _checkMatch();
    }
    notifyListeners();
  }

  void _checkMatch() {
    if (_firstSelection?.id == _secondSelection?.id) {
      _score += 12.5;
      _updateCardStatus(_firstSelection!, CardStatus.matched);
      _updateCardStatus(_secondSelection!, CardStatus.matched);
      _clearSelections();
      if (isGameFinished) {
        _stopTimer();
        _shouldShowDialog = true;
      }
    } else {
      _score = max(0.0, _score - 2);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_firstSelection != null && _secondSelection != null) {
          _updateCardStatus(_firstSelection!, CardStatus.hidden);
          _updateCardStatus(_secondSelection!, CardStatus.hidden);
        }
        _clearSelections();
        notifyListeners();
      });
    }
  }

  void showHelp() async {
    if (!_isGameActive || !_isGameStarted) return;
    _score = max(0.0, _score - 15);
    _isHelpActive = true;

    for (var card in _cards) {
      if (card.status == CardStatus.hidden) {
        _updateCardStatus(card, CardStatus.visible);
      }
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    for (var card in _cards) {
      if (card.status == CardStatus.visible) {
        _updateCardStatus(card, CardStatus.hidden);
      }
    }
    _isHelpActive = false;
    notifyListeners();
  }

  void _updateCardStatus(CardItem card, CardStatus status) {
    final index = _cards.indexWhere((c) => c == card);
    if(index != -1){
      _cards[index].status = status;
    }
  }

  void _clearSelections() {
    _firstSelection = null;
    _secondSelection = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameActive) {
        _secondsElapsed++;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isGameActive = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}