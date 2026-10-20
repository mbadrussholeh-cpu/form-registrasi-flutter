import 'package:flutter/material.dart';
void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F46E5),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk membaca isi field
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // FocusNode untuk pindah fokus antar field
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final List<String> _prodiList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Manajemen',
    'Akuntansi',
  ];

  String? _gender;
  String? _prodi;
  bool _agree = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ---------- Validator ----------
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!value.contains('@')) {
      return 'Email harus mengandung karakter "@"';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // ---------- Aksi tombol Daftar ----------
  void _onSubmit() {
    // 1. Jalankan semua validator di dalam Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Cek checkbox syarat & ketentuan
    if (!_agree) {
      _showSnackBar(
        'Anda harus menyetujui Syarat & Ketentuan',
        Icons.warning_amber_rounded,
        Colors.orange.shade800,
      );
      return;
    }

    // 3. Semua lolos -> tampilkan dialog konfirmasi
    _showConfirmationDialog();
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  void _showConfirmationDialog() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          icon: CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(Icons.fact_check_rounded,
                size: 30, color: colorScheme.primary),
          ),
          title: const Text('Konfirmasi Data'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pastikan data yang kamu isi sudah benar.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Nama', _nameController.text.trim()),
                      _summaryRow('Email', _emailController.text.trim()),
                      _summaryRow('Jenis Kelamin', _gender ?? '-'),
                      _summaryRow('Program Studi', _prodi ?? '-'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _submitData();
              },
              child: const Text('Ya, Daftar'),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _submitData() {
    _showSnackBar(
      'Registrasi berhasil!',
      Icons.check_circle_rounded,
      Colors.green.shade700,
    );
    _resetForm();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _gender = null;
      _prodi = null;
      _agree = false;
    });
  }

  // ---------- Style helper ----------
  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final primary = Theme.of(context).colorScheme.primary;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: border(Colors.grey.shade300),
      enabledBorder: border(Colors.grey.shade300),
      focusedBorder: border(primary, 2),
      errorBorder: border(Colors.red.shade400),
      focusedErrorBorder: border(Colors.red.shade400, 2),
    );
  }

  Widget _genderOption(String value, IconData icon, FormFieldState<String> state) {
    final primary = Theme.of(context).colorScheme.primary;
    final selected = _gender == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() => _gender = value);
          state.didChange(value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? primary.withValues(alpha: 0.08) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? primary : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: _gender,
                onChanged: (v) {
                  setState(() => _gender = v);
                  state.didChange(v);
                },
              ),
              Icon(icon, size: 20, color: selected ? primary : Colors.grey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.18),
              const Color(0xFFF5F3FF),
              const Color(0xFFE0F2FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  const Color(0xFF7C3AED),
                                ],
                              ),
                            ),
                            child: const Icon(Icons.person_add_alt_1_rounded,
                                color: Colors.white, size: 32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Buat Akun Baru',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Lengkapi data di bawah untuk mendaftar',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Nama Lengkap
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          decoration:
                          _decoration('Nama Lengkap', Icons.person_outline),
                          validator: _validateName,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_emailFocus),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration:
                          _decoration('Email', Icons.email_outlined),
                          validator: _validateEmail,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          decoration: _decoration(
                            'Password',
                            Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _onSubmit(),
                        ),
                        const SizedBox(height: 20),

                        // Jenis Kelamin (Radio)
                        const Text('Jenis Kelamin',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        FormField<String>(
                          validator: (_) =>
                          _gender == null ? 'Pilih jenis kelamin' : null,
                          builder: (state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _genderOption(
                                        'Laki-laki', Icons.male, state),
                                    const SizedBox(width: 12),
                                    _genderOption(
                                        'Perempuan', Icons.female, state),
                                  ],
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 16, top: 8),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(
                                        color: colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Program Studi (Dropdown)
                        DropdownButtonFormField<String>(
                          value: _prodi,
                          borderRadius: BorderRadius.circular(14),
                          decoration:
                          _decoration('Program Studi', Icons.school_outlined),
                          items: _prodiList
                              .map((p) =>
                              DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (v) => setState(() => _prodi = v),
                          validator: (v) =>
                          v == null ? 'Pilih program studi' : null,
                        ),
                        const SizedBox(height: 12),

                        // Checkbox Syarat & Ketentuan
                        CheckboxListTile(
                          title: const Text(
                            'Saya setuju dengan Syarat & Ketentuan',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: _agree,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onChanged: (v) =>
                              setState(() => _agree = v ?? false),
                        ),
                        const SizedBox(height: 12),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _onSubmit,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}