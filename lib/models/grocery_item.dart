class GroceryItem {
  final String name;
  final String unit;
  double quantity;
  bool checked;

  GroceryItem({
    required this.name,
    required this.unit,
    required this.quantity,
    this.checked = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
        'quantity': quantity,
        'checked': checked,
      };

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
        name: json['name'] as String,
        unit: json['unit'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        checked: json['checked'] as bool? ?? false,
      );

  String get key => '$name|$unit';

  String get displayQuantity {
    final q = quantity;
    final rounded = q.truncateToDouble() == q ? q.toInt().toString() : q.toStringAsFixed(1);
    return '$rounded$unit';
  }
}

/// Parses a raw quantity string like "100g", "2tk", "100-200g", "Kuni 300g",
/// "170g / 5tk" into a (quantity, unit) pair usable for consolidation.
/// Falls back to (1, rawText) when no numeric value can be extracted.
(double, String) parseQuantity(String raw) {
  final cleaned = raw.replaceAll('Kuni', '').trim();
  final firstPart = cleaned.split('/').first.trim();
  final match = RegExp(r'(\d+(?:[.,]\d+)?)\s*-?\s*(\d+(?:[.,]\d+)?)?\s*([a-zA-Z%]+)')
      .firstMatch(firstPart);
  if (match == null) {
    return (1, raw.trim().isEmpty ? 'tk' : raw.trim());
  }
  final low = double.parse(match.group(1)!.replaceAll(',', '.'));
  final high = match.group(2) != null
      ? double.parse(match.group(2)!.replaceAll(',', '.'))
      : low;
  final unit = match.group(3) ?? 'tk';
  return ((low + high) / 2, unit);
}
