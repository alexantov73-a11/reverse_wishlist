import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reverse_wishlist/main.dart';
import 'package:reverse_wishlist/data/services/local_storage_service.dart';
import 'package:reverse_wishlist/data/services/camera_service.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    final storageService = LocalStorageService();
    final cameraService = CameraService();

    await tester.pumpWidget(
      MyApp(storageService: storageService, cameraService: cameraService),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
