import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_cubit.dart';
import '../models/event_model.dart';
import 'event_page.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            tooltip: 'Edit Event',
            onPressed: () {
              // Navigate to EventPage for editing
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventPage(event: event),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            tooltip: 'Delete Event',
            onPressed: () {
              // Show confirmation dialog for deletion
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this event?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<EventCubit>().deleteEvent(event.id!);
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go back to event list
                        },
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF0B698B)), // Set color to match app bar
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF0B698B)), // Set color to match app bar
                        child: const Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.imagePath.isNotEmpty
                ? Image.file(File(event.imagePath)) // Display the event image
                : Image.asset('assets/images/default_event_image.png'),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold), // Bold for the description header
            ),
            Text(event.description), // Normal content for description
            const SizedBox(height: 8),
            const Text(
              'Date:',
              style: TextStyle(fontWeight: FontWeight.bold), // Bold for the date header
            ),
            Text('${event.date.month.toString().padLeft(2, '0')} ${event.date.day.toString()}, ${event.date.year}'), // Normal content for date
          ],
        ),
      ),
    );
  }
}
