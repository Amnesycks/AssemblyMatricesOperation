;; Integer matrix operations in assembly x86
extern malloc

;; Create a 2d int array / matrix
; edi = nb_col
; esi = nb_line
global create_matrix
create_matrix:
  mov eax, 8;Get size to allocate
  imul esi ;nb_line

  push rdi ;Push variable that will be used later
  push rsi
  mov edi, eax
  call malloc
  pop rsi ;Get back variable
  pop rdi
  lea ebx, [eax]
  xor edx, edx

  .loop:
    push rdx ;Push variable that will be used later
    push rdi
    push rsi
    mov eax, 4
    imul edi
    mov edi, eax
    mov esi, 0
    call malloc
    pop rsi ;Get back variable
    pop rdi
    pop rdx
    lea ecx, [eax]
    mov [ebx + 8 * edx], ecx

    inc edx
    cmp edx, esi
    jne .loop

    ;end
      mov eax, ebx
      ret


;; Common error check, for matrix operations
common_error_check:
  ;Check
    cmp edi, 0 ;Check if matrix_a is null
    je .error
    cmp esi, 0 ;Check if matrix_b is null
    je .error
    cmp edx, 0 ;Check if matrix_a nb_line is null
    je .error
    cmp ecx, 0 ;Check if matrix_a nb_col is null
    je .error
    xor eax, eax
    ret

  ;.error
  .error:
    mov eax, 1
    ret

;; Addition of two matrix
;; int **addition(int **matrix_a, int **matrix_b, int nb_col, int nb_line);
global add_matrix
add_matrix:
  ;error_check:
    call common_error_check
    cmp eax, 0
    jne .error

  ;init:
    push rdi ; Stack argument before function calling
    push rsi
    push rdx
    push rcx
    mov rdi, rdx
    mov rsi, rcx
    call create_matrix
    pop rcx ; Get argument previously stacked
    pop rdx
    pop rsi
    pop rdi
    lea eax, [eax]
    xor ebx, ebx ; Init register


  .loop_line:
    mov r8d, [edi + ebx * 8] ; Access to the subelement of the matrix (line)
    mov r9d, [esi + ebx * 8]
    mov r10d, [eax + ebx * 8]
    xor r11d, r11d ; Initialisation of index to iterate over the line

    .loop_col:
      mov r12d, [r9d + r11d * 4] ; Access to the int on the same position
      add r12d, [r8d + r11d * 4] ; and substract them together before append it
      mov [r10d + r11d * 4], r12d ; to the new matrix
      inc r11d ; Increment the index to iterate through columns
      cmp r11d, edx ; Check if we reach the last column
      jne .loop_col

    inc ebx ; Increment the index to iterate through lines
    cmp ebx, ecx ; Check if we reach the last line
    jne .loop_line

  ;end:
    ret

  ;error:
  .error:
    mov eax, 0
    ret

;; Substraction of two matrix
;; int **substract(int **matrix_a, int **matrix_b, int nb_col, int nb_line);
global sub_matrix
sub_matrix:
  ;error_check:
    call common_error_check
    cmp eax, 0
    jne .error

  ;init:
    push rdi ; Stack argument before function calling
    push rsi
    push rdx
    push rcx
    mov rdi, rdx
    mov rsi, rcx
    call create_matrix
    pop rcx ; Get argument previously stacked
    pop rdx
    pop rsi
    pop rdi
    lea eax, [eax]
    xor ebx, ebx ; Init register


  .loop_line:
    mov r8d, [edi + ebx * 8] ; Access to the subelement of the matrix (line)
    mov r9d, [esi + ebx * 8]
    mov r10d, [eax + ebx * 8]
    xor r11d, r11d ; Initialisation of index to iterate over the line

    .loop_col:
      mov r12d, [r8d + r11d * 4] ; Access to the int on the same position
      sub r12d, [r9d + r11d * 4] ; and substract them together before append it
      mov [r10d + r11d * 4], r12d ; to the new matrix
      inc r11d ; Increment the index to iterate through columns
      cmp r11d, edx ; Check if we reach the last column
      jne .loop_col

    inc ebx ; Increment the index to iterate through lines
    cmp ebx, ecx ; Check if we reach the last line
    jne .loop_line

  ;end:
    ret

  ;error:
  .error:
    mov eax, 0
    ret

;; Multiplication of two matrix
;; int **multiply_matrix(int **matrix_a, int **matrix_b,
;;                       int matrix_a_nb_col, int matrix_a_nb_line,
;;                       int matrix_b_nb_col, int matrix_b_nb_line)
global multiply_matrix
multiply_matrix:
  ;error_check:
    call common_error_check
    cmp eax, 0
    jne .error
    cmp edx, 0 ;Check if matrix_b nb_line is null
    je .error
    cmp ecx, 0 ;Check if matrix_b nb_col is null
    je .error
    cmp edx, r9d ;Check if matrix can be multiply (nb_col_a == nb_line_b)
    jne .error

  ;init:
    ; Stack argument before function calling
    push rdi ; matrix_a
    push rsi ; matrix_b
    push rdx ; matrix_a_nb_col
    push rcx ; matrix_a_nb_line
    push r8  ; matrix_b_nb_col
    push r9  ; matrix_b_nb_line
    mov rdi, r8
    mov rsi, rcx
    call create_matrix
    pop r9 ; Get argument previously stacked
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    lea r10d, [eax]
    xor r12d, r12d

  ;parent_loop:
  .parent_loop:
    xor r13d, r13d

    ;child_loop:
    .child_loop:
      xor r14d, r14d
      xor ebx, ebx

      ;grandchild_loop: Iterate over matrix_a lines and matrix_b columns
      .grandchild_loop:
        mov edx, [edi + r12d * 8] ; Multiply all element of the matrix_a line a
        mov eax, [edx + r14d * 4] ; with the element of the matrix_b column
        mov edx, [esi + r14d * 8] ; then sum the result of all products
        imul dword [edx + r13d * 4]
        add ebx, eax
        inc r14d
        cmp r14d, r9d
        jne .grandchild_loop

      mov r15d, [r10d + r12d * 8] ; Append the value found in grandchild loop
      mov [r15d + r13d * 4], ebx  ; to the final matrix
      inc r13d
      cmp r13d, r8d
      jne .child_loop

    inc r12d
    cmp r12d, ecx
    jne .parent_loop

  ;end:
    mov eax, r10d
    ret

  ;error:
  .error:
    mov eax, 0
    ret
