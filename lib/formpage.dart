import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/form_bloc.dart' as formBloc; // Alias the import

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          formBloc.FormBloc()..add(const formBloc.FetchFormData()),
      child: FormView(),
    );
  }
}

class FormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('MCQ Bank'),
      ),
      body: BlocBuilder<formBloc.FormBloc, formBloc.FormState>(
        builder: (context, state) {
          if (state is formBloc.FormLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is formBloc.FormLoaded) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.formData['fields'].length,
                              itemBuilder: (context, index) {
                                var field = state.formData['fields'][index];
                                return _row(
                                  index,
                                  field['name'],
                                  field["type"],
                                  field["id"],
                                  field["options"],
                                  state.selectedValues,
                                  context,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('See questions'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Take quiz'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _row(
      int index,
      String name,
      String fieldType,
      String id,
      List<dynamic> fieldData,
      Map<String, String> selectedValues,
      BuildContext context) {
    if (fieldType == "dropdown") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          DropdownButtonFormField<String>(
            value: selectedValues[id]!.isNotEmpty ? selectedValues[id] : null,
            hint: Text('Select $name'),
            items: fieldData.map<DropdownMenuItem<String>>((option) {
              return DropdownMenuItem<String>(
                value: option['text'],
                child: Text(option['text']),
              );
            }).toList(),
            onChanged: (value) {
              BlocProvider.of<formBloc.FormBloc>(context)
                  .add(formBloc.UpdateSelectedValue(id, value!));
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      );
    } else if (fieldType == "radio") {
      var radioData =
          List<String>.from(fieldData.map((option) => option["text"]));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Wrap(
            spacing: 10.0,
            children: radioData.map((option) {
              return SizedBox(
                width: (radioData.length == 2
                    ? MediaQuery.of(context).size.width
                    : (MediaQuery.of(context).size.width - 26) / 2),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<formBloc.FormBloc>(context)
                        .add(formBloc.UpdateSelectedValue(id, option));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 14.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: option == selectedValues[id]
                          ? Color.fromRGBO(194, 234, 247, .3)
                          : Colors.transparent,
                      border: Border.all(
                        color: option == selectedValues[id]
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option),
                        if (option == selectedValues[id])
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
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: TextFormField(
          keyboardType: fieldType == "number" && id == "amount"
              ? TextInputType.numberWithOptions(decimal: true)
              : fieldType == "text"
                  ? TextInputType.text
                  : TextInputType.phone,
          inputFormatters: [
            fieldType == "number" && id == "amount"
                ? FilteringTextInputFormatter.allow(RegExp("[. 0-9]"))
                : fieldType == "text"
                    ? FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                    : FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: name,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
            labelStyle: TextStyle(),
          ),
          onChanged: (val) {
            BlocProvider.of<formBloc.FormBloc>(context)
                .add(formBloc.UpdateSelectedValue(id, val));
          },
        ),
      );
    }
  }
}
