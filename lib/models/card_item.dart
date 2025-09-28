import 'package:flutter/material.dart';

enum CardStatus { hidden, visible, matched }

class CardItem {
  final int id;
  final IconData icon;
  CardStatus status;

  CardItem({
    required this.id,
    required this.icon,
    this.status = CardStatus.hidden,
  });

  CardItem copyWith({CardStatus? status}) {
    return CardItem(
      id: id,
      icon: icon,
      status: status ?? this.status,
    );
  }
}
