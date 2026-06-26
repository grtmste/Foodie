import 'package:flutter/material.dart';

import 'screens/grocery_list_screen.dart';
import 'screens/meal_planner_screen.dart';
import 'screens/recipe_browser_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(const FoodieApp());
}

class FoodieApp extends StatefulWidget {
  const FoodieApp({super.key});

  @override
  State<FoodieApp> createState() => _FoodieAppState();
}

class _FoodieAppState extends State<FoodieApp> {
  final AppState appState = AppState();

  @override
  void initState() {
    super.initState();
    appState.load();
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE8722C);
    return MaterialApp(
      title: 'Foodie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          secondary: const Color(0xFF4C9A5B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFBF7F1),
      ),
      home: HomeShell(appState: appState),
    );
  }
}

class HomeShell extends StatefulWidget {
  final AppState appState;
  const HomeShell({super.key, required this.appState});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      RecipeBrowserScreen(appState: widget.appState),
      GroceryListScreen(appState: widget.appState),
      MealPlannerScreen(appState: widget.appState),
    ];
    return Scaffold(
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, _) => screens[_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Grocery'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Planner'),
        ],
      ),
    );
  }
}
