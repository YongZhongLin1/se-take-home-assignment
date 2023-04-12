// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mcd/counter/counter.dart';
import 'package:mcd/counter/cubit/counter_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const CounterPage());
      expect(find.byType(CounterText), findsOneWidget);
    });
  });

  group('CounterView', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = MockCounterCubit();
    });

    testWidgets('renders current count', (tester) async {
      const state = 0;
      when(() => counterCubit.bots.length).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterCubit,
          child: CounterText(),
        ),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    testWidgets('calls increment when increment button is tapped',
        (tester) async {
      when(() => counterCubit.bots.length).thenReturn(0);
      when(() => counterCubit.incrementBot()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterCubit,
          child: CounterText(),
        ),
      );
      await tester.tap(find.byKey(Key('IncrementBotKey')));
      verify(() => counterCubit.incrementBot()).called(1);
    });

    testWidgets('calls decrement when decrement button is tapped',
        (tester) async {
      when(() => counterCubit.bots.length).thenReturn(0);
      when(() => counterCubit.decrementBot()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterCubit,
          child: CounterText(),
        ),
      );
      await tester.tap(find.byIcon(Icons.remove));
      verify(() => counterCubit.decrementBot()).called(1);
    });
  });
}
