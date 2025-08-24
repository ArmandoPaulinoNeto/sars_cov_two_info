import 'package:flutter/material.dart';
import 'app_controller.dart';
import 'state_management.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.intancia,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: AppController.intancia.mudaEstado
                  ? Brightness.dark
                  : Brightness.light),
          title: 'Welcome!',
          home: StateManagement(),
        );
      },
    );
  }
}
