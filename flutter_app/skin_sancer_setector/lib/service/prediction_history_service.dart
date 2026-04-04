import 'package:shared_preferences/shared_preferences.dart';
import '../model/recent_prediction.dart';

class PredictionHistoryService {
  static const _key = 'recent_predictions';
  static const _maxItems = 20; // keep last 20

  // Save a new prediction
  static Future<void> save(RecentPrediction prediction) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();

    // Avoid duplicates by imagePath + label
    existing.removeWhere(
          (e) => e.imagePath == prediction.imagePath &&
          e.predictionLabel == prediction.predictionLabel,
    );

    existing.insert(0, prediction); // newest first

    // Keep only last _maxItems
    final trimmed = existing.take(_maxItems).toList();

    await prefs.setString(_key, RecentPrediction.encode(trimmed));
  }

  // Get all saved predictions
  static Future<List<RecentPrediction>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null || data.isEmpty) return [];
    return RecentPrediction.decode(data);
  }

  // Delete a single prediction
  static Future<void> delete(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();
    existing.removeAt(index);
    await prefs.setString(_key, RecentPrediction.encode(existing));
  }

  // Clear all predictions
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}