import 'package:client_app/screens/Authentication/entryname.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void _sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      OTPScreen(verificationId: verificationId, phone: phone),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter valid 10-digit mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9EBFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildTitle(),
              _buildDescription(),
              SizedBox(height: 20),
              _buildPhoneInputField(),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF17430),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Send OTP",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inder',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              SizedBox(height: 0),
              _buildFooterNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
      color: Color(0xFF44C5F4),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "TORTUGA",
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          "Better Food, Better Mood",
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Inder',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _buildTitle() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      "Login",
      style: TextStyle(fontSize: 22, fontFamily: 'InknutAntiqua'),
    ),
  );

  Widget _buildDescription() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Text(
      "To complete your order, see prices and exclusive deals, you'll need to Log in or Sign up here.",
      style: TextStyle(fontSize: 14, fontFamily: 'Inder'),
    ),
  );

  Widget _buildPhoneInputField() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/setup_illustration/India.png', width: 30),
          SizedBox(width: 5),
          Text(
            "+91",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inder',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter Mobile number...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildFooterNote() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      "We will send a 6-digit OTP number to the registered mobile number.",
      style: TextStyle(fontSize: 14, fontFamily: 'Inder'),
    ),
  );
}

// OTP Screen
class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OTPScreen({Key? key, required this.verificationId, required this.phone})
    : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  bool verifying = false;

  void _verifyOtp() async {
    String otp = otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter valid 6-digit OTP")));
      return;
    }

    setState(() => verifying = true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save phone number to Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone': widget.phone,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login successful")));

      // Navigate to the Profile screen or dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfileName(), // Replace with your actual screen
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
    } finally {
      setState(() => verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9EBFC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter OTP", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "6-digit code",
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              verifying
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text("Verify"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
