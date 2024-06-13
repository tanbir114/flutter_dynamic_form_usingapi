import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Map<String, dynamic>? formData;
  Map<String, String> selectedValues = {};

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  fetchFormData() async {
    // Simulate network request by loading JSON from the provided data
    var url = Uri.parse('http://127.0.0.1:5500/lib/data.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body);
      return responsebody;
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      formData = response;
      // for (var field in formData!['fields']) {
      //   selectedValues[field['id']] = null;
      // }
    });
  }

  Widget buildCustomRadioButton(
      String value, String groupValue, Function(String) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: value == groupValue
              ? Color.fromRGBO(194, 234, 247, .3)
              : Colors.transparent,
          border: Border.all(
            color: value == groupValue ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            if (value == groupValue)
              Container(
                width: 18.0,
                height: 18.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioButtonGroup(
      List<String> options, String groupValue, Function(String) onChanged) {
    return Wrap(
      spacing: 10.0,
      children: options.map((option) {
        return SizedBox(
          width: (options.length == 2
              ? MediaQuery.sizeOf(context).width
              : (MediaQuery.sizeOf(context).width - 42) / 2),
          child: buildCustomRadioButton(option, groupValue, onChanged),
        );
      }).toList(),
    );
  }

  Widget buildFormField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field['name']),
            buildRadioButtonGroup(
              field['options'].map<String>((opt) => opt['text']).toList(),
              selectedValues[field['id']] ?? '',
              (val) {
                setState(() {
                  selectedValues[field['id']] = val;
                });
              },
            ),
            SizedBox(height: 16.0),
          ],
        );
      case 'dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field['name']),
            DropdownButtonFormField<String>(
              value: selectedValues[field['id']],
              hint: Text('Select ${field['name']}'),
              items: field['options'].map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['text'],
                  child: Text(option['text']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedValues[field['id']] = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Bank'),
      ),
      body: formData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: formData!['fields']
                            .map<Widget>((field) => buildFormField(field))
                            .toList(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add functionality to see questions
                          },
                          child: Text('See questions'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add functionality to take quiz
                          },
                          child: Text('Take quiz'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
