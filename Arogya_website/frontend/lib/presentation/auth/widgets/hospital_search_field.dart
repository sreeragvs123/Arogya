import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/hospital_search/hospital_search_bloc.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';

class HospitalSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<Hospital> onHospitalSelected;

  const HospitalSearchField({
    super.key,
    required this.controller,
    required this.onHospitalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          onChanged: (value) =>
              context.read<HospitalSearchBloc>().add(HospitalQueryChanged(value)),
          decoration: InputDecoration(
            hintText: 'Choose your medical institution...',
            prefixIcon: const Icon(Icons.business, size: 19, color: Color(0xFF475569)),
            suffixIcon: BlocSelector<HospitalSearchBloc, HospitalSearchState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) => isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),
        BlocBuilder<HospitalSearchBloc, HospitalSearchState>(
          builder: (context, state) {
            if (!state.showResults || state.results.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(7),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final hospital = state.results[index];
                  return ListTile(
                    dense: true,
                    title: Text(hospital.name),
                    onTap: () {
                      onHospitalSelected(hospital);
                      context.read<HospitalSearchBloc>().add(HospitalQueryChanged(''));
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}