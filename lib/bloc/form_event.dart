part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
}

class FetchFormData extends FormEvent {
  const FetchFormData();

  @override
  List<Object> get props => [];
}

class UpdateSelectedValue extends FormEvent {
  final String id;
  final String value;

  const UpdateSelectedValue(this.id, this.value);

  @override
  List<Object> get props => [id, value];
}
