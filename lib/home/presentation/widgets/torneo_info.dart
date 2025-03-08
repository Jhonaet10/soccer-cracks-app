import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/widgets/teams/team_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';

class TorneoInfoWidget extends ConsumerWidget {
  final Torneo torneo;
  final bool showAdminActions;
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const TorneoInfoWidget({
    super.key,
    required this.torneo,
    this.showAdminActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoNotifier = ref.read(torneoProvider.notifier);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header con gradiente
          Container(
            width: double.infinity,
            color: mainColor,
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Logo del torneo
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Nombre del torneo
                Text(
                  torneo.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Estado del torneo
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    torneo.estado ?? "Sin Empezar",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Información adicional
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(
                        icon: Icons.emoji_events,
                        label: 'Formato',
                        value: torneo.formato,
                      ),
                      _InfoItem(
                        icon: Icons.calendar_today,
                        label: 'Inicio',
                        value:
                            '${torneo.fechaInicio.day}/${torneo.fechaInicio.month}/${torneo.fechaInicio.year}',
                      ),
                      _InfoItem(
                        icon: Icons.groups,
                        label: 'Equipos',
                        value: '${torneo.equipos.length}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Sección de códigos de acceso (solo para organizador)
          if (showAdminActions)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Códigos de Acceso',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _AccessCodeItem(
                    role: 'Jugador',
                    code: torneo.codigoAccesoJugador,
                    icon: Icons.sports_soccer,
                  ),
                  const SizedBox(height: 10),
                  _AccessCodeItem(
                    role: 'Árbitro',
                    code: torneo.codigoAccesoArbitro,
                    icon: Icons.sports_score,
                  ),
                ],
              ),
            ),
          // Sección de equipos
          Container(
            color: Colors.grey[50],
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: Row(
                    children: [
                      const Text(
                        'Equipos Participantes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: torneo.equipos.length,
                  itemBuilder: (context, index) {
                    final equipo = torneo.equipos[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shield,
                            color: mainColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          equipo.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          '${equipo.jugadores.length} jugadores',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        trailing: TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => TeamDetailsModal(
                                equipo: equipo,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: mainColor,
                          ),
                          label: const Text(
                            'Ver',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (showAdminActions && torneo.estado == "Sin Empezar")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => torneoNotifier.iniciarCampeonato(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Iniciar Torneo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AccessCodeItem extends StatelessWidget {
  final String role;
  final String code;
  final IconData icon;
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const _AccessCodeItem({
    required this.role,
    required this.code,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código para $role',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (context.mounted) {
                showCustomSnackbar(
                  context,
                  message: 'Código copiado al portapapeles',
                );
              }
            },
            icon: const Icon(
              Icons.copy,
              color: mainColor,
              size: 20,
            ),
            tooltip: 'Copiar código',
          ),
        ],
      ),
    );
  }
}
