import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/patient_dashboard_sidebar.dart';
import '../../../common/patient_dashboard_topbar.dart';
import '../../../common/snack_bar_helper.dart';
import '../bloc/qr_bloc.dart';
import '../widgets/backup_method/backup_method_card.dart';
import '../widgets/camera_preview_panel.dart';
import '../widgets/encryption_footer.dart';
import '../widgets/pro_tips/pro_tips_card.dart';
import '../widgets/qr_sync_page_header.dart';

class PatientQrSyncPage extends StatelessWidget {
  const PatientQrSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QrBloc>(),
      child: const _PatientQrSyncView(),
    );
  }
}

class _PatientQrSyncView extends StatefulWidget {
  const _PatientQrSyncView();

  @override
  State<_PatientQrSyncView> createState() => _PatientQrSyncViewState();
}

class _PatientQrSyncViewState extends State<_PatientQrSyncView> {
  final TextEditingController _patientIdController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  void _handleSearchPatient(BuildContext context) {
    context.read<QrBloc>().add(QrPatientLookupRequested(_patientIdController.text));
  }

  /// Hook for a real QR scanner plugin (e.g. mobile_scanner) once it's
  /// added to pubspec.yaml — wire its onDetect callback to this.
  void _handleQrDetected(BuildContext context, String rawValue) {
    context.read<QrBloc>().add(QrPatientLookupRequested(rawValue));
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
                  child: BlocConsumer<QrBloc, QrState>(
                    listenWhen: (previous, current) =>
                        previous.lookupToken != current.lookupToken,
                    listener: (context, state) {
                      if (state.lookupStatus == QrLookupStatus.success &&
                          state.foundPatient != null) {
                        SnackbarHelper.showSuccess(
                          context,
                          'Linked to ${state.foundPatient!.name}\'s record.',
                        );
                        Navigator.pushNamed(
                          context,
                          AppRoutes.patientDetail,
                          arguments: state.foundPatient!.id,
                        );
                      } else if (state.lookupStatus == QrLookupStatus.failure) {
                        SnackbarHelper.showError(
                          context,
                          state.errorMessage ?? 'Could not find that patient.',
                        );
                      }
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
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
                                  isCameraActive: true,
                                  isFlashOn: state.isFlashOn,
                                  onToggleFlash: () =>
                                      context.read<QrBloc>().add(const QrFlashToggled()),
                                  onSwitchCamera: () =>
                                      context.read<QrBloc>().add(const QrCameraSwitched()),
                                );

                                final rightRail = Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    BackupMethodCard(
                                      controller: _patientIdController,
                                      isSearching: state.lookupStatus == QrLookupStatus.loading,
                                      onSearch: () => _handleSearchPatient(context),
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
                      );
                    },
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
