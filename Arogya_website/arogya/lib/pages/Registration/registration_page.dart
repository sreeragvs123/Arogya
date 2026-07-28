import 'package:flutter/material.dart';
import 'data.dart';

class HomeRegistration extends StatefulWidget {
  const HomeRegistration({super.key});

  @override
  State<HomeRegistration> createState() => _HomeRegistrationState();
}

class _HomeRegistrationState extends State<HomeRegistration> {
  //Info Controller
  final _hospitalNameController = TextEditingController();
  final _hopitalNumberController = TextEditingController();
  final _yearOfEstablishController = TextEditingController();

  //Location Controller
  final _primaryAddressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _secondaryAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Datas for DropDown Box
  final hospitalTypes = Data.hospitalType;
  final keralaDistricts = Data.keralaDistricts;
  final districtTaluk = Data.keralaDistrictsTaluk;

  late List<Widget> homeSpace;
  int homeSpaceIdx = 0;
  String? _selectedHopitalType;
  String? _selectedDistrict;
  String? _selectedTaluk;
  List<String>? selectedTalukList;

  @override
  void initState() {
    homeSpace = [contactInfo(), locationInfo()];
    super.initState();
  }

  @override
  void dispose() {
    _hopitalNumberController.dispose();
    _hospitalNameController.dispose();
    _phoneNumberController.dispose();
    _pincodeController.dispose();
    _primaryAddressController.dispose();
    _secondaryAddressController.dispose();
    _yearOfEstablishController.dispose();
    super.dispose();
  }

  Widget buildProgressBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildIcon(
          icon: Icons.healing_outlined,
          title: "Basic Info",
          widgetIdx: 0,
        ),
        buildBar(widgetIdx: 0),
        buildIcon(
          icon: Icons.healing_outlined,
          title: "Adress Information",
          widgetIdx: 1,
        ),
        buildBar(widgetIdx: 1),
        buildIcon(
          icon: Icons.healing_outlined,
          title: "Contact Information",
          widgetIdx: 2,
        ),
      ],
    );
  }

  Widget buildBar({required int widgetIdx}) {
    Color currColor = homeSpaceIdx > widgetIdx
        ? const Color.fromARGB(255, 116, 255, 120)
        : Colors.grey;
    return AnimatedContainer(
      height: 5,
      width: 300,
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        color: currColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget buildIcon({
    required IconData icon,
    required String title,
    required int widgetIdx,
  }) {
    Color currColor = homeSpaceIdx > widgetIdx
        ? const Color.fromARGB(255, 116, 255, 120)
        : (homeSpaceIdx == widgetIdx ? Colors.blue : Colors.grey);
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          AnimatedContainer(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: currColor,
            ),
            duration: Duration(milliseconds: 500),
            child: Icon(icon),
          ),
          SizedBox(height: 5),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: Text(title, style: TextStyle(color: currColor)),
          ),
        ],
      ),
    );
  }


  Column _buildHeadText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 15),
          child: Text(
            " AROGYA",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: const Color.fromARGB(255, 113, 113, 113),
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 10),
          child: Text(
            " Hospital Registration",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Text(
            " Complete all steps to register your Hospital",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget contactInfo() {
    return Column(
      children: [
        _buildTextInput(
          controller: _hospitalNameController,
          title: "Hospital Name",
          isObsure: false,
          icon: Icons.business_rounded,
        ),
        _buildDropdownBox(
          icon: Icons.local_hospital_rounded,
          hint: "Hospital Type",
          list: hospitalTypes,
          initialValue: _selectedHopitalType,
          onChanged: (value) {
            setState(() {
              _selectedHopitalType = value;
            });
          },
        ),
        _buildTextInput(
          controller: _hopitalNumberController,
          title: "Registration Number",
          isObsure: false,
          icon: Icons.category_rounded,
        ),
        _buildTextInput(
          controller: _yearOfEstablishController,
          title: "Established Year",
          icon: Icons.calendar_month_outlined,
          isObsure: false,
          type: TextInputType.datetime,
        ),
      ],
    );
  }

  Widget locationInfo() {
    return Column(
      children: [
        _buildTextInput(
          controller: _primaryAddressController,
          title: "Primary Address",
          isObsure: false,
          icon: Icons.location_city_rounded,
        ),
        _buildTextInput(
          controller: _secondaryAddressController,
          title: "Secondary Address (Optional)",
          isObsure: false,
          icon: Icons.location_city_rounded,
        ),
        Row(
          children: [
            Expanded(
              child: _buildDropdownBox(
                icon: Icons.landscape,
                hint: "Select District",
                list: keralaDistricts,
                initialValue: _selectedDistrict,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value;
                    selectedTalukList =
                        Data.keralaDistrictsTaluk[_selectedDistrict];
                    _selectedTaluk = selectedTalukList?[0];
                  });
                },
              ),
            ),
            Expanded(
              child: _buildDropdownBox(
                icon: Icons.landscape_rounded,
                hint: "Select Taluk",
                list: selectedTalukList,
                initialValue: _selectedTaluk,
                onChanged: (value) {
                  _selectedTaluk = value;
                },
              ),
            ),
          ],
        ),
        _buildTextInput(
          controller: _pincodeController,
          title: "Pincode",
          isObsure: false,
          icon: Icons.numbers_rounded,
        ),
      ],
    );
  }

  Widget _buildDropdownBox({
    required IconData icon,
    required String? hint,
    List<String>? list,
    required Function(String?)? onChanged,
    required String? initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        initialValue: initialValue,
        decoration: InputDecoration(prefixIcon: Icon(icon), hintText: hint),
        items: list?.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String title,
    required bool isObsure,
    required IconData icon,
    TextInputType? type,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isObsure,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(255, 123, 123, 123)),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildButton({required String title, required VoidCallback onClick}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A6EBD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }



   @override
  Widget build(BuildContext context) {
    homeSpace = [contactInfo(), locationInfo()];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 66, 201, 71),
                    const Color.fromARGB(255, 111, 255, 116),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: _buildHeadText(),
            ),
          ),
          Expanded(flex: 2, child: buildProgressBoard()),
          Expanded(
            flex: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [homeSpace[homeSpaceIdx]]),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (homeSpaceIdx > 0)
                  Expanded(
                    flex: 1,
                    child: _buildButton(
                      title: "Back",
                      onClick: () {
                        setState(() {
                          homeSpaceIdx--;
                        });
                      },
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: _buildButton(
                    title: "Continue",
                    onClick: () {
                      setState(() {
                        homeSpaceIdx++;
                      });
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
