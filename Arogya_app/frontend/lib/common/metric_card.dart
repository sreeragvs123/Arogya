import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String metricName;
  final String value;
  final String status;
  final String unit;
  final Color statusBgColor;
  final VoidCallback onTap;
  
  final color = const Color.fromARGB(255, 66, 130, 31);

  const MetricCard({super.key, required this.icon, required this.metricName, required this.value, required this.status, required this.statusBgColor, required this.unit,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon,color: color,size: 33,),
                  Container(
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(status,style: TextStyle(fontSize: 12),),
                      ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text(metricName,style: TextStyle(letterSpacing: -0.1, fontSize: 17,fontWeight: FontWeight.w500,color: Colors.grey),),
              Row(
                children: [
                  Text(value,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
                  SizedBox(width: 7,),
                  Text(unit,style: TextStyle(fontSize: 16,color:const Color.fromARGB(255, 72, 72, 72)),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}