class AnalysisResult {
    final String resumenNeutral;
    final List<String> categoriasAplicables;
    final Map<String, dynamic> datosAnalisis;
    final Map<String, EjeAnalisis>? ejes; // Nuevo campo para los 4 ejes

    AnalysisResult({
      required this.resumenNeutral,
      required this.categoriasAplicables,
      required this.datosAnalisis,
      this.ejes,
    });

    Map<String, dynamic> toJson() {
      return {
        'resumen_neutral': resumenNeutral,
        'categorias_aplicables': categoriasAplicables,
        ...datosAnalisis,
        if (ejes != null) 'ejes': ejes!.map((k, v) => MapEntry(k, v.toJson())),
      };
    }

    factory AnalysisResult.fromJson(Map<String, dynamic> json) {
      return AnalysisResult(
        resumenNeutral: json['resumen_neutral'] ?? '',
        categoriasAplicables: List<String>.from(json['categorias_aplicables'] ?? []),
        datosAnalisis: json,
        ejes: json['ejes'] != null
          ? json['ejes'].map((k, v) => MapEntry(k, EjeAnalisis.fromJson(v)))
          : null,
      );
    }
  }

class EjeAnalisis {
    final int puntaje; // 1-10
    final String justificacion;

    EjeAnalisis({required this.puntaje, required this.justificacion});

    Map<String, dynamic> toJson() => {'puntaje': puntaje, 'justificacion': justificacion};
    factory EjeAnalisis.fromJson(Map<String, dynamic> json) =>
        EjeAnalisis(puntaje: json['puntaje'] ?? 0, justificacion: json['justificacion'] ?? '');
}