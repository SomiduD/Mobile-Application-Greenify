import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PickupFormScreen extends StatefulWidget {
  const PickupFormScreen({super.key});

  @override
  State<PickupFormScreen> createState() => _PickupFormScreenState();
}

class _PickupFormScreenState extends State<PickupFormScreen> {
  final Map<String, bool> _wasteTypes = {'Plastic': false, 'Paper': false, 'Glass': false, 'E-Waste': false, 'Metal': false, 'Organic': false};
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Pickup', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pickup Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(decoration: InputDecoration(hintText: 'Enter your address', prefixIcon: const Icon(Icons.home), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),
            const Text('What are you recycling?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: _wasteTypes.keys.map((String key) {
                final isSelected = _wasteTypes[key]!;
                return FilterChip(
                  label: Text(key),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  checkmarkColor: Colors.white,
                  onSelected: (bool value) => setState(() => _wasteTypes[key] = value),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('Preferred Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () async { final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30))); if (date != null) setState(() => _selectedDate = date); }, icon: const Icon(Icons.calendar_today), label: Text(_selectedDate == null ? 'Date' : '${_selectedDate!.day}/${_selectedDate!.month}'))),
                const SizedBox(width: 16),
                Expanded(child: OutlinedButton.icon(onPressed: () async { final time = await showTimePicker(context: context, initialTime: TimeOfDay.now()); if (time != null) setState(() => _selectedTime = time); }, icon: const Icon(Icons.access_time), label: Text(_selectedTime == null ? 'Time' : _selectedTime!.format(context)))),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pickup Scheduled!'), backgroundColor: AppColors.primaryGreen)); Navigator.pop(context); }, child: const Text('Confirm Pickup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}