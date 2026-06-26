import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/recipes.dart';
import '../models/grocery_item.dart';

const List<String> weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class AppState extends ChangeNotifier {
  final List<GroceryItem> groceryItems = [];
  final Map<String, int?> mealPlan = {for (final d in weekdays) d: null};

  static const _groceryKey = 'grocery_items';
  static const _mealPlanKey = 'meal_plan';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final groceryJson = prefs.getString(_groceryKey);
    if (groceryJson != null) {
      final list = jsonDecode(groceryJson) as List;
      groceryItems
        ..clear()
        ..addAll(list.map((e) => GroceryItem.fromJson(e as Map<String, dynamic>)));
    }
    final mealPlanJson = prefs.getString(_mealPlanKey);
    if (mealPlanJson != null) {
      final map = jsonDecode(mealPlanJson) as Map<String, dynamic>;
      for (final d in weekdays) {
        mealPlan[d] = map[d] as int?;
      }
    }
    notifyListeners();
  }

  Future<void> _saveGrocery() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _groceryKey,
      jsonEncode(groceryItems.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _saveMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mealPlanKey, jsonEncode(mealPlan));
  }

  void addRecipeToGroceryList(Recipe recipe) {
    for (final ing in recipe.ingredients) {
      final (qty, unit) = parseQuantity(ing.quantity);
      final existing = groceryItems.firstWhere(
        (g) => g.name == ing.name && g.unit == unit,
        orElse: () {
          final item = GroceryItem(name: ing.name, unit: unit, quantity: 0);
          groceryItems.add(item);
          return item;
        },
      );
      existing.quantity += qty;
    }
    _saveGrocery();
    notifyListeners();
  }

  void toggleGroceryItem(GroceryItem item) {
    item.checked = !item.checked;
    _saveGrocery();
    notifyListeners();
  }

  void clearAllGrocery() {
    groceryItems.clear();
    _saveGrocery();
    notifyListeners();
  }

  void clearCheckedGrocery() {
    groceryItems.removeWhere((g) => g.checked);
    _saveGrocery();
    notifyListeners();
  }

  void setMealForDay(String day, int? recipeId) {
    mealPlan[day] = recipeId;
    _saveMealPlan();
    notifyListeners();
  }

  void shuffleDay(String day) {
    final rnd = Random();
    mealPlan[day] = allRecipes[rnd.nextInt(allRecipes.length)].id;
    _saveMealPlan();
    notifyListeners();
  }

  void shuffleWeek() {
    final rnd = Random();
    final pool = List<Recipe>.from(allRecipes)..shuffle(rnd);
    for (var i = 0; i < weekdays.length; i++) {
      mealPlan[weekdays[i]] = pool[i % pool.length].id;
    }
    _saveMealPlan();
    notifyListeners();
  }

  void clearWeek() {
    for (final d in weekdays) {
      mealPlan[d] = null;
    }
    _saveMealPlan();
    notifyListeners();
  }

  int get weeklyCalories {
    var total = 0;
    for (final d in weekdays) {
      final id = mealPlan[d];
      if (id != null) {
        total += allRecipes.firstWhere((r) => r.id == id).calories;
      }
    }
    return total;
  }
}

Recipe? recipeById(int? id) {
  if (id == null) return null;
  try {
    return allRecipes.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
}
