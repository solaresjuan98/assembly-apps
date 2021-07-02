; calculadora
include mismacr.asm
; todo: validar la extension arq y los ids
.model small

.stack 100h
; ============= DATA SEGMENT =============
.data

    ; Texto
    encabezado  db "  *********************************************** ", 0dh, 0ah
	        db "  Universidad de San Carlos de Guatemala",0dh,0ah
	        db "  Facultad de Ingenieria",0dh,0ah
	        db "  Arquitectura de ensambladores y computadores 1",0dh,0ah
	        db "  Vacaciones Junio 2021",0dh,0ah
	        db "  Seccion N ",0dh,0ah
	        db "  Nombre: Juan Antonio Solares Samayoa",0dh,0ah
	        db "  No. de carnet 201800496",0dh,0ah
	        db "  Practica #3 Assembler ", 0dh , 0ah, "$"
    
    menu    db " ********** MENU ********** ", 0dh, 0ah
            db " * 0. Mostrar Encabezado  * ", 0dh, 0ah
            db " * 1. Cargar Archivo      * ", 0dh, 0ah
            db " * 2. Modo Calculadora    * ", 0dh, 0ah
            db " * 3. Crear Reporte       * ", 0dh, 0ah
            db " * 4. Ver Resultados      * ", 0dh, 0ah
            db " * 5. Salir               * ", 0dh, 0ah
            db " * Elige una opcion       * ", 0dh, 0ah, "$"

    ; mensajes
    modoCalc    db " >> Modo calculadora", 0dh, 0ah, "$"
    modoFact    db " >> Modo Factorial", 0dh, 0ah, "$"
    modoArchivo db " >> Modo Archivo ", 0dh, 0ah, "$"
    modoRep     db " >> Modo Reporte ", 0dh, 0ah, "$"

    mensajePedirArchivo    db ' >> Ingresa el nombre del archivo: ', 0dh, 0ah, "$"
    mensajeSuma            db " >> Suma ", 0dh, 0ah, "$"
    mensajeResta           db " >> Resta ", 0dh, 0ah, "$"
    mensajeMultiplicacion  db " >> Multiplicacion ", 0dh, 0ah, "$"
    mensajeDivision        db " >> Division ", 0dh, 0ah, "$"
    mensajeConfirmacion    db " >> Deseas guardar el resultado [s/n]? ", 0dh, 0ah, "$"
    mensajeGuardado        db " >> Guardando... ", 0dh, 0ah, "$"
    mensajeListaResultados db " >> ---- Listado de resultados ---- ", 0dh, 0ah, "$"
    mensajeGuadarReporte   db " >> Escribe el nombre del reporte: ", 0dh, 0ah, "$"
    mensajeIdentificador   db " >> Escribe el id. de la operacion: ", 0dh, 0ah, "$"

    ; Mensajes de error
    err1 db 0ah,0dh, 'El archivo no existe' , '$'
    err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
    err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
    err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
    err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'

    ; manejo de archivos 
    bufferentrada db 50 dup('$')
    handlerentrada dw ?
    bufferInformacion db 500 dup('$')

    ingresoNum      db " >> Ingresa un valor: ", "$"
    ingresoOperador db " >> Ingresa un operador", "$"
    finalizarOp     db " (Presiona ';' para finalizar): ", "$"

    saltoLinea db " ", 0dh, 0ah, "$"
    tiempo db '00:00:00', 0ah, 0dh, "$" 
    fecha  db '01/01/2000', 0ah, 0dh, "$"

    ; estructura de reporte HTML
    HTMLencabezado1  db '<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8" />', 0dh, 0ah, "$"
                    

    HTMLencabezado2  db "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x' crossorigin='anonymous' />", 0dh, 0ah, "$"
                
    HTMLencabezado3  db 0ah, 0dh,'<title> Document</title> </head>', 0dh, 0ah, "$"

    HTMLbodyAbre db 0ah,0dh, '<body>', 0ah,0dh, '$' ; signo de dolar se utiliza si se va a mostar en consola

    HTMLAbreContainer db '<div class="container mt-5">', 0dh, 0ah, "$"
    
    HTMLDatos1 db "<h1>PRACTICA 3 ARQUI 1 SECCION N</h1>", 0dh, 0ah, "$"
    HTMLFecha  db '<h2>Hora: </h2>', 0dh, 0ah, "$"
    HTMLDatos2 db "<h2>Estudiante: </h2> <span>Juan Antonio Solares</span>", 0dh, 0ah, "$"
    HTMLDatos3 db "<h2>Carnet: </h2> <span>201800496</span>", 0dh, 0ah, "$"

    HTMLAbreTabla1 db '<table class="table mt-5">', 0dh, 0ah, "$"
    HTMLAbreTabla2 db '<thead class="thead-dark">', 0dh, 0ah, "$"


    HTMLAbreTr      db 0ah,0dh, '<tr> ', 0dh, 0ah, "$"
    HTMLCierraTr    db 0ah,0dh, '</tr> ', 0dh, 0ah, "$"

    HTMLTh1 db '<th scope="col"> Id operacion</th>', 0dh, 0ah, "$"
    HTMLTh2 db '<th scope="col"> Operacion</th>', 0dh, 0ah, "$"
    HTMLTh3 db '<th scope="col"> Resultado</th>', 0dh, 0ah, "$"

    HTMLCierraTh db '</th>', 0dh, 0ah, "$"

    HTMLAbreTbody   db '<tbody>', 0dh, 0ah, "$"
    HTMLCierraTbody db '</tbody>', 0dh, 0ah, "$"

    HTMLAbreTd db '<td>', 0dh, 0ah, "$"
    HTMLCierraTd db '</td>', 0dh, 0ah, "$"


    HTMLCierraThead db '</thead>', 0ah, 0dh, "$"

    HTMLCierraTabla db '</table>', 0ah, 0dh, "$"

    HTMLCierraContainer db '</div>', 0ah, 0dh, "$"
    HTMLbodyCierra db 0ah,0dh, '</body>', 0ah,0dh, "$" ; signo de dolar se utiliza si se va a mostar en consola

    HTMLCierre db '</html>', 0ah, 0dh, "$"

    ; numerales
    uno     db 'op1', 0ah, 0dh, "$"
    dos     db 'op2', 0ah, 0dh, "$"; aqui me quede xd
    tres    db 'op3', 0ah, 0dh, "$"
    cuatro  db 'op4', 0ah, 0dh, "$"
    cinco   db "5", 0ah, 0dh, "$"
    seis    db "6", 0ah, 0dh, "$"
    siete   db "7", 0ah, 0dh, "$"
    ocho    db "8", 0ah, 0dh, "$"
    nueve   db "9", 0ah, 0dh, "$"
    diez    db "10", 0ah, 0dh, "$"

    ; Variables numericas
    opcion  db 0
    bandera db 0
    
    operador     db "$$"
    confirmacion db "$$"

    numero_operaciones db 0

    num1    db 0
    decena1 db 0
    unidad1 db 0

    num2    db 0
    decena2 db 0
    unidad2 db 0

    num3    db 0
    decena3 db 0
    unidad3 db 0

    valorImprimir   db 3 dup(0), "$"
    aux             db 100, 10, 1

    resultado db 0

    ; Resultados
    resultado1  db 3 dup(?), "$"
    ;resultado1  db 3 dup(?), "$"
    resultado2  db 3 dup(?), "$"
    resultado3  db 3 dup(?), "$"
    resultado4  db 3 dup(?), "$"
    resultado5  db 3 dup(?), "$"
    resultado6  db 3 dup(?), "$"
    resultado7  db 3 dup(?), "$"
    resultado8  db 3 dup(?), "$"
    resultado9  db 3 dup(?), "$"
    resultado10 db 3 dup(?), "$"

    ; Resultados en string
    res1Str     db 3 dup(0), "$"
    res2Str     db 3 dup(0), "$"
    res3Str     db 3 dup(0), "$"
    res4Str     db 3 dup(0), "$"
    res5Str     db 3 dup(0), "$"
    res6Str     db 3 dup(0), "$"
    res7Str     db 3 dup(0), "$"
    res8Str     db 3 dup(0), "$"
    res9Str     db 3 dup(0), "$"
    res10Str    db 3 dup(0), "$"

    ; identificadores
    nombreId1 db 50 dup('$')


    ;resStr db 3 dup(0), "$"

; ============= CODE SEGMENT =============
.code

main proc

    ; --------------------------------------------------------------------------------
    MenuPrincipal:
        mov bandera, 0
        ;print encabezado
        print saltoLinea
        print menu

        ingresarCaracter opcion

        ; Validar la opcion ingresada

        mov al, opcion

        ; comparar con 0
        cmp opcion, 0
        je MostrarEncabezado

        ; comparar con 1
        cmp opcion, 1
        je CargarArchivo

        ; comparar con 2
        cmp opcion, 2
        je ModoCalculadora

        ; comparar con 3
        cmp opcion, 3
        je ModoReporte

        ; comparar con 4
        cmp opcion, 4
        je VerResultados

        ; comparar con 5
        cmp opcion, 5
        je FinalizarPrograma

    ; --------------------------------------------------------------------------------
    MostrarEncabezado:
        print saltoLinea
        print encabezado
        print saltoLinea

        jmp MenuPrincipal
    ; --------------------------------------------------------------------------------
    CargarArchivo:
        print modoArchivo
        print saltoLinea

        ; Pedir ruta de archivo
        print mensajePedirArchivo
        print saltoLinea
        limpiar bufferentrada, SIZEOF bufferentrada, 24h
        obtenerRuta bufferentrada

        ; Abrir archivo
        abrirArchivo bufferentrada, handlerentrada
        limpiar bufferInformacion, SIZEOF bufferInformacion, 24h ;        leerArchivo handlerentrada, bufferInformacion, SIZEOF bufferInformacion
        leerArchivo handlerentrada, bufferInformacion, SIZEOF bufferInformacion
        ;print handlerentrada

        print saltoLinea
        analisisArchivo handlerentrada
        ; Cerrar Archivo
        cerrarArchivo handlerentrada

        jmp MenuPrincipal

    ; --------------------------------------------------------------------------------
    ; Inicio Modo Calculadora
    ModoCalculadora:
        ;print modoCalc
        ;print saltoLinea
        ;mov resultado, 0
        cmp bandera, 0
        je  Secuencia1
        cmp bandera, 1
        je  Secuencia2

        ; ----------------------------------
        Secuencia1:
            print saltoLinea
            print ingresoNum
            
            ; pedir numero de dos cifras
            ingresoNumero decena1, unidad1, num1
            
            ; pedir operador
            print saltoLinea
            print ingresoOperador
            
            ingresarOperador operador

            ; pedir ingreso de otro numero
            print saltoLinea
            print ingresoNum
            ingresoNumero decena2, unidad2, num2
            print saltoLinea

            ; validar que tipo de operacion es 
            ;print operador
            mov al, operador
            cmp operador, 2bh       ; (+) realizar suma
            je Suma

            cmp operador, 2dh       ; (-) realizar resta
            je Resta
            
            cmp operador, 2ah       ; (*) realizar multiplicacion
            je Multiplicacion

            cmp operador, 2fh       ; (/) realizar division
            je Division

        ; ----------------------------------
        Secuencia2:
            
            print ingresoOperador
            print finalizarOp
            ingresarOperador operador

            print saltoLinea
            print ingresoNum
            ingresoNumero decena3, unidad3, num3
            print saltoLinea

            ; validar que tipo de operacion es 
            ;print operador
            mov al, operador
            cmp operador, 2bh        ; (+) realizar suma
            je Suma1

            cmp operador, 2dh       ; (-) realizar resta
            je Resta1
            
            cmp operador, 2ah       ; (*) realizar multiplicacion
            je Multiplicacion1

            cmp operador, 2fh       ; (/) realizar division
            je Division1

            cmp operador, 3bh       ; (;) finalizar operacion
            je Confirmar
            

        
        ; ----- INICIO DE OPERACIONES ------
        Suma:
            ;print saltoLinea
            ;print mensajeSuma

            ; realizar suma
            mov al, num1
            add al, num2
            mov resultado, al

            ;xor ax, ax
            imprimir8Bits resultado
            print saltoLinea
            
            mov bandera, 1
            jmp ModoCalculadora

        ; ----------------------------------
        Suma1:

            ; realizar suma
            mov al, resultado
            add al, num3
            mov resultado, al

            imprimir8Bits resultado
            print saltoLinea
            
            jmp ModoCalculadora
        ; ----------------------------------
        Resta:
            print saltoLinea
            print mensajeResta

            ; realizar resta
            mov al, num1
            sub al, num2
            mov resultado, al

            imprimir8Bits resultado
            print saltoLinea

            mov bandera, 1
            jmp ModoCalculadora

        ; ----------------------------------
        Resta1:
        
            mov al, resultado
            sub al, num3
            mov resultado, al

            imprimir8Bits resultado
            print saltoLinea

            jmp ModoCalculadora

        ; ----------------------------------
        Multiplicacion:
            ;print saltoLinea
            ;print mensajeMultiplicacion

            mov al, num1
            mov bl, num2
            mul bl
            mov resultado, al

            imprimir8Bits resultado
            print saltoLinea

            mov bandera, 1
            jmp ModoCalculadora

        ; ----------------------------------
        Multiplicacion1:
            
            mov al, resultado
            mov bl, num3
            mul bl
            
            mov resultado, al
            mov al, resultado

            jmp ModoCalculadora


        ; ----------------------------------
        Division:
            ;print saltoLinea
            ;print mensajeDivision

            mov al, num1
            mov bl, num2
            div bl
            mov resultado, al

            imprimir8Bits resultado
            print saltoLinea

            mov bandera, 1
            jmp ModoCalculadora

        ; ----------------------------------
        Division1:

            mov al, resultado
            mov bl, num3
            div bl
            mov resultado, al

            imprimir8Bits resultado
            jmp ModoCalculadora

        ; ------- FIN DE OPERACIONES -------
        
        ; ----------------------------------
        Confirmar:

            ; Confirmar si se desea guardar el resultado
            print mensajeConfirmacion

            ingresarOperador confirmacion

            mov confirmacion, al

            cmp confirmacion, 73h       ; s
            je GuardarResultado

            cmp confirmacion, 53h       ; S
            je GuardarResultado

        ; ----------------------------------
        GuardarResultado:

            cmp numero_operaciones, 10
            je MenuPrincipal
            jg MenuPrincipal
            jmp Incrementar

        ; ----------------------------------
        Incrementar:

            print mensajeGuardado
            ; Incrementar la cantidad de operaciones hechas
            mov al, numero_operaciones
            add al, 1
            mov numero_operaciones, al

            ; Guardar resultados
            cmp numero_operaciones, 1
            je Guardar1

            cmp numero_operaciones, 2
            je Guardar2

            cmp numero_operaciones, 3
            je Guardar3

            cmp numero_operaciones, 4
            je Guardar4

            cmp numero_operaciones, 5
            je Guardar5

            cmp numero_operaciones, 6
            je Guardar6

            cmp numero_operaciones, 7
            je Guardar7

            cmp numero_operaciones, 8
            je Guardar8

            cmp numero_operaciones, 9
            je Guardar9

            cmp numero_operaciones, 10
            je Guardar10

        

        ; ------- GUARDAR RESULTADO ------
        Guardar1:
            mov al, resultado
            mov resultado1, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar2:
            mov al, resultado
            mov resultado2, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar3:
            mov al, resultado
            mov resultado3, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar4:
            mov al, resultado
            mov resultado4, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar5:
            mov al, resultado
            mov resultado5, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar6:
            mov al, resultado
            mov resultado6, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar7:
            mov al, resultado
            mov resultado7, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar8:
            mov al, resultado
            mov resultado8, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar9:
            mov al, resultado
            mov resultado9, al
            jmp MenuPrincipal

        ; ----------------------------------
        Guardar10:
            mov al, resultado
            mov resultado10, al
            jmp MenuPrincipal


        jmp MenuPrincipal
    ; Fin Modo Calculadora
    ; --------------------------------------------------------------------------------
    ModoReporte:
        print modoRep
        print saltoLinea
        print mensajeGuadarReporte
        limpiar bufferentrada, SIZEOF bufferentrada,24h 
        obtenerRuta bufferentrada
        crearArchivo bufferentrada, handlerentrada 
        
        ; escribir encabezado 
        escribirArchivo handlerentrada, HTMLencabezado1, SIZEOF HTMLencabezado1
        escribirArchivo handlerentrada, HTMLencabezado2, SIZEOF HTMLencabezado2
        escribirArchivo handlerentrada, HTMLencabezado3, SIZEOF HTMLencabezado3
        escribirArchivo handlerentrada, HTMLbodyAbre, SIZEOF HTMLbodyAbre
        
        ; <div class="container mt-5">
        escribirArchivo handlerentrada, HTMLAbreContainer, SIZEOF HTMLAbreContainer

        ; datos
        escribirArchivo handlerentrada, HTMLDatos1, SIZEOF HTMLDatos1
        escribirArchivo handlerentrada, HTMLDatos2, SIZEOF HTMLDatos2
        escribirArchivo handlerentrada, HTMLDatos3, SIZEOF HTMLDatos3

        ; hora

        escribirArchivo handlerentrada, HTMLFecha, SIZEOF HTMLFecha
        
        mov ax, @data
        mov ds, ax
        lea bx, tiempo

        CALL Obtener_Hora

        lea dx, tiempo
        mov ah, 09h
        int 21h

        escribirArchivo handlerentrada, tiempo, SIZEOF tiempo


        ; tabla
        escribirArchivo handlerentrada, HTMLAbreTabla1, SIZEOF HTMLAbreTabla1
        
        escribirArchivo handlerentrada, HTMLAbreTabla2, SIZEOF HTMLAbreTabla2
        
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
        
        ; headers de la tabla
        escribirArchivo handlerentrada, HTMLTh1, SIZEOF HTMLTh1
        escribirArchivo handlerentrada, HTMLTh2, SIZEOF HTMLTh2
        escribirArchivo handlerentrada, HTMLTh3, SIZEOF HTMLTh3

        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr

        ; </thead> 
        escribirArchivo handlerentrada, HTMLCierraThead, SIZEOF HTMLCierraThead
        
        ; <tbody>
        escribirArchivo handlerentrada, HTMLAbreTbody, SIZEOF HTMLAbreTbody

        ; RESULTADO 1
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 1
            escribirArchivo handlerentrada, uno, SIZEOF uno            
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd


            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
                
                ; resultado
                numeroaString resultado1, res1Str
                escribirArchivo handlerentrada, res1Str, SIZEOF res1Str
            
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------


        ; RESULTADO 2
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 2
            escribirArchivo handlerentrada, dos, SIZEOF dos 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado2, res2Str
                escribirArchivo handlerentrada, res2Str, SIZEOF res2Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 3
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 3
            escribirArchivo handlerentrada, tres, SIZEOF tres 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                ;imprimir8Bits resultado3
                numeroaString resultado3, res3Str
                escribirArchivo handlerentrada, res3Str, SIZEOF res3Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------


        ; RESULTADO 4
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 4
            escribirArchivo handlerentrada, cuatro, SIZEOF cuatro 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado4, res4Str
                imprimir8Bits res4Str
                escribirArchivo handlerentrada, res4Str, SIZEOF res4Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 5
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 5
            escribirArchivo handlerentrada, cinco, SIZEOF cinco 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado5, res5Str
                imprimir8Bits res5Str
                escribirArchivo handlerentrada, res5Str, SIZEOF res5Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 6
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 6
            escribirArchivo handlerentrada, seis, SIZEOF seis 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado6, res6Str
                imprimir8Bits res6Str
                escribirArchivo handlerentrada, res6Str, SIZEOF res6Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------


        ; RESULTADO 7
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 7
            escribirArchivo handlerentrada, siete, SIZEOF siete 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado7, res7Str
                imprimir8Bits res7Str
                escribirArchivo handlerentrada, res7Str, SIZEOF res7Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 8
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 4
            escribirArchivo handlerentrada, ocho, SIZEOF ocho 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado8, res8Str
                ;imprimir8Bits res5Str
                escribirArchivo handlerentrada, res8Str, SIZEOF res8Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 9
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 4
            escribirArchivo handlerentrada, nueve, SIZEOF nueve 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                numeroaString resultado9, res9Str
                ;imprimir8Bits res5Str
                escribirArchivo handlerentrada, res9Str, SIZEOF res9Str

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------

        ; RESULTADO 10
        ; ---------------- CELDAS DONDE VAN LOS DATOS ----------------
        ; <tr>
        escribirArchivo handlerentrada, HTMLAbreTr, SIZEOF HTMLAbreTr
            
            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; 4
            escribirArchivo handlerentrada, diez, SIZEOF diez 
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd
            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd

            ; <td>
            escribirArchivo handlerentrada, HTMLAbreTd, SIZEOF HTMLAbreTd

                ; resultado
                ;numeroaString resultado5, res5Str
                ;imprimir8Bits res5Str
                escribirArchivo handlerentrada, valorImprimir, SIZEOF valorImprimir

            ; </td>
            escribirArchivo handlerentrada, HTMLCierraTd, SIZEOF HTMLCierraTd
        ; </tr>
        escribirArchivo handlerentrada, HTMLCierraTr, SIZEOF HTMLCierraTr
        ; -----------------------------------------------------------


        ; </tbody>
        escribirArchivo handlerentrada, HTMLCierraTbody, SIZEOF HTMLCierraTbody

        ; </table>
        escribirArchivo handlerentrada, HTMLCierraTbody, SIZEOF HTMLCierraTbody

        ; </div>
        escribirArchivo handlerentrada, HTMLCierraContainer, SIZEOF HTMLCierraContainer


        escribirArchivo handlerentrada, HTMLbodyCierra, SIZEOF HTMLbodyCierra
        
        escribirArchivo handlerentrada, HTMLCierre, SIZEOF HTMLCierre

        cerrarArchivo handlerentrada

        jmp MenuPrincipal
    ; --------------------------------------------------------------------------------
    VerResultados:

        print saltoLinea
        print mensajeListaResultados
        
        imprimir8Bits resultado1
        print saltoLinea
        
        imprimir8Bits resultado2
        print saltoLinea
        
        imprimir8Bits resultado3
        print saltoLinea
        
        imprimir8Bits resultado4
        print saltoLinea
        
        imprimir8Bits resultado5
        print saltoLinea
        
        imprimir8Bits resultado6
        print saltoLinea
        
        imprimir8Bits resultado7
        print saltoLinea
        
        imprimir8Bits resultado8
        print saltoLinea
        
        imprimir8Bits resultado9
        print saltoLinea
        
        imprimir8Bits resultado10
        print saltoLinea

        jmp MenuPrincipal
    
    ; --------------------------------------------------------------------------------

    ; ============== ERRORES DE MANEJO DE ARCHIVOS ==============
    Error1:

        print saltoLinea
        print err1
        jmp MenuPrincipal

    Error2:

        print saltoLinea
        print err2
        jmp MenuPrincipal

    Error3:

        print saltoLinea
        print err3
        jmp MenuPrincipal

    Error4:

        print saltoLinea
        print err4
        jmp MenuPrincipal


    ; --------------------------------------------------------------------------------
    FinalizarPrograma:
        mov ax, 4c00h
        int 21h

    ;---------------------------------------------------------------------------------

    ; ============= PROCEDIMIENTOS =============
    ; Procedimiento para obtener la hora
    Obtener_Hora PROC
    ; this procedure will get the current system time 
    ; input : BX=offset address of the string TIME
    ; output : BX=current time

        PUSH AX                       ; PUSH AX onto the STACK
        PUSH CX                       ; PUSH CX onto the STACK 

        MOV AH, 2CH                   ; get the current system time
        INT 21H                       

        MOV AL, CH                    ; set AL=CH , CH=hours
        CALL Convertir                  ; call the procedure CONVERT
        MOV [BX], AX                  ; set [BX]=hr  , [BX] is pointing to hr
                                        ; in the string TIME

        MOV AL, CL                    ; set AL=CL , CL=minutes
        CALL Convertir                  ; call the procedure CONVERT
        MOV [BX+3], AX                ; set [BX+3]=min  , [BX] is pointing to min
                                    ; in the string TIME
                                            
        MOV AL, DH                    ; set AL=DH , DH=seconds
        CALL Convertir                  ; call the procedure CONVERT
        MOV [BX+6], AX                ; set [BX+6]=min  , [BX] is pointing to sec
                                    ; in the string TIME
                                                        
        POP CX                        ; POP a value from STACK into CX
        POP AX                        ; POP a value from STACK into AX

        RET                           ; return control to the calling procedure
    Obtener_Hora ENDP                  ; end of procedure Obtener_Hora

    
    ;description
    Obtener_Fecha PROC
        
        PUSH AX                       ; PUSH AX onto the STACK
        PUSH CX                       ; PUSH CX onto the STACK 

        MOV AH, 2AH                   ; get the current system time
        INT 21H                       

        MOV AL, dl                    ; set AL=CH , CH=hours
        CALL Convertir                  ; call the procedure CONVERT
        MOV [BX], AX                  ; set [BX]=hr  , [BX] is pointing to hr
                                        ; in the string TIME

        MOV AL, dh                    ; set AL=CL , CL=minutes
        CALL Convertir                  ; call the procedure CONVERT
        MOV [BX+3], AX                ; set [BX+3]=min  , [BX] is pointing to min
                                    ; in the string TIME                    
        MOV AL, DH                    
        MOV [BX+6], AX               
                                                        
        POP CX                        ; POP a value from STACK into CX
        POP AX                        ; POP a value from STACK into AX

        RET

    Obtener_Fecha ENDP


    Convertir PROC 
        ; this procedure will convert the given binary code into ASCII code
        ; input : AL=binary code
        ; output : AX=ASCII code

        PUSH DX                       ; PUSH DX onto the STACK 

        MOV AH, 0                     ; set AH=0
        MOV DL, 10                    ; set DL=10
        DIV DL                        ; set AX=AX/DL
        OR AX, 3030H                  ; convert the binary code in AX into ASCII

        POP DX                        ; POP a value from STACK into DX 

        RET                           ; return control to the calling procedure
    Convertir ENDP


main endp
end