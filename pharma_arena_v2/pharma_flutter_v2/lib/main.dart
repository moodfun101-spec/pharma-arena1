import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF020817),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF020817),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const PharmaArenaApp());
}

class PharmaArenaApp extends StatelessWidget {
  const PharmaArenaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma Arena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020817),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.65, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WebViewScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1991FF), Color(0xFF22d3ee)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1991FF).withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medication_liquid_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Pharma Arena',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Master Pharmacology with AI',
                  style: TextStyle(
                    color: Color(0xFF1991FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 56),
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1991FF),
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF020817))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _loading = true;
          _error = false;
        }),
        onPageFinished: (_) => setState(() => _loading = false),
        onWebResourceError: (err) {
          if (err.isForMainFrame == true) {
            setState(() {
              _loading = false;
              _error = true;
            });
          }
        },
      ))
      ..loadRequest(Uri.parse('https://pharma-arena.replit.app'));
  }

  void _reload() {
    setState(() {
      _loading = true;
      _error = false;
    });
    _controller.loadRequest(Uri.parse('https://pharma-arena.replit.app'));
  }

  Future<bool> _onBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        backgroundColor: const Color(0xFF020817),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              Container(
                color: const Color(0xFF020817),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1991FF),
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            if (_error)
              Container(
                color: const Color(0xFF020817),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          size: 48, color: Color(0xFF64748B)),
                      const SizedBox(height: 16),
                      const Text('No Connection',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _reload,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1991FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text('Try Again',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
