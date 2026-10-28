import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller Utama (Modul)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controller Tambahan (Latihan 1 & 2)
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // State Tambahan (Latihan 2, 3, 4, 5)
  DateTime? _selectedDate;
  String? _gender;
  bool _isAgreed = false;
  String? _agreeError;

  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;
  double _strengthProgress = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Validasi Nama (Modul)
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi Email (Modul)
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi Telepon (Latihan 1)
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    if (value.trim().length < 10 || value.trim().length > 13) {
      return 'Nomor telepon harus 10-13 digit';
    }
    return null;
  }

  // Validasi Password (Modul)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi Konfirmasi Password (Modul)
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Helper DatePicker (Latihan 2)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Helper Indikator Kekuatan Password (Latihan 5)
  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthProgress = 0.0;
      });
      return;
    }

    bool hasMinLength = value.length >= 8;
    bool hasUpper = value.contains(RegExp(r'[A-Z]'));
    bool hasLower = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasMinLength && hasUpper && hasLower && hasDigits && hasSpecial) {
      setState(() {
        _passwordStrength = 'Kuat';
        _strengthColor = Colors.green;
        _strengthProgress = 1.0;
      });
    } else if (hasMinLength && (hasUpper || hasLower) && hasDigits) {
      setState(() {
        _passwordStrength = 'Sedang';
        _strengthColor = Colors.orange;
        _strengthProgress = 0.6;
      });
    } else {
      setState(() {
        _passwordStrength = 'Lemah';
        _strengthColor = Colors.red;
        _strengthProgress = 0.3;
      });
    }
  }

  // Handler Submit Form (Modul + Latihan 4)
  void _submitForm() {
    setState(() {
      _agreeError = !_isAgreed ? 'Anda harus menyetujui syarat & ketentuan' : null;
    });

    if (_formKey.currentState!.validate() && _isAgreed) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses registrasi
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}\n'
              'No. Telp: ${_phoneController.text}\n'
              'Tgl Lahir: ${_dobController.text}\n'
              'Jenis Kelamin: $_gender',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  // Handler Reset Form (Modul + Latihan 1-4)
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _dobController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedDate = null;
      _gender = null;
      _isAgreed = false;
      _agreeError = null;
      _passwordStrength = '';
      _strengthProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Field Nama (Modul)
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),

                // Field Email (Modul)
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                // Field Nomor Telepon (Latihan 1)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan nomor telepon (contoh: 08123456789)',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),

                // Field Tanggal Lahir (Latihan 2)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir Anda',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal lahir wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),

                // Dropdown Jenis Kelamin (Latihan 3)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(
                          value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis kelamin wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),

                // Field Password (Modul + Latihan 5)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: _checkPasswordStrength,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: _validatePassword,
                  ),
                ),

                // Indikator Kekuatan Password (Latihan 5)
                if (_passwordStrength.isNotEmpty) ...[
                  LinearProgressIndicator(
                    value: _strengthProgress,
                    backgroundColor: Colors.grey[200],
                    color: _strengthColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kekuatan Password: $_passwordStrength',
                    style: TextStyle(
                      color: _strengthColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Field Konfirmasi Password (Modul)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ),

                // Checkbox Syarat & Ketentuan (Latihan 4)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Saya menyetujui Syarat & Ketentuan'),
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isAgreed = value ?? false;
                          if (_isAgreed) _agreeError = null;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_agreeError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          _agreeError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Tombol Submit (Modul)
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                const SizedBox(height: 12),

                // Tombol Reset (Modul)
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}