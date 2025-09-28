import 'package:flutter/material.dart';
import 'package:memorama/provider/memo_provider.dart';
import 'package:memorama/widgets/control_panel.dart';
import 'package:memorama/widgets/game_card.dart';
import 'package:provider/provider.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  // Flag para asegurar que el diálogo solo se muestre una vez
  bool _isDialogShowing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final memoProvider = Provider.of<MemoProvider>(context);

    // Muestra el diálogo solo cuando el juego termina
    if (memoProvider.isGameFinished && !_isDialogShowing) {
      _isDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameFinishedDialog(memoProvider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorama'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ControlPanel(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<MemoProvider>(
                builder: (context, provider, child) {
                  return provider.isGameStarted
                      ? _buildGameGrid(provider)
                      : _buildStartButton(provider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(MemoProvider provider) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontSize: 24),
        ),
        onPressed: () => provider.startGame(),
        child: const Text('Iniciar Juego'),
      ),
    );
  }

  Widget _buildGameGrid(MemoProvider provider) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: provider.cards.length,
      itemBuilder: (context, index) {
        final card = provider.cards[index];
        return GameCard(
          card: card,
          onTap: () => provider.onCardPressed(card),
        );
      },
    );
  }

  // ¡MÉTODO ACTUALIZADO! Ahora maneja tanto la victoria como la derrota.
  void _showGameFinishedDialog(MemoProvider provider) {
    final bool playerWon = provider.didPlayerWin;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(playerWon ? '¡Felicidades!' : 'Has Perdido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(playerWon
                  ? '¡Has completado el juego con éxito!'
                  : 'No alcanzaste los 60 puntos necesarios.'),
              const SizedBox(height: 10),
              Text('Puntuación final: ${provider.score.toStringAsFixed(1)}'),
              Text('Intentos: ${provider.attempts}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Jugar de Nuevo'),
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogShowing = false; // Permite que el diálogo se muestre en la próxima partida
                provider.resetGame();
              },
            ),
          ],
        );
      },
    );
  }
}