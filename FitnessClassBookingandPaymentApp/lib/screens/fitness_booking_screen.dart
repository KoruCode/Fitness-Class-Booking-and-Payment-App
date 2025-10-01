import 'package:flutter/material.dart';

class FitnessBookingScreen extends StatefulWidget {
  @override
  _FitnessBookingScreenState createState() => _FitnessBookingScreenState();
}

class _FitnessBookingScreenState extends State<FitnessBookingScreen> {
  final _formKey = GlobalKey<FormState>(); // Activity #4

  final _nameController = TextEditingController(); // Activity #6
  final _emailController = TextEditingController(); // Activity #6 + #3
  final _notesController = TextEditingController(); // Activity #9

  bool _termsAccepted = false; // Activity #5 Checkbox
  bool _needsEquipment = false; // Activity #5 Switch
  bool _paymentConfirmed = false; // Payment confirmation checkbox

  String _userType = 'Member'; // Activity #7 Dropdown (Member, Walk-in)
  String _paymentMethod = 'Credit Card'; // Payment method

  DateTime? _pickedDate; // Activity #8 Date picker
  TimeOfDay? _pickedTime; // Activity #8 Time picker

  final List<Map<String, dynamic>> _bookings =
      []; // Activity #10 Save and display bookings

  String? _validateEmail(String? value) {
    if (value == null || !value.contains('@')) return 'Email must contain "@"';
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (selected != null) setState(() => _pickedDate = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected != null) setState(() => _pickedTime = selected);
  }

  void _showNotesDialog() {
    // Activity #9
    final notes = _notesController.text;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Additional Notes'),
        content: Text(notes.isEmpty ? 'No notes entered' : notes),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must accept terms and conditions')),
      );
      return;
    }

    if (!_paymentConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please confirm payment')),
      );
      return;
    }

    if (_pickedDate == null || _pickedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() {
      _bookings.add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'userType': _userType,
        'needsEquipment': _needsEquipment,
        'paymentMethod': _paymentMethod,
        'date': _pickedDate,
        'time': _pickedTime,
        'notes': _notesController.text.trim(),
      });

      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _notesController.clear();
      _termsAccepted = false;
      _needsEquipment = false;
      _paymentConfirmed = false;
      _userType = 'Member';
      _paymentMethod = 'Credit Card';
      _pickedDate = null;
      _pickedTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking and payment submitted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness Class Booking')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Form(
              key: _formKey, // Activity #4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity #6
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: _validateRequired,
                  ),
                  SizedBox(height: 16),

                  // Activity #6 + #3
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 16),

                  // Activity #7
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'User Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.group),
                    ),
                    value: _userType,
                    items: ['Member', 'Walk-in']
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _userType = val ?? 'Member'),
                  ),
                  SizedBox(height: 16),

                  // Activity #5 Checkbox
                  CheckboxListTile(
                    title: Text('Accept Terms and Conditions'),
                    value: _termsAccepted,
                    onChanged: (val) =>
                        setState(() => _termsAccepted = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // Activity #5 Switch
                  SwitchListTile(
                    title: Text('Require Equipment'),
                    value: _needsEquipment,
                    onChanged: (val) => setState(() => _needsEquipment = val),
                  ),
                  SizedBox(height: 16),

                  // Activity #8 Date picker and Time picker
                  Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Booking Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _pickedDate != null
                                ? _pickedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                : 'Select a date',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: _pickDate, child: Text('Pick Date')),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Booking Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _pickedTime != null
                                ? _pickedTime!.format(context)
                                : 'Select a time',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: _pickTime, child: Text('Pick Time')),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Activity #9 Notes TextField and show button
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Additional Notes',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: Icon(Icons.visibility),
                      label: Text('Show Notes'),
                      onPressed: _showNotesDialog,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment section with dropdown and confirmation checkbox
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    value: _paymentMethod,
                    items: [
                      'Credit Card',
                      'Paypal',
                      'Cash on Arrival',
                      'Bank Transfer',
                    ]
                        .map((pm) =>
                            DropdownMenuItem(value: pm, child: Text(pm)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _paymentMethod = val ?? 'Credit Card'),
                  ),
                  SizedBox(height: 16),

                  CheckboxListTile(
                    title: Text('I confirm payment has been made'),
                    value: _paymentConfirmed,
                    onChanged: (val) =>
                        setState(() => _paymentConfirmed = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 20),

                  // Submit button - Activity #10
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        child: Text('Submit Booking',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Display bookings - Activity #10
            Text(
              'Submitted Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            _bookings.isEmpty
                ? Text('No bookings submitted yet.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        elevation: 3,
                        child: ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.teal),
                          title: Text(
                              '${booking['name']} (${booking['userType']})'),
                          subtitle: Text(
                            'Email: ${booking['email']}\n'
                            'Date: ${booking['date'].toLocal().toString().split(' ')[0]}  Time: ${booking['time'].format(context)}\n'
                            'Equipment required: ${booking['needsEquipment'] ? "Yes" : "No"}\n'
                            'Payment Method: ${booking['paymentMethod']}\n'
                            'Notes: ${booking['notes'].isEmpty ? "None" : booking['notes']}',
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
