import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(FormInitial()) {
    on<FetchFormData>(_onFetchFormData);
    on<UpdateSelectedValue>(_onUpdateSelectedValue);
  }

  Future<void> _onFetchFormData(
      FetchFormData event, Emitter<FormState> emit) async {
    emit(FormLoading());

    var url = Uri.parse('http://192.168.231.31:5500/lib/data.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      Map<String, String> initialSelectedValues = {};
      for (var field in responseBody!['fields']) {
        initialSelectedValues[field['id']] = "";
      }
      emit(FormLoaded(responseBody, initialSelectedValues));
    } else {
      emit(FormInitial());
    }
  }

  void _onUpdateSelectedValue(
      UpdateSelectedValue event, Emitter<FormState> emit) {
    if (state is FormLoaded) {
      final loadedState = state as FormLoaded;
      Map<String, String> updatedValues = Map.from(loadedState.selectedValues);
      updatedValues[event.id] = event.value;
      emit(FormLoaded(loadedState.formData, updatedValues));
    }
  }
}
