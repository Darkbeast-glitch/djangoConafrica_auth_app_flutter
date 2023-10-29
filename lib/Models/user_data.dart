import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String ticketName;
  final String country;
  final List<String> tickets;

  UserData(this.name, this.ticketName, this.country, this.tickets);

  factory UserData.fromJson(Map<String, dynamic> json) {
    final List<String> tickets =
        json['data']['tickets'].map((ticket) => ticket['ticket_name']).toList();

    return UserData(
      json['data']['profile']['fullname'],
      tickets[0], // Assume that the user only has one ticket.
      json['data']['profile']['country'],
      tickets,
    );
  }
}
