import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/provider/chat_provider.dart';
import 'package:mobile/core/provider/workout_section_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import './ui/screens/authScreen/auth_screen.dart';
import './core/provider/AuthProvider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './core/provider/bottom_navbar_provider.dart';
import './ui/widgets/bottom_navbar/bottom_navbar.dart';
import './core/provider/feed_provider.dart';
import 'core/provider/pose_detector_provider.dart';
import './ui/screens/chats_screen/chats_screen.dart';
import 'ui/screens/chats_screen/chatbot_conversation_screen.dart';
import 'ui/screens/exercices_screen/exercices_screen.dart';

const Color primaryColor =Color(0xFFF7713D);
const Color secondaryColor =Color.fromARGB(255, 31, 31, 31);
const Color tertiaryColor =Color.fromARGB(255, 255, 255, 255);
const Color bg_gray = Color(0xEEEEEEEE);
const Color bg_light_gray = Color.fromARGB(255, 248, 248, 248);
const Color text_gray = Color.fromARGB(255, 179, 179, 179);


// const Color darkmodeBackgroundColor = Color(0xFF121212);

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => PoseDetectorProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutSectionProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider())
      ],
      child: const MyApp(),
    ) 
  );
    
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = Provider.of<BottomNavbarProvider>(context, listen: true).current_screen;
    final isLoggedIn = Provider.of<AuthProvider>(context, listen: true).isLoggedIn;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
    return PlatformApp(
      title: 'Flutter Demo',
      routes: {
        '/chats': (context) => const ChatsScreen(),
        '/chatbot-conversation': (context) => ChatbotConversationScreen(chatId: 1,chatName:  'John Doe',chatMessages:  ['Hello', 'How are you?'],lastSeen:  DateTime.now()),
        '/exercices': (context) => const ExercicesScreen(),
      },
      material: (_, __) => MaterialAppData(
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: secondaryColor,  
            displayColor: secondaryColor,
          ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white, 
            selectedItemColor: primaryColor,
            unselectedItemColor: text_gray,
            ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey[900],
          textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,  
            displayColor: Colors.white,
          ),
          // bottomNavigationBarTheme: BottomNavigationBarThemeData(
          //   backgroundColor: darkmodeBackgroundColor, 
          //   selectedItemColor: primaryColor,
          //   unselectedItemColor: text_gray,
          //   ),
        ),
        themeMode: ThemeMode.system,  // Automatically switches between light/dark themes
      ),
      
      
      
      cupertino: (_, __) => CupertinoAppData(
        theme: isDarkMode
            ? CupertinoThemeData(
                primaryColor: CupertinoColors.inactiveGray,
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(color: Colors.white),
                ),
              )
            : CupertinoThemeData(
                primaryColor: CupertinoColors.activeBlue,
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(color: secondaryColor),
                ),
              ),
      ),

      home:Scaffold(
        body: isLoggedIn ? currentScreen: AuthScreen(),
        bottomNavigationBar:isLoggedIn ?BottomNavbar():null,
        )
      

      
      
      

    );
  }
}
