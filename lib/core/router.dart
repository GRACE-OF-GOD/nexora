import 'package:go_router/go_router.dart';
import 'package:nexora/screens/auth/login_screen.dart';
import 'package:nexora/screens/admin/admin_dashboard_screen.dart';
import 'package:nexora/screens/admin/eleves_screen.dart';
import 'package:nexora/screens/admin/enseignants_screen.dart';
import 'package:nexora/screens/teacher/teacher_dashboard_screen.dart';
import 'package:nexora/screens/parent/parent_dashboard_screen.dart';
import 'package:nexora/screens/student/student_dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/admin', name: 'admin-dashboard', builder: (context, state) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/eleves', name: 'admin-eleves', builder: (context, state) => const ElevesScreen()),
    GoRoute(path: '/admin/enseignants', name: 'admin-enseignants', builder: (context, state) => const EnseignantsScreen()),
    GoRoute(path: '/teacher', name: 'teacher-dashboard', builder: (context, state) => const TeacherDashboardScreen()),
    GoRoute(path: '/parent', name: 'parent-dashboard', builder: (context, state) => const ParentDashboardScreen()),
    GoRoute(path: '/student', name: 'student-dashboard', builder: (context, state) => const StudentDashboardScreen()),
  ],
);
