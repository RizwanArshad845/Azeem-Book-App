/// Roles that authenticate through the generic phone+OTP flow. Salesman and
/// Admin are separate apps with their own login models (§9.1) and are
/// deliberately excluded here.
enum UserRole { teacher, student }
