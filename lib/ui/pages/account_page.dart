import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/ui/pages/login_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final boardProvider = context.watch<BoardProvider>();

    if (userProvider.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Log In')),
        body: const LoginForm(),
      );
    }

    final user = userProvider.currentUser;

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
                    'Name: ${user!.fullName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(
                    context,
                    'Full Name',
                    user!.fullName,
                    (val) => userProvider.updateUser(user.copyWith(fullName: val)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Username (display only)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Username: ${user.uid}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Email (editable)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Email: ${user.email}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(
                    context,
                    'Email',
                    user.email,
                    (val) => userProvider.updateUser(user.copyWith(email: val)),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            Text(
              'Workspaces',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: boardProvider.getMyBoards.isEmpty
                  ? const Text('No workspaces yet.')
                  : ListView.builder(
                      itemCount: boardProvider.getMyBoards.length,
                      itemBuilder: (ctx, i) {
                        final board = boardProvider.getMyBoards[i];
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
          onPressed: () => userProvider.updateUser(null),
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
