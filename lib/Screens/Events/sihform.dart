import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:omnia/Resources/Theme/theme.dart';
import 'package:omnia/Resources/elegantnotif.dart';
import 'package:omnia/Screens/Events/paymentsscard.dart';
import 'package:omnia/cardvalues.dart';

/// Registration fee shown on the form.
const String sihRegistrationFee = '₹100';

/// Payment destinations offered on the form.
///
/// TODO(ACM-JUIT): fill these in with the chapter's real payment links before
/// release. They are intentionally left blank rather than guessed — a wrong UPI
/// id or link would send participants' money to the wrong place. Any entry left
/// blank is rendered as disabled instead of opening a dead link.
const Map<String, String> sihPaymentLinks = <String, String>{
  'UPI / Any app': '',
  'Google Pay': '',
  'Paytm': '',
};

/// Worksheet that submissions are appended to, and the header row written when
/// the sheet is still empty.
const String _sihWorksheetTitle = 'Sheet1';
const List<String> _sihHeaderRow = <String>[
  'Timestamp',
  'Team Name',
  'Team Leader',
  'Email',
  'Phone',
  'Enrollment No',
  'Branch',
  'Year',
  'Problem Statement',
  'Team Members',
  'Transaction Ref',
  'Payment Screenshot',
];

class SihForm extends StatefulWidget {
  const SihForm({super.key});

  @override
  State<SihForm> createState() => _SihFormState();
}

class _SihFormState extends State<SihForm> {
  final _formKey = GlobalKey<FormState>();
  final Elegantnotif notif = const Elegantnotif();

  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController leaderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController membersController = TextEditingController();
  final TextEditingController transactionController = TextEditingController();

  String? paymentScreenshotUrl;
  bool submitting = false;

  @override
  void dispose() {
    teamNameController.dispose();
    leaderController.dispose();
    emailController.dispose();
    phoneController.dispose();
    enrollmentController.dispose();
    branchController.dispose();
    yearController.dispose();
    problemController.dispose();
    membersController.dispose();
    transactionController.dispose();
    super.dispose();
  }

  Future<void> _openPaymentLink(String label, String url) async {
    if (url.isEmpty) {
      notif.myElegantError(context, '$label is not configured yet.');
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        notif.myElegantError(context, 'Could not open $label.');
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (paymentScreenshotUrl == null) {
      notif.myElegantError(
        context,
        'Upload and save your payment screenshot first.',
      );
      return;
    }

    setState(() => submitting = true);
    notif.myElegantInfo(context, 'Submitting registration...', 6);

    try {
      final gsheets = GSheets(credentials);
      final spreadsheet = await gsheets.spreadsheet(spreadsheetId);
      final sheet = spreadsheet.worksheetByTitle(_sihWorksheetTitle) ??
          spreadsheet.sheets.first;

      final firstRow = await sheet.values.row(1);
      if (firstRow.isEmpty) {
        await sheet.values.appendRow(_sihHeaderRow);
      }

      await sheet.values.appendRow(<String>[
        DateTime.now().toIso8601String(),
        teamNameController.text.trim(),
        leaderController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
        enrollmentController.text.trim(),
        branchController.text.trim(),
        yearController.text.trim(),
        problemController.text.trim(),
        membersController.text.trim(),
        transactionController.text.trim(),
        paymentScreenshotUrl!,
      ]);

      if (!mounted) return;
      notif.myElegantSuccess(context, 'Registered successfully!');
      Navigator.pop(context);
    } on GSheetsException catch (e) {
      if (mounted) {
        notif.myElegantError(context, 'Sheets error: ${e.cause}');
      }
    } catch (e) {
      if (mounted) {
        notif.myElegantError(context, 'Could not submit: $e');
      }
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: navColor,
        foregroundColor: Colors.white,
        title: const Text('Smart India Hackathon'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'JUIT Internal Round',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All fields are required. Registration fee: '
                '$sihRegistrationFee per team.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 20),
              _field(
                controller: teamNameController,
                label: 'Team Name',
              ),
              _field(
                controller: leaderController,
                label: 'Team Leader Name',
              ),
              _field(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final email = value.trim();
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              _field(
                controller: phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final phone = (value ?? '').trim();
                  if (phone.isEmpty) return 'Phone number is required';
                  if (phone.replaceAll(RegExp(r'\D'), '').length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              _field(
                controller: enrollmentController,
                label: 'Enrollment Number',
              ),
              _field(
                controller: branchController,
                label: 'Branch',
              ),
              _field(
                controller: yearController,
                label: 'Year',
                keyboardType: TextInputType.number,
              ),
              _field(
                controller: problemController,
                label: 'Problem Statement',
                maxLines: 2,
              ),
              _field(
                controller: membersController,
                label: 'Team Members (name + enrollment, one per line)',
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              _paymentSection(),
              const SizedBox(height: 8),
              _field(
                controller: transactionController,
                label: 'Transaction / UPI Reference',
              ),
              PaymentUploadCard(
                onUploadComplete: (url) {
                  setState(() => paymentScreenshotUrl = url);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dateColor,
                    disabledBackgroundColor: imageColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Registration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentSection() {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: itemColor),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay $sihRegistrationFee',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sihPaymentLinks.entries.map((entry) {
                final configured = entry.value.isNotEmpty;
                return OutlinedButton(
                  onPressed: () => _openPaymentLink(entry.key, entry.value),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: configured ? itemColor : Colors.grey,
                    ),
                  ),
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      color: configured ? Colors.white : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          filled: true,
          fillColor: searchColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: itemColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: itemColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: validator ??
            (value) => (value == null || value.trim().isEmpty)
                ? '$label is required'
                : null,
      ),
    );
  }
}
