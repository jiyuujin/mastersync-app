import 'package:mastersync_app/models/master_model.dart';
import 'package:mastersync_app/supabase/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'master_repository.g.dart';

@Riverpod(keepAlive: true)
class MasterRepository extends _$MasterRepository {
  late final SupabaseClient supabaseClient;
  @override
  void build() {
    supabaseClient = ref.read(supabaseRepositoryProvider);
  }

  SupabaseStreamBuilder? stream({
    Master? condition,
  }) {
    SupabaseStreamFilterBuilder query =
      supabaseClient.from('masters').stream(primaryKey: ['id']);

    // 作成日に応じて降順に並び替え
    query = query.order('created_at', ascending: false)
      as SupabaseStreamFilterBuilder;

    return query;
  }

  Future<List<Map<String, dynamic>>> select() async {
    final data = await supabaseClient.from('masters').select();
    return data;
  }
}
