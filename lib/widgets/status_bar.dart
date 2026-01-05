import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("9:41", style: TextStyle(color: Colors.white)),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Icon(Icons.wifi, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Icon(Icons.battery_full, color: Colors.white, size: 18),
            ],
          )
        ],
      ),
    );
  }
}
