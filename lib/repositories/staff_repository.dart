import 'package:mastersync_app/models/master_model.dart';
import 'package:mastersync_app/supabase/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'staff_repository.g.dart';

@Riverpod(keepAlive: true)
class StaffRepository extends _$StaffRepository {
  late final SupabaseClient supabaseClient;
  @override
  void build() {
    supabaseClient = ref.read(supabaseRepositoryProvider);
  }

  SupabaseStreamBuilder? stream({
    Master? condition,
  }) {
    SupabaseStreamFilterBuilder query =
        supabaseClient.from('staffs').stream(primaryKey: ['id']);

    // 作成日に応じて降順に並び替え
    query = query.order('created_at', ascending: false)
        as SupabaseStreamFilterBuilder;

    return query;
  }

  Future<List<Map<String, dynamic>>> select() async {
    final data = await supabaseClient.from('staffs').select();
    return data;
  }
}
