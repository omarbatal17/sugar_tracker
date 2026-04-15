import 'package:go_router/go_router.dart';
import '../state/app_state.dart';
import 'app_shell.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/add_reading_screen.dart';
import '../screens/reading_details_screen.dart';
import '../screens/alert_details_screen.dart';
import '../screens/recommendations_screen.dart';
import '../screens/detailed_report_screen.dart';
import '../screens/pump_simulation_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/tabs/dashboard_screen.dart';
import '../screens/tabs/history_screen.dart';
import '../screens/tabs/alerts_screen.dart';
import '../screens/tabs/reports_screen.dart';
import '../screens/tabs/profile_screen.dart';
import '../screens/chatbot_screen.dart';

class AppRouter {
  static GoRouter router(AppState appState) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: appState,
      redirect: (context, state) {
        final path = state.uri.path;

        // Allow splash to handle its own redirect
        if (path == '/') return null;

        // If not completed onboarding, redirect there
        if (!appState.hasCompletedOnboarding &&
            path != '/onboarding') {
          return '/onboarding';
        }

        // If not logged in, redirect to login
        if (!appState.isLoggedIn &&
            path != '/login' &&
            path != '/register' &&
            path != '/forgot-password' &&
            path != '/onboarding') {
          return '/login';
        }

        // If logged in and trying to access auth pages, go to dashboard
        if (appState.isLoggedIn &&
            (path == '/login' || path == '/register' || path == '/forgot-password')) {
          return '/tabs/dashboard';
        }

        return null;
      },
      errorBuilder: (context, state) => const NotFoundScreen(),
      routes: [
        // Splash
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),

        // Onboarding
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Auth
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Tab Shell
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/tabs/dashboard',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DashboardScreen(),
              ),
            ),
            GoRoute(
              path: '/tabs/history',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryScreen(),
              ),
            ),
            GoRoute(
              path: '/tabs/chatbot',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChatbotScreen(),
              ),
            ),
            GoRoute(
              path: '/tabs/reports',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ReportsScreen(),
              ),
            ),
            GoRoute(
              path: '/tabs/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),

        // Detail & Action Routes
        GoRoute(
          path: '/add-reading',
          builder: (context, state) => const AddReadingScreen(),
        ),
        GoRoute(
          path: '/reading-details/:id',
          builder: (context, state) => ReadingDetailsScreen(
            readingId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/alert-details/:id',
          builder: (context, state) => AlertDetailsScreen(
            alertId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) => const RecommendationsScreen(),
        ),
        GoRoute(
          path: '/detailed-report',
          builder: (context, state) => const DetailedReportScreen(),
        ),
        GoRoute(
          path: '/pump-simulation',
          builder: (context, state) => const PumpSimulationScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/help-support',
          builder: (context, state) => const HelpSupportScreen(),
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => const AlertsScreen(),
        ),
      ],
    );
  }
}
