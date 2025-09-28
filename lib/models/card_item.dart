import 'package:flutter/material.dart';

// Enum para representar los posibles estados de una carta
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

  // Método para facilitar la creación de copias del objeto
  CardItem copyWith({CardStatus? status}) {
    return CardItem(
      id: id,
      icon: icon,
      status: status ?? this.status,
    );
  }
}