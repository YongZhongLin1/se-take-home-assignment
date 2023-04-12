// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: parameter_assignments, lines_longer_than_80_chars, unnecessary_statements

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcd/counter/counter.dart';
import 'package:mcd/counter/cubit/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(InitialCounterState());
  List<Bot> bots = <Bot>[];
  List<Order> orders = <Order>[];
  int orderId = 0;

  void createNormalOrder() {
    emit(LoadingCounterState());
    orderId++;
    orders.add(Order(orderId, OrderType.normal));
    emit(LoadingDoneCounterState());
  }

  void createVIPOrder() {
    emit(LoadingCounterState());
    orderId++;
    orders.insert(
      orders.where((element) => element.orderType == OrderType.vip).length,
      Order(orderId, OrderType.vip),
    );
    emit(LoadingDoneCounterState());
  }

  void incrementBot() {
    final newBot = Bot();
    newBot.timer = pickupTimer(newBot);
    emit(LoadingCounterState());
    bots.add(newBot);
    emit(LoadingDoneCounterState());
  }

  void decrementBot() {
    emit(LoadingCounterState());
    removeBot();
    emit(LoadingDoneCounterState());
  }

  Timer pickupTimer(Bot? bot) {
    return makePeriodicTimer(const Duration(seconds: 1), (timer) {
      if (orders.isNotEmpty) {
        var order = bot?.order;
        emit(LoadingCounterState());
        if (bot?.status.toLowerCase() == 'idle') {
          if (orders
              .where((element) => element.orderStatus == OrderStatus.pending)
              .isNotEmpty) {
            order = orders
                .where((element) => element.orderStatus == OrderStatus.pending)
                .first;
            bot?.order = order;
            orders
                .where((element) => element.id == order?.id)
                .first
                .orderStatus = OrderStatus.processing;
            Future.delayed(Duration(seconds: 10), () {
              if(bots.where((element) => element.order?.id == order?.id).isNotEmpty) {
                var tempOrder = bot?.order;
                if(tempOrder?.id != null) {
                  orders
                      .where((element) => element.id == tempOrder?.id)
                      .first
                      .orderStatus = OrderStatus.complete;
                  bot?.order = null;
                }
              }
            });
          }
        }
        // if (order != null) {
        //   orders
        //       .where((element) => element.id == order?.id)
        //       .first
        //       .orderStatus = OrderStatus.complete;
        //   order = null;
        // }
        // if (orders
        //     .where((element) => element.orderStatus == OrderStatus.pending)
        //     .isNotEmpty) {
        //   order = orders
        //       .where((element) => element.orderStatus == OrderStatus.pending)
        //       .first;
        //   bot?.order = order;
        //   orders
        //       .where((element) => element.id == order?.id)
        //       .first
        //       .orderStatus = OrderStatus.processing;
        // }
        emit(LoadingDoneCounterState());
      }
    }, fireNow: true);
  }

  Timer makePeriodicTimer(
    Duration duration,
    void Function(Timer timer) callback, {
    bool fireNow = false,
  }) {
    var timer = Timer.periodic(duration, callback);
    if (fireNow) {
      callback(timer);
    }
    return timer;
  }

  void removeBot() {
    if (bots.isNotEmpty) {
      if (bots.last.order?.id != null) {
        orders
            .where((element) => element.id == bots.last.order?.id)
            .first
            .orderStatus = OrderStatus.pending;
      }
      bots.last.timer?.cancel();
      bots.isNotEmpty ? bots.removeLast() : bots = [];
    }
  }
}
