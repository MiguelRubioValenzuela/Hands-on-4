


(defrule Enfermera-lleva-paciente-quirofano
    ?paciente   <- (paciente (Posicion ?a) (Estado Pendiente-de-cirugia))
    ?enfermera  <- (enfermera (Posicion ?a) (Accion Desconocido))
    => 
    (printout t "(plan (Enfermera-lleva-paciente-quirofano) ")

    (modify ?paciente   (Posicion Quirofano))
    (modify ?enfermera  (Posicion Quirofano) (Accion llevo-paciente-a-quirofano))
)

(defrule personal-listo
    (paciente   (Posicion Quirofano) (Estado Pendiente-de-cirugia))
    (enfermera  (Posicion Quirofano) (Accion llevo-paciente-a-quirofano))
    ?anestesiologo  <- (anestesiologo (Posicion Unidad-de-Anestesia))
    ?Cirujano_Jefe  <- (Cirujano_Jefe (Posicion Oficina))
    ?Cirujano2      <- (Cirujano2 (Posicion Desconocido))
    => 
    (printout t "(personal-listo) " crlf)
    (modify ?anestesiologo  (Posicion Quirofano))
    (modify ?Cirujano_Jefe  (Posicion Quirofano))
    (modify ?Cirujano2      (Posicion Quirofano))
) 

(defrule Cirujano2-confirma-intervenir
    (paciente       (Posicion ?pos) (Estado Pendiente-de-cirugia))
    (enfermera      (Posicion ?pos))
    (anestesiologo  (Posicion ?pos))
    ?Cirujano_Jefe  <- (Cirujano_Jefe (Posicion ?pos) (Estado Desconocido))
    ?Cirujano2      <- (Cirujano2 (Posicion ?pos) (Accion Desconocido))
    =>
    (printout t "(Cirujano2-confirma-intervenir) " )
    (modify ?Cirujano2      (Accion informa-inicio-intervencion))
    (modify ?Cirujano_Jefe  (Estado Informado-de-intervencion))
)

(defrule ordenar-confirmacion-anestesia
    (paciente   (Estado Pendiente-de-cirugia))
    ?anestesiologo <- (anestesiologo (Posicion ?pos) (Estado Desconocido))
    ?Cirujano_Jefe <- (Cirujano_Jefe (Posicion ?pos) (Estado Informado-de-intervencion))
    =>
    (printout t "(ordenar-confirmacion-anestesia) ")
    (modify ?Cirujano_Jefe (Accion ordena-confirmar-anestesia))
    (modify ?anestesiologo (Estado informado-de-confirmar-anestesia))
)

(defrule anestesia-paciente
    ?paciente       <- (paciente (Posicion ?pos) (Estado Pendiente-de-cirugia) )
    ?anestesiologo  <- (anestesiologo (Posicion ?pos) (Estado informado-de-confirmar-anestesia))
    =>
    (printout t "(anestesia)" crlf)
    (modify ?paciente       (Estado anestesiado))
    (modify ?anestesiologo  (Accion anestesio-al-paciente))
)

(defrule confirma-anestesia
    (paciente (Posicion ?pos) (Estado anestesiado))
    ?anestesiologo <- (anestesiologo (Posicion ?pos) (Accion anestesio-al-paciente))
    ?Cirujano_Jefe <- (Cirujano_Jefe (Posicion ?pos) (Accion ordena-confirmar-anestesia))
    =>
    (printout t "(confirma-anestesia) ")
    (modify ?anestesiologo (Accion confirma-anestesia))
    (modify ?Cirujano_Jefe (Estado confirma-paciente-anestesiado) (Accion interviniendo))
)

(defrule comenzar-intervencion
    (Cirujano_Jefe (Posicion ?pos) (Estado confirma-paciente-anestesiado))
    ?Cirujano2 <- (Cirujano2 (Posicion ?pos) (Accion informa-inicio-intervencion))
    =>
    (printout t "(comenzar-intervencion) ")
    (modify ?Cirujano2 (Accion interviniendo) (Estado requiere-instrumentos))
)

(defrule solicita-instrumentos
    ?Cirujano2 <- (Cirujano2 (Posicion ?pos) (Accion interviniendo) (Estado requiere-instrumentos))
    ?enfermera <- (enfermera (Posicion ?pos))
    =>
    (printout t "(solicita-instrumentos) " crlf)
    (modify ?Cirujano2 (Accion solicita-instrumentos))
    (modify ?enfermera (Estado instrumentos-solicitados))
)

(defrule enfermera-provee-instrumentos
    ?Cirujano2 <- (Cirujano2 (Posicion ?pos) (Accion solicita-instrumentos))
    ?enfermera <- (enfermera (Posicion ?pos) (Estado instrumentos-solicitados))
    =>
    (printout t "(enfermera-provee-instrumentos) ")
    (modify ?Cirujano2 (Accion interviniendo) (Estado comienza-intervencion))
    (modify ?enfermera (Accion entrega-instrumentos) (Estado sin-pendientes))
)

(defrule termina-intervencion
    ?Cirujano2 <- (Cirujano2 (Posicion ?pos) (Accion interviniendo) (Estado comienza-intervencion))
    =>
    (printout t "(termina-intervencion) ")
    (modify ?Cirujano2 (Accion termina-intervencion) (Estado termina-intervencion))
)

(defrule informa-finalizacion-intervencion
    ?Cirujano2      <- (Cirujano2 (Posicion ?pos) (Accion ?inter) (Estado ?inter))
    ?Cirujano_Jefe  <- (Cirujano_Jefe (Posicion ?pos))
    =>
    (printout t "(informa-finalizacion-intervencion) " crlf)
    (modify ?Cirujano2      (Accion informa-finalizacion))
    (modify ?Cirujano_Jefe  (Estado finaliza-intervencion))
)

(defrule traslada-paciente-recuperacion
    (Cirujano_Jefe (Posicion ?pos) (Estado finaliza-intervencion) )
    ?enfermera  <- (enfermera (Posicion ?pos))
    ?paciente   <- (paciente (Posicion ?pos))
    =>
    (printout t "(traslada-paciente-recuperacion) ")
    (modify ?enfermera  (Posicion recuperacion) (Accion traslada-a-recuperacion))
    (modify ?paciente   (Posicion recuperacion))
)

(defrule finaliza
    ?paciente       <- (paciente (Posicion recuperacion))
    ?enfermera      <- (enfermera (Posicion recuperacion) (Accion traslada-a-recuperacion))
    ?anestesiologo  <- (anestesiologo (Posicion ?pos))
    ?Cirujano_Jefe  <- (Cirujano_Jefe (Posicion ?pos))    
    ?Cirujano2      <- (Cirujano2 (Posicion ?pos))
    =>
    (printout t "(finaliza)) "crlf)
    (modify ?enfermera      (Accion finalizado) (Estado terminado))
    (modify ?paciente       (Estado intervenido))
    (modify ?anestesiologo  (Accion finalizado) (Estado terminado))
    (modify ?Cirujano_Jefe  (Accion finalizado) (Estado terminado))
    (modify ?Cirujano2      (Accion finalizado) (Estado terminado))
)