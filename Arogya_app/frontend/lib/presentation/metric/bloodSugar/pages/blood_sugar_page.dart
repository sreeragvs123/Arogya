import 'package:flutter/material.dart';

class BloodSugarPage extends StatefulWidget {
  const BloodSugarPage({super.key});

  @override
  State<BloodSugarPage> createState() => _BloodSugarPageState();
}

class _BloodSugarPageState extends State<BloodSugarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blood Sugar"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 8),
      
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '98',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'mg/dL',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'NORMAL',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
      
              const SizedBox(height: 4),
              const Text(
                'Measured today at 08:30 AM',
                style: TextStyle(color: Colors.grey),
              ),
      
              const SizedBox(height: 16),
      
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '30 DAY AVG',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '102 mg/dL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LAST',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '138 mg/dL',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
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
      
        /// 30 Day Trend
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                    '30-Day Trend',
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
                      '30D',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('7D'),
                  const SizedBox(width: 10),
                  const Text('24H'),
                ],
              ),
      
              const SizedBox(height: 20),
      
              /// Replace with fl_chart
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Blood Sugar Trend Graph'),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Healthy Range
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Healthy Range',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Target range',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                '70–140 mg/dL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'For most healthy adults, a normal blood sugar level when fasting is under 100 mg/dL. A reading between 100 and 125 mg/dL is typically considered prediabetes.',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Text(
                    'LEARN MORE',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.open_in_new,
                      size: 16, color: Colors.green),
                ],
              )
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Reading History
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                    'Reading History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.tune, size: 20),
                ],
              ),
      
              const SizedBox(height: 16),
      
              _sugarItem('98 mg/dL', 'Today • 08:30 AM',
                  'NORMAL', Colors.green),
      
              const Divider(),
      
              _sugarItem('115 mg/dL', 'Yesterday • 09:15 PM',
                  'NORMAL', Colors.green),
      
              const Divider(),
      
              _sugarItem('142 mg/dL', 'May 12 • 02:40 PM',
                  'HIGH', Colors.red),
      
              const Divider(),
      
              _sugarItem('104 mg/dL', 'May 11 • 06:45 AM',
                  'NORMAL', Colors.green),
      
              const Divider(),
      
              _sugarItem('92 mg/dL', 'May 10 • 08:15 AM',
                  'NORMAL', Colors.green),
      
              const SizedBox(height: 16),
      
              const Text(
                'VIEW FULL HISTORY',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      
        const SizedBox(height: 100),
      ],
        ),
      ),
    );


  }
  Widget _sugarItem(
  String value,
  String time,
  String status,
  Color color,
) {
  return Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.12),
        child: Icon(
          status == 'HIGH'
              ? Icons.warning_amber_rounded
              : Icons.water_drop,
          color: color,
          size: 18,
        ),
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
}