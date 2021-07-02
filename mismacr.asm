; Archivo de macros

print MACRO buffer ;imprime cadena
push ax
push dx
	mov ax, @data
	mov ds,ax
	mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
	mov dx,offset buffer ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
	int 21h
pop dx
pop ax
ENDM

ingresarCaracter MACRO valor
	mov ax, seg @data
	mov ds, ax

	mov ah, 01h
	int 21h
	sub al, 30h
	mov valor, al

ENDM

; sirve para ingresar caracteres
ingresarOperador MACRO op
	
	mov ah, 01h
    int 21h
    mov op, al
ENDM

getChar macro  ;obtiene el caracter

	mov ah,01h ; se guarda en al en codigo hexadecimal
	int 21h

endm

; ingreso de numero de 2 cifras (0-99)
ingresoNumero MACRO decena, unidad, numero

	; *** primer caracter ***
	mov ah, 01h 	; lee el primer caracter, correspondiente a las decenas
	int 21h     	; interrupcion  21h
	sub al, 30h 	; restar a al 30h
	mov decena, al 	; mover a la variable de decenas lo que está en al

	; *** segundo caracter ***
	mov ah, 01h 	; lee el caracter correspondiente a las unidades
	int 21h     	; interrupcion 21h
	sub al, 30h 	; restar a al 30 h
	mov unidad, al	; mover el valor del reg. al en la variable de unidades

	mov al, decena 	; mover al reg. al las decenas
	mov bl, 0ah 	; mover a bl
	mul bl      	; multiplicar bl
	add al, unidad	; sumar el valor de unidades al registro al
	mov numero, al 	; guardar el valor del reg. al en num

ENDM

; imprimir numero de 0 a 255
imprimir8Bits MACRO numero

	mov ax, 0
	mov al, numero
	div aux[0]  ; b
	mov valorImprimir[0], al

	mov bh, ah
	mov ax, 0
	mov al, bh
	div aux[1]
	mov valorImprimir[1], al
	mov valorImprimir[2], ah

	add valorImprimir[0], 48
	add valorImprimir[1], 48
	add valorImprimir[2], 48

	lea dx, valorImprimir
	mov ah, 9
	int 21h

ENDM

numeroaString MACRO numero, destino
	
	mov ax, 0
	mov al, numero
	div aux[0]  ; b
	mov destino[0], al

	mov bh, ah
	mov ax, 0
	mov al, bh
	div aux[1]
	mov destino[1], al
	mov destino[2], ah

	add destino[0], 48
	add destino[1], 48
	add destino[2], 48

ENDM

IntToString macro numero, arreglo
LOCAL Unidades,Decenas, Salir
	xor ax,ax
	xor bx,bx

	mov al,numero
	cmp al, 9 
	ja Decenas

	Unidades:
		add al,30h
		mov arreglo[0],al
		jmp Salir

	Decenas:
		mov bl,10
		div bl     ;divide entre 10 las decenas
		add al,30h ;le suma 30h a al, al cociente 
		add ah,30h ; le suma 30h al residuo 
		mov arreglo[0],al ;decenas
		mov arreglo[1],ah ;unidades 

		jmp Salir

	Salir:
endm


limpiar macro buffer, numbytes, caracter
LOCAL Repetir
push si
push cx

	xor si,si
	xor cx,cx
	mov	cx,numbytes

	Repetir:
		mov buffer[si], caracter
		inc si
		Loop Repetir
pop cx
pop si
endm

obtenerRuta macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ;
		mov buffer[si], al  
endm

obtenerId macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ;
		mov buffer[si], al  
endm

crearArchivo macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	;ya cree el archivo
	;jump carry si la bandera de accareo esta en 1 se ejecuta
	jc Error4
	mov handler, ax

endm

abrirArchivo macro buffer, handler

	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax

endm

leerArchivo macro handler, buffer, numbytes
	
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer 
	int 21h

endm

escribirArchivo macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc Error3

endm

cerrarArchivo macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	jc Error2
	mov handler,ax

endm

; ---------------------------------
analisisArchivo macro textoEntrada

	print textoEntrada

endm

ConvDecimal macro num
LOCAL Inicio, Final

	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov bx, 10
	xor si, si 

	Inicio:
		cmp cl, num[si]
		cmp cl, 48
		jl Final
		cmp cl, 57
		jg Final
		inc si 
		sub cl, 48
		mul bx
		add ax, cx
		jmp Inicio

	Final:

endm

ConvertirString MACRO buffer
LOCAL Div1, Div2, FinCr3, Negativo, Fin2, Fin	

	; limpiar registros
	xor si, si 
	xor bx, bx
	xor cx, cx
	xor dx, dx 
	mov dl, 10
	test ax, 1000000000000000
	jnz Negativo
	jmp Div2

	Negativo:
		neg ax
		mov buffer[si], 45	; guion
		inc si
		jmp Div2

	Div1:
		xor ah,ah

	Div2:
		div dl
		inc cx
		push ax
		cmp al, 00h
		je FinCr3
		jmp Div1
		
	FinCr3:
		pop ax
		add ah, 30h
		mov buffer[si], ah
		inc si
	
	loop FinCr3
	mov ah, 24h
	mov buffer[si], ah
	inc si

	Fin:


ENDM

; Obtener numeros
obtenerNumeros MACRO buffer, cantidad, arreglo, num
LOCAL Inicio, Reconocer, Guardar, Fin, Salir

	; Limpiar registros
	xor bx, bx
	xor si, si 
	xor di, di

	Inicio:

		mov bl, buffer[si]

		cmp bl, 36
		je Fin
		cmp bl, 48
		jl Salir
		cmp bl, 57
		jg Salir
		jmp Reconocer

	Reconocer:

		mov bl, buffer[si]
		cmp bl, 48
		jl Guardar
		cmp bl, 57
		jg Guardar
		inc si 
		mov num[di], bl
		inc di
		jmp Reconocer


	Guardar:

		push si
		ConvDecimal num
		xor bx, bx
		mov bl, cantidad
		mov arreglo[bx], al

		inc cantidad
		pop si
		xor bx, bx
		xor ax, ax
		jmp Inicio

	Salir:

		inc si
		xor di, di
		jmp Inicio

	Fin:

		xor ax, ax
		mov al, cantidad
		mov cantidad2, ax

ENDM

; Arreglos
copiarArr macro arrFuente, arrDestino
LOCAL Inicio, Finalizar
	xor si, si 
	xor bx, bx

	Inicio:

		mov bl, cantidad
		cmp si, bx
		je Finalizar
		mov al, arrFuente[si]
		mov arrDestino[si], al
		inc si
		jmp Finalizar

	Finalizar:

endm

; ordenamiento
obtenerMayor macro
LOCAL BubbleSort, Menor, Reiniciar, Terminar, Menor2

	; limpiar registros
	xor si, si 
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx 
	mov dx, cantidad2
	dec dx 
	BubbleSort:

		mov al, arreglo[si]
		mov bl, arreglo[si+1]
		cmp al, bl
		jl Menor
		inc si
		inc cx
		cmp cx, dx
		jne BubbleSort

		mov cx, 0
		mov si, 0 

		jmp Menor2
	
	Menor:

		mov arreglo[si], bl
		mov arreglo[si+1], al 
		inc si
		inc cx
		cmp cx, dx
		jne BubbleSort
		mov cx, 0
		mov si, 0
		jmp Menor2

	Menor2:

		mov al, arreglo[si]
		mov bl, arreglo[si+1]
		cmp al, bl
		jl Reiniciar
		inc si
		inc cx
		cmp cx, dx
		jne Menor2
		jmp Terminar

	Reiniciar:
		mov si, 0
		mov cx, 0
		jmp BubbleSort
		
	Terminar:

		xor ax, ax
		mov al, arreglo[0]
		mov maximo, ax



endm


Bubble macro
	; convertir velocidad a Hertz
	mov cl, 9
	sub cl, vel
	inc cl

	mov ax, 500
	mov bl, cl
	mul bl 
	mov tiempo, ax

	; ------------------------
	BubbleAsc

	

endm

; NO TOCAR
BubbleAsc macro
LOCAL BubbleSort, Menor, Reiniciar, Terminar, Menor2

	; limpiar registros
	xor si, si 
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx 
	mov dl, cantidad
	dec dx
	;Graficar	; Graficar primero sin ordenar
	GraficarArreglo arreglo

	BubbleSort:

		mov al, arreglo[si]
		mov bl, arreglo[si+1]
		cmp al, bl
		jg Menor
		inc si
		inc cx
		cmp cx, dx
		jne BubbleSort

		mov cx, 0
		mov si, 0 

		jmp Menor2
	
	Menor:

		mov arreglo[si], bl
		mov arreglo[si+1], al
		; Graficar 
		GraficarArreglo arreglo
		; ----
		inc si
		inc cx
		cmp cx, dx
		jne BubbleSort
		mov cx, 0
		mov si, 0
		jmp Menor2

	Menor2:

		mov al, arreglo[si]
		mov bl, arreglo[si+1]
		cmp al, bl
		jg Reiniciar
		inc si
		inc cx
		cmp cx, dx
		jne Menor2
		jmp Terminar

	Reiniciar:
		mov si, 0
		mov cx, 0
		jmp BubbleSort
		
	Terminar:
		; Graficar arreglo y esperar tecla para salir 
		GraficarArregloFinal arreglo


endm


; ========= MODO VIDEO =========
modoVideo macro

	mov ax, 0013h
	int 10h
	mov ax, 0A000h
	mov ds, ax

endm

finModoVideo macro

	mov ax, 0003h
	int 10h
	mov ax, @data
	mov ds, ax

endm

; Graficar
GraficarArreglo macro arreglo

	pushearRegistros
	; poner un macro que grafica letras
	
	
	;
	obtenerNumeros2
	DeterminarTamanio tamX, espacio, cantidad2, espaciador
	
	pushVideo arreglo
	modoVideo
	imprimirVidNum numerosM, 16h, 02h
	popVideo arreglo
	
	dibujarBarras cantidad2, espacio2, arreglo

	finModoVideo

	popRegistros

endm

GraficarArregloFinal macro arreglo

	pushearRegistros
	
	obtenerNumeros2
	DeterminarTamanio tamX, espacio, cantidad2, espaciador
	
	pushVideo arreglo
	modoVideo
	imprimirVidNum numerosM, 16h, 02h
	popVideo arreglo
	
	dibujarBarras cantidad2, espacio2, arreglo

	getChar
	finModoVideo

	popRegistros

endm

imprimirVidNum macro cadena, fila, columna

	push ds
	push dx
	xor dx, dx
	mov ah, 02h 
	mov bh, 0		; pag 0
	mov dh, fila
	mov dl, columna
	int 10h			; correr el cursor


	; imprimir en consola
	mov ax, @data
	mov ds, ax
	mov ah, 09
	mov dx, offset cadena
	int 21h
	pop dx
	pop ds

endm

DeterminarTamanio macro tamX, espacio, cantidad, espaciador

	mov ax, 260 ; tamanio para dibujar de largo
	mov bx, cantidad ; cantidad de datos que se tienen
	xor bh, bh
	div bl			; dividiendo la pantalla en la cantidad de datos que tenemos
	xor dx, dx
	mov dl, al		; guardar el cociente en dl
	mov espaciador, dx ; guardar cociente en espaciador
	xor ah, ah
	mov bl, 25
	mul bl
	mov bl, 100
	div bl			; sacar el 25 % 

	mov espacio, al 	; guardar el cociente en espacio (entre barras)
	mov bx, espaciador
	sub bl, espacio
	mov tamX, bx		; asignar el valor a la variable tamX


endm

dibujarBarras macro cantidad, espacio2, arreglo
LOCAL Inicio, Fin

	xor cx, cx

	Inicio: 

		cmp cx, cantidad
		je Fin
		push cx
		mov si, cx
		xor ax, ax
		mov al, arreglo[si]
		mov valor, al
		push ax

		; mandar a llamar un macro para determinar el color de la barra 
		mov dl, 10	; color que va a tomar la barra
		xor ax, ax
		mov ax, maximo
		mov max, al 

		dibujarBarra espacio2, valor, max

		pop ax
		mov valor, al
		delay2 tiempo
		pop cx
		inc cx
		jmp Inicio

		Fin:
endm



dibujarBarra macro espacio, valor, max
LOCAL Inicio, Fin

	xor cx, cx
	DeterminarTamanoY valor, max

	Inicio: 
		cmp cx, tamX
		je Fin
		push cx
		mov ax, 170
		mov bx, ax
		sub bl, valor
		xor bh, bh
		mov si, bx
		mov bx, 30
		add bx, espacio ; xd
		add bx, cx
		PintarY
		pop cx
		inc cl
		jmp Inicio

	Fin:
		mov ax, espaciador
		add espacio, ax ; xd

endm

DeterminarTamanoY macro valor, max

	xor ax, ax
	mov al, valor
	mov bl, 130
	mul bl
	mov bl, max
	div bl
	mov valor, al 


endm


PintarY macro 
LOCAL Ejey, Fin

	mov cx, si 

	Ejey: 
		cmp cx, ax
		je Fin
		mov di, cx
		push ax
		push dx
		mov ax, 320
		mul di
		mov di, ax
		pop dx
		pop ax
		mov [di+bx], dl
		inc cx
		jmp Ejey
	
	Fin:

endm


delay2 macro duracion
LOCAL D1, D2, Fin

	push si
	push di 

	mov si, duracion

	D1:
		dec si
		jz Fin
		mov di, duracion


	D2: 
		dec di
		jnz D2
		jmp D1

	Fin:
		pop di
		pop si 

endm

obtenerNumeros2 macro ; macro de obtenerNumeros en el video
LOCAL Inicio, Finalizar

	pushearRegistros

	xor si, si 
	xor dx, dx
	mov dl, cantidad
	LimpiarBuffer2 numerosM

	Inicio: 
		LimpiarBuffer resultado
		cmp si, dx
		je Finalizar
		push si
		push dx
		xor ax, ax
		mov al, arreglo[si]
		ConvertirString resultado
		insertarMumero resultado
		LimpiarBuffer resultado
		pop dx
		pop si 
		inc si
		jmp Inicio

	Finalizar:
		popRegistros

endm


insertarMumero macro cadena
LOCAL Inicio, Fin, Siguiente

	xor si, si 
	xor di, di 

	Inicio:

		cmp si, 60	; solo se pueden guardar 60 pos
		je Fin
		mov al, numerosM[si]
		cmp al, 36
		je Siguiente
		inc si 
		jmp Inicio

	Siguiente:

		mov al, cadena[di]
		cmp al, 36
		je Fin
		mov numerosM[si], al 
		inc di
		inc si
		jmp Siguiente

	Fin:

		mov numerosM[si], 32


endm

; limpiar la cadena
LimpiarBuffer macro buffer
LOCAL Inicio, Fin

	xor bx, bx

		Inicio:
			mov buffer[bx], 36	; simbolo de $
			inc bx
			cmp bx, 20
			je Fin
			jmp Inicio
		Fin:
endm

Limpiarbuffer2 macro buffer
LOCAL Inicio, Fin

	xor bx, bx

		Inicio:
			mov buffer[bx], 24h	; simbolo de $
			inc bx
			cmp bx, 60
			je Fin
			jmp Inicio
		Fin:
	

endm

pushearRegistros MACRO
	push ax
	push bx
	push cx
	push dx
	push si
	push di

ENDM

popRegistros MACRO 
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ENDM

pushArreglo macro arreglo
LOCAL Inicio, Finalizar

	xor si, si

	Inicio:
		xor ax, ax
		cmp si, cantidad2
		je Finalizar
		mov al, arreglo[si]
		push ax
		inc si
		jmp Inicio

	Finalizar:

endm

popArreglo macro arreglo
LOCAL Inicio, Finalizar

	xor si, si
	mov si, cantidad2
	dec si

	Inicio:
		cmp si, 0
		jl Finalizar
		pop ax
		mov arreglo[si], al
		dec si
		jmp Inicio

	Finalizar:

endm


pushVideo macro arreglo

	pushArreglo arreglo
	push maximo
	push tamX
	push espaciador
	push cantidad2
	push tiempo

endm

popVideo macro arreglo
	
	pop maximo
	pop tamX
	pop espaciador
	pop cantidad2
	pop tiempo	
	popArreglo arreglo

endm

Graficar macro
LOCAL ciclo1, ciclo2
	modoVideo
	;pintar_marco izq, der, arr, aba, color
    ;pintar_marco 20d, 299d, 20d, 180d, 10d

	mov ah, 08h
	mov bh, 00h
	mov bl, 00h
	int 10h

	; mov ah, 0ch
	; mov al, 0ch	; color 
	; mov bh, 00h
	; mov cx, 10d ; eje x
	; mov dx, 90d ; eje y
	; int 10h

	;pintar_pixel2 10d, 90d, 0ch
	
	mov ah, 02h
    mov bh, 00
    mov dh, 01d  ; 23 filas 
    mov dl, 03d  ; 118 columnas
    int 10h
	print mensajeprueba2

	;
	mov ah, 02h
    mov bh, 00
    mov dh, 01d  ; 23 filas 
    mov dl, 17d  ; 118 columnas
    int 10h
	print mensajeprueba
	delay 4000
	finModoVideo
	jmp MenuPrincipal
endm

delay macro param

    push ax
    push bx 
    xor ax, ax 
    xor bx, bx
    mov ax, param

    ret2:
        dec ax        
        jz finRet   
        mov bx, param 

        ret1: 
            dec bx 
        jnz ret1 
    jmp ret2 

    finRet: 
    pop bx
    pop ax

endm



pintar_pixel2 MACRO x, y, color
	mov ah, 0ch
	mov al, color	; color 
	mov bh, 00h
	mov cx, x ; eje x
	mov dx, y ; eje y
	int 10h
ENDM

pintar_pixel MACRO i, j, color 

    push ax
    push bx 
    push di 
        
    xor ax, ax   
    xor bx, bx 
    xor di, di 

    mov ax, 320d 
    mov bx, i
    mul bx
    add ax, j
    mov di, ax
    mov [di], color
        
    pop di 
    pop bx 
    pop ax 
        
ENDM

pintar_marco macro izq, der, arr, aba, color  
LOCAL ciclo1, ciclo2  
    push si 
    xor si, si 
    mov si, izq
    ciclo1:
        pintar_pixel2 arr, si, color
        pintar_pixel2 aba, si, color
        inc si 
        cmp si, der 
    jne ciclo1


    xor si, si 
    mov si, arr 
    
	ciclo2:
        pintar_pixel2 si, der, color
        pintar_pixel2 si, izq, color 
        inc si
        cmp si, aba 
    jne ciclo2

    pop si

endm



;--------------------------

GuardarNumeros macro buffer,cantidad,arreglo,numero
	LOCAL INICIO,RECONOCER,GUARDAR,FIN,SALIR
	xor bx,bx
	xor si,si
	xor di,di
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo palabras reservadas o caracteres especiales
	;hasta que encuentra un caracter de un numero, y poder iniciar a guardarlo. 
	INICIO:
		mov bl,buffer[si] ; lectura de archivo
		
		cmp bl,36   ; $
		je FIN      ; terminar
		cmp bl,48   ; 0
		jl SALIR    ; salta si es menor que 0
		cmp bl,57   ; 9
		jg SALIR    ; salta si es mayor que 9
		jmp RECONOCER	
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo el numero, hasta que encuentra un caracter de finalización. 
	;Al encontrarlo procede a guardar dicho numero
	RECONOCER:
		mov bl,buffer[si]
		cmp bl,48
		jl GUARDAR
		cmp bl,57
		jg GUARDAR
		inc si
		mov numero[di],bl
		inc di
		jmp RECONOCER
;--------------------------------------------------------------------------------------------
	; metodo que guarda el numero reconocido en el arreglo
	GUARDAR:
		push si
		ConvertirDec numero
		xor bx,bx
		mov bl,cantidad
		mov arreglo[bx],al
		
		;getChar
		;xor ax,ax
		;mov al,arreglo[bx]
		;ConvertirString numero
		;print numero
		;Limpiarbuffer numero
		
		inc cantidad
		pop si
		xor bx,bx
		xor ax,ax
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	SALIR:
		
		inc si
		xor di,di
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	FIN: 
		xor ax,ax
		mov al,cantidad
		mov cantidad2,ax
endm

ConvertirDec macro numero
  LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm
; ------------------------