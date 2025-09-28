import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memorama/models/card_item.dart';

class GameCard extends StatelessWidget {
  final CardItem card;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(card.status == CardStatus.hidden) != child?.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt = tilt * (isUnder ? -1.0 : 1.0);
              final value = min(rotateAnim.value, pi / 2);
              return Transform(
                transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: _buildCardFace(),
      ),
    );
  }

  Widget _buildCardFace() {
    if (card.status == CardStatus.hidden) {
      return Card(
        key: const ValueKey(true),
        color: Colors.blueGrey,
        child: const Center(
          child: Icon(Icons.question_mark, color: Colors.white, size: 40),
        ),
      );
    } else {
      return Card(
        key: const ValueKey(false),
        color: card.status == CardStatus.matched ? Colors.green.withOpacity(0.7) : Colors.white,
        child: Center(
          child: Icon(card.icon, size: 40, color: card.status == CardStatus.matched ? Colors.white : Colors.blue),
        ),
      );
    }
  }
}