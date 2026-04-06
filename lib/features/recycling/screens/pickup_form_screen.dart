import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PickupFormScreen extends StatefulWidget {
  const PickupFormScreen({super.key});

  @override
  State<PickupFormScreen> createState() => _PickupFormScreenState();
}

class _PickupFormScreenState extends State<PickupFormScreen> {
  String? _selectedTime;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Request', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Truck Graphic Placeholder
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.local_shipping, size: 80, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 24),
            
            // Waste Type Checkboxes (Simplified for UI mockup)
            const Text('Waste Type*', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildCheckbox('Plastic Bottles'),
            _buildCheckbox('Cardboard & paper'),
            _buildCheckbox('Iron'),
            _buildCheckbox('Electronic'),
            const SizedBox(height: 20),

            // Time Period
            const Text('Choose time period*', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile<String>(
              title: const Text('Afternoon (14:00 - 16:00)'),
              value: 'Afternoon',
              groupValue: _selectedTime,
              activeColor: AppColors.primaryGreen,
              onChanged: (value) => setState(() => _selectedTime = value),
            ),
            const SizedBox(height: 20),

            // Date Picker Button
            const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate == null ? 'Choose a date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    const Icon(Icons.calendar_month, color: AppColors.primaryGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Weight Input
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Estimated Weight (Kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit to backend and show success screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request Validating...'), backgroundColor: AppColors.primaryGreen),
                  );
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: false, // Static for UI testing
      onChanged: (bool? value) {},
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primaryGreen,
    );
  }
}