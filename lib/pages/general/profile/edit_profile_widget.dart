import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/verification_account/verification_account_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  static String routeName = 'EditProfile';
  static String routePath = '/edit-profile';

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _originalEmail = '';
  String _originalPhone = '';

  // Variables para controlar si la verificación fue exitosa
  bool _emailVerified = false;
  bool _phoneVerified = false;

  @override
  void initState() {
    super.initState();
    // Inicializar el modelo inmediatamente para evitar LateInitializationError
    _model = createModel(context, () => EditProfileModel());
    // Cargar los datos del usuario después de la inicialización
    _loadUserData();
    // Configurar listeners para los campos de email y celular
    _setupFieldListeners();
  }

  void _setupFieldListeners() {
    // Listener para el campo de email
    _model.emailFocusNode?.addListener(() async {
      if (_model.emailFocusNode!.hasFocus && !_emailVerified) {
        // Quitar el focus inmediatamente para evitar edición
        _model.emailFocusNode?.unfocus();

        // Mostrar modal de verificación
        bool verificationSuccess = await _showVerificationModal();

        if (verificationSuccess) {
          _emailVerified = true;
          // Permitir editar después de verificación exitosa
          _model.emailFocusNode?.requestFocus();
        } else {
          // Restaurar valor original si cancela verificación
          setState(() {
            _model.emailTextController.text = _originalEmail;
          });
        }
      }
    });

    // Listener para el campo de celular
    _model.phoneFocusNode?.addListener(() async {
      if (_model.phoneFocusNode!.hasFocus && !_phoneVerified) {
        // Quitar el focus inmediatamente para evitar edición
        _model.phoneFocusNode?.unfocus();

        // Mostrar modal de verificación
        bool verificationSuccess = await _showVerificationModal();

        if (verificationSuccess) {
          _phoneVerified = true;
          // Permitir editar después de verificación exitosa
          _model.phoneFocusNode?.requestFocus();
        } else {
          // Restaurar valor original si cancela verificación
          setState(() {
            _model.phoneTextController.text = _originalPhone;
          });
        }
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final nombres = prefs.getString('user_nombres') ?? '';
    final apellidos = prefs.getString('user_apellidos') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final phone = prefs.getString('user_phone') ?? '';

    // Guardar valores originales para comparar
    _originalEmail = email;
    _originalPhone = phone;

    // Asignar los datos a los controladores después de cargarlos
    if (mounted) {
      setState(() {
        _model.nombresTextController.text = nombres;
        _model.apellidosTextController.text = apellidos;
        _model.emailTextController.text = email;
        _model.phoneTextController.text = phone;
      });
    }
  }

  Future<bool> _showVerificationModal() async {
    final result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: VerificationAccountWidget(),
          ),
        );
      },
    );

    // Devolver true si la verificación fue exitosa, false si fue cancelada
    return result ?? false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      // Verificar si cambió email o teléfono
      bool emailChanged = _model.emailTextController.text != _originalEmail;
      bool phoneChanged = _model.phoneTextController.text != _originalPhone;

      // La verificación ya se hizo al intentar editar, solo validar que se completó
      if ((emailChanged && !_emailVerified) || (phoneChanged && !_phoneVerified)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe verificar los cambios antes de guardar'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nombres', _model.nombresTextController.text);
      await prefs.setString('user_apellidos', _model.apellidosTextController.text);
      await prefs.setString('user_email', _model.emailTextController.text);
      await prefs.setString('user_phone', _model.phoneTextController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );

      // Navegación segura - verificar que el contexto sigue válido
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Editar Perfil',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                ),
                color: Colors.white,
                fontSize: 24.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.nombresTextController,
                      focusNode: _model.nombresFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Nombres',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese sus nombres';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.apellidosTextController,
                      focusNode: _model.apellidosFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Apellidos',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese sus apellidos';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.emailTextController,
                      focusNode: _model.emailFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Por favor ingrese un email válido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: TextFormField(
                      controller: _model.phoneTextController,
                      focusNode: _model.phoneFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Celular',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(value.replaceAll(' ', ''))) {
                            return 'Por favor ingrese un número válido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: _saveUserData,
                    text: 'Guardar Cambios',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
