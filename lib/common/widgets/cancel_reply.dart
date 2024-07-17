import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_reply_provider.dart';

void cancelReply(WidgetRef ref) {
  ref.read(messageReplyProvider.notifier).resetMessageReply();
}
