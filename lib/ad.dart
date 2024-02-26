import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class AdDialog extends StatelessWidget {
  final VoidCallback onNext; // Add this callback

  final String url = 'https://go.smart-minded.com/Seller-Tools';

  const AdDialog({super.key, required this.onNext});

  Future<void> _launchURL(String url) async {
    try {
      html.window.open(url, '_blank');
    } catch (e) {
      print('Could not launch $url. $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.all(3.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                InkWell(
                  onTap: () => _launchURL(url),
                  child: Image.asset('assets/Get_Discount_on_Helium_10.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: IconButton(
                    icon:
                        Icon(Icons.close, color: Colors.grey.withOpacity(0.5)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2F80ED),
                      Color(0xFF3CA4F5),
                    ], // Adjust the gradient colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor:
                        Colors.transparent, // This changes the background color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded border
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Generate Invoice Now ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          width: 4), // Add some spacing between text and icon
                      Icon(
                        Icons.arrow_forward,
                        size: 18, // You can change the size
                        color: Colors.white, // You can change the color
                      ),
                    ],
                  ),
                  onPressed: () {
                    onNext(); // Call the exportPng() function // Close the dialog
                  },
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.deepOrange
                    ], // Adjust the gradient colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    // This changes the background color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // Rounded border
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Get the Discount ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          width: 4), // Add some spacing between text and icon
                      Icon(
                        Icons.arrow_forward,
                        size: 18, // You can change the size
                        color: Colors.white, // You can change the color
                      ),
                    ],
                  ),
                  onPressed: () {
                    _launchURL(url);
                  },
                ),
              ),
            ],
          ),
        ]);
  }
}
