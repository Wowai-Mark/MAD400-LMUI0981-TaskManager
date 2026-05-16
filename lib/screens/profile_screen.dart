import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile Data
  String _name = 'Wowai Mark Ngombiga';
  String _studentId = 'LMUI250981';
  String _department = 'Software Engineering';
  String _bio =
      ' A passionate Software Engineering student focused on building, developing a user-friendly applications and web applications. I enjoy tackling problems and solving it';
  List<String> _goals = [
    'build strong programming and problem solving skill',
    'create real projects and a solid portfolio',
    'graduate with skills ready for a software engineering career',
  ];

  void _editProfile() {
    final nameController = TextEditingController(text: _name);
    final idController = TextEditingController(text: _studentId);
    final deptController = TextEditingController(text: _department);
    final bioController = TextEditingController(text: _bio);
    final goalControllers = _goals
        .map((g) => TextEditingController(text: g))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'EDIT PROFILE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'FULL NAME',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'STUDENT ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: deptController,
                decoration: const InputDecoration(
                  labelText: 'DEPARTMENT',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'BIO',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Icon(Icons.text_snippet_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'CORE GOALS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: goalControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Goal ${index + 1}',
                      prefixText: '${index + 1}. ',
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _name = nameController.text;
                    _studentId = idController.text;
                    _department = deptController.text;
                    _bio = bioController.text;
                    _goals = goalControllers.map((c) => c.text).toList();
                  });
                  Navigator.pop(context);
                },
                child: const Text('SAVE CHANGES'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_note_rounded, size: 28),
            color: primaryColor,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Header
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: primaryColor.withAlpha(20),
                        child: Text(
                          _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _editProfile,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  _name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _studentId,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _department,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // Info Section
                _buildSectionHeader('ABOUT ME'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Text(
                    _bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader('CORE GOALS'),
                const SizedBox(height: 16),
                ..._goals.asMap().entries.map((entry) {
                  return _buildGoalTile(entry.key + 1, entry.value);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }

  Widget _buildGoalTile(int index, String goal) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: primaryColor.withAlpha(20), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              goal,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
