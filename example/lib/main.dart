import 'package:firebase_auth_kit/firebase_auth_kit.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebase_auth_kit example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const _Root(),
    );
  }
}

/// Root widget — auth screen is placed inside a [Stack] so the background
/// layer is fully customisable by the user.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Layer 0 : BACKGROUND (required) ───────────────────────
          // You can replace this Container with:
          //   • A solid color  → Container(color: Colors.black)
          //   • A network image → Image.network('url', fit: BoxFit.cover)
          //   • An asset image  → Image.asset('assets/bg.jpg', fit: BoxFit.cover)
          //   • Any widget      → e.g. a video player, animated canvas, etc.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Layer 1 : LOGIN SCREEN (required) ─────────────────────
          AuthLoginScreen(
            // ── Auth methods (required — enable at least one) ────────
            config: const AuthUIConfig(
              enableEmailPassword: true, // optional — default: true
              enableOtp: true,           // optional — default: false
              enableGoogle: true,        // optional — default: false

              // ── Background (optional) ──────────────────────────────
              // Keep transparent so Layer 0 background shows through.
              // Remove these two lines to use the default white background.
              backgroundColor: Colors.transparent,
              headerBackground: BoxDecoration(color: Colors.transparent),

              // ── Header logo (optional) ─────────────────────────────
              // Uncomment to replace the default lock icon:
              // headerLogoWidget: Icon(Icons.person, color: Colors.white, size: 36),
              // Use SizedBox.shrink() to hide the icon completely:
              // headerLogoWidget: SizedBox.shrink(),

              // ── Header text styles (optional) ──────────────────────
              // Uncomment to customise title / subtitle appearance:
              // headerTitleStyle: TextStyle(
              //   color: Colors.white,
              //   fontSize: 28,
              //   fontWeight: FontWeight.w800,
              // ),
              // headerSubtitleStyle: TextStyle(color: Colors.white70),

              // ── Decorative circles in header (optional) ─────────────
              // Set to false to hide the subtle circle overlays:
              // showHeaderDecorations: false,

              // ── Color scheme (optional) ────────────────────────────
              // Override individual widget colors. All fields are optional.
              // colorScheme: AuthColorScheme(
              //   primary: Color(0xFF0D9488),
              //   buttonColor: Color(0xFF0D9488),
              //   inputFocusBorderColor: Color(0xFF0D9488),
              //   linkColor: Color(0xFF0D9488),
              //   cardColor: Colors.white,
              //   textPrimaryColor: Colors.black87,
              // ),
            ),

            // ── Called after successful login (required) ─────────────
            onSuccess: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),

            // ── Called when "Don't have an account?" is tapped (optional)
            // Remove this to hide the footer link entirely.
            onSignupTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => Scaffold(
                  body: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ── Signup background (required inside Stack) ──
                      // Use the same background as the login screen, or
                      // swap it for a different one.
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      // ── Signup screen (required) ───────────────────
                      AuthSignupScreen(
                        config: const AuthUIConfig(
                          enableEmailPassword: true, // optional
                          enableOtp: true,           // optional
                          enableGoogle: true,        // optional

                          // ── Background (optional) ──────────────────
                          backgroundColor: Colors.transparent,
                          headerBackground:
                              BoxDecoration(color: Colors.transparent),

                          // ── Header logo (optional) ─────────────────
                          // headerLogoWidget: SizedBox.shrink(),

                          // ── Color scheme (optional) ────────────────
                          // colorScheme: AuthColorScheme(
                          //   primary: Color(0xFF0D9488),
                          //   buttonColor: Color(0xFF0D9488),
                          // ),
                        ),

                        // ── Called after successful signup (required) ─
                        onSuccess: () => Navigator.pushAndRemoveUntil(
                          ctx,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (_) => false,
                        ),

                        // ── Called when "Already have an account?" is tapped
                        // (optional) — remove to hide the footer link.
                        onLoginTap: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Home screen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('You are logged in!')),
    );
  }
}
