import 'dart:math';
import '../models/glucose_reading.dart';
import '../models/alert_item.dart';
import '../models/recommendation.dart';
import '../models/user_profile.dart';

class MockDataService {
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextDouble().toString();
  }

  static List<GlucoseReading> generateReadings() {
    final random = Random(42); // Seeded for consistency
    final now = DateTime.now();
    final readings = <GlucoseReading>[];
    final mealContexts = ['before', 'after', 'fasting', 'bedtime'];

    for (int i = 0; i < 14; i++) {
      final hoursAgo = (i * 12) + random.nextInt(6);
      final timestamp = now.subtract(Duration(hours: hoursAgo));

      // 60% normal, 20% high, 20% low
      int value;
      final roll = random.nextDouble();
      if (roll < 0.2) {
        // Low: 65–79
        value = 65 + random.nextInt(15);
      } else if (roll < 0.4) {
        // High: 181–280
        value = 181 + random.nextInt(100);
      } else {
        // Normal: 80–180
        value = 80 + random.nextInt(101);
      }

      readings.add(GlucoseReading(
        id: '${timestamp.millisecondsSinceEpoch}${random.nextDouble()}',
        value: value,
        status: GlucoseReading.computeStatus(value),
        timestamp: timestamp.toIso8601String(),
        mealContext: mealContexts[i % 4],
      ));
    }

    // Sort newest first
    readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return readings;
  }

  static List<AlertItem> mockAlerts() {
    final now = DateTime.now();
    return [
      AlertItem(
        id: _generateId(),
        type: 'high',
        title: 'High Glucose Detected',
        titleAr: 'اكتشاف ارتفاع الجلوكوز',
        message: 'Your blood sugar reading of 245 mg/dL is above the target range. Please monitor closely and consider taking corrective action.',
        messageAr: 'قراءة سكر الدم 245 مغ/دل أعلى من النطاق المستهدف. يرجى المراقبة عن كثب والنظر في اتخاذ إجراء تصحيحي.',
        severity: 'critical',
        timestamp: now.subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      AlertItem(
        id: _generateId(),
        type: 'low',
        title: 'Low Glucose Warning',
        titleAr: 'تحذير من انخفاض الجلوكوز',
        message: 'Your blood sugar reading of 68 mg/dL is below the target range. Consider having a quick snack or glucose tablet.',
        messageAr: 'قراءة سكر الدم 68 مغ/دل أقل من النطاق المستهدف. فكر في تناول وجبة خفيفة سريعة أو قرص جلوكوز.',
        severity: 'warning',
        timestamp: now.subtract(const Duration(hours: 8)).toIso8601String(),
      ),
    ];
  }

  static List<RecommendationItem> mockRecommendations() {
    return [
      RecommendationItem(
        id: _generateId(),
        category: 'exercise',
        title: 'Post-Meal Walk',
        titleAr: 'المشي بعد الوجبة',
        description: 'A 15-minute walk after meals can help lower blood sugar levels by up to 30%. Try to make it a daily habit.',
        descriptionAr: 'المشي لمدة 15 دقيقة بعد الوجبات يمكن أن يساعد في خفض مستوى سكر الدم بنسبة تصل إلى 30%. حاول أن تجعلها عادة يومية.',
        icon: 'activity',
      ),
      RecommendationItem(
        id: _generateId(),
        category: 'meal',
        title: 'Choose Low-GI Foods',
        titleAr: 'اختر أطعمة ذات مؤشر سكري منخفض',
        description: 'Foods with a low glycemic index release glucose slowly, helping maintain stable blood sugar levels throughout the day.',
        descriptionAr: 'الأطعمة ذات المؤشر السكري المنخفض تطلق الجلوكوز ببطء، مما يساعد في الحفاظ على مستويات سكر الدم مستقرة طوال اليوم.',
        icon: 'coffee',
      ),
      RecommendationItem(
        id: _generateId(),
        category: 'lifestyle',
        title: 'Stress Management',
        titleAr: 'إدارة التوتر',
        description: 'Chronic stress can raise blood sugar levels. Practice deep breathing, meditation, or yoga for at least 10 minutes daily.',
        descriptionAr: 'التوتر المزمن يمكن أن يرفع مستويات سكر الدم. مارس التنفس العميق أو التأمل أو اليوغا لمدة 10 دقائق يومياً على الأقل.',
        icon: 'heart',
      ),
      RecommendationItem(
        id: _generateId(),
        category: 'tip',
        title: 'Stay Hydrated',
        titleAr: 'حافظ على الترطيب',
        description: 'Drinking enough water helps your kidneys flush out excess blood sugar. Aim for 8 glasses of water per day.',
        descriptionAr: 'شرب كمية كافية من الماء يساعد الكلى على التخلص من سكر الدم الزائد. اهدف إلى 8 أكواب من الماء يومياً.',
        icon: 'droplet',
      ),
      RecommendationItem(
        id: _generateId(),
        category: 'meal',
        title: 'Healthy Snack Options',
        titleAr: 'خيارات وجبات خفيفة صحية',
        description: 'Keep nuts, seeds, and fresh vegetables handy for snacking. They provide nutrients without spiking blood sugar.',
        descriptionAr: 'احتفظ بالمكسرات والبذور والخضروات الطازجة في متناول اليد للتسلية. توفر العناصر الغذائية دون رفع سكر الدم.',
        icon: 'shopping-bag',
      ),
      RecommendationItem(
        id: _generateId(),
        category: 'exercise',
        title: 'Resistance Training',
        titleAr: 'تمارين المقاومة',
        description: 'Strength training 2-3 times per week can improve insulin sensitivity and help your body use glucose more effectively.',
        descriptionAr: 'تمارين القوة 2-3 مرات في الأسبوع يمكن أن تحسن حساسية الأنسولين وتساعد جسمك على استخدام الجلوكوز بشكل أكثر فعالية.',
        icon: 'trending-up',
      ),
    ];
  }

  static UserProfile mockUser() {
    return const UserProfile(
      name: 'User',
      email: 'user@example.com',
      age: 28,
      diabetesType: 'type1',
      targetRangeMin: 80,
      targetRangeMax: 180,
    );
  }
}
