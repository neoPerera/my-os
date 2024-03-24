section .data
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f  ; the color byte for each character

section .text
global kprint
global kprint_c
kprint:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 0x8] ; Offset of 8 bytes for cdecl calling convention

    ; Move video memory address to edx
    mov edx, 0xb8000
    add edx, [ebp + 0xc] 
    ;mov al, [ebx]
    mov [edx], bx
    mov ah, WHITE_ON_BLACK
    mov [edx], ax
    jmp kprint_c_done

;     ; Set up stack frame
;     push ebp
;     mov ebp, esp

;     ; Get the address of the string from the stack
;     mov ebx, [ebp + 8]  ; Offset of 8 bytes for cdecl calling convention

;     ; Move video memory address to edx
;     mov edx, VIDEO_MEMORY

; kprint_loop:
;     ; Load character from memory
;     mov al,  [ebx]
;     mov ah, WHITE_ON_BLACK

;     ; Check for end of string
;     cmp al, 0
;     je kprint_done

;     ; Write character and attribute to video memory
;     mov [edx], ax
;     add ebx, 1  ; Move to next character
;     add edx, 2  ; Move to next video memory position

;     ; Repeat loop
;     jmp kprint_loop

; kprint_done:
;     ; Clean up stack frame
;     pop ebp

;     ; Return to caller
;     ret


kprint_c:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 0x8] ; Offset of 8 bytes for cdecl calling convention

    ; Move video memory address to edx
    mov edx, 0xb8000
    add edx, [ebp + 0xc] 
    ;mov al, [ebx]
    mov [edx], bx
    mov ah, WHITE_ON_BLACK
    mov [edx], ax
    jmp kprint_c_done

kprint_c_done:
    ; Clean up stack frame
    pop ebp

    ; Return to caller
    ret