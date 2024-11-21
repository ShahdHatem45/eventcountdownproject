import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_new_project/models/event_model.dart';
import 'package:new_new_project/services/event_database.dart';
import 'package:new_new_project/bloc/event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventDatabase database;

  EventCubit(this.database) : super(EventInitial());

  Future<void> loadEvents() async {
    try {
      emit(EventLoading());
      final events = await database.getAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to load events'));
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await database.createEvent(event);
      loadEvents();
    } catch (e) {
      emit(EventError('Failed to add event'));
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await database.updateEvent(event);
      loadEvents();
    } catch (e) {
      emit(EventError('Failed to update event'));
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await database.deleteEvent(id);
      loadEvents();
    } catch (e) {
      emit(EventError('Failed to delete event'));
    }
  }
}