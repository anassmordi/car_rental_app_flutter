import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_model.dart' as custom; // Import the notification model with an alias
import '../api_constants.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<custom.Notification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _resetUnreadNotificationsCount(); // Reset unread notifications count when page is visited
  }

  Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      // Handle the case when there is no access token
      setState(() {
        _isLoading = false;
      });
      throw Exception('No access token found');
    }

    final url = Uri.parse('$BASE_URL/api/notification');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _notifications = data.map((json) => custom.Notification.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> _resetUnreadNotificationsCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('unreadNotifications', 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(notification.message),
                            subtitle: Text(notification.timestamp),
                            onTap: () {
                              // Handle notification tap
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
