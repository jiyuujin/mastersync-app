import 'package:mastersync_app/models/logs_status_model.dart';
import 'package:mastersync_app/supabase/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'logs_status_repository.g.dart';

@Riverpod(keepAlive: true)
class LogsStatusRepository extends _$LogsStatusRepository {
  late final SupabaseClient supabaseClient;
  @override
  void build() {
    supabaseClient = ref.read(supabaseRepositoryProvider);
  }

  SupabaseStreamBuilder? stream({
    LogsStatusMasterSync? condition,
  }) {
    SupabaseStreamFilterBuilder query = supabaseClient
        .from('logs_status_master_sync')
        .stream(primaryKey: ['id']);

    // 作成日に応じて降順に並び替え
    query = query.order('created_at', ascending: false)
        as SupabaseStreamFilterBuilder;

    return query;
  }

  Future<List<Map<String, dynamic>>> select() async {
    final data = await supabaseClient.from('logs_status_master_sync').select();
    return data;
  }

  Future<void> insert({
    required String masterId,
    String assignedTeamName = '',
    String assigneeName = '',
    int count = 0,
  }) async {
    await supabaseClient.from('logs_status_master_sync').insert({
      'master_id': masterId,
      'assigned_team_name': assignedTeamName,
      'assignee_name': assigneeName,
      'count': count,
      'deleted_at': null,
    });
  }

  Future<void> delete({
    required String id,
    required String masterId,
  }) async {
    await supabaseClient.from('logs_status_master_sync').upsert({
      'id': id,
      'master_id': masterId,
      'deleted_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
