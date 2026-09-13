import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/snack_bar_helper.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import 'package:frontend/presentation/hospital_dashboard/pages/hospital_dashboard_page.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_footer_links.dart';
import '../widgets/auth_hero_panel.dart';
import '../widgets/auth_tab_toggle.dart';
import '../widgets/doctor_sign_in_form.dart';
import '../widgets/hospital_sign_in_form.dart';
import '../widgets/register_hospital_form.dart';

enum AuthTab { doctorSignIn, hospitalSignIn, registerHospital }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Doctor
  final _doctorHospitalController = TextEditingController();
  final _doctorIdController = TextEditingController();
  final _doctorPasswordController = TextEditingController();

  // Hospital
  final _hospitalIdentifierController = TextEditingController();
  final _hospitalPasswordController = TextEditingController();
  final _hospitalDepartmentController = TextEditingController();

  // Registration
  final _hospitalNameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _directorNameController = TextEditingController();
  final _officialEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _masterPasswordController = TextEditingController();
  final _confirmMasterPasswordController = TextEditingController();

  String? _selectedFacilityType;

  @override
  void dispose() {
    _doctorHospitalController.dispose();
    _doctorIdController.dispose();
    _doctorPasswordController.dispose();
    _hospitalIdentifierController.dispose();
    _hospitalPasswordController.dispose();
    _hospitalDepartmentController.dispose();
    _hospitalNameController.dispose();
    _licenseController.dispose();
    _directorNameController.dispose();
    _officialEmailController.dispose();
    _phoneController.dispose();
    _masterPasswordController.dispose();
    _confirmMasterPasswordController.dispose();

    super.dispose();
  }

  void _handleDoctorSignIn() {
    context.read<AuthBloc>().add(
      DoctorSiginInEvent(
        hospitalId: _doctorHospitalController.text.trim(),
        doctorId: _doctorIdController.text.trim(),
        password: _doctorPasswordController.text,
      ),
    );
  }

  void _handleHospitalSignIn() {
    context.read<AuthBloc>().add(
      HospitalSignInEvent(
        identifier: _hospitalIdentifierController.text.trim(),
        password: _hospitalPasswordController.text,
        department: _hospitalDepartmentController.text.trim(),
      ),
    );
  }

  void _handleHospitalRegistration() {
    if (_selectedFacilityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a facility type')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      HospitalRegistrationEvent(
        hospitalName: _hospitalNameController.text.trim(),
        facilityType: _selectedFacilityType!,
        license: _licenseController.text.trim(),
        directorName: _directorNameController.text.trim(),
        email: _officialEmailController.text.trim(),
        password: _masterPasswordController.text,
        phone: _phoneController.text.trim(),
      ),
    );
  }

  Widget _buildCurrentForm(AuthTab tab) {
    switch (tab) {
      case AuthTab.doctorSignIn:
        return DoctorSignInForm(
          hospitalController: _doctorHospitalController,
          doctorIdController: _doctorIdController,
          passwordController: _doctorPasswordController,
          onSubmit: _handleDoctorSignIn,
          onForgotPassword: () {
            // TODO
          },
        );

      case AuthTab.hospitalSignIn:
        return HospitalSignInForm(
          identifierController: _hospitalIdentifierController,
          passwordController: _hospitalPasswordController,
          departmentController: _hospitalDepartmentController,
          onSubmit: _handleHospitalSignIn,
          onForgotPassword: () {
            // TODO
          },
        );

      case AuthTab.registerHospital:
        return RegisterHospitalForm(
          hospitalNameController: _hospitalNameController,
          licenseController: _licenseController,
          directorController: _directorNameController,
          emailController: _officialEmailController,
          phoneController: _phoneController,
          passwordController: _masterPasswordController,
          confirmPasswordController: _confirmMasterPasswordController,
          onFacilityTypeChanged: (value) {
            // NEW
            setState(() {
              _selectedFacilityType = value;
            });
          },
          onSubmit: _handleHospitalRegistration,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          SnackbarHelper.showError(context, state.message);
        }
        if (state is AuthSuccessState) {
          SnackbarHelper.showSuccess(context, state.message);

          if (state.tab == AuthTab.hospitalSignIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HospitalDashboardPage(
                  hospitalId: state.session?.hospitalId ?? 1,
                  session: state.session,
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final selectedTab = state.tab;
        final isLoading = state is AuthLoadingState;
        final isRegistration = selectedTab == AuthTab.registerHospital;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 1160,
                  maxHeight: 805,
                ),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Expanded(flex: 5, child: AuthHeroPanel(type: selectedTab)),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 46,
                          vertical: 38,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthTabToggle(
                              selected: selectedTab,
                              onChanged: (tab) => context.read<AuthBloc>().add(
                                AuthTabChangedEvent(tab),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isLoading)
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: LinearProgressIndicator(),
                                      ),
                                    _buildCurrentForm(selectedTab),
                                    SizedBox(height: isRegistration ? 20 : 28),
                                    AuthFooterLinks(
                                      onPrivacyTap: () {},
                                      onTermsTap: () {},
                                      onSupportTap: () {},
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
