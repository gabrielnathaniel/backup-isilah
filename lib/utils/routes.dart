import 'package:isilahtitiktitik/utils/root.dart';
import 'package:isilahtitiktitik/view/page-auth/page-forgot-password/page_forgot_password.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register.dart';
import 'package:isilahtitiktitik/view/page-fun-fact/page_fun_fact.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-profile/page_change_password.dart';
import 'package:isilahtitiktitik/view/page-profile/page_edit_profile.dart';
import 'package:isilahtitiktitik/view/page-profile/page_help.dart';
import 'package:isilahtitiktitik/view/page-profile/page_options.dart';
import 'package:isilahtitiktitik/view/page-profile/page_statistics.dart';
import 'package:isilahtitiktitik/view/page-profile/page_history.dart';
import 'package:isilahtitiktitik/view/page-profile/page-referral/page_referral.dart';

final appRoutes = {
  //home
  '/': (context) => const Root(),
  '/home': (context) => const HomeWidget(),
  '/login': (context) => const LoginByEmailPage(),
  '/login-email': (context) => const LoginByEmailPage(),
  '/register': (context) => const RegisterPage(),

  //profile
  '/change-password': (context) => const ChangePasswordPage(),
  '/forgot-password': (context) => const ForgotPasswordPage(),
  '/edit-profile': (context) => const EditProfilePage(),
  // '/detail-profile': (context) => const DetailProfilePage(),
  '/referral': (context) => const ReferralPage(),
  '/options': (context) => const OptionsPage(),
  '/statistics': (context) => const StatisticsPage(),
  '/history': (context) => const HistoryPage(),
  '/help': (context) => const HelpPage(),

  // Fun Fact
  '/fun-fact': (context) => const FunFactPage(),

  // Mini Games
  // '/game-tarik-tambang': (context) => const MainMenu(),
  // '/game-isiboy-run': (context) => const GamePlay(),
};
