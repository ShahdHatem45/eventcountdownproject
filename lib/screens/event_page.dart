import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/event_cubit.dart';
import '../models/event_model.dart';
import 'event_list_page.dart'; // Import EventListPage

class EventPage extends StatefulWidget {
  final Event? event;

  EventPage({Key? key, this.event}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _selectedDate = widget.event?.date ?? DateTime.now();
    _imagePath = widget.event?.imagePath; // Keep image path if editing
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveEvent() async {
    final event = Event(
      id: widget.event?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      imagePath: _imagePath ?? '', // Save empty string if no image selected
    );

    if (widget.event != null) {
      context.read<EventCubit>().updateEvent(event);
    } else {
      context.read<EventCubit>().addEvent(event);
    }

    // Navigate to EventListPage and replace the current page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EventListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'Add Event', style: TextStyle(color: Colors.white)),
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
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: _saveEvent,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imagePath != null && _imagePath!.isNotEmpty
                      ? Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/default_event_image.png', // Default image from assets
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Text(
                'Event Date: ${_selectedDate.toLocal()}'.split(' ')[0],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: const Text('Select date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
