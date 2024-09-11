import 'package:bi_ufcg/models/course.dart';
import 'package:bi_ufcg/models/student.dart';

abstract class HomeView {
  void setCourse(List<Course> courses);

  void onError(String string);

  void onStudentsReceived(List<Student> student, int code);

  void removeCode(int code);

  void setFalseisRequestingStudentsByCourse();

  void setTrueisRequestingStudentsByCourse();

  //void updateEnrollmentEvolution(Map<String, int> enrollmentEvolution);

  void updateGenderDistribution(
      Map<String, Map<String, int>> genderDistribution);

  void updateAgeDistribution(Map<String, Map<String, int>> ageDistribution);

  void updateAffirmativePolicyDistribution(
      Map<String, Map<String, int>> affirmativePolicyDistribution);

  void updateStatusDistribution(
      Map<String, Map<String, int>> statusDistribution);

  void updateInactivityReasonDistribution(
      Map<String, Map<String, int>> inactivityReasonDistribution);

  void updateAdmissionTypeDistribution(
      Map<String, Map<String, int>> admissionTypeDistribution);

  void updateSecondarySchoolTypeDistribution(
      Map<String, Map<String, int>> secondarySchoolTypeDistribution);

  void setTerms(List<String> terms);

  void changeIndexMenu(int index);

  void addTermToData(String term);

  void removeTermToData(String term);

  void message(String message);

  void showLoading();

  void hideLoading();

  List<int> getCourseSelectedIndexes();
  List<int> getTermSelectedIndexes();
  void addCourseSelectIndex(int index);
  void removeCourseSelectIndex(int index);
  void addTermSelectIndex(int index);
  void removeTermSelectIndex(int index);
}
