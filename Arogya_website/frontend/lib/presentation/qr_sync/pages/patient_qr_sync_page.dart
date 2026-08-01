import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/app_sidebar.dart';
import '../../../common/app_top_bar.dart';
import '../widgets/backup_method/backup_method_card.dart';
import '../widgets/camera_preview_panel.dart';
import '../widgets/encryption_footer.dart';
import '../widgets/pro_tips/pro_tips_card.dart';
import '../widgets/qr_sync_page_header.dart';

class PatientQrSyncPage extends StatefulWidget {
  const PatientQrSyncPage({super.key});

  @override
  State<PatientQrSyncPage> createState() => _PatientQrSyncPageState();
}

class _PatientQrSyncPageState extends State<PatientQrSyncPage> {
  final TextEditingController _patientIdController = TextEditingController();
  bool _isFlashOn = false;
  bool _isCameraActive = true;

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  void _handleToggleFlash() {
    setState(() => _isFlashOn = !_isFlashOn);
    // TODO: call actual camera-controller flash toggle here.
  }

  void _handleSwitchCamera() {
    // TODO: call actual camera-controller lens switch here.
  }

  void _handleSearchPatient() {
    // TODO: validate _patientIdController.text and dispatch a lookup,
    // e.g. context.read<PatientLookupBloc>().add(SearchPatientById(id));
  }

  void _handleQrDetected(String rawValue) {
    // TODO: parse rawValue, resolve the patient, then navigate:
    // Navigator.pushNamed(context, AppRoutes.patientDetail, arguments: patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(currentRoute: AppRoutes.scanPatientQr),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const QrSyncPageHeader(),
                        const SizedBox(height: 28),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 900;

                            final cameraPanel = CameraPreviewPanel(
                              isCameraActive: _isCameraActive,
                              isFlashOn: _isFlashOn,
                              onToggleFlash: _handleToggleFlash,
                              onSwitchCamera: _handleSwitchCamera,
                            );

                            final rightRail = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                BackupMethodCard(
                                  controller: _patientIdController,
                                  onSearch: _handleSearchPatient,
                                ),
                                const SizedBox(height: 20),
                                const ProTipsCard(),
                                const SizedBox(height: 20),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: EncryptionFooter(),
                                ),
                              ],
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: cameraPanel),
                                  const SizedBox(width: 24),
                                  SizedBox(width: 340, child: rightRail),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                cameraPanel,
                                const SizedBox(height: 24),
                                rightRail,
                              ],
                            );
                          },
                        ),
                      ],
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
