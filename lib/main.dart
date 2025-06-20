import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/theme/app_theme.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'core/utils/helper/on_genrated_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // setup service locator
  runApp(const MyApp());
}
 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      initialRoute: LoginView.routeName,
      onGenerateRoute: onGenratedRoutes,
    );
  }
}
