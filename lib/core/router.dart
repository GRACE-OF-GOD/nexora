 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/providers/auth_provider.dart';
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
import 'package:nexora/screens/teacher/emploi_temps_teacher_screen.dart';
import 'package:nexora/screens/parent/parent_dashboard_screen.dart';
import 'package:nexora/screens/parent/notes_parent_screen.dart';
import 'package:nexora/screens/parent/absences_parent_screen.dart';
import 'package:nexora/screens/parent/bulletins_parent_screen.dart';
import 'package:nexora/screens/student/student_dashboard_screen.dart';
import 'package:nexora/screens/student/notes_student_screen.dart';
import 'package:nexora/screens/student/absences_student_screen.dart';
import 'package:nexora/screens/student/bulletins_student_screen.dart';
import 'package:nexora/screens/student/emploi_temps_student_screen.dart';
import 'package:nexora/screens/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
       final isLoggedIn = authState.value != null;
final isLoginPage = state.matchedLocation == '/login';

if (!isLoggedIn && !isLoginPage) return '/login';
if (!isLoggedIn) return null;
if (isLoginPage) {
        final role = authState.value!.role;
        if (role == AppConstants.roleAdmin) return '/admin';
        if (role == AppConstants.roleTeacher) return '/teacher';
        if (role == AppConstants.roleParent) return '/parent';
        return '/student';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/eleves',
        name: 'admin-eleves',
        builder: (context, state) => const ElevesScreen(),
      ),
      GoRoute(
        path: '/admin/enseignants',
        name: 'admin-enseignants',
        builder: (context, state) => const EnseignantsScreen(),
      ),
      GoRoute(
        path: '/admin/classes',
        name: 'admin-classes',
        builder: (context, state) => const ClassesScreen(),
      ),
      GoRoute(
        path: '/admin/matieres',
        name: 'admin-matieres',
        builder: (context, state) => const MatieresScreen(),
      ),
      GoRoute(
        path: '/admin/notes',
        name: 'admin-notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/admin/absences',
        name: 'admin-absences',
        builder: (context, state) => const AbsencesScreen(),
      ),
      GoRoute(
        path: '/admin/bulletins',
        name: 'admin-bulletins',
        builder: (context, state) => const BulletinsScreen(),
      ),
      GoRoute(
        path: '/admin/paiements',
        name: 'admin-paiements',
        builder: (context, state) => const PaiementsScreen(),
      ),
      GoRoute(
        path: '/teacher',
        name: 'teacher-dashboard',
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/teacher/emploi-temps',
        name: 'teacher-emploi-temps',
        builder: (context, state) => const EmploiTempsTeacherScreen(),
      ),
      GoRoute(
        path: '/parent',
        name: 'parent-dashboard',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/parent/notes',
        name: 'parent-notes',
        builder: (context, state) => const NotesParentScreen(),
      ),
      GoRoute(
        path: '/parent/absences',
        name: 'parent-absences',
        builder: (context, state) => const AbsencesParentScreen(),
      ),
      GoRoute(
        path: '/parent/bulletins',
        name: 'parent-bulletins',
        builder: (context, state) => const BulletinsParentScreen(),
      ),
      GoRoute(
        path: '/student',
        name: 'student-dashboard',
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/student/notes',
        name: 'student-notes',
        builder: (context, state) => const NotesStudentScreen(),
      ),
      GoRoute(
        path: '/student/absences',
        name: 'student-absences',
        builder: (context, state) => const AbsencesStudentScreen(),
      ),
      GoRoute(
        path: '/student/bulletins',
        name: 'student-bulletins',
        builder: (context, state) => const BulletinsStudentScreen(),
      ),
      GoRoute(
        path: '/student/emploi-temps',
        name: 'student-emploi-temps',
        builder: (context, state) => const EmploiTempsStudentScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
    ],
  );
});