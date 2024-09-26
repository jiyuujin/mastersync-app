import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mastersync_app/constants.dart';
import 'package:mastersync_app/repositories/attendee_repository.dart';

class AnalysisPage extends HookConsumerWidget {
  AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendeeRepositoryNotifier =
        ref.read(attnedeeRepositoryProvider.notifier);
    final attendeeStream = attendeeRepositoryNotifier.stream(hasParty: false);
    final attendeePartyStream =
        attendeeRepositoryNotifier.stream(hasParty: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('分析'),
      ),
      body: ListView.builder(
          itemCount: analysisItems.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: attendeeStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final attendees = snapshot.data!;
                  return ListTile(
                    title: Text(analysisItems[index]),
                    subtitle: const Text('注文番号照合完了'),
                    trailing: Text(attendees
                        .where((element) => element['activated_at'] != null)
                        .length
                        .toString()),
                  );
                },
              );
            }
            if (index == 1) {
              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: attendeePartyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final attendees = snapshot.data!;
                  return ListTile(
                    title: Text(analysisItems[index]),
                    subtitle: const Text('注文番号照合完了'),
                    trailing: Text(attendees
                        .where((element) => element['activated_at'] != null)
                        .length
                        .toString()),
                  );
                },
              );
            }
            return null;
          }),
    );
  }
}
