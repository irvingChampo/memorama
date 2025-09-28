import 'package:flutter/material.dart';
import 'package:memorama/viewmodels/memo_viewmodel.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoViewModel>(
      builder: (context, viewModel, child) {
        final minutes = (viewModel.secondsElapsed / 60).floor().toString().padLeft(2, '0');
        final seconds = (viewModel.secondsElapsed % 60).toString().padLeft(2, '0');
        final bool isGameStarted = viewModel.isGameStarted;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard('Puntos', viewModel.score.toStringAsFixed(1)),
                  _buildInfoCard('Tiempo', '$minutes:$seconds'),
                  _buildInfoCard('Intentos', viewModel.attempts.toString()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: isGameStarted ? () => viewModel.resetGame() : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isGameStarted ? () => viewModel.showHelp() : null,
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Ayuda'),
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }
}