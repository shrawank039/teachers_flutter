import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerAPI {
  var status;
  String apiRoot = "http://128.199.237.154/school_erp";

  _buildHeader() {
    return {'Accept': 'application/json', 'cache-control': 'no-cache'};
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('userData');
  }

  _buildHeaderWithAuth() async {
    final currentAPIToken = await getApiToken();
    return {
      'Accept': 'application/json',
      'authorization': 'Bearer ' + currentAPIToken,
      'cache-control': 'no-cache'
    };
  }

  Future<String> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiToken = await prefs.get('api_token');
    return apiToken;
  }

  static successToast(String msg) {
    return SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    );
  }

  static errorToast(String msg) {
    return SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  setAuthUser(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = json.encode(data);
    await prefs.setBool('isLogin', true);
    await prefs.setString('username', data['student_username'].toString());
    await prefs.setString('password', data['student_tmp_password'].toString());
    await prefs.setString('userData', userData.toString());
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("userData");
    return json.decode(data);
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = await prefs.getBool('isLogin');
    if (isLogin == null) {
      return false;
    }
    return isLogin;
  }

  Future<Map<String, dynamic>> updateDeviceID(data) async {
    final response = await http.post(apiRoot + "/updateStudentDeviceId",
        headers: _buildHeader(), body: data);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // SERVER SIDE API FUNCTIONS //

  Future<Map<String, dynamic>> authRequest(data) async {
    final response = await http.post(apiRoot + "/ApiLogin",
        headers: _buildHeader(), body: data);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> todaySchedule() async {
    final userInfo = await this.getUserInfo();
    final teacherID = userInfo['id'];
    final schoolID = userInfo['school_id'];
    final response = await http.get(apiRoot + "/dailyWiseRouting?teacher_id=$teacherID&school_id=$schoolID", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> calssWiseStudentAttendanceList(String date, String class_id, String subjectID) async {
    final userInfo = await this.getUserInfo();
    final response = await http.get(apiRoot + "/getClassWiseAttendence?date=$date&class_id=$class_id&subject_id=$subjectID", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> classSubjectWiseStudentAtendenceList(student_id, class_id, subject_id, month, year) async {
    final userInfo = await this.getUserInfo();
    print(apiRoot + "/classSubjectWiseStudentAtendenceList?student_id=$student_id&class_id=$class_id&subject_id=$subject_id&month=$month&year=$year");
    final response = await http.get(apiRoot + "/classSubjectWiseStudentAtendenceList?student_id=$student_id&class_id=$class_id&subject_id=$subject_id&month=$month&year=$year", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> calssWiseSubjectList() async {
    final userInfo = await this.getUserInfo();
    final teacherID = userInfo['id'];
    final schoolID = userInfo['school_id'];
    final response = await http.get(apiRoot + "/getAllClassRoutine?teacher_id=$teacherID&school_id=$schoolID", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> weeklyScheduleClass() async {
    final userInfo = await this.getUserInfo();
    final teacherID = userInfo['id'];
    final response = await http.get(apiRoot + "/teacherweeklyScheduleClass?teacher_id=$teacherID", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> announcement() async {
    final userInfo = await this.getUserInfo();
    final schoolID = userInfo['school_id'];
    final response = await http.get(
        apiRoot + "/announcement?type=teacher&school_id=$schoolID",
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> individualChatRoomList(
      classID, subjectID) async {
    final userInfo = await this.getUserInfo();
    final teacherID = userInfo['id'];
    final schoolID = userInfo['school_id'];
    final response = await http.get(apiRoot + "/classWiseStudentList?teacher_id=$teacherID&school_id=$schoolID&class_id=" + classID + "&subject_id=" + subjectID, headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Chat

  Future<Map<String, dynamic>> getGroupChatHistory(groupId) async {
    final response = await http.get(
        apiRoot + "/groupChatHistory?group_chat_id=" + groupId,
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> getIndividualChatHistory(groupId) async {
    print(groupId);
    final response = await http.get(
        apiRoot + "/individualChatHistory?group_chat_id=" + groupId,
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  attachmentUpload(image) async {
    var url = apiRoot + "/upload";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'attachment',
        image,
      ),
    );
    final Map<String, String> header = {
      'Accept': 'application/json',
    };
    request.headers.addAll(header);
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    return json.decode(response.body.toString());
  }

  Future<Map<String, dynamic>> getClassWiseSubjectList(classID) async {
    final response = await http.get(
        apiRoot + "/classWiseSubjectList?class_id=$classID",
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> getIndividualAssignment(
      calssID, subjectId) async {
    final userInfo = await this.getUserInfo();
    final teacherID = userInfo['id'];
    final response = await http.get(
        apiRoot +
            "/getTeacherSubjectWiseAssignmentList?teacher_id=$teacherID&class_id=" +
            calssID +
            "&subject_id=" +
            subjectId,
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  submitAssignment(data, attachmentPath) async {
    var url = apiRoot + "/addWorkAssignment";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'attachment',
        attachmentPath,
      ),
    );
    request.fields.addAll(data);
    final Map<String, String> header = {
      'Accept': 'application/json',
    };
    request.headers.addAll(header);
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    return json.decode(response.body.toString());
  }

  Future<Map<String, dynamic>> submitAssignmentWithoutAttachment(body) async {
    final response = await http.post(apiRoot + "/addWorkAssignment", headers: _buildHeader(), body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> contactQuery(body) async {
    final response = await http.post(apiRoot + "/contactFormQuery", headers: _buildHeader(), body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final userInfo = await this.getUserInfo();
    final response = await http.get(
        apiRoot + "/getTeacherDeatils?teacher_id=" + userInfo['id'],
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> addSupport() async {
    final userInfo = await this.getUserInfo();
    final userID = userInfo['id'];
    final response = await http.get(
        apiRoot + "/addTeacherSupport?teacher_id=$userID&status=1",
        headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> readAllMessage(chatRoomID) async {
    final response = await http.get(apiRoot+"/setReadMessage?room_id=$chatRoomID&sender=teacher", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> changePassword(oldPassword, newPassword, confirmPassword) async {
    final userInfo = await this.getUserInfo();
    final userID = userInfo['id'];
    final response = await http.get(apiRoot+"/teacherchangePassword?user_id=$userID&old_password=$oldPassword&new_password=$newPassword&confirm_password=$confirmPassword", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> changeLiveClassStatus(teacherID, classID, roomID, status) async {
    print(apiRoot + "/liveclass?teacher_id=$teacherID&class_id=$classID&status=$status&room_id=$roomID");
    final response = await http.get(apiRoot + "/liveclass?teacher_id=$teacherID&class_id=$classID&status=$status&room_id=$roomID", headers: _buildHeader());
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> getNews(type) async {
    final response = await http.get(apiRoot + "/getNewsStory?type=$type", headers: _buildHeader());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> versionCheck() async {
    var body = {
      "type" : "teacher"
    };
    final response = await http.post(apiRoot + "/vesionInfo", headers: _buildHeader(), body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

}
