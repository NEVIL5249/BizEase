import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/inventory_item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = context.watch<InventoryProvider>();
    final items = inventoryProvider.inventory;
    final lowStock = inventoryProvider.getLowStockItems();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (lowStock.isNotEmpty)
              Card(
                color: Colors.red.shade50,
                child: ListTile(
                  title: Text(
                    '⚠ Stock Alert: ${lowStock.length} item(s) out of stock',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.productName),
                      subtitle: Text('HSN: ${item.hsnCode} | Size: ${item.size}'),
                      trailing: Text(
                        'Qty: ${item.quantity}',
                        style: TextStyle(
                          color: item.quantity == 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
