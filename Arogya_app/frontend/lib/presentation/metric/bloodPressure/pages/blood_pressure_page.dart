import "package:flutter/material.dart";

class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({super.key});

  @override
  State<BloodPressurePage> createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  Widget _bpGuide(
  String title,
  String range,
  Color color,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 4,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(range),
          ],
        ),
      ),
    ],
  );
}

Widget _bpHistory(
  String value,
  String time,
  String status,
  Color color,
  IconData icon,
) {
  return Row(
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      )
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blood Pressure"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        /// Current Reading
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURRENT READING',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
      
              const SizedBox(height: 12),
      
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '138/92',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'STAGE 1',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
      
              const SizedBox(height: 6),
      
              const Text(
                'Measured today at 08:45 AM',
                style: TextStyle(color: Colors.grey),
              ),
      
              const SizedBox(height: 20),
      
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Systolic',
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text(
                          '138',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [
                          Text('Diastolic',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text(
                            '92',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Hero Image
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Take control of your blood pressure',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Monthly Trends
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Monthly Trends',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '30 DAYS',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 20),
      
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Blood Pressure Trend Graph'),
              ),
      
              const SizedBox(height: 16),
      
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Systolic'),
                  const SizedBox(width: 20),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Diastolic'),
                ],
              ),
      
              const SizedBox(height: 16),
      
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your systolic pressure has improved by 6 mmHg over the last month, which is a meaningful positive trend.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Pressure Guide
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Blood Pressure Guide',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              const SizedBox(height: 20),
      
              _bpGuide('NORMAL', '<120 / <80 mmHg',
                  Colors.green),
      
              const SizedBox(height: 12),
      
              _bpGuide('ELEVATED', '120–129 / <80 mmHg',
                  Colors.orange),
      
              const SizedBox(height: 12),
      
              _bpGuide('HYPERTENSION STAGE 1',
                  '130–139 / 80–89 mmHg', Colors.red),
      
              const SizedBox(height: 12),
      
              _bpGuide('HYPERTENSION STAGE 2',
                  '≥140 / ≥90 mmHg', Colors.red.shade700),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Recent History
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Recent History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 16),
      
              _bpHistory(
                '138/92 mmHg',
                'Today • 08:45 AM',
                'STAGE 1',
                Colors.red,
                Icons.trending_up,
              ),
      
              const Divider(),
      
              _bpHistory(
                '122/81 mmHg',
                'Oct 27 • 07:23 PM',
                'ELEVATED',
                Colors.orange,
                Icons.access_time,
              ),
      
              const Divider(),
      
              _bpHistory(
                '141/95 mmHg',
                'Apr 11 • 09:15 AM',
                'STAGE 2',
                Colors.red.shade700,
                Icons.trending_up,
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 100),
      ],
        ),
      ),
    );


  }
}