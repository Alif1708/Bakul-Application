import 'package:flutter/material.dart';

class VendorFilterWidget extends StatelessWidget {
  const VendorFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'All Vendors',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Active',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'In Active',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Top Picked',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Top Rated',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
