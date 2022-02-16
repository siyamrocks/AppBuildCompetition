/* 

-------------- [ Students Study Better ] -----------------
Created by: Shafil Alam, Suraj Hussain
----------------------------------------------------------

This is the main file where the theme, translations, auth, and student providers are setup. 
After this process is done, the code will open the sign in screen or the home screen.

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/constants/constants.dart';
import 'package:flutter_starter/ui/auth/auth.dart';
import 'package:flutter_starter/ui/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is ready
  await Firebase.initializeApp(); // Wait for Firebase to be initialized
  LanguageProvider().setInitialLocalLanguage(); // Set lang based on the device
  runApp(
    // Create the providers
    MultiProvider(
      providers: [
        /* Theme Provider */
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        /* Language Provider */
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
        /* Auth Service */
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        /* Student Service */
        ChangeNotifierProvider<StudentVueProvider>(
          create: (context) => StudentVueProvider(),
        )
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build Language provider ->
    return Consumer<LanguageProvider>(
      builder: (_, languageProviderRef, __) {
        // Build Theme provider ->
        return Consumer<ThemeProvider>(
          builder: (_, themeProviderRef, __) {
            // Build Auth provider ->
            return AuthWidgetBuilder(
              builder:
                  (BuildContext context, AsyncSnapshot<User> userSnapshot) {
                return MaterialApp(
                  // Begin language translation code
                  locale: languageProviderRef.getLocale, // <- Current locale
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(), // <- Set app localizations
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.languages.keys
                      .toList(), // <- Supported locales
                  // End language translation
                  debugShowCheckedModeBanner: false,
                  routes: Routes.routes, // <- Create the routes
                  theme: AppThemes.lightTheme, // <- Set the light theme
                  darkTheme: AppThemes.darkTheme, // <- Set the dark theme
                  // Set the theme based on the user's device or setting.
                  themeMode: themeProviderRef.isDarkModeOn
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  // If a user is logged in (not null) then show the home screen else show the sign in page.
                  home:
                      (userSnapshot?.data?.uid != null) ? HomeUI() : SignInUI(),
                );
              },
            );
          },
        );
      },
    );
  }
}
