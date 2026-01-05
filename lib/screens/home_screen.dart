import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Task> tasks = [];
  final List<Task> priorityTasks = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Task> getTasksByTab(int index) {
    DateTime now = DateTime.now();
    switch (index) {
      case 0: // Today
        return tasks
            .where((t) =>
                t.dateTime.year == now.year &&
                t.dateTime.month == now.month &&
                t.dateTime.day == now.day)
            .toList();
      case 1: // This week
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
        return tasks
            .where((t) =>
                t.dateTime.isAfter(
                    startOfWeek.subtract(const Duration(seconds: 1))) &&
                t.dateTime.isBefore(endOfWeek.add(const Duration(days: 1))))
            .toList();
      case 2: // This month
        return tasks
            .where((t) =>
                t.dateTime.year == now.year && t.dateTime.month == now.month)
            .toList();
      default:
        return tasks;
    }
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Notes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Have a great day",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  ProfileAvatar(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Priority Task",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    priorityTasks.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(16)),
                            child: const Text("No priority tasks yet"),
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: priorityTasks.length,
                              itemBuilder: (context, index) {
                                final task = priorityTasks[index];
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(task.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(task.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const Spacer(),
                                      Text(
                                        "${task.startTime != null ? task.startTime!.format(context) : '--'} - ${task.endTime != null ? task.endTime!.format(context) : '--'}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.green,
                      tabs: const [
                        Tab(text: "Today's Task"),
                        Tab(text: "Weekly Task"),
                        Tab(text: "Monthly Task"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: List.generate(
                          3,
                          (index) {
                            final tabTasks = getTasksByTab(index);
                            if (tabTasks.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.edit_note,
                                        size: 60, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      "No tasks added yet",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Tap + to add a new task"),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: tabTasks.length,
                              itemBuilder: (context, idx) {
                                final task = tabTasks[idx];
                                return TaskCard(
                                  task: task,
                                  onDelete: () {
                                    setState(() {
                                      tasks.remove(task);
                                      priorityTasks.remove(task);
                                    });
                                  },
                                );
                              },
                            );
                          },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
              if (newTask.priority == Priority.high) {
                priorityTasks.add(newTask);
              }
            });
          }
        },
      ),
    );
  }
}
