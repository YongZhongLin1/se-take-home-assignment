

import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {}

class InitialCounterState extends CounterState {
  @override
  List<Object> get props => [];
}

class LoadingCounterState extends CounterState {
  @override
  List<Object> get props => [];
}

class LoadingDoneCounterState extends CounterState {
  @override
  List<Object> get props => [];
}