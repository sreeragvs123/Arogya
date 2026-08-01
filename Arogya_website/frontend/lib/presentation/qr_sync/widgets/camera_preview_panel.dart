import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// The main camera panel: live preview area with a scan-frame overlay,
/// a "CAMERA ACTIVE" pill, and the bottom instruction/action row.
///
/// The actual camera feed is intentionally left as a placeholder —
/// swap [previewBuilder] for a real `CameraPreview` widget once the
/// camera plugin + controller logic is wired up.
class CameraPreviewPanel extends StatelessWidget {
  final WidgetBuilder? previewBuilder;
  final bool isCameraActive;
  final bool isFlashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onSwitchCamera;

  const CameraPreviewPanel({
    super.key,
    this.previewBuilder,
    this.isCameraActive = true,
    this.isFlashOn = false,
    required this.onToggleFlash,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softPanel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Camera feed placeholder.
                  // TODO: replace with `CameraPreview(controller)` once the
                  // camera package + permission/lifecycle logic is added.
                  previewBuilder?.call(context) ??
                      Container(
                        color: const Color(0xFF9FB8B2),
                        alignment: Alignment.center,
                        child: const Icon(Icons.videocam_outlined,
                            size: 48, color: Colors.white70),
                      ),
                  const _ScanFrameOverlay(),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: _LiveBadge(isActive: isCameraActive),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _BottomInstructionRow(
            isFlashOn: isFlashOn,
            onToggleFlash: onToggleFlash,
            onSwitchCamera: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}

/// Rounded-corner bracket frame drawn over the live preview to guide
/// where the patient should position their QR code.
class _ScanFrameOverlay extends StatelessWidget {
  const _ScanFrameOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.55,
        heightFactor: 0.78,
        child: CustomPaint(
          painter: _ScanFramePainter(color: AppColors.accent),
        ),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final Color color;
  const _ScanFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(18),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _LiveBadge extends StatelessWidget {
  final bool isActive;
  const _LiveBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppColors.liveIndicator : AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'CAMERA ACTIVE' : 'CAMERA OFF',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInstructionRow extends StatelessWidget {
  final bool isFlashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onSwitchCamera;

  const _BottomInstructionRow({
    required this.isFlashOn,
    required this.onToggleFlash,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        final infoBlock = Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.softPanel,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Ready to scan', style: AppTextStyles.cardTitle, textScaler: TextScaler.linear(0.85)),
                  SizedBox(height: 2),
                  Text(
                    "Position the patient's app QR code within the frame to sync records.",
                    style: AppTextStyles.cardBody,
                  ),
                ],
              ),
            ),
          ],
        );

        final actionsBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OutlinedIconButton(
              icon: isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              label: 'Flash',
              onTap: onToggleFlash, // TODO: hook up camera flash toggle
            ),
            const SizedBox(width: 12),
            _OutlinedIconButton(
              icon: Icons.cameraswitch_outlined,
              label: 'Switch',
              onTap: onSwitchCamera, // TODO: hook up front/back camera switch
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoBlock,
              const SizedBox(height: 16),
              actionsBlock,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: infoBlock),
            const SizedBox(width: 16),
            actionsBlock,
          ],
        );
      },
    );
  }
}

class _OutlinedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlinedIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.textPrimary),
      label: Text(label,
          style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
