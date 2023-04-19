import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YuvalAboutCard extends StatelessWidget {
  const YuvalAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/yuvalProfile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Yuval Miller',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Founder and CEO',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'MBA graduate and a soon-to-be-completed BSc in computer science, Yuval has a vast knowledge and experince in both management and technology. together with extensive background in eating sweet desserts, when it comes to sweet recipes, Yuval is the man with the plan.',
                    maxLines: 9,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
