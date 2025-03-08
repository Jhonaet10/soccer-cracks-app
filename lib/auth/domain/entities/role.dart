import 'package:flutter/material.dart';

enum UserRole {
  player,
  referee,
  organizer;

  String get name {
    switch (this) {
      case UserRole.player:
        return 'Jugador';
      case UserRole.referee:
        return 'Árbitro';
      case UserRole.organizer:
        return 'Organizador';
    }
  }

  String get description {
    switch (this) {
      case UserRole.player:
        return 'Puede ver la tabla de posiciones y sus partidos programados';
      case UserRole.referee:
        return 'Puede ver la tabla de posiciones, partidos y editar resultados';
      case UserRole.organizer:
        return 'Puede crear torneos y gestionar toda la información';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.player:
        return Icons.sports_soccer;
      case UserRole.referee:
        return Icons.gavel;
      case UserRole.organizer:
        return Icons.event;
    }
  }

  List<String> get permissions {
    switch (this) {
      case UserRole.player:
        return [
          'view_standings',
          'view_matches',
          'view_profile',
          'view_team_info',
          'view_tournament_info',
        ];
      case UserRole.referee:
        return [
          'view_standings',
          'view_matches',
          'view_profile',
          'edit_match_results',
          'view_team_info',
          'view_tournament_info',
        ];
      case UserRole.organizer:
        return [
          'view_standings',
          'view_matches',
          'view_profile',
          'edit_match_results',
          'create_tournament',
          'manage_tournament',
          'manage_users',
          'view_team_info',
          'view_tournament_info',
        ];
    }
  }
}
