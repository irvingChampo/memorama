import 'package:flutter/material.dart';
import 'package:memorama/provider/memo_provider.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoProvider>(
      builder: (context, provider, child) {
        final minutes = (provider.secondsElapsed / 60).floor().toString().padLeft(2, '0');
        final seconds = (provider.secondsElapsed % 60).toString().padLeft(2, '0');
        final bool isGameStarted = provider.isGameStarted;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ¡CAMBIO! Se formatea el puntaje para mostrar un decimal
                  _buildInfoCard('Puntos', provider.score.toStringAsFixed(1)),
                  _buildInfoCard('Tiempo', '$minutes:$seconds'),
                  _buildInfoCard('Intentos', provider.attempts.toString()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: isGameStarted ? () => provider.resetGame() : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isGameStarted ? () => provider.showHelp() : null,
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