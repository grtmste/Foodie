import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../state/app_state.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final AppState appState;

  const RecipeDetailScreen({super.key, required this.recipe, required this.appState});

  void _pickMealPlanDay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Add to which day?', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...weekdays.map(
              (day) => ListTile(
                title: Text(day),
                onTap: () {
                  appState.setMealForDay(day, recipe.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "${recipe.title}" to $day')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: scheme.secondaryContainer,
                child: Icon(Icons.restaurant, size: 64, color: scheme.onSecondaryContainer),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    children: [
                      _statChip(context, Icons.local_fire_department, '${recipe.calories} kcal'),
                      _statChip(context, Icons.people, '${recipe.servings} serving${recipe.servings > 1 ? 's' : ''}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 6, color: scheme.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ing.name)),
                          const SizedBox(width: 8),
                          Text(ing.quantity, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Preparation', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...recipe.steps.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: scheme.primaryContainer,
                            child: Text('${e.key + 1}',
                                style: TextStyle(fontSize: 12, color: scheme.onPrimaryContainer)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(e.value)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            appState.addRecipeToGroceryList(recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added ingredients to grocery list')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Grocery List'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickMealPlanDay(context),
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Add to Meal Plan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(BuildContext context, IconData icon, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 16, color: scheme.primary),
      label: Text(label),
    );
  }
}
