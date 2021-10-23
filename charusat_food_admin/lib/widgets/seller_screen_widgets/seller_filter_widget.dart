import 'package:flutter/material.dart';

class SellerFilterWidget extends StatelessWidget {
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
              onPressed: () {},
              elevation: 3,
              label: Text(
                'All Shops',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black54,
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              label: Text(
                'Active',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black54,
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              label: Text(
                'Inactive',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black54,
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              label: Text(
                'Top Picked',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black54,
            ),
            ActionChip(
              onPressed: () {},
              elevation: 3,
              label: Text(
                'Top Rated',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
