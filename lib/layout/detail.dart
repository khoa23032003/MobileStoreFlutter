import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null) {
      setState(() {
        user = User.fromJson(jsonDecode(strUser));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );

    TextStyle contentStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black87,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundImage:
                    user.imageURL != null && user.imageURL!.isNotEmpty
                        ? NetworkImage(user.imageURL!)
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfoRow(
                        'NumberID:', user.idNumber, titleStyle, contentStyle),
                    _buildUserInfoRow(
                        'Fullname:', user.fullName, titleStyle, contentStyle),
                    _buildUserInfoRow('Phone Number:', user.phoneNumber,
                        titleStyle, contentStyle),
                    _buildUserInfoRow(
                        'Gender:', user.gender, titleStyle, contentStyle),
                    _buildUserInfoRow(
                        'BirthDay:', user.birthDay, titleStyle, contentStyle),
                    _buildUserInfoRow('School Year:', user.schoolYear,
                        titleStyle, contentStyle),
                    _buildUserInfoRow('School Key:', user.schoolKey, titleStyle,
                        contentStyle),
                    _buildUserInfoRow('Date Created:', user.dateCreated,
                        titleStyle, contentStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String title, String? content, TextStyle titleStyle,
      TextStyle contentStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: titleStyle),
          const SizedBox(width: 10),
          Expanded(child: Text(content ?? 'N/A', style: contentStyle)),
        ],
      ),
    );
  }
}
