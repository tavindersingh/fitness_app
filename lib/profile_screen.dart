import 'package:drift/drift.dart' hide Column;
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const _backgroundColor = Color(0xFF0b0d0f);
const _cardColor = Color(0xFF15181C);
const _textColor = Color(0xFFF5F6F7);
const _mutedColor = Color.fromRGBO(255, 255, 255, 0.45);
const _dividerColor = Color.fromRGBO(255, 255, 255, 0.06);
const _accentColor = Colors.indigoAccent;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  UserProfileData? profile;
  WeightData? latestWeight;
  DateTime? memberSince;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final database = DatabaseProvider().database;
    final loadedProfile = await getProfile(database);
    final weight = await findLatestWeight(database);
    final since = await findMemberSince(database);

    if (!mounted) return;
    setState(() {
      profile = loadedProfile;
      latestWeight = weight;
      memberSince = since;
      isLoading = false;
    });
  }

  Future<void> saveChanges(UserProfileCompanion changes) async {
    try {
      await updateProfile(DatabaseProvider().database, changes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't save your profile.")),
      );
      return;
    }
    await loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                _header(),
                const SizedBox(height: 20),
                _detailsCard(),
                const SizedBox(height: 14),
                _goalCard(),
              ],
            ),
    );
  }

  Widget _header() {
    final name = profile?.name;
    final hasName = name != null && name.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: editName,
      child: Row(
        spacing: 14,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _accentColor,
              shape: BoxShape.circle,
              border: Border.all(color: _accentColor.withAlpha(90), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withAlpha(90),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: hasName
                ? Text(
                    name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const Icon(Icons.person_rounded, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  hasName ? name : "Add your name",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: hasName ? _textColor : _mutedColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (memberSince != null)
                  Text(
                    "Member since ${DateFormat('MMM yyyy').format(memberSince!)}",
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: _mutedColor, size: 18),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    final age = profile?.age;
    final height = profile?.heightCm;
    final weight = latestWeight?.value;

    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          _DetailRow(
            label: "Age",
            value: age == null ? "Add" : "$age",
            isPlaceholder: age == null,
            onTap: editAge,
          ),
          const Divider(height: 1, color: _dividerColor),
          _DetailRow(
            label: "Height",
            value: height == null ? "Add" : "${height.toStringAsFixed(0)} cm",
            isPlaceholder: height == null,
            onTap: editHeight,
          ),
          const Divider(height: 1, color: _dividerColor),
          // Weight comes from the weight log on the Home screen.
          _DetailRow(
            label: "Weight",
            value: weight == null
                ? "Log from Home"
                : "${weight.toStringAsFixed(1)} kg",
            isPlaceholder: weight == null,
          ),
        ],
      ),
    );
  }

  Widget _goalCard() {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fitness Goal",
            style: TextStyle(
              color: _mutedColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final goal in fitnessGoals)
                _GoalChip(
                  label: goal,
                  isSelected: profile?.goal == goal,
                  onTap: () =>
                      saveChanges(UserProfileCompanion(goal: Value(goal))),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> editName() async {
    final value = await _showEditDialog(
      title: "Your name",
      initialValue: profile?.name ?? "",
      keyboardType: TextInputType.name,
      maxLength: 40,
      validate: (text) => text.isEmpty ? "Please enter your name." : null,
    );
    if (value == null) return;
    await saveChanges(UserProfileCompanion(name: Value(value)));
  }

  Future<void> editAge() async {
    final value = await _showEditDialog(
      title: "Age",
      initialValue: profile?.age?.toString() ?? "",
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 3,
      validate: (text) {
        final age = int.tryParse(text);
        if (age == null || age < 1 || age > 120) {
          return "Enter an age between 1 and 120.";
        }
        return null;
      },
    );
    if (value == null) return;
    await saveChanges(UserProfileCompanion(age: Value(int.parse(value))));
  }

  Future<void> editHeight() async {
    final value = await _showEditDialog(
      title: "Height (cm)",
      initialValue: profile?.heightCm?.toStringAsFixed(0) ?? "",
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 3,
      validate: (text) {
        final height = int.tryParse(text);
        if (height == null || height < 50 || height > 272) {
          return "Enter a height between 50 and 272 cm.";
        }
        return null;
      },
    );
    if (value == null) return;
    await saveChanges(
      UserProfileCompanion(heightCm: Value(double.parse(value))),
    );
  }

  /// Shows a single-field edit dialog. Returns the trimmed value, or null if
  /// the user cancelled.
  Future<String?> _showEditDialog({
    required String title,
    required String initialValue,
    required String? Function(String text) validate,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _EditValueDialog(
        title: title,
        initialValue: initialValue,
        validate: validate,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
      ),
    );
  }
}

class _EditValueDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final String? Function(String text) validate;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const _EditValueDialog({
    required this.title,
    required this.initialValue,
    required this.validate,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  State<_EditValueDialog> createState() => _EditValueDialogState();
}

class _EditValueDialogState extends State<_EditValueDialog> {
  late final TextEditingController controller = TextEditingController(
    text: widget.initialValue,
  );
  String? errorText;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final text = controller.text.trim();
    final error = widget.validate(text);
    if (error != null) {
      setState(() => errorText = error);
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(errorText: errorText),
        onSubmitted: (_) => submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(onPressed: submit, child: const Text("Save")),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const _Card({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPlaceholder;
  final VoidCallback? onTap;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isPlaceholder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: _mutedColor, fontSize: 13),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: isPlaceholder ? _mutedColor : _textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: _mutedColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _accentColor.withAlpha(46) : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? _accentColor.withAlpha(102)
                : const Color.fromRGBO(255, 255, 255, 0.12),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _accentColor : _mutedColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
