import 'package:base_widgets/components/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mastersync_app/repositories/logs_status_repository.dart';
import 'package:mastersync_app/repositories/master_repository.dart';
import 'package:mastersync_app/repositories/staff_repository.dart';

class LogsStatusPage extends HookConsumerWidget {
  LogsStatusPage({super.key});

  String _masterId = '';
  TextEditingController _assignedTeamName = TextEditingController();
  String _assigneeName = '';
  TextEditingController _count = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterRepositoryNotifier =
        ref.read(masterRepositoryProvider.notifier);
    final logsStatusRepositoryNotifier =
        ref.read(logsStatusRepositoryProvider.notifier);
    final staffRepositoryNotifier = ref.read(staffRepositoryProvider.notifier);
    final masterStream = masterRepositoryNotifier.stream();
    final logsStatusMasterSyncStream = logsStatusRepositoryNotifier.stream();
    final staffStream = staffRepositoryNotifier.stream();

    return Scaffold(
      appBar: AppBar(
        title: const Text('備品管理'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: logsStatusMasterSyncStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final logsStatus = snapshot.data!;
            return ListView.builder(
              itemCount: logsStatus.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: masterStream,
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
                      final masters = snapshot.data!;
                      return Text(masters.firstWhere((m) =>
                          m['id'] == logsStatus[index]['master_id'])['name']);
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: masterStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final masters = snapshot.data!;
                          return Text(masters.firstWhere((m) =>
                              m['id'] ==
                              logsStatus[index]['master_id'])['owner_name']);
                        },
                      ),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: staffStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final staffs = snapshot.data!;
                          return Text(
                              '${logsStatus[index]['assigned_team_name'] != '' ? logsStatus[index]['assigned_team_name'] : staffs.firstWhere((m) => m['id'] == logsStatus[index]['assignee_name'])['name']}');
                        },
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<ListTileTitleAlignment>(
                    onSelected: (ListTileTitleAlignment? value) async {
                      if (value == ListTileTitleAlignment.threeLine) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('返却'),
                              content: const Text('貸出履歴から削除します。'),
                              actions: [
                                TextButton(
                                  child: const Text('キャンセル'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async =>
                                      await logsStatusRepositoryNotifier
                                          .delete(
                                            id: logsStatus[index]['id'],
                                            masterId: logsStatus[index]
                                                ['master_id'],
                                          )
                                          .then((value) =>
                                              Navigator.pop(context)),
                                ),
                              ],
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ListTileTitleAlignment>>[
                      PopupMenuItem<ListTileTitleAlignment>(
                        value: ListTileTitleAlignment.threeLine,
                        enabled: logsStatus[index]['deleted_at'] != null
                            ? false
                            : true,
                        child: const Text('返却'),
                      ),
                    ],
                  ),
                  tileColor: logsStatus[index]['deleted_at'] != null
                      ? Colors.grey[100]
                      : Colors.white,
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('貸出'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  children: [
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: masterStream,
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
                        List<String> result = [];
                        final masters = snapshot.data!;
                        masters.forEach((data) {
                          result.add(data['name']);
                        });
                        return DropdownField(
                          textColor: Colors.blue,
                          underlineColor: Colors.deepPurpleAccent,
                          dropdownList: [...result],
                          isExpanded: true,
                          onChanged: (String? value) {
                            _masterId = masters.firstWhere(
                              (s) => s['name'] == value,
                            )['id'];
                            print(value);
                            print(_masterId);
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: _assignedTeamName,
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: staffStream,
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
                        List<String> result = [];
                        final staffs = snapshot.data!;
                        staffs.forEach((data) {
                          result.add(data['name']);
                        });
                        return DropdownField(
                          textColor: Colors.blue,
                          underlineColor: Colors.deepPurpleAccent,
                          dropdownList: [...result],
                          isExpanded: true,
                          onChanged: (String? value) {
                            _assigneeName = staffs.firstWhere(
                              (s) => s['name'] == value,
                            )['id'];
                            print(value);
                            print(_assigneeName);
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: _count,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await logsStatusRepositoryNotifier.insert(
                          masterId: _masterId,
                          assignedTeamName: _assignedTeamName.text,
                          assigneeName: _assigneeName,
                          count:
                              int.parse(_count.text != '' ? _count.text : '0'),
                        );
                      },
                      child: const Text('Post'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
