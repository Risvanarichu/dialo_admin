import 'dart:ui';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/providers/loginprovider.dart';
import 'package:dialo_admin/views/agents/web_users.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:dialo_admin/widget/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // FocusNode to move focus from email → password on Enter
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<Loginprovider>(context, listen: false);
      bool loggedIn = await provider.isLoggedIn();
      if (loggedIn) {
        final prefs = await SharedPreferences.getInstance();
        String? agentId = prefs.getString('agentId');
        if (agentId != null && agentId.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SideMenu()),
          );
        } else {
          Provider.of<Loginprovider>(context, listen: false).loadUserData();
        }
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ─── Shared login handler (used by button AND Enter key) ───────────────────
  Future<void> _handleLogin(BuildContext context, Loginprovider provider) async {
    if (!_formKey.currentState!.validate()) return;

    bool success = await provider.login();

    if (!mounted) return;

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await provider.loadUserRole();

      final leadProvider =
      Provider.of<LeadProvider>(context, listen: false);
      await leadProvider.loadAgentData();
      leadProvider.listenLeads();

      if (provider.isChecked) {
        await prefs.setString('email', provider.emailController.text);
        await prefs.setString('remember', 'true');
      } else {
        await prefs.remove('email');
        await prefs.remove('remember');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SideMenu()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("Login Failed"),
            ],
          ),
          content: Text("This user was not found. Please check your credentials."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Loginprovider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/shibi.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = MediaQuery.of(context).size.width;
                final bool isNarrow = screenWidth < 750;

                return SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: isNarrow ? 400 : 800,
                        height: 390,
                        padding: const EdgeInsets.all(30),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            // Left decorative panel (wide screen only)
                            if (!isNarrow)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Form panel
                            Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // ── Email field ──────────────────────
                                      _inputField(
                                        label: "Email/Username",
                                        hint: "Enter your Email",
                                        icon: Icons.email_outlined,
                                        controller: provider.emailController,
                                        // Move focus to password on Enter
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email is required";
                                          }
                                          final emailRegex = RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          );
                                          if (!emailRegex.hasMatch(value)) {
                                            return "Enter a valid email address";
                                          }
                                          return null;
                                        },
                                        labelSize: 18,
                                        labelWeight: FontWeight.bold,
                                      ),

                                      SizedBox(height: 25),

                                      // ── Password field ───────────────────
                                      _inputField(
                                        label: "Password",
                                        hint: "Enter your Password",
                                        icon: Icons.lock_outline_rounded,
                                        isPassword: provider.isPasswordHidden,
                                        controller: provider.passwordController,
                                        focusNode: _passwordFocusNode,
                                        // Trigger login on Enter key
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) =>
                                            _handleLogin(context, provider),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Password is required";
                                          }
                                          if (value.length < 6) {
                                            return "Password must be at least 6 characters";
                                          }
                                          if (!RegExp(r'[A-Z]')
                                              .hasMatch(value)) {
                                            return "Must contain at least 1 uppercase letter";
                                          }
                                          if (!RegExp(r'[a-z]')
                                              .hasMatch(value)) {
                                            return "Must contain at least 1 lowercase letter";
                                          }
                                          if (!RegExp(
                                              r'[!@#$%^&*(),.?":{}\|<>]')
                                              .hasMatch(value)) {
                                            return "Must contain at least 1 special character";
                                          }
                                          if (!RegExp(r'[0-9]')
                                              .hasMatch(value)) {
                                            return "Password must contain at least one number";
                                          }
                                          return null;
                                        },
                                        labelSize: 18,
                                        labelWeight: FontWeight.bold,
                                        suffixIcon: GestureDetector(
                                          onTap: provider.togglePassword,
                                          child: Icon(
                                            provider.isPasswordHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.indigo[900],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      // ── Remember me ──────────────────────
                                      Row(
                                        children: [
                                          SizedBox(width: 8),
                                          Text(
                                            "Remember me",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: provider.toggleRemember,
                                            child: Icon(
                                              provider.isChecked
                                                  ? Icons.check_box
                                                  : Icons
                                                  .check_box_outline_blank_outlined,
                                              color: Colors.indigo[900],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 28),

                                      // ── Buttons ───────────────────────────
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          // Log In button
                                          SizedBox(
                                            width: 140,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.blue[900],
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              onPressed: provider.isLoading
                                                  ? null
                                                  : () => _handleLogin(
                                                  context, provider),
                                              child: provider.isLoading
                                                  ? SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                                  : Text(
                                                "Log In",
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 17),

                                          // Google Sign-In button
                                          SizedBox(
                                            height: 40,
                                            child: ElevatedButton.icon(
                                              onPressed: provider.isLoading
                                                  ? null
                                                  : () async {
                                                await provider
                                                    .signInWithGoogle();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.blue[900],
                                                padding: EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                ),
                                                side: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              icon: Image.asset(
                                                "assets/google.png",
                                                height: 20,
                                              ),
                                              label: Text(
                                                "Login with Google",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Reusable input field widget ────────────────────────────────────────────
  Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    double labelSize = 14,
    FontWeight labelWeight = FontWeight.bold,
    Widget? suffixIcon,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: labelSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.indigo[900],
            ),
            suffixIcon: suffixIcon,
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}