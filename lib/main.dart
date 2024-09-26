import 'package:base_widgets/components/bottom_navigation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mastersync_app/constants.dart';
import 'package:mastersync_app/features/mastersync/logs_status_page.dart';
import 'package:mastersync_app/features/setting/analysis_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MasterSync App (備品管理アプリ)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavigationTab(
        title: title,
        tabItems: tabItems,
        screens: [
          LogsStatusPage(),
          AnalysisPage(),
        ],
      ),
    );
  }
}
