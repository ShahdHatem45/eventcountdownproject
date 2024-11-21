import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_new_project/bloc/event_cubit.dart';
import 'package:new_new_project/screens/event_details_page.dart'; // Import the details page
import 'package:new_new_project/screens/event_page.dart'; // Import EventPage
import '../bloc/event_state.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Count Down', style: (TextStyle(color: Colors.white)),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0B698B),
                Color(0xFF0396A6),
                Color(0xFF9CD3D8),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Event',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Circular border radius
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventLoaded) {
                  final filteredEvents = state.events
                      .where((event) => event.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                      .toList();

                  if (filteredEvents.isEmpty) {
                    return Center(child: Text('No events found.'));
                  }
                  return ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final timeRemaining = event.date.difference(DateTime.now());

                      return ListTile(
                        leading: event.imagePath.isNotEmpty
                            ? Image.file(
                          File(event.imagePath),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/default_event_image.png', // Default image from assets
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(event.title),
                        subtitle: Text('${timeRemaining.inDays} days remaining'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Info Icon to open EventDetailsPage
                            IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailsPage(event: event),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is EventError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Center(child: Text('Start by adding an event.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B698B), // Match app bar color
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<EventCubit>(),
              child: EventPage(),  // Navigate to add event page
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
