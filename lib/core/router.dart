import 'package:go_router/go_router.dart';
import 'package:nexora/screens/auth/login_screen.dart';
import 'package:nexora/screens/admin/admin_dashboard_screen.dart';
import 'package:nexora/screens/admin/eleves_screen.dart';
import 'package:nexora/screens/admin/enseignants_screen.dart';
import 'package:nexora/screens/admin/classes_screen.dart';
import 'package:nexora/screens/admin/matieres_screen.dart';
import 'package:nexora/screens/admin/notes_screen.dart';
import 'package:nexora/screens/admin/absences_screen.dart';
import 'package:nexora/screens/admin/bulletins_screen.dart';
import 'package:nexora/screens/admin/paiements_screen.dart';
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
    GoRoute(path: '/admin/classes', name: 'admin-classes', builder: (context, state) => const ClassesScreen()),
    GoRoute(path: '/admin/matieres', name: 'admin-matieres', builder: (context, state) => const MatieresScreen()),
    GoRoute(path: '/admin/notes', name: 'admin-notes', builder: (context, state) => const NotesScreen()),
    GoRoute(path: '/admin/absences', name: 'admin-absences', builder: (context, state) => const AbsencesScreen()),
    GoRoute(path: '/admin/bulletins', name: 'admin-bulletins', builder: (context, state) => const BulletinsScreen()),
    GoRoute(path: '/admin/paiements', name: 'admin-paiements', builder: (context, state) => const PaiementsScreen()),
    GoRoute(path: '/teacher', name: 'teacher-dashboard', builder: (context, state) => const TeacherDashboardScreen()),
    GoRoute(path: '/parent', name: 'parent-dashboard', builder: (context, state) => const ParentDashboardScreen()),
    GoRoute(path: '/student', name: 'student-dashboard', builder: (context, state) => const StudentDashboardScreen()),
  ],
);
