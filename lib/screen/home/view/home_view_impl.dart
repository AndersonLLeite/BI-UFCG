import 'package:bi_ufcg/core/ui/helpers/loader.dart';
import 'package:bi_ufcg/core/ui/helpers/messages.dart';
import 'package:bi_ufcg/models/course.dart';
import 'package:bi_ufcg/models/student.dart';
import 'package:bi_ufcg/service/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';
import 'home_view.dart';

abstract class HomeViewImpl extends State<HomePage>
    with Loader<HomePage>, Messages<HomePage>
    implements HomeView {
  int menuIndexSelected = 0;
  List<Course> listCourses = [];
  List<Course> selecteCourses = [];
  List<String> terms = [];
  List<String> selectedTerms = [];
  List<int> courseSelectedIndexes = [];
  List<int> termSelectedIndexes = [];
  bool isRequestingStudentsByCourse = false;

  @override
  void initState() {
    widget.presenter.view = this;
    super.initState();
    widget.presenter.getCourses();
    widget.presenter.getTerms(14102100);
  }

  @override
  void setCourse(List<Course> courses) {
    setState(() {
      listCourses = courses;
    });
  }

  @override
  void setTerms(List<String> terms) {
    setState(() {
      this.terms = terms;
    });
  }

  @override
  void setFalseisRequestingStudentsByCourse() {
    setState(() {
      isRequestingStudentsByCourse = false;
    });
  }

  @override
  void setTrueisRequestingStudentsByCourse() {
    setState(() {
      isRequestingStudentsByCourse = true;
    });
  }

  @override
  void changeIndexMenu(int index) {
    setState(() {
      menuIndexSelected = index;
    });
  }

  @override
  List<int> getCourseSelectedIndexes() {
    return courseSelectedIndexes;
  }

  @override
  List<int> getTermSelectedIndexes() {
    return termSelectedIndexes;
  }

  @override
  void addCourseSelectIndex(int index) {
    setState(() {
      courseSelectedIndexes.add(index);
    });
  }

  @override
  void removeCourseSelectIndex(int index) {
    setState(() {
      courseSelectedIndexes.remove(index);
    });
  }

  @override
  void addTermSelectIndex(int index) {
    setState(() {
      termSelectedIndexes.add(index);
    });
  }

  @override
  void removeTermSelectIndex(int index) {
    setState(() {
      termSelectedIndexes.remove(index);
    });
  }

  @override
  void onStudentsReceived(List<Student> students, int courseCode) {
    setState(() {
      selecteCourses.add(listCourses
          .firstWhere((element) => element.codigoDoCurso == courseCode)
        ..students = students);
    });
    widget.presenter.attDataBase(selecteCourses, selectedTerms);
    setFalseisRequestingStudentsByCourse();
  }

  @override
  void removeCode(int coursecode) {
    setState(() {
      selecteCourses = selecteCourses
          .where((element) => element.codigoDoCurso != coursecode)
          .toList();
    });
    widget.presenter.attDataBase(selecteCourses, selectedTerms);
  }

  @override
  void addTermToData(String term) {
    setState(() {
      selectedTerms.add(term);
    });
    widget.presenter.attDataBase(selecteCourses, selectedTerms);
  }

  @override
  void removeTermToData(String term) {
    setState(() {
      selectedTerms.remove(term);
    });
    widget.presenter.attDataBase(selecteCourses, selectedTerms);
  }

  @override
  void onError(String error) {
    showError(error);
  }

  @override
  void message(String message) {
    showInfo(message);
  }

  @override
  void showLoading() {
    showLoader();
  }

  @override
  void hideLoading() {
    hideLoader();
  }

  // @override
  // void updateEnrollmentEvolution(Map<String, int> enrollmentEvolution) {
  //   context.read<Data>().setEnrollmentEvolution(enrollmentEvolution);
  // }

  @override
  void updateGenderDistribution(
      Map<String, Map<String, int>> genderDistribution) {
    context.read<Data>().setGenderDistribution(genderDistribution);
    print('genderDistribution:  $genderDistribution');
  }

  @override
  void updateAgeDistribution(Map<String, Map<String, int>> ageDistribution) {
    context.read<Data>().setAgeDistribution(ageDistribution);
    print('ageDistribution:  $ageDistribution');
  }

  @override
  void updateAffirmativePolicyDistribution(
      Map<String, Map<String, int>> affirmativePolicyDistribution) {
    context
        .read<Data>()
        .setAffirmativePolicyDistribution(affirmativePolicyDistribution);
  }

  @override
  void updateStatusDistribution(
      Map<String, Map<String, int>> statusDistribution) {
    context.read<Data>().setStatusDistribution(statusDistribution);
    print('statusDistribuition:  $statusDistribution');
  }

  @override
  void updateInactivityReasonDistribution(
      Map<String, Map<String, int>> inactivityReasonDistribution) {
    context
        .read<Data>()
        .setInactivityReasonDistribution(inactivityReasonDistribution);
    print('inactivityReasonDistribution:  $inactivityReasonDistribution');
  }

  @override
  void updateAdmissionTypeDistribution(
      Map<String, Map<String, int>> admissionTypeDistribution) {
    context
        .read<Data>()
        .setAdmissionTypeDistribution(admissionTypeDistribution);
    print('admissionTypeDistribution:  $admissionTypeDistribution');
  }

  @override
  void updateSecondarySchoolTypeDistribution(
      Map<String, Map<String, int>> secondarySchoolTypeDistribution) {
    context
        .read<Data>()
        .setSecondarySchoolTypeDistribution(secondarySchoolTypeDistribution);
    print('secondarySchoolTypeDistribution:  $secondarySchoolTypeDistribution');
  }
}
