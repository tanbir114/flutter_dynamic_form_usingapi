part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();
}

class FormInitial extends FormState {
  @override
  List<Object> get props => [];
}

class FormLoading extends FormState {
  @override
  List<Object> get props => [];
}

class FormLoaded extends FormState {
  final Map<String, dynamic> formData;
  final Map<String, String> selectedValues;

  const FormLoaded(this.formData, this.selectedValues);

  @override
  List<Object> get props => [formData, selectedValues];
}
