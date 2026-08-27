import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omnia/Resources/elegantnotif.dart';

class PaymentUploadCard extends StatefulWidget {
  final Function(String?) onUploadComplete; // Callback to pass the URL

  const PaymentUploadCard({super.key, required this.onUploadComplete});

  @override
  PaymentUploadCardState createState() => PaymentUploadCardState();
}


class PaymentUploadCardState extends State<PaymentUploadCard> {
  File? paymentImageFile;
  String? username;
  String? downloadURL;
  String? email;
  final User? user = FirebaseAuth.instance.currentUser;
  Elegantnotif notif = const Elegantnotif();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        paymentImageFile = File(pickedFile.path);
      });
    } else {
      if (mounted) {
        notif.myElegantError(context, 'No image selected.');
      }
    }
  }

  Future<String> _uploadImage() async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user/payment').child(user!.email!);
      UploadTask uploadTask = ref.putFile(paymentImageFile!);
      if (mounted) {
        notif.myElegantInfo(context, 'Uploading...', 10);
      }
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Listener for debugging purposes
      }, onError: (e) {
        if (mounted) {
          notif.myElegantInfo(context, 'Error: $e', 4);
        }
      });

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('FirebaseException: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred while uploading the image: $e');
    }
  }

  Future<void> _saveScreenshot() async {
    if (paymentImageFile == null) {
      notif.myElegantError(context, 'No screenshot selected.');
      return;
    }

    try {
      downloadURL = await _uploadImage();
      widget.onUploadComplete(downloadURL); // Pass the URL to the parent widget
      if (mounted) {
        notif.myElegantSuccess(context, 'Screenshot uploaded successfully');
      }
    } catch (e) {
      if (mounted) {
        notif.myElegantError(context, 'Failed to upload screenshot: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Payment Screenshot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            paymentImageFile != null
                ? GestureDetector(
                    onTap: _pickImage,
                    child: Image.file(
                      paymentImageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                : GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Tap to upload screenshot',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveScreenshot,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  // : Colors.white, // Text color
                ),
                child: const Text('Save Screenshot',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
