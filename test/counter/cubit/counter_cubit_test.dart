// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mcd/counter/counter.dart';
import 'package:mcd/counter/cubit/counter_state.dart';

void main() {
  group('CounterCubit', () {
    test('initial state is 0', () {
      expect(CounterCubit().bots.length, equals(0));
    });

    test('increase 1 bot when incrementBot is called', () {
      final cubit = CounterCubit();
      cubit.incrementBot();
      expect(cubit.bots.length, 1);
    });

    test('decrease 1 bot when decrementBot is called', () {
      final cubit = CounterCubit();
      cubit.decrementBot();
      expect(cubit.bots.length, 0);
    });

    test('number of bot cannot be negative', () {
      final cubit = CounterCubit();
      cubit.decrementBot();
      expect(cubit.bots.length, 0);
      cubit.decrementBot();
      expect(cubit.bots.length, 0);
    });

    test('create 1 normal order', () {
      final cubit = CounterCubit();
      cubit.createNormalOrder();
      expect(
          cubit.orders
              .where((element) => element.orderType == OrderType.normal)
              .length,
          1);
    });

    test('create 1 VIP order', () {
      final cubit = CounterCubit();
      cubit.createVIPOrder();
      expect(
          cubit.orders
              .where((element) => element.orderType == OrderType.vip)
              .length,
          1);
    });

    test(
        'when VIP order is created, it shall be placed in front of all normal order',
        () {
      final cubit = CounterCubit();
      cubit.createNormalOrder();
      cubit.createNormalOrder();
      cubit.createVIPOrder();
      expect(cubit.orders[0].orderType, OrderType.vip);
    });

    test(
        'when VIP order is created, it shall be placed in front of all normal order and behind of all VIP order',
        () {
      final cubit = CounterCubit();
      cubit.createNormalOrder();
      cubit.createNormalOrder();
      cubit.createVIPOrder();
      cubit.createVIPOrder();
      expect(cubit.orders[1].id, 4);
      expect(cubit.orders[1].orderType, OrderType.vip);
    });

    test('when bot is not processing order, the status should be idle', () {
      final cubit = CounterCubit();
      cubit.incrementBot();
      expect(cubit.bots[0].status.toLowerCase(), 'idle');
    });

    test('when bot is processing order, the status should be active', () {
      final cubit = CounterCubit();
      cubit.createNormalOrder();
      cubit.incrementBot();
      expect(cubit.bots[0].status.toLowerCase(), 'active');
    });
  });
}
