import "package:flutter/material.dart";
import "package:frontend/presentation/meds/pages/meds_detail_page.dart";

class MedicationCard extends StatelessWidget {
  final String Medicine = "Atorvastatin";
  final String dosage = "20 mg";
  final String frequency = "Daily Dose";
  final String time = "12:30PM";
  const MedicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MedsDetailsPage())),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: const Color.fromARGB(255, 39, 80, 17),
              width: 5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 23, 18, 23),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NEXT MEDICATION",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 128, 127, 127),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "$Medicine",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "$dosage | $frequency",
                        style: TextStyle(fontSize: 18,color: const Color.fromARGB(255, 80, 80, 80)),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 188, 236, 179),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: const Color.fromARGB(255, 19, 142, 23),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 19, 142, 23),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 79, 157, 37),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          size: 26,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mark as Taken',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
