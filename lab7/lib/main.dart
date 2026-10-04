import 'package:flutter/material.dart';

// ==========================================================
// LAB 7 - SIGNUP FORM WITH VALIDATION & GOOD UX
// Tất cả code nằm trong một file main.dart
// ==========================================================

void main() {
  runApp(const MyApp());
}

// ==========================================================
// 1. MAIN APP
// ==========================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 - Signup Form',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),

      home: const SignupScreen(),
    );
  }
}

// ==========================================================
// 2. SIGNUP SCREEN
//
// Dùng StatefulWidget vì:
// - Dữ liệu form thay đổi
// - Password có thể show/hide
// - Checkbox thay đổi
// - Loading thay đổi
// ==========================================================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ========================================================
  // LAB 7.1 - FORM KEY
  //
  // GlobalKey<FormState> dùng để:
  // - validate()
  // - save()
  // ========================================================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ========================================================
  // TEXT CONTROLLERS
  //
  // Dùng để đọc dữ liệu người dùng nhập
  // ========================================================

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  // ========================================================
  // LAB 7.3 - FOCUS NODES
  //
  // Dùng để chuyển focus:
  // Name -> Email -> Password -> Confirm Password
  // ========================================================

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();

  // ========================================================
  // STATE
  // ========================================================

  // Ẩn/hiện password
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // Terms & Conditions
  bool acceptedTerms = false;

  // Async email checking
  bool isCheckingEmail = false;

  // ========================================================
  // LAB 7.2 - VALIDATION
  // ========================================================

  // --------------------------------------------------------
  // VALIDATE FULL NAME
  // --------------------------------------------------------

  String? validateName(String? value) {
    // Không được để trống
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  // --------------------------------------------------------
  // VALIDATE EMAIL
  //
  // Theo đề:
  // - Required
  // - Có @
  // - Có .
  // --------------------------------------------------------

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final String email = value.trim();

    // Kiểm tra email đơn giản theo yêu cầu đề
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  // --------------------------------------------------------
  // VALIDATE PASSWORD
  //
  // Theo đề:
  // - Required
  // - Ít nhất 8 ký tự
  // - Ít nhất 1 chữ số
  // --------------------------------------------------------

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // [0-9] kiểm tra password có ít nhất 1 số
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  // --------------------------------------------------------
  // VALIDATE CONFIRM PASSWORD
  // --------------------------------------------------------

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    // Confirm phải giống Password
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ========================================================
  // BONUS - PASSWORD STRENGTH
  // ========================================================

  String getPasswordStrength() {
    final String password = passwordController.text;

    if (password.isEmpty) {
      return '';
    }

    // Dưới 8 ký tự -> Weak
    if (password.length < 8) {
      return 'Weak';
    }

    final bool hasLetter =
    RegExp(r'[A-Za-z]').hasMatch(password);

    final bool hasNumber =
    RegExp(r'[0-9]').hasMatch(password);

    final bool hasSpecial =
    RegExp(r'[!@#$%^&*]').hasMatch(password);

    // >= 10 ký tự + chữ + số + ký tự đặc biệt
    if (password.length >= 10 &&
        hasLetter &&
        hasNumber &&
        hasSpecial) {
      return 'Strong';
    }

    // Có chữ và số
    if (hasLetter && hasNumber) {
      return 'Medium';
    }

    return 'Weak';
  }

  // ========================================================
  // LAB 7.4 - SUBMIT FORM
  // ========================================================

  Future<void> submitForm() async {
    // ------------------------------------------------------
    // Đóng keyboard
    // ------------------------------------------------------

    FocusScope.of(context).unfocus();

    // ------------------------------------------------------
    // BƯỚC 1:
    // Validate toàn bộ form
    // ------------------------------------------------------

    final bool isValid =
    formKey.currentState!.validate();

    // Nếu form không hợp lệ -> không submit
    if (!isValid) {
      return;
    }

    // ------------------------------------------------------
    // BONUS:
    // Kiểm tra Terms & Conditions
    // ------------------------------------------------------

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept Terms & Conditions',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------
    // BƯỚC 2:
    // Save form
    // ------------------------------------------------------

    formKey.currentState!.save();

    // ------------------------------------------------------
    // BƯỚC 3:
    // Bắt đầu kiểm tra Email
    // ------------------------------------------------------

    setState(() {
      isCheckingEmail = true;
    });

    // ------------------------------------------------------
    // LAB 7.4 - ASYNC VALIDATION
    //
    // Giả lập gọi API trong 2 giây
    // ------------------------------------------------------

    await Future.delayed(
      const Duration(seconds: 2),
    );

    // Kiểm tra widget còn tồn tại không
    if (!mounted) {
      return;
    }

    // ------------------------------------------------------
    // Fake rule:
    //
    // Email bắt đầu bằng "taken"
    // được xem là đã có người sử dụng
    //
    // Ví dụ:
    // taken@gmail.com
    // taken123@gmail.com
    // ------------------------------------------------------

    final bool emailTaken = emailController.text
        .trim()
        .toLowerCase()
        .startsWith('taken');

    // ------------------------------------------------------
    // EMAIL ĐÃ TỒN TẠI
    // ------------------------------------------------------

    if (emailTaken) {
      setState(() {
        isCheckingEmail = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This email is already taken',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------
    // ĐĂNG KÝ THÀNH CÔNG
    // ------------------------------------------------------

    setState(() {
      isCheckingEmail = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account created successfully for '
              '${nameController.text.trim()}',
        ),
      ),
    );
  }

  // ========================================================
  // DISPOSE
  //
  // Giải phóng Controller và FocusNode
  // ========================================================

  @override
  void dispose() {
    // Controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    // FocusNodes
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();

    super.dispose();
  }

  // ========================================================
  // BUILD UI
  // ========================================================

  @override
  Widget build(BuildContext context) {
    // Lấy trạng thái password hiện tại
    final String passwordStrength =
    getPasswordStrength();

    return Scaffold(
      // ====================================================
      // APP BAR
      // ====================================================

      appBar: AppBar(
        title: const Text('Signup'),
        centerTitle: true,
      ),

      // ====================================================
      // GESTURE DETECTOR
      //
      // Tap ra ngoài -> đóng keyboard
      // ====================================================

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SafeArea(
          // =================================================
          // LISTVIEW
          //
          // Form có thể scroll khi keyboard mở.
          // Tránh overflow trên màn hình nhỏ.
          // =================================================

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              // =============================================
              // HEADER
              // =============================================

              const Icon(
                Icons.person_add_alt_1,
                size: 65,
              ),

              const SizedBox(height: 8),

              const Text(
                'Create Account',

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Enter your information to create an account.',

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // =============================================
              // FORM
              // =============================================

              Form(
                key: formKey,

                // Sau khi user tương tác với field
                // validator sẽ tự chạy
                autovalidateMode:
                AutovalidateMode.onUserInteraction,

                child: Column(
                  children: [
                    // =========================================
                    // 1. FULL NAME
                    // =========================================

                    TextFormField(
                      controller: nameController,

                      focusNode: nameFocus,

                      decoration: const InputDecoration(
                        labelText: 'Full Name',

                        hintText:
                        'Enter your full name',

                        prefixIcon:
                        Icon(Icons.person),

                        border:
                        OutlineInputBorder(),
                      ),

                      // Keyboard hiện nút Next
                      textInputAction:
                      TextInputAction.next,

                      validator: validateName,

                      // Name -> Email
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(
                          emailFocus,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================
                    // 2. EMAIL
                    // =========================================

                    TextFormField(
                      controller: emailController,

                      focusNode: emailFocus,

                      keyboardType:
                      TextInputType.emailAddress,

                      decoration: const InputDecoration(
                        labelText: 'Email',

                        hintText:
                        'example@email.com',

                        prefixIcon:
                        Icon(Icons.email),

                        border:
                        OutlineInputBorder(),
                      ),

                      textInputAction:
                      TextInputAction.next,

                      validator: validateEmail,

                      // Email -> Password
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(
                          passwordFocus,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================
                    // 3. PASSWORD
                    // =========================================

                    TextFormField(
                      controller:
                      passwordController,

                      focusNode: passwordFocus,

                      // Ẩn password
                      obscureText: hidePassword,

                      decoration: InputDecoration(
                        labelText: 'Password',

                        hintText:
                        'At least 8 characters',

                        prefixIcon:
                        const Icon(Icons.lock),

                        border:
                        const OutlineInputBorder(),

                        // BONUS:
                        // Show / Hide password
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              hidePassword =
                              !hidePassword;
                            });
                          },
                        ),
                      ),

                      textInputAction:
                      TextInputAction.next,

                      validator: validatePassword,

                      // Mỗi khi password thay đổi,
                      // rebuild để cập nhật Strength
                      onChanged: (_) {
                        setState(() {});
                      },

                      // Password -> Confirm Password
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(
                          confirmFocus,
                        );
                      },
                    ),

                    // =========================================
                    // BONUS:
                    // PASSWORD STRENGTH
                    // =========================================

                    if (passwordStrength.isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 8,
                        ),

                        child: Align(
                          alignment:
                          Alignment.centerLeft,

                          child: Text(
                            'Password strength: '
                                '$passwordStrength',

                            style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // =========================================
                    // 4. CONFIRM PASSWORD
                    // =========================================

                    TextFormField(
                      controller:
                      confirmPasswordController,

                      focusNode: confirmFocus,

                      obscureText:
                      hideConfirmPassword,

                      decoration: InputDecoration(
                        labelText:
                        'Confirm Password',

                        hintText:
                        'Enter password again',

                        prefixIcon:
                        const Icon(
                          Icons.lock_outline,
                        ),

                        border:
                        const OutlineInputBorder(),

                        // BONUS:
                        // Show / Hide confirm password
                        suffixIcon: IconButton(
                          icon: Icon(
                            hideConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),

                          onPressed: () {
                            setState(() {
                              hideConfirmPassword =
                              !hideConfirmPassword;
                            });
                          },
                        ),
                      ),

                      // Field cuối dùng Done
                      textInputAction:
                      TextInputAction.done,

                      validator:
                      validateConfirmPassword,

                      // Nhấn Done -> submit
                      onFieldSubmitted: (_) {
                        submitForm();
                      },
                    ),

                    const SizedBox(height: 10),

                    // =========================================
                    // BONUS:
                    // TERMS & CONDITIONS
                    // =========================================

                    CheckboxListTile(
                      contentPadding:
                      EdgeInsets.zero,

                      controlAffinity:
                      ListTileControlAffinity.leading,

                      value: acceptedTerms,

                      title: const Text(
                        'I accept the Terms & Conditions',
                      ),

                      onChanged: (value) {
                        setState(() {
                          acceptedTerms =
                              value ?? false;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // =========================================
                    // CREATE ACCOUNT BUTTON
                    // =========================================

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        // Khi đang check email:
                        // null -> disable button
                        onPressed: isCheckingEmail
                            ? null
                            : submitForm,

                        // -------------------------------------
                        // Nếu đang kiểm tra Email
                        // -> Loading
                        // -------------------------------------

                        child: isCheckingEmail
                            ? const SizedBox(
                          width: 22,
                          height: 22,

                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )

                        // ---------------------------------
                        // Bình thường
                        // ---------------------------------

                            : const Text(
                          'Create Account',

                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}