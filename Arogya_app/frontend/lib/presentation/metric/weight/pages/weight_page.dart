import "package:flutter/material.dart";

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weight"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Current Weight
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
                "CURRENT WEIGHT",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "74.5 kg",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_downward,
                        color: Colors.green, size: 15),
                    SizedBox(width: 4),
                    Text(
                      "1.2 kg",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("since last month"),
                  ],
                ),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// BMI
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
                "BODY MASS INDEX",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "23.4",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                          Colors.orange,
                          Colors.red,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("18.5"),
                  Text("25.0"),
                  Text("30.0"),
                ],
              )
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Weight History
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
                    "Weight History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("Last 6 Months"),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your progress over the last\n6 months",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
      
              /// Replace with fl_chart later
              Container(
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("Weight Graph"),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Understanding
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
                "Understanding Your Weight",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              const SizedBox(height: 20),
      
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(
                      Icons.lightbulb,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The Morning Effect",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Weight fluctuates naturally throughout the day. "
                          "For the most accurate tracking, weigh yourself "
                          "at the same time every morning.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 20),
      
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(
                      Icons.local_florist,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Beyond the Scale",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Muscle is denser than fat. "
                          "If you stay active, your body "
                          "composition can improve even if "
                          "the scale barely changes.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 20),
      
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1490645935967-10de6ba17061",
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Read: 5 Myths About Calorie Counting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 16),
      
        /// Recent Entries
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
                    "Recent Entries",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
      
              const SizedBox(height: 20),
      
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text("JUN\n24"),
                title: Text("74.5 kg"),
                subtitle: Text("Logged at 07:45 AM"),
                trailing: Text(
                  "-0.2 kg",
                  style: TextStyle(color: Colors.green),
                ),
              ),
      
              const Divider(),
      
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text("JUN\n21"),
                title: Text("74.7 kg"),
                subtitle: Text("Logged at 08:12 AM"),
                trailing: Text("+0.1 kg"),
              ),
      
              const Divider(),
      
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text("JUN\n18"),
                title: Text("74.6 kg"),
                subtitle: Text("Logged at 07:30 AM"),
                trailing: Text("+0.1 kg"),
              ),
            ],
          ),
        ),
      
        const SizedBox(height: 80),
      ],
        ),
      ),
    );
  }
}