import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/profile_avatar.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  Priority selectedPriority = Priority.high;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? const TimeOfDay(hour: 16, minute: 30),
    );
    if (picked != null) setState(() => endTime = picked);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C72CB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Create New Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ProfileAvatar(),
                ],
              ),
            ),

            /// TIME PICKER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "Time: ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: pickStartTime,
                    child: Text(
                      formatTime(startTime),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Text(
                    " to ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: pickEndTime,
                    child: Text(
                      formatTime(endTime),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Priority",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: Priority.values.map((p) {
                        return ChoiceChip(
                          label: Text(p.name.toUpperCase()),
                          selected: selectedPriority == p,
                          selectedColor: p == Priority.high
                              ? Colors.red
                              : p == Priority.medium
                                  ? Colors.orange
                                  : Colors.green,
                          onSelected: (_) =>
                              setState(() => selectedPriority = p),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C72CB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            Navigator.pop(
                              context,
                              Task(
                                title: titleController.text,
                                description: descController.text,
                                priority: selectedPriority,
                                startTime: startTime,
                                endTime: endTime,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Add Task",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
