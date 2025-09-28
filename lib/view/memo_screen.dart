import 'package:flutter/material.dart';
import 'package:memorama/viewmodels/memo_viewmodel.dart';
import 'package:memorama/view/widgets/control_panel.dart';
import 'package:memorama/view/widgets/game_card.dart';
import 'package:provider/provider.dart';

class MemoScreen extends StatelessWidget {
  const MemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.shouldShowDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGameFinishedDialog(context, viewModel);
            viewModel.dialogWasShown();
          });
        }

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
                  child: viewModel.isGameStarted
                      ? _buildGameGrid(context, viewModel)
                      : _buildStartButton(context, viewModel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartButton(BuildContext context, MemoViewModel viewModel) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontSize: 24),
        ),
        onPressed: () => viewModel.startGame(),
        child: const Text('Iniciar Juego'),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context, MemoViewModel viewModel) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: viewModel.cards.length,
      itemBuilder: (context, index) {
        final card = viewModel.cards[index];
        return GameCard(
          card: card,
          onTap: () => viewModel.onCardPressed(card),
        );
      },
    );
  }

  void _showGameFinishedDialog(BuildContext context, MemoViewModel viewModel) {
    final bool playerWon = viewModel.didPlayerWin;

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
              Text('Puntuación final: ${viewModel.score.toStringAsFixed(1)}'),
              Text('Intentos: ${viewModel.attempts}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Jugar de Nuevo'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resetGame();
              },
            ),
          ],
        );
      },
    );
  }
}