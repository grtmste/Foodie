import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../state/app_state.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipeBrowserScreen extends StatefulWidget {
  final AppState appState;
  const RecipeBrowserScreen({super.key, required this.appState});

  @override
  State<RecipeBrowserScreen> createState() => _RecipeBrowserScreenState();
}

class _RecipeBrowserScreenState extends State<RecipeBrowserScreen> {
  String _query = '';

  List<Recipe> get _filtered {
    if (_query.trim().isEmpty) return allRecipes;
    final q = _query.toLowerCase();
    return allRecipes.where((r) {
      if (r.title.toLowerCase().contains(q)) return true;
      return r.ingredients.any((i) => i.name.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filtered;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foodie', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or ingredient...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: recipes.isEmpty
                ? const Center(child: Text('No recipes found'))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, i) {
                      final recipe = recipes[i];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              recipe: recipe,
                              appState: widget.appState,
                            ),
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
}
