import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import '../providers/signalements_providers.dart';
import '../../domain/entities/signalement.dart';
import '../widgets/incident_marker.dart';
import '../widgets/incident_details.dart';

/// Page affichant la carte des incidents
class CarteIncidentsPage extends ConsumerStatefulWidget {
  const CarteIncidentsPage({super.key});

  @override
  ConsumerState<CarteIncidentsPage> createState() => _CarteIncidentsPageState();
}

class _CarteIncidentsPageState extends ConsumerState<CarteIncidentsPage> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    // Charger les signalements au démarrage
    Future.microtask(() {
      ref.read(signalementsNotifierProvider.notifier).loadAllSignalements();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    _mapController.animatedZoomIn();
  }

  void _zoomOut() {
    _mapController.animatedZoomOut();
  }

  Future<void> _goToMyLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Utilisation du use case via Riverpod (Clean Architecture)
      final getCurrentLocation = ref.read(getCurrentLocationUseCaseProvider);
      final userLocation = await getCurrentLocation();

      _mapController.animateTo(
        dest: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: 15.0,
      );
    } on Exception catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } catch (e) {
      _showError('Erreur lors de la récupération de la position');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signalementsState = ref.watch(signalementsNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6ECEF),
      appBar: AppBar(
        title: const Text('Carte des incidents'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(signalementsNotifierProvider.notifier).loadAllSignalements();
            },
          ),
        ],
      ),
      body: signalementsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : signalementsState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        signalementsState.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(signalementsNotifierProvider.notifier).loadAllSignalements();
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _buildMap(signalementsState),
    );
  }

  Widget _buildMap(signalementsState) {
    final signalementsWithLocation = signalementsState.signalementsWithLocation;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController.mapController,
          options: const MapOptions(
            initialCenter: LatLng(47.218637, -1.554136),
            initialZoom: 11.0,
            minZoom: 5.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'fr.nomos_app',
            ),
            if (signalementsWithLocation.isNotEmpty)
              MarkerLayer(
                markers: signalementsWithLocation.map<Marker>((signalement) {
                  return Marker(
                    point: LatLng(signalement.latitude!, signalement.longitude!),
                    width: 40,
                    height: 40,
                    child: IncidentMarkerIcon(
                      statut: signalement.statut ?? 'en_attente',
                      onTap: () => _showSignalementDetails(signalement),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
        // Compteur de signalements
        if (signalementsWithLocation.isNotEmpty)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${signalementsWithLocation.length} incident${signalementsWithLocation.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Boutons de zoom (droite)
        Positioned(
          right: 16,
          bottom: 40,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'zoom_in',
                mini: true,
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'zoom_out',
                mini: true,
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        // Bouton de localisation (gauche)
        Positioned(
          left: 16,
          bottom: 50,
          child: FloatingActionButton(
            heroTag: 'my_location',
            onPressed: _isLoadingLocation ? null : _goToMyLocation,
            child: _isLoadingLocation
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  void _showSignalementDetails(Signalement signalement) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => IncidentDetailsSheet(signalement: signalement),
    );
  }
}

