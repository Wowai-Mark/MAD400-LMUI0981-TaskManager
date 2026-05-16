import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_bottom_sheet.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _filter = 'All'; // All, Pending, Completed
  String _sortBy = 'Due Date'; // Due Date, Priority
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for demonstration
  final List<Task> _tasks = [
    Task(
      title: 'Design UI Mockups',
      description: 'Create high-fidelity mockups for the new task manager app.',
      priority: 'High',
      category: 'Design',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: 'Review System Architecture',
      description: 'Meet with the backend team to discuss the service layer.',
      priority: 'Medium',
      category: 'Development',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: true,
    ),
  ];

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _updateTask(int index, Task updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  void _showTaskForm({Task? task, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskFormBottomSheet(
        task: task,
        onSave: (savedTask) {
          if (index != null) {
            _updateTask(index, savedTask);
          } else {
            setState(() {
              _tasks.add(savedTask);
            });
          }
        },
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks?'),
        content: const Text(
          'This will permanently delete all tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tasks cleared')),
              );
            },
            child: const Text(
              'CLEAR ALL',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Task> _getFilteredAndSortedTasks() {
    List<Task> filteredTasks = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      if (!matchesSearch) return false;

      if (_filter == 'Pending') return !task.isCompleted;
      if (_filter == 'Completed') return task.isCompleted;
      return true;
    }).toList();

    if (_sortBy == 'Due Date') {
      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortBy == 'Priority') {
      final priorityMap = {'High': 0, 'Medium': 1, 'Low': 2};
      filteredTasks.sort(
        (a, b) => (priorityMap[a.priority] ?? 3).compareTo(
          priorityMap[b.priority] ?? 3,
        ),
      );
    }

    return filteredTasks;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredAndSortedTasks();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalTasks = _tasks.length;
    final completedTasks = _tasks.where((t) => t.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;
    final completionPercentage = totalTasks == 0
        ? 0.0
        : completedTasks / totalTasks;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : const Text('TASKS'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => _showClearAllConfirmation(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Due Date',
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: 'Priority',
                child: Text('Sort by Priority'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add_rounded),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF800020), // Ox Blood
                      Color(0xFF4A0E1C), // Deep Wine
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF800020).withAlpha(60),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'TOTAL',
                          totalTasks.toString(),
                          Icons.layers_outlined,
                        ),
                        _buildStatCard(
                          'PENDING',
                          pendingTasks.toString(),
                          Icons.hourglass_empty_rounded,
                        ),
                        _buildStatCard(
                          'DONE',
                          completedTasks.toString(),
                          Icons.check_circle_outline_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'DAILY PROGRESS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white70,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              '${(completionPercentage * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(40),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.fastOutSlowIn,
                                  height: 8,
                                  width:
                                      constraints.maxWidth *
                                      completionPercentage,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(100),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: ['All', 'Pending', 'Completed'].map((f) {
                    final isSelected = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _filter = f);
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          // Find real index for delete/toggle actions
                          final realIndex = _tasks.indexOf(task);
                          return Dismissible(
                            key: ObjectKey(
                              task,
                            ), // Use ObjectKey for dynamic lists
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              _deleteTask(realIndex);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Task deleted')),
                              );
                            },
                            child: TaskCard(
                              task: task,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailScreen(task: task),
                                  ),
                                );

                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  if (result['action'] == 'delete') {
                                    _deleteTask(realIndex);
                                  } else if (result['action'] == 'update') {
                                    _updateTask(realIndex, result['task']);
                                  }
                                }
                              },
                              onToggle: (val) => _toggleTask(realIndex),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white24
                : Colors.black12,
          ),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enjoy your free time or add a new task.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white60,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
