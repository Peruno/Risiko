import 'package:flutter/material.dart';
import 'package:risiko_simulator/state/battle_state.dart';

class AttackModeSelector extends StatelessWidget {
  final AttackMode? selectedAttackMode;
  final ValueChanged<AttackMode> onModeSelected;
  final VoidCallback onTap;

  const AttackModeSelector({
    super.key,
    required this.selectedAttackMode,
    required this.onModeSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildModeCard(
              title: 'All In',
              description: 'Kampf bis zum letzten Mann',
              isSelected: selectedAttackMode == AttackMode.allIn,
              onTap: () {
                onTap();
                onModeSelected(AttackMode.allIn);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModeCard(
              title: 'Sicherer Angriff',
              description: 'Rückzug bei 2 verbleibenden Angreifern',
              isSelected: selectedAttackMode == AttackMode.safe,
              onTap: () {
                onTap();
                onModeSelected(AttackMode.safe);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: isSelected ? Colors.blue : Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
