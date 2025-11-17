import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../shared/utility/extension.dart';
import '../../login/presentation/login_controller.dart';
import 'territory_controller.dart';

class TerritoryPage extends StatelessWidget {
  const TerritoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TerritoryController c = Get.find();
    final auth = Get.find<LoginController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = auth.userId;
      if (uid != null) c.loadUserTerritories(uid);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My Territories')),
      body: Obx(() {
        if (c.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (c.territories.isEmpty) return const Center(child: Text('No territories yet'));

        return RefreshIndicator(
          onRefresh: () async {
            final uid = auth.userId!;
            await c.loadUserTerritories(uid);
          },
          child: ListView.builder(
            itemCount: c.territories.length,
            itemBuilder: (ctx, i) {
              final t = c.territories[i];
              return ListTile(
                leading: Container(
                  width:56,
                  height:56,
                  decoration: BoxDecoration(color: context.colors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.map, color: context.colors.primary),
                ),
                title: Text('${(t.distanceMeters/1000).toStringAsFixed(2)} km'),
                subtitle: Text(DateFormat.yMMMd().add_jm().format(t.createdAt)),
                trailing: Text('${t.points.length} pts'),
                onTap: () => Get.toNamed('/territory_detail', arguments: t.id),
              );
            },
          ),
        );
      }),
    );
  }
}