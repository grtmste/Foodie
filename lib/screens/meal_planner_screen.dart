import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../state/app_state.dart';

class MealPlannerScreen extends StatelessWidget {
  final AppState appState;
  const MealPlannerScreen({super.key, required this.appState});

  void _pickRecipe(BuildContext context, String day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Pick recipe for $day', style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: allRecipes.length,
                  itemBuilder: (context, i) {
                    final r = allRecipes[i];
                    return ListTile(
                      title: Text(r.title),
                      subtitle: Text('${r.calories} kcal'),
                      onTap: () {
                        appState.setMealForDay(day, r.id);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text('Weekly Planner', style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: scheme.primary),
                const SizedBox(width: 6),
                Text('Weekly total: ${appState.weeklyCalories} kcal',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: appState.shuffleWeek,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Shuffle Week'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmClearWeek(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Week'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: weekdays.length,
              itemBuilder: (context, i) {
                final day = weekdays[i];
                final recipe = recipeById(appState.mealPlan[day]);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    onTap: () => _pickRecipe(context, day),
                    title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      recipe == null ? 'No recipe assigned' : '${recipe.title} · ${recipe.calories} kcal',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.shuffle),
                      tooltip: 'Shuffle Day',
                      onPressed: () => appState.shuffleDay(day),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearWeek(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear week?'),
        content: const Text('This removes every recipe assigned this week.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              appState.clearWeek();
              Navigator.of(context).pop();
            },
            child: const Text('Clear Week'),
          ),
        ],
      ),
    );
  }
}
