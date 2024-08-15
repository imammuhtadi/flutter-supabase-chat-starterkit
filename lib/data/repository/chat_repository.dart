// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supachat/data/model/contact_model.dart';
import 'package:supachat/data/model/message_model.dart';
import 'package:supachat/data/model/room_model.dart';
import 'package:supachat/data/model/user_chat_model.dart';

class ChatRepository {
  final supabase = Supabase.instance.client;
  RealtimeChannel? contactChannel;
  RealtimeChannel? roomChannel;
  RealtimeChannel? messageChannel;

  Stream<List<ContactModel>> subscribeContacts({
    required String userId,
  }) {
    contactChannel =
        supabase.channel('public:contacts:$userId').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'contacts',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: userId,
              ),
              callback: (payload) {
                print('onUpdate ${payload.toString()}');
              },
            );
    contactChannel!.subscribe();
    print('subscribed public:contacts:$userId');
    return supabase
        .from('contacts')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((v) => v.map((map) => ContactModel.fromMap(map)).toList());
  }

  unsubsribeContacts({required String userId}) {
    print('unsubscribe public:contacts:$userId');
    if (contactChannel != null) supabase.removeChannel(contactChannel!);
  }

  Stream<List<RoomModel>> subscribRooms({
    required String userId,
    required List<String> contactIds,
  }) {
    roomChannel = supabase.channel('public:rooms:$userId').onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'rooms',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.inFilter,
            column: 'id',
            value: contactIds,
          ),
          callback: (payload) {
            print('onUpdate ${payload.toString()}');
          },
        );
    roomChannel!.subscribe();
    print('subscribed public:rooms:$userId');
    return supabase
        .from('rooms')
        .stream(primaryKey: ['id'])
        .inFilter('id', contactIds)
        .order('last_message_sent')
        .map((v) => v.map((map) => RoomModel.fromMap(map)).toList());
  }

  unsubsribeRooms({required String userId}) {
    print('unsubscribe public:rooms:$userId');
    if (roomChannel != null) supabase.removeChannel(roomChannel!);
  }

  Stream<List<MessageModel>> subscribeMessages({
    required String roomId,
    required String userId,
  }) {
    messageChannel =
        supabase.channel('public:messages:$roomId').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'room_id',
                value: roomId,
              ),
              callback: (payload) {
                print('update last active trigger');
                updateLastActive(roomId: roomId, userId: userId);
              },
            );
    messageChannel!.subscribe();
    print('subscribed public:messages:$roomId');
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map((v) => v.map((map) => MessageModel.fromMap(map)).toList());
  }

  Future<List<UserModel>> getMember({required String roomId}) {
    return supabase
        .from('contacts')
        .select('user:users!participants_user_id_fkey(id, name, photo)')
        .eq('room_id', roomId)
        .then(
          (v) => v.map((map) => UserModel.fromMap(map['user'])).toList(),
        );
  }

  unsubsribeMessages({required String roomId}) {
    print('unsubscribe public:messages:$roomId');
    if (messageChannel != null) supabase.removeChannel(messageChannel!);
  }

  updateLastActive({required String roomId, required String userId}) {
    print('update last active action');
    final date = DateTime.now().toIso8601String();
    supabase
        .from('contacts')
        .update({'last_active_local': date})
        .eq('room_id', roomId)
        .eq('user_id', userId)
        .select()
        .then((value) {
          print('onUpdate ${value.toString()}');
        });
  }
}
