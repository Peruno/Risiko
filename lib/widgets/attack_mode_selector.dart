import 'package:flutter/material.dart';

class AttackModeSelector extends StatelessWidget {
  final String? selectedAttackMode;
  final ValueChanged<String> onModeSelected;
  final VoidCallback onTap;

  const AttackModeSelector({
    super.key,
    required this.selectedAttackMode,
    required this.onModeSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildModeCard(
            mode: 'allIn',
            title: 'All In',
            description: 'Kampf bis zum letzten Mann',
            isSelected: selectedAttackMode == 'allIn',
            onTap: () {
              onTap();
              onModeSelected('allIn');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModeCard(
            mode: 'safe',
            title: 'Sicherer Angriff',
            description: 'Rückzug bei 2 verbleibenden Angreifern',
            isSelected: selectedAttackMode == 'safe',
            onTap: () {
              onTap();
              onModeSelected('safe');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required String mode,
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
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey, width: isSelected ? 2 : 1),
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
