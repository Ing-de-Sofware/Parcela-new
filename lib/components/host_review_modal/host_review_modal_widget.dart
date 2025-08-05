import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'host_review_modal_model.dart';
export 'host_review_modal_model.dart';

class HostReviewModalWidget extends StatefulWidget {
  const HostReviewModalWidget({
    super.key,
    this.travelerName,
    this.carPlate,
    this.carModel,
    this.carColor,
    this.phoneNumber,
    this.profileImageUrl,
  });

  final String? travelerName;
  final String? carPlate;
  final String? carModel;
  final String? carColor;
  final String? phoneNumber;
  final String? profileImageUrl;

  @override
  State<HostReviewModalWidget> createState() => _HostReviewModalWidgetState();
}

class _HostReviewModalWidgetState extends State<HostReviewModalWidget>
    with TickerProviderStateMixin {
  late HostReviewModalModel _model;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HostReviewModalModel());

    // Animación rebote estrellas
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  // Ejecuta animación bounce
  void _playBounceAnimation() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }

  // Widget categoría calificación
  Widget _buildRatingCategory(String title, double? currentRating, Function(double) onRatingUpdate) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título categoría
          Text(
            title,
            style: GoogleFonts.inter(
              color: Color(0xFF1A1A1A),
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
            textAlign: TextAlign.center,
          ),

          // Estrellas con animación
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: RatingBar.builder(
                    onRatingUpdate: (rating) {
                      _playBounceAnimation();
                      onRatingUpdate(rating);
                    },
                    itemBuilder: (context, index) => Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFD700), // Amarillo dorado
                    ),
                    direction: Axis.horizontal,
                    initialRating: currentRating ?? 0.0,
                    unratedColor: Color(0xFFE5E5E5), // Gris claro
                    itemCount: 5,
                    itemSize: 40.0,
                    glowColor: Color(0xFFFFD700),
                    allowHalfRating: false,
                    tapOnlyMode: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    wrapAlignment: WrapAlignment.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget opción aspecto
  Widget _buildAspectOption(String aspect) {
    bool isSelected = _model.selectedAspect == aspect;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _model.selectedAspect = aspect;
          });
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                    child: Text(
                      aspect,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.95,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF37365C), // Fondo modal
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header modal con botón cerrar
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 16.0),
              child: Column(
                children: [
                  // Barra superior con indicador y botón X
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Espacio vacío para centrar
                      SizedBox(width: 32.0),

                      // Indicador modal centrado
                      Container(
                        width: 50.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),

                      // Botón X cerrar
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Título principal
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Califica al viajero',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tarjeta información viajero
                    Container(
                      width: double.infinity,
                      margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Color(0x20000000),
                            offset: Offset(0.0, 8.0),
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Avatar con gradiente
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF37365C),
                                    Color(0xFF5A4FCF),
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(-1.0, -1.0),
                                  end: AlignmentDirectional(1.0, 1.0),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: Image.asset(
                                      widget.profileImageUrl ?? 'assets/images/profile-placeholder.jpg',
                                      width: 74.0,
                                      height: 74.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Nombre viajero
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 20.0),
                              child: Text(
                                widget.travelerName ?? 'Viajero',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Info vehículo y contacto
                            Column(
                              children: [
                                _buildInfoRow(Icons.directions_car, 'Placa', widget.carPlate ?? 'N/A'),
                                SizedBox(height: 12.0),
                                _buildInfoRow(Icons.car_rental, 'Vehículo',
                                    '${widget.carModel ?? 'Modelo'} - ${widget.carColor ?? 'Color'}'),
                                SizedBox(height: 12.0),
                                _buildInfoRow(Icons.phone, 'Teléfono', widget.phoneNumber ?? 'N/A'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sección calificaciones
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15.0,
                            color: Color(0x15000000),
                            offset: Offset(0.0, 4.0),
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Califica estos aspectos',
                            style: GoogleFonts.inter(
                              color: Color(0xFF37365C),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 24.0),

                          _buildRatingCategory(
                            'Puntualidad',
                            _model.punctualityRating,
                                (rating) => setState(() => _model.punctualityRating = rating),
                          ),
                          _buildRatingCategory(
                            'Limpieza',
                            _model.cleanlinessRating,
                                (rating) => setState(() => _model.cleanlinessRating = rating),
                          ),
                          _buildRatingCategory(
                            'Amabilidad',
                            _model.kindnessRating,
                                (rating) => setState(() => _model.kindnessRating = rating),
                          ),
                        ],
                      ),
                    ),

                    // Pregunta condicional y comentario
                    if (_model.punctualityRating != null &&
                        _model.cleanlinessRating != null &&
                        _model.kindnessRating != null) ...[
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15.0,
                                color: Color(0x15000000),
                                offset: Offset(0.0, 4.0),
                                spreadRadius: 0.0,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _model.averageRating < 4.0
                                    ? '¿Qué aspecto no cumplió tus expectativas?'
                                    : '¿Qué aspecto cumplió tus expectativas?',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF37365C),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                child: Column(
                                  children: [
                                    _buildAspectOption('Seguridad de la cochera'),
                                    _buildAspectOption('Limpieza de la cochera'),
                                    _buildAspectOption('Amabilidad del anfitrión'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Campo comentario
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15.0,
                                color: Color(0x15000000),
                                offset: Offset(0.0, 4.0),
                                spreadRadius: 0.0,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comentario adicional (opcional)',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF37365C),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: _model.commentTextController,
                                  focusNode: _model.commentFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Escribe tu comentario aquí...',
                                    hintStyle: GoogleFonts.inter(
                                      color: Color(0xFF999999),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E0E0),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF37365C),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF8F9FA),
                                    contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF1A1A1A),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                  ),
                                  maxLines: 4,
                                  minLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Botón calificar fijo
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 20.0),
              decoration: BoxDecoration(
                color: Color(0xFF37365C),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
              ),
              child: FFButtonWidget(
                onPressed: (_model.punctualityRating != null &&
                    _model.cleanlinessRating != null &&
                    _model.kindnessRating != null) ? () async {
                  // Mensaje éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reseña enviada exitosamente',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Color(0xFF4CAF50),
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  );

                  // Cerrar modal
                  Navigator.pop(context, true);
                } : null,
                text: 'Calificar',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: (_model.punctualityRating != null &&
                      _model.cleanlinessRating != null &&
                      _model.kindnessRating != null)
                      ? Color(0xFF4CAF50)
                      : Color(0xFF666666),
                  textStyle: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
                  elevation: (_model.punctualityRating != null &&
                      _model.cleanlinessRating != null &&
                      _model.kindnessRating != null) ? 6.0 : 0.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  disabledColor: Color(0xFF666666),
                  disabledTextColor: Color(0xFFCCCCCC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget fila información con iconos
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: Color(0xFF37365C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            icon,
            color: Color(0xFF37365C),
            size: 18.0,
          ),
        ),

        SizedBox(width: 12.0),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Color(0xFF666666),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.0,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Color(0xFF1A1A1A),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}