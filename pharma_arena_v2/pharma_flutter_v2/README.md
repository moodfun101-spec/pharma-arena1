# Pharma Arena — Flutter APK

## خطوات بناء الـ APK

### المتطلبات
- [Android Studio](https://developer.android.com/studio) (مجاني)
- Flutter SDK (يثبّت تلقائياً مع Android Studio)

### الخطوات

**1. افتح Android Studio وثبّت Flutter plugin:**
   - File → Settings → Plugins → ابحث عن "Flutter" → Install

**2. افتح المشروع:**
   - File → Open → اختر مجلد pharma_arena

**3. غيّر رابط التطبيق في `lib/main.dart`:**
   ```dart
   const String kAppUrl = 'https://YOUR-REPLIT-APP.replit.app';
   ```
   استبدل الرابط برابط تطبيقك على Replit بعد النشر.

**4. ابنِ الـ APK:**
   افتح Terminal داخل Android Studio واكتب:
   ```bash
   flutter pub get
   flutter build apk --release
   ```

**5. الـ APK جاهز في:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

---

## ما يوفره هذا التطبيق
- Splash screen احترافي
- Full-screen بدون شريط متصفح
- شاشة No Connection مع زر إعادة المحاولة
- Back button يرجع للصفحة السابقة داخل التطبيق
- Portrait mode فقط (مثل APK أصلي)
