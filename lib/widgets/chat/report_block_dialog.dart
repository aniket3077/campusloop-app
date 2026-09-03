import 'package:flutter/material.dart';
import '../../models/chat_message_model.dart';
import '../../providers/app_state_provider.dart';

class ReportBlockDialog {
  static void showOptions({
    required BuildContext context,
    required ChatConversationModel conversation,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.orange),
                title: Text('Report ${conversation.otherParticipantName}'),
                subtitle: const Text('Report suspicious behavior, spam, or misconduct'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportForm(context, conversation);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.block_outlined, color: Colors.red),
                title: Text('Block ${conversation.otherParticipantName}'),
                subtitle: const Text('Prevent further messages from this user'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock(context, conversation);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static void _showReportForm(BuildContext context, ChatConversationModel conversation) {
    String selectedReason = 'Spam or Misleading Listing';
    final reasons = [
      'Spam or Misleading Listing',
      'Inappropriate Messages',
      'Unresponsive or No-show for Pickup',
      'Off-platform Contact Request',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report ${conversation.otherParticipantName}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select reason for reporting to Campus Moderators:'),
                const SizedBox(height: 12),
                ...reasons.map((r) {
                  final isSelected = selectedReason == r;
                  return InkWell(
                    onTap: () => setState(() => selectedReason = r),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(r, style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final chatProvider = AppStateProvider.of(context).chatProvider;
              await chatProvider.reportUser(
                conversation.id,
                conversation.participant.id,
                selectedReason,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted to Campus Moderation Team.')),
                );
              }
            },
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  static void _confirmBlock(BuildContext context, ChatConversationModel conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${conversation.otherParticipantName}?'),
        content: const Text(
          'You will no longer receive messages or offer proposals from this user on CampusLoop.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final chatProvider = AppStateProvider.of(context).chatProvider;
              await chatProvider.blockUser(
                conversation.id,
                conversation.participant.id,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${conversation.otherParticipantName} has been blocked.')),
                );
              }
            },
            child: const Text('Block User'),
          ),
        ],
      ),
    );
  }
}
