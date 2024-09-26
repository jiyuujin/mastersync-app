import 'package:mastersync_app/models/attendee_model.dart';
import 'package:mastersync_app/supabase/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attendee_repository.g.dart';

@Riverpod(keepAlive: true)
class AttnedeeRepository extends _$AttnedeeRepository {
  late final SupabaseClient supabaseClient;
  @override
  void build() {
    supabaseClient = ref.read(supabaseRepositoryProvider);
  }

  SupabaseStreamBuilder? stream({
    Attendee? condition,
    bool hasParty = false,
  }) {
    SupabaseStreamFilterBuilder query =
        supabaseClient.from('attendees').stream(primaryKey: ['id']);

    // 参加者の種別に応じてフィルタリング
    query = query.eq('role', hasParty ? 'attendee + party' : 'attendee')
        as SupabaseStreamFilterBuilder;

    // 照合完了日に応じて降順に並び替え
    query = query.order('activated_at', ascending: false)
        as SupabaseStreamFilterBuilder;

    // 照合完了していない者を除外 (TBD)

    return query;
  }

  Future<List<Map<String, dynamic>>> select() async {
    final data = await supabaseClient.from('attendees').select();
    return data;
  }
}
