import 'package:flutter/material.dart';

/// Distinct native icon per class-level or board-class stream name — shared
/// by both student onboarding (`StudentAcademicInfoView`) and teacher
/// onboarding (`TeacherSignupStep2Card`) so both flows draw from one source
/// instead of each keeping a private copy. A caller can't know ahead of time
/// whether a given `BoardClass.name` is a class-level string ("9th") or a
/// stream leaf string ("Pre-Medical"), so this combines both switches.
IconData classOrStreamIcon(String name) {
  switch (name) {
    case '9th':
      return Icons.looks_one_outlined;
    case 'Matric':
      return Icons.school_outlined;
    case '1st year':
      return Icons.looks_two_outlined;
    case '2nd year':
      return Icons.filter_3_outlined;
    case 'Pre-Medical':
      return Icons.biotech_outlined;
    case 'Pre-Engineering':
      return Icons.engineering_outlined;
    case 'I.Com':
      return Icons.account_balance_outlined;
    case 'F.A':
      return Icons.palette_outlined;
    case 'I.C.S':
      return Icons.computer_outlined;
    default:
      return Icons.class_outlined;
  }
}
