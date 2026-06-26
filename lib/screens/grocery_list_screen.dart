import 'package:flutter/material.dart';

import '../state/app_state.dart';

class GroceryListScreen extends StatelessWidget {
  final AppState appState;
  const GroceryListScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final items = [...appState.groceryItems]
      ..sort((a, b) => a.checked == b.checked ? a.name.compareTo(b.name) : (a.checked ? 1 : -1));

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text('Grocery List', style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
          ),
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: appState.clearCheckedGrocery,
                      icon: const Icon(Icons.checklist),
                      label: const Text('Clear Checked'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmClearAll(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear All'),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Your grocery list is empty.\nAdd ingredients from a recipe!', textAlign: TextAlign.center))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return CheckboxListTile(
                        value: item.checked,
                        onChanged: (_) => appState.toggleGroceryItem(item),
                        title: Text(
                          item.name,
                          style: item.checked
                              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                              : null,
                        ),
                        subtitle: Text(
                          item.displayQuantity,
                          style: item.checked
                              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                              : null,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear grocery list?'),
        content: const Text('This removes all items from your grocery list.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              appState.clearAllGrocery();
              Navigator.of(context).pop();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
