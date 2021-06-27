import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_assignment/routes/main_view.dart';
import 'package:test_assignment/services/main_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    Material(
      child: GetMaterialApp(
        showPerformanceOverlay: false,
        initialRoute: '/',
        initialBinding: MainBinding(),
        getPages: [
          GetPage(
            name: '/',
            page: () => MainView(),
          ),
        ],
      ),
    ),
  );
}
