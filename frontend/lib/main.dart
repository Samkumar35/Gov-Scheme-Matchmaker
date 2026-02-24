import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Required for links
import 'scheme_model.dart';

void main() => runApp(const MaterialApp(home: SchemeMatchmaker(), debugShowCheckedModeBanner: false));

class SchemeMatchmaker extends StatefulWidget {
  const SchemeMatchmaker({super.key});
  @override
  _SchemeMatchmakerState createState() => _SchemeMatchmakerState();
}

class _SchemeMatchmakerState extends State<SchemeMatchmaker> {
  final String ipAddress = "172.28.158.132";
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  String? _gender, _category, _occupation, _state;
  List<Scheme> _results = [];
  bool _isLoading = false;
  bool _showSummary = false;

  // 1. ALL INDIAN STATES LIST
  final List<String> _statesList = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa",
    "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala",
    "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland",
    "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
    "Uttar Pradesh", "Uttarakhand", "West Bengal", "Andaman and Nicobar", "Chandigarh",
    "Dadra and Nagar Haveli", "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
  ];

  final List<String> _occupationList = ["Student", "Farmer", "Entrepreneur", "Working", "Unemployed"];
  final List<String> _categoryList = ["General", "OBC", "SC", "ST", "EWS"];

  Future<void> findSchemes() async {
    if (_ageController.text.isEmpty || _incomeController.text.isEmpty || _gender == null || _state == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all details")));
      return;
    }
    setState(() { _isLoading = true; _showSummary = false; });
    final url = Uri.parse('http://$ipAddress:8080/api/schemes/check');

    try {
      final response = await http.post(
        url, headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "age": int.parse(_ageController.text),
          "gender": _gender, "category": _category,
          "profession": _occupation, "monthlyIncome": int.parse(_incomeController.text),
          "state": _state,
        }),
      );
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        setState(() {
          _results = jsonResponse.map((s) => Scheme.fromJson(s)).toList();
          _isLoading = false;
          _showSummary = true;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("NATIONAL SCHEME PORTAL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo[900], centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputForm(),
            if (_showSummary) _buildProfileSummary(),
            if (_showSummary) _buildResultsList(),
          ],
        ),
      ),
    );
  }

  // 2. SMALLER COMPACT FORM BOX
  Widget _buildInputForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // Makes the whole box smaller
        child: Card(
          elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text("Citizen Eligibility Form", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 25),
                Row(children: [
                  Expanded(child: _buildTextField(_ageController, "Age", Icons.cake)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField(_incomeController, "Income (₹)", Icons.account_balance_wallet)),
                ]),
                const SizedBox(height: 15),
                _buildDropdown("Select State", _state, _statesList, (v) => setState(() => _state = v)),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(child: _buildDropdown("Gender", _gender, ["Male", "Female", "Other"], (v) => setState(() => _gender = v))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildDropdown("Category", _category, _categoryList, (v) => setState(() => _category = v))),
                ]),
                const SizedBox(height: 15),
                _buildDropdown("Occupation", _occupation, _occupationList, (v) => setState(() => _occupation = v)),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: findSchemes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("FIND SCHEMES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. FIXED PROFILE SUMMARY (NO YELLOW OVERFLOW)
  Widget _buildProfileSummary() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.indigo.shade100)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Icon(Icons.assignment, color: Colors.indigo), SizedBox(width: 8), Text("Your Profile Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
            const Divider(height: 30),
            Wrap( // FIX: Wrap prevents the yellow overflow mark
              spacing: 30, runSpacing: 15,
              children: [
                _summaryItem(Icons.person, "Age: ${_ageController.text}"),
                _summaryItem(Icons.work, "Occupation: $_occupation"),
                _summaryItem(Icons.wc, "Gender: $_gender"),
                _summaryItem(Icons.payments, "Income: ₹${_incomeController.text}"),
                _summaryItem(Icons.location_on, "State: $_state"),
                _summaryItem(Icons.label, "Category: $_category"),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 22),
                const SizedBox(width: 10),
                Text("Success! Found ${_results.length} matching scheme(s).", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Available Schemes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final s = _results[index];
              List<String> steps = s.applySteps.split(RegExp(r'\d+\.'));
              steps.removeWhere((item) => item.trim().isEmpty);

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ExpansionTile(
                  leading: const Icon(Icons.account_balance, color: Colors.indigo),
                  title: Text(s.schemeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _detailRow(Icons.card_giftcard, "Benefit: ${s.benefit}"),
                        const SizedBox(height: 15),
                        const Text("How to Apply:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                        ...steps.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("${entry.key + 1}. ${entry.value.trim()}", style: const TextStyle(height: 1.4)),
                        )).toList(),
                        const SizedBox(height: 20),
                        Center(child: TextButton.icon(
                          onPressed: () async {
                            final Uri url = Uri.parse(s.officialWebsite);
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Cannot open link")));
                            }
                          },
                          icon: const Icon(Icons.launch, size: 18),
                          label: const Text("Visit Official Website", style: TextStyle(decoration: TextDecoration.underline)),
                        )),
                      ]),
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 50),
        ]),
      ),
    );
  }

  Widget _summaryItem(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: Colors.indigo.shade300), const SizedBox(width: 8), Text(text, style: const TextStyle(fontSize: 15))]);
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 18, color: Colors.orange), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)))]);
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller, keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, size: 20, color: Colors.indigo),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value, hint: Text(label),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged, isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
    );
  }
}