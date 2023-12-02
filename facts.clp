

(deffacts pacientes
    (paciente (Posicion Unidad-del-paciente) (Estado Pendiente-de-cirugia))
)

(deffacts enfermera-asistente
    (enfermera (Posicion Unidad-del-paciente) (Accion Desconocido) (Estado Desconocido))
)

(deffacts anestesiologo-encargado
    (anestesiologo (Posicion Unidad-de-Anestesia) (Accion Desconocido) (Estado Desconocido))
)

(deffacts Jefe-Cirujano
    (Cirujano_Jefe (Posicion Oficina) (Accion Desconocido) (Estado Desconocido))
)

(deffacts Segundo-Cirujano
    (Cirujano2 (Posicion Desconocido) (Accion Desconocido) (Estado Desconocido))
)

