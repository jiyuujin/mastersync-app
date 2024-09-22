import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseClient supabaseRepository(SupabaseRepositoryRef ref) {
  return Supabase.instance.client;
}
