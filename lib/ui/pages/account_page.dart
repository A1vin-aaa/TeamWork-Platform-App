// lib/ui/pages/account_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/ui/widgets/login_form.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardProvider>();
    final userId = provider.currentUserId ?? '';

    // If not logged in, show the reusable LoginForm widget
    if (userId.isEmpty) {
      return const LoginForm();
    }

    final profile = provider.userProfiles[userId]!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name (editable)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Name: ${profile['name']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(
                    context,
                    'Name',
                    profile['name']!,
                        (val) => provider.updateProfileField(userId, 'name', val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Username (display only)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Username: $userId',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Email (editable)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Email: ${profile['email']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(
                    context,
                    'Email',
                    profile['email']!,
                        (val) => provider.updateProfileField(userId, 'email', val),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Workspaces list
            Text(
              'Workspaces',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: provider.visibleBoards.isEmpty
                  ? const Text('No workspaces yet.')
                  : ListView.builder(
                itemCount: provider.visibleBoards.length,
                itemBuilder: (ctx, i) {
                  final board = provider.visibleBoards[i];
                  return ListTile(
                    leading: const Icon(Icons.dashboard_outlined),
                    title: Text(board.name),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/board',
                      arguments: board.id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Log Out button at bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () => provider.setCurrentUserId(''),
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      String fieldName,
      String currentValue,
      Future<void> Function(String) onSave,
      ) {
    final ctrl = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: fieldName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final val = ctrl.text.trim();
              if (val.isNotEmpty) await onSave(val);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
