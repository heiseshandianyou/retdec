source_filename = "test"
target datalayout = "e-m:e-p:64:64-i64:64-f80:128-n8:16:32:64-S128"

@_asm_program_counter = internal global i64 0
@cf = internal global i1 false
@pf = internal global i1 false
@az = internal global i1 false
@zf = internal global i1 false
@sf = internal global i1 false
@tf = internal global i1 false
@if = internal global i1 false
@df = internal global i1 false
@of = internal global i1 false
@iopl = internal global i2 0
@nt = internal global i1 false
@rf = internal global i1 false
@vm = internal global i1 false
@ac = internal global i1 false
@vif = internal global i1 false
@vip = internal global i1 false
@id = internal global i1 false
@rflags = internal global i64 0
@ss = internal global i16 0
@cs = internal global i16 0
@ds = internal global i16 0
@es = internal global i16 0
@fs = internal global i16 0
@gs = internal global i16 0
@st0 = internal global x86_fp80 0xK00000000000000000000
@st1 = internal global x86_fp80 0xK00000000000000000000
@st2 = internal global x86_fp80 0xK00000000000000000000
@st3 = internal global x86_fp80 0xK00000000000000000000
@st4 = internal global x86_fp80 0xK00000000000000000000
@st5 = internal global x86_fp80 0xK00000000000000000000
@st6 = internal global x86_fp80 0xK00000000000000000000
@st7 = internal global x86_fp80 0xK00000000000000000000
@fpu_stat_IE = internal global i1 false
@fpu_stat_DE = internal global i1 false
@fpu_stat_ZE = internal global i1 false
@fpu_stat_OE = internal global i1 false
@fpu_stat_UE = internal global i1 false
@fpu_stat_PE = internal global i1 false
@fpu_stat_SF = internal global i1 false
@fpu_stat_ES = internal global i1 false
@fpu_stat_C0 = internal global i1 false
@fpu_stat_C1 = internal global i1 false
@fpu_stat_C2 = internal global i1 false
@fpu_stat_C3 = internal global i1 false
@fpu_stat_TOP = internal global i3 0
@fpu_stat_B = internal global i1 false
@fpu_control_IM = internal global i1 false
@fpu_control_DM = internal global i1 false
@fpu_control_ZM = internal global i1 false
@fpu_control_OM = internal global i1 false
@fpu_control_UM = internal global i1 false
@fpu_control_PM = internal global i1 false
@fpu_control_PC = internal global i2 0
@fpu_control_RC = internal global i2 0
@fpu_control_X = internal global i1 false
@fp0 = internal global double 0.000000e+00
@fp1 = internal global double 0.000000e+00
@fp2 = internal global double 0.000000e+00
@fp3 = internal global double 0.000000e+00
@fp4 = internal global double 0.000000e+00
@fp5 = internal global double 0.000000e+00
@fp6 = internal global double 0.000000e+00
@fp7 = internal global double 0.000000e+00
@k0 = internal global i64 0
@k1 = internal global i64 0
@k2 = internal global i64 0
@k3 = internal global i64 0
@k4 = internal global i64 0
@k5 = internal global i64 0
@k6 = internal global i64 0
@k7 = internal global i64 0
@mm0 = internal global i64 0
@mm1 = internal global i64 0
@mm2 = internal global i64 0
@mm3 = internal global i64 0
@mm4 = internal global i64 0
@mm5 = internal global i64 0
@mm6 = internal global i64 0
@mm7 = internal global i64 0
@xmm0 = internal global i128 0
@xmm1 = internal global i128 0
@xmm2 = internal global i128 0
@xmm3 = internal global i128 0
@xmm4 = internal global i128 0
@xmm5 = internal global i128 0
@xmm6 = internal global i128 0
@xmm7 = internal global i128 0
@xmm8 = internal global i128 0
@xmm9 = internal global i128 0
@xmm10 = internal global i128 0
@xmm11 = internal global i128 0
@xmm12 = internal global i128 0
@xmm13 = internal global i128 0
@xmm14 = internal global i128 0
@xmm15 = internal global i128 0
@xmm16 = internal global i128 0
@xmm17 = internal global i128 0
@xmm18 = internal global i128 0
@xmm19 = internal global i128 0
@xmm20 = internal global i128 0
@xmm21 = internal global i128 0
@xmm22 = internal global i128 0
@xmm23 = internal global i128 0
@xmm24 = internal global i128 0
@xmm25 = internal global i128 0
@xmm26 = internal global i128 0
@xmm27 = internal global i128 0
@xmm28 = internal global i128 0
@xmm29 = internal global i128 0
@xmm30 = internal global i128 0
@xmm31 = internal global i128 0
@ymm0 = internal global i256 0
@ymm1 = internal global i256 0
@ymm2 = internal global i256 0
@ymm3 = internal global i256 0
@ymm4 = internal global i256 0
@ymm5 = internal global i256 0
@ymm6 = internal global i256 0
@ymm7 = internal global i256 0
@ymm8 = internal global i256 0
@ymm9 = internal global i256 0
@ymm10 = internal global i256 0
@ymm11 = internal global i256 0
@ymm12 = internal global i256 0
@ymm13 = internal global i256 0
@ymm14 = internal global i256 0
@ymm15 = internal global i256 0
@ymm16 = internal global i256 0
@ymm17 = internal global i256 0
@ymm18 = internal global i256 0
@ymm19 = internal global i256 0
@ymm20 = internal global i256 0
@ymm21 = internal global i256 0
@ymm22 = internal global i256 0
@ymm23 = internal global i256 0
@ymm24 = internal global i256 0
@ymm25 = internal global i256 0
@ymm26 = internal global i256 0
@ymm27 = internal global i256 0
@ymm28 = internal global i256 0
@ymm29 = internal global i256 0
@ymm30 = internal global i256 0
@ymm31 = internal global i256 0
@zmm0 = internal global i512 0
@zmm1 = internal global i512 0
@zmm2 = internal global i512 0
@zmm3 = internal global i512 0
@zmm4 = internal global i512 0
@zmm5 = internal global i512 0
@zmm6 = internal global i512 0
@zmm7 = internal global i512 0
@zmm8 = internal global i512 0
@zmm9 = internal global i512 0
@zmm10 = internal global i512 0
@zmm11 = internal global i512 0
@zmm12 = internal global i512 0
@zmm13 = internal global i512 0
@zmm14 = internal global i512 0
@zmm15 = internal global i512 0
@zmm16 = internal global i512 0
@zmm17 = internal global i512 0
@zmm18 = internal global i512 0
@zmm19 = internal global i512 0
@zmm20 = internal global i512 0
@zmm21 = internal global i512 0
@zmm22 = internal global i512 0
@zmm23 = internal global i512 0
@zmm24 = internal global i512 0
@zmm25 = internal global i512 0
@zmm26 = internal global i512 0
@zmm27 = internal global i512 0
@zmm28 = internal global i512 0
@zmm29 = internal global i512 0
@zmm30 = internal global i512 0
@zmm31 = internal global i512 0
@bnd0 = internal global i128 0
@bnd1 = internal global i128 0
@bnd2 = internal global i128 0
@bnd3 = internal global i128 0
@dr0 = internal global i64 0
@dr1 = internal global i64 0
@dr2 = internal global i64 0
@dr3 = internal global i64 0
@dr4 = internal global i64 0
@dr5 = internal global i64 0
@dr6 = internal global i64 0
@dr7 = internal global i64 0
@dr8 = internal global i64 0
@dr9 = internal global i64 0
@dr10 = internal global i64 0
@dr11 = internal global i64 0
@dr12 = internal global i64 0
@dr13 = internal global i64 0
@dr14 = internal global i64 0
@dr15 = internal global i64 0
@cr0 = internal global i64 0
@cr1 = internal global i64 0
@cr2 = internal global i64 0
@cr3 = internal global i64 0
@cr4 = internal global i64 0
@cr5 = internal global i64 0
@cr6 = internal global i64 0
@cr7 = internal global i64 0
@cr8 = internal global i64 0
@cr9 = internal global i64 0
@cr10 = internal global i64 0
@cr11 = internal global i64 0
@cr12 = internal global i64 0
@cr13 = internal global i64 0
@cr14 = internal global i64 0
@cr15 = internal global i64 0
@fpsw = internal global i64 0
@rax = internal global i64 0
@rcx = internal global i64 0
@rdx = internal global i64 0
@rbx = internal global i64 0
@rsp = internal global i64 0
@rbp = internal global i64 0
@rsi = internal global i64 0
@rdi = internal global i64 0
@r8 = internal global i64 0
@r9 = internal global i64 0
@r10 = internal global i64 0
@r11 = internal global i64 0
@r12 = internal global i64 0
@r13 = internal global i64 0
@r14 = internal global i64 0
@r15 = internal global i64 0
@rip = internal global i64 0
@riz = internal global i64 0
@0 = global i64 0
@global_var_4008 = external global i64
@global_var_2004 = constant [14 x i8] c"callback: %d\0A\00"
@global_var_2012 = constant [13 x i8] c"another: %d\0A\00"
@global_var_201f = constant [11 x i8] c"Stack: %d\0A\00"
@1 = global i64 42
@2 = global i64 0
@3 = global i64 0
@global_var_202a = constant [16 x i8] c"Global: %d, %c\0A\00"
@global_var_203a = constant [14 x i8] c"Heap: %d, %d\0A\00"
@global_var_2048 = constant [19 x i8] c"Array: %d, %d, %d\0A\00"
@4 = global i64 7093007127769251940
@global_var_205b = constant [24 x i8] c"Struct: %d, %d, %c, %d\0A\00"
@global_var_2073 = constant [29 x i8] c"Pointer: %d, %d, %d, %d, %d\0A\00"
@global_var_40a8 = global i64 0
@global_var_2090 = constant [13 x i8] c"FuncPtr: %d\0A\00"
@global_var_209d = constant [14 x i8] c"Complex: done\00"
@global_var_20ab = constant [10 x i8] c"Copy: %s\0A\00"
@global_var_20b5 = constant [17 x i8] c"Conditional: %d\0A\00"
@global_var_20c6 = constant [27 x i8] c"=== Memory Access Test ===\00"
@global_var_20e1 = constant [28 x i8] c"=== All tests completed ===\00"
@5 = external global i32
@global_var_4040 = global i8 0
@global_var_4010 = global i32 42
@global_var_4011 = global i32 0
@global_var_4060 = global i8 0
@global_var_4024 = global i32 100

define i64 @function_1000() {
dec_label_pc_1000:
  %stack_var_-8 = alloca i64

; 0x1000
  store volatile i64 4096, i64* @_asm_program_counter

; 0x1004
  store volatile i64 4100, i64* @_asm_program_counter
  %0 = ptrtoint i64* %stack_var_-8 to i64
  store i64 %0, i64* @rsp

; 0x1008
  store volatile i64 4104, i64* @_asm_program_counter
  %1 = load i64, i64* inttoptr (i64 16360 to i64*)
  store i64 %1, i64* @rax

; 0x100f
  store volatile i64 4111, i64* @_asm_program_counter
  %2 = icmp eq i64 %1, 0

; 0x1012
  store volatile i64 4114, i64* @_asm_program_counter
  br i1 %2, label %dec_label_pc_1016, label %dec_label_pc_1014

dec_label_pc_1014:                                ; preds = %dec_label_pc_1000

; 0x1014
  store volatile i64 4116, i64* @_asm_program_counter
  %3 = call i64 @__gmon_start__()
  store i64 %3, i64* @rax
  br label %dec_label_pc_1016

dec_label_pc_1016:                                ; preds = %dec_label_pc_1014, %dec_label_pc_1000

; 0x1016
  store volatile i64 4118, i64* @_asm_program_counter

; 0x101a
  store volatile i64 4122, i64* @_asm_program_counter
  %4 = load i64, i64* @rax
  ret i64 %4
}

define i64 @function_1090(i64 %arg1) {
dec_label_pc_1090:

; 0x1090
  store volatile i64 4240, i64* @_asm_program_counter

; 0x1094
  store volatile i64 4244, i64* @_asm_program_counter
  %0 = ptrtoint i32* @5 to i64
  %1 = call i64 @__cxa_finalize(i64 %arg1)
  ret i64 %1
}

declare i64 @6()

define i64 @function_10a0(i64 %arg1) {
dec_label_pc_10a0:

; 0x10a0
  store volatile i64 4256, i64* @_asm_program_counter

; 0x10a4
  store volatile i64 4260, i64* @_asm_program_counter
  %0 = ptrtoint i32* @5 to i64
  %1 = call i64 @free(i64 %arg1)
  ret i64 %1
}

declare i64 @7()

define i64 @function_10b0(i64 %arg1) {
dec_label_pc_10b0:

; 0x10b0
  store volatile i64 4272, i64* @_asm_program_counter

; 0x10b4
  store volatile i64 4276, i64* @_asm_program_counter
  %0 = ptrtoint i32* @5 to i64
  %1 = call i64 @puts(i64 %arg1)
  ret i64 %1
}

declare i64 @8()

define i64 @function_10c0() {
dec_label_pc_10c0:

; 0x10c0
  store volatile i64 4288, i64* @_asm_program_counter

; 0x10c4
  store volatile i64 4292, i64* @_asm_program_counter
  %0 = call i64 @__stack_chk_fail()
  ret i64 %0
}

define i64 @function_10d0(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5, i64 %arg6) {
dec_label_pc_10d0:

; 0x10d0
  store volatile i64 4304, i64* @_asm_program_counter

; 0x10d4
  store volatile i64 4308, i64* @_asm_program_counter
  %0 = ptrtoint i32* @5 to i64
  %1 = ptrtoint i32* @5 to i64
  %2 = ptrtoint i32* @5 to i64
  %3 = ptrtoint i32* @5 to i64
  %4 = ptrtoint i32* @5 to i64
  %5 = ptrtoint i32* @5 to i64
  %6 = call i64 @printf(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5, i64 %arg6)
  ret i64 %6
}

declare i64 @9()

define i64 @function_10e0(i64* %arg1, i64* %arg2, i64 %arg3, i64* %arg4) {
dec_label_pc_10e0:

; 0x10e0
  store volatile i64 4320, i64* @_asm_program_counter

; 0x10e4
  store volatile i64 4324, i64* @_asm_program_counter
  %0 = bitcast i32* @5 to i64*
  %1 = bitcast i32* @5 to i64*
  %2 = ptrtoint i32* @5 to i64
  %3 = bitcast i32* @5 to i64*
  %4 = call i64 @memcpy(i64* %arg1, i64* %arg2, i64 %arg3, i64* %arg4)
  ret i64 %4
}

declare i64 @10()

define i64 @function_10f0(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4) {
dec_label_pc_10f0:

; 0x10f0
  store volatile i64 4336, i64* @_asm_program_counter

; 0x10f4
  store volatile i64 4340, i64* @_asm_program_counter
  %0 = ptrtoint i32* @5 to i64
  %1 = ptrtoint i32* @5 to i64
  %2 = ptrtoint i32* @5 to i64
  %3 = ptrtoint i32* @5 to i64
  %4 = call i64 @malloc(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4)
  ret i64 %4

; uselistorder directives
  uselistorder i32* @5, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 0 }
}

declare i64 @11()

define i64 @entry_point(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5, i64 %arg6) {
dec_label_pc_1100:
  %stack_var_-8 = alloca i64
  %stack_var_8 = alloca i64

; 0x1100
  store volatile i64 4352, i64* @_asm_program_counter

; 0x1104
  store volatile i64 4356, i64* @_asm_program_counter

; 0x1106
  store volatile i64 4358, i64* @_asm_program_counter

; 0x1109
  store volatile i64 4361, i64* @_asm_program_counter

; 0x110a
  store volatile i64 4362, i64* @_asm_program_counter

; 0x110d
  store volatile i64 4365, i64* @_asm_program_counter

; 0x1111
  store volatile i64 4369, i64* @_asm_program_counter
  %0 = load i64, i64* @rax
  store i64 %0, i64* %stack_var_-8

; 0x1112
  store volatile i64 4370, i64* @_asm_program_counter
  %1 = ptrtoint i64* %stack_var_-8 to i64

; 0x1113
  store volatile i64 4371, i64* @_asm_program_counter
  %2 = trunc i64 %arg5 to i32
  %3 = trunc i64 %arg5 to i32
  %4 = xor i32 %2, %3
  %5 = zext i32 %4 to i64

; 0x1116
  store volatile i64 4374, i64* @_asm_program_counter
  %6 = trunc i64 %arg4 to i32
  %7 = trunc i64 %arg4 to i32
  %8 = xor i32 %6, %7
  %9 = zext i32 %8 to i64

; 0x1118
  store volatile i64 4376, i64* @_asm_program_counter

; 0x111f
  store volatile i64 4383, i64* @_asm_program_counter
  %10 = trunc i64 %9 to i32
  %11 = trunc i64 %5 to i32
  %12 = inttoptr i64 %1 to i64*
  %13 = load i64, i64* %stack_var_-8
  %14 = call i64 @__libc_start_main(i64 6774, i64 %arg6, i64* %stack_var_8, i32 %10, i32 %11, i64 %arg3, i64* %12, i64 %13)

; 0x1125
  store volatile i64 4389, i64* @_asm_program_counter
  %15 = call i64 @__asm_hlt()
  unreachable

; uselistorder directives
  uselistorder i64 %arg5, { 1, 0 }
  uselistorder i64 %arg4, { 1, 0 }
}

declare i64 @12()

define i64 @function_1130() {
dec_label_pc_1130:

; 0x1130
  store volatile i64 4400, i64* @_asm_program_counter
  store i64 16440, i64* @rdi

; 0x1137
  store volatile i64 4407, i64* @_asm_program_counter
  store i64 16440, i64* @rax

; 0x113e
  store volatile i64 4414, i64* @_asm_program_counter
  %0 = sub i64 16440, 16440
  %1 = icmp eq i64 %0, 0

; 0x1141
  store volatile i64 4417, i64* @_asm_program_counter
  br i1 %1, label %dec_label_pc_1158, label %dec_label_pc_1143

dec_label_pc_1143:                                ; preds = %dec_label_pc_1130

; 0x1143
  store volatile i64 4419, i64* @_asm_program_counter
  %2 = load i64, i64* inttoptr (i64 16352 to i64*)
  store i64 %2, i64* @rax

; 0x114a
  store volatile i64 4426, i64* @_asm_program_counter
  %3 = icmp eq i64 %2, 0

; 0x114d
  store volatile i64 4429, i64* @_asm_program_counter
  br i1 %3, label %dec_label_pc_1158, label %dec_label_pc_114f

dec_label_pc_114f:                                ; preds = %dec_label_pc_1143

; 0x114f
  store volatile i64 4431, i64* @_asm_program_counter
  %4 = load i64, i64* @rdi
  %5 = call i64 @_ITM_deregisterTMCloneTable(i64 %4)
  ret i64 %5

dec_label_pc_1158:                                ; preds = %dec_label_pc_1143, %dec_label_pc_1130

; 0x1158
  store volatile i64 4440, i64* @_asm_program_counter
  %6 = load i64, i64* @rax
  ret i64 %6
}

define i64 @function_1160() {
dec_label_pc_1160:

; 0x1160
  store volatile i64 4448, i64* @_asm_program_counter
  store i64 16440, i64* @rdi

; 0x1167
  store volatile i64 4455, i64* @_asm_program_counter

; 0x116e
  store volatile i64 4462, i64* @_asm_program_counter
  %0 = sub i64 16440, 16440

; 0x1171
  store volatile i64 4465, i64* @_asm_program_counter

; 0x1174
  store volatile i64 4468, i64* @_asm_program_counter
  %1 = lshr i64 %0, 63

; 0x1178
  store volatile i64 4472, i64* @_asm_program_counter
  %2 = ashr i64 %0, 3
  store i64 %2, i64* @rax

; 0x117c
  store volatile i64 4476, i64* @_asm_program_counter
  %3 = add i64 %1, %2

; 0x117f
  store volatile i64 4479, i64* @_asm_program_counter
  %4 = ashr i64 %3, 1
  %5 = icmp eq i64 %4, 0
  store i64 %4, i64* @rsi

; 0x1182
  store volatile i64 4482, i64* @_asm_program_counter
  br i1 %5, label %dec_label_pc_1198, label %dec_label_pc_1184

dec_label_pc_1184:                                ; preds = %dec_label_pc_1160

; 0x1184
  store volatile i64 4484, i64* @_asm_program_counter
  %6 = load i64, i64* inttoptr (i64 16368 to i64*)
  store i64 %6, i64* @rax

; 0x118b
  store volatile i64 4491, i64* @_asm_program_counter
  %7 = icmp eq i64 %6, 0

; 0x118e
  store volatile i64 4494, i64* @_asm_program_counter
  br i1 %7, label %dec_label_pc_1198, label %dec_label_pc_1190

dec_label_pc_1190:                                ; preds = %dec_label_pc_1184

; 0x1190
  store volatile i64 4496, i64* @_asm_program_counter
  %8 = load i64, i64* @rdi
  %9 = load i64, i64* @rsi
  %10 = call i64 @_ITM_registerTMCloneTable(i64 %8, i64 %9)
  ret i64 %10

dec_label_pc_1198:                                ; preds = %dec_label_pc_1184, %dec_label_pc_1160

; 0x1198
  store volatile i64 4504, i64* @_asm_program_counter
  %11 = load i64, i64* @rax
  ret i64 %11

; uselistorder directives
  uselistorder i64* @rdi, { 0, 2, 1, 3 }
  uselistorder i64 16440, { 1, 0, 4, 3, 2, 5, 6 }
}

define i64 @function_11a0() {
dec_label_pc_11a0:

; 0x11a0
  store volatile i64 4512, i64* @_asm_program_counter

; 0x11a4
  store volatile i64 4516, i64* @_asm_program_counter
  %0 = load i8, i8* @global_var_4040
  %1 = icmp eq i8 %0, 0

; 0x11ab
  store volatile i64 4523, i64* @_asm_program_counter
  %2 = icmp eq i1 %1, false
  br i1 %2, label %dec_label_pc_11d8, label %dec_label_pc_11ad

dec_label_pc_11ad:                                ; preds = %dec_label_pc_11a0

; 0x11ad
  store volatile i64 4525, i64* @_asm_program_counter
  %3 = load i64, i64* @rbp

; 0x11ae
  store volatile i64 4526, i64* @_asm_program_counter
  %4 = load i64, i64* inttoptr (i64 16376 to i64*)
  %5 = icmp eq i64 %4, 0

; 0x11b6
  store volatile i64 4534, i64* @_asm_program_counter

; 0x11b9
  store volatile i64 4537, i64* @_asm_program_counter
  br i1 %5, label %dec_label_pc_11c7, label %dec_label_pc_11bb

dec_label_pc_11bb:                                ; preds = %dec_label_pc_11ad

; 0x11bb
  store volatile i64 4539, i64* @_asm_program_counter
  %6 = load i64, i64* inttoptr (i64 16392 to i64*)

; 0x11c2
  store volatile i64 4546, i64* @_asm_program_counter
  %7 = call i64 @__cxa_finalize(i64 %6)
  br label %dec_label_pc_11c7

dec_label_pc_11c7:                                ; preds = %dec_label_pc_11bb, %dec_label_pc_11ad

; 0x11c7
  store volatile i64 4551, i64* @_asm_program_counter
  %8 = call i64 @function_1130()

; 0x11cc
  store volatile i64 4556, i64* @_asm_program_counter
  store i8 1, i8* @global_var_4040

; 0x11d3
  store volatile i64 4563, i64* @_asm_program_counter

; 0x11d4
  store volatile i64 4564, i64* @_asm_program_counter
  ret i64 %8

dec_label_pc_11d8:                                ; preds = %dec_label_pc_11a0

; 0x11d8
  store volatile i64 4568, i64* @_asm_program_counter
  %9 = load i64, i64* @rax
  ret i64 %9

; uselistorder directives
  uselistorder i8* @global_var_4040, { 1, 0 }
}

define i64 @function_11e0() {
dec_label_pc_11e0:

; 0x11e0
  store volatile i64 4576, i64* @_asm_program_counter

; 0x11e4
  store volatile i64 4580, i64* @_asm_program_counter
  %0 = call i64 @function_1160()
  ret i64 %0
}

define i64 @function_11e9(i64 %arg1) {
dec_label_pc_11e9:

; 0x11e9
  store volatile i64 4585, i64* @_asm_program_counter

; 0x11ed
  store volatile i64 4589, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x11ee
  store volatile i64 4590, i64* @_asm_program_counter

; 0x11f1
  store volatile i64 4593, i64* @_asm_program_counter

; 0x11f5
  store volatile i64 4597, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32

; 0x11f8
  store volatile i64 4600, i64* @_asm_program_counter
  %2 = zext i32 %1 to i64

; 0x11fb
  store volatile i64 4603, i64* @_asm_program_counter
  %3 = trunc i64 %2 to i32
  %4 = zext i32 %3 to i64

; 0x11fd
  store volatile i64 4605, i64* @_asm_program_counter

; 0x1204
  store volatile i64 4612, i64* @_asm_program_counter

; 0x1207
  store volatile i64 4615, i64* @_asm_program_counter

; 0x120c
  store volatile i64 4620, i64* @_asm_program_counter
  %5 = load i64, i64* @rdx
  %6 = load i64, i64* @rcx
  %7 = load i64, i64* @r8
  %8 = load i64, i64* @r9
  %9 = call i64 @printf(i64 ptrtoint ([14 x i8]* @global_var_2004 to i64), i64 %4, i64 %5, i64 %6, i64 %7, i64 %8)

; 0x1211
  store volatile i64 4625, i64* @_asm_program_counter

; 0x1212
  store volatile i64 4626, i64* @_asm_program_counter

; 0x1213
  store volatile i64 4627, i64* @_asm_program_counter
  ret i64 %9
}

declare i64 @13()

define i64 @function_1214(i64 %arg1) {
dec_label_pc_1214:

; 0x1214
  store volatile i64 4628, i64* @_asm_program_counter

; 0x1218
  store volatile i64 4632, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1219
  store volatile i64 4633, i64* @_asm_program_counter

; 0x121c
  store volatile i64 4636, i64* @_asm_program_counter

; 0x1220
  store volatile i64 4640, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32

; 0x1223
  store volatile i64 4643, i64* @_asm_program_counter
  %2 = zext i32 %1 to i64

; 0x1226
  store volatile i64 4646, i64* @_asm_program_counter
  %3 = trunc i64 %2 to i32
  %4 = zext i32 %3 to i64

; 0x1228
  store volatile i64 4648, i64* @_asm_program_counter

; 0x122f
  store volatile i64 4655, i64* @_asm_program_counter

; 0x1232
  store volatile i64 4658, i64* @_asm_program_counter

; 0x1237
  store volatile i64 4663, i64* @_asm_program_counter
  %5 = load i64, i64* @rdx
  %6 = load i64, i64* @rcx
  %7 = load i64, i64* @r8
  %8 = load i64, i64* @r9
  %9 = call i64 @printf(i64 ptrtoint ([13 x i8]* @global_var_2012 to i64), i64 %4, i64 %5, i64 %6, i64 %7, i64 %8)

; 0x123c
  store volatile i64 4668, i64* @_asm_program_counter

; 0x123d
  store volatile i64 4669, i64* @_asm_program_counter

; 0x123e
  store volatile i64 4670, i64* @_asm_program_counter
  ret i64 %9
}

declare i64 @14()

define i64 @function_123f(i64 %arg1, i64 %arg2) {
dec_label_pc_123f:

; 0x123f
  store volatile i64 4671, i64* @_asm_program_counter

; 0x1243
  store volatile i64 4675, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1244
  store volatile i64 4676, i64* @_asm_program_counter

; 0x1247
  store volatile i64 4679, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32

; 0x124a
  store volatile i64 4682, i64* @_asm_program_counter
  %2 = trunc i64 %arg2 to i32

; 0x124d
  store volatile i64 4685, i64* @_asm_program_counter
  %3 = zext i32 %1 to i64

; 0x1250
  store volatile i64 4688, i64* @_asm_program_counter
  %4 = zext i32 %2 to i64

; 0x1253
  store volatile i64 4691, i64* @_asm_program_counter
  %5 = trunc i64 %4 to i32
  %6 = trunc i64 %3 to i32
  %7 = add i32 %5, %6
  %8 = zext i32 %7 to i64

; 0x1255
  store volatile i64 4693, i64* @_asm_program_counter

; 0x1256
  store volatile i64 4694, i64* @_asm_program_counter
  ret i64 %8
}

declare i64 @15()

define i64 @function_1257(i64 %arg1, i64 %arg2) {
dec_label_pc_1257:

; 0x1257
  store volatile i64 4695, i64* @_asm_program_counter

; 0x125b
  store volatile i64 4699, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x125c
  store volatile i64 4700, i64* @_asm_program_counter

; 0x125f
  store volatile i64 4703, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32

; 0x1262
  store volatile i64 4706, i64* @_asm_program_counter
  %2 = trunc i64 %arg2 to i32

; 0x1265
  store volatile i64 4709, i64* @_asm_program_counter
  %3 = zext i32 %1 to i64

; 0x1268
  store volatile i64 4712, i64* @_asm_program_counter
  %4 = trunc i64 %3 to i32
  %5 = sub i32 %4, %2
  %6 = zext i32 %5 to i64

; 0x126b
  store volatile i64 4715, i64* @_asm_program_counter

; 0x126c
  store volatile i64 4716, i64* @_asm_program_counter
  ret i64 %6
}

declare i64 @16()

define i64 @function_126d() {
dec_label_pc_126d:

; 0x126d
  store volatile i64 4717, i64* @_asm_program_counter

; 0x1271
  store volatile i64 4721, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1272
  store volatile i64 4722, i64* @_asm_program_counter

; 0x1275
  store volatile i64 4725, i64* @_asm_program_counter

; 0x1279
  store volatile i64 4729, i64* @_asm_program_counter

; 0x1280
  store volatile i64 4736, i64* @_asm_program_counter

; 0x1287
  store volatile i64 4743, i64* @_asm_program_counter
  %1 = zext i32 10 to i64

; 0x128a
  store volatile i64 4746, i64* @_asm_program_counter
  %2 = zext i32 20 to i64

; 0x128d
  store volatile i64 4749, i64* @_asm_program_counter
  %3 = trunc i64 %2 to i32
  %4 = trunc i64 %1 to i32
  %5 = add i32 %3, %4
  %6 = zext i32 %5 to i64

; 0x128f
  store volatile i64 4751, i64* @_asm_program_counter
  %7 = trunc i64 %6 to i32

; 0x1292
  store volatile i64 4754, i64* @_asm_program_counter

; 0x1295
  store volatile i64 4757, i64* @_asm_program_counter

; 0x1298
  store volatile i64 4760, i64* @_asm_program_counter
  %8 = sext i32 100 to i64
  %9 = trunc i64 %8 to i32

; 0x129f
  store volatile i64 4767, i64* @_asm_program_counter
  %10 = sext i32 %9 to i64
  %11 = trunc i64 %10 to i32
  %12 = zext i32 %11 to i64

; 0x12a2
  store volatile i64 4770, i64* @_asm_program_counter
  %13 = trunc i64 %12 to i32
  %14 = add i32 %13, 1
  %15 = zext i32 %14 to i64

; 0x12a5
  store volatile i64 4773, i64* @_asm_program_counter
  %16 = trunc i64 %15 to i32
  %17 = sext i32 %16 to i64
  %18 = trunc i64 %17 to i32

; 0x12a8
  store volatile i64 4776, i64* @_asm_program_counter
  %19 = zext i32 %7 to i64

; 0x12ab
  store volatile i64 4779, i64* @_asm_program_counter
  %20 = trunc i64 %19 to i32
  %21 = zext i32 %20 to i64

; 0x12ad
  store volatile i64 4781, i64* @_asm_program_counter

; 0x12b4
  store volatile i64 4788, i64* @_asm_program_counter

; 0x12b7
  store volatile i64 4791, i64* @_asm_program_counter

; 0x12bc
  store volatile i64 4796, i64* @_asm_program_counter
  %22 = load i64, i64* @rcx
  %23 = load i64, i64* @r8
  %24 = load i64, i64* @r9
  %25 = call i64 @printf(i64 ptrtoint ([11 x i8]* @global_var_201f to i64), i64 %21, i64 %1, i64 %22, i64 %23, i64 %24)

; 0x12c1
  store volatile i64 4801, i64* @_asm_program_counter

; 0x12c2
  store volatile i64 4802, i64* @_asm_program_counter

; 0x12c3
  store volatile i64 4803, i64* @_asm_program_counter
  ret i64 %25

; uselistorder directives
  uselistorder i64 %1, { 1, 0 }
}

define i64 @function_12c4() {
dec_label_pc_12c4:

; 0x12c4
  store volatile i64 4804, i64* @_asm_program_counter

; 0x12c8
  store volatile i64 4808, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x12c9
  store volatile i64 4809, i64* @_asm_program_counter

; 0x12cc
  store volatile i64 4812, i64* @_asm_program_counter

; 0x12d0
  store volatile i64 4816, i64* @_asm_program_counter
  %1 = load i32, i32* @global_var_4010
  %2 = zext i32 %1 to i64

; 0x12d6
  store volatile i64 4822, i64* @_asm_program_counter
  %3 = trunc i64 %2 to i32

; 0x12d9
  store volatile i64 4825, i64* @_asm_program_counter

; 0x12dc
  store volatile i64 4828, i64* @_asm_program_counter

; 0x12df
  store volatile i64 4831, i64* @_asm_program_counter
  %4 = trunc i64 ptrtoint (i32* @global_var_4011 to i64) to i32
  store i32 %4, i32* @global_var_4010

; 0x12e5
  store volatile i64 4837, i64* @_asm_program_counter
  store i8 65, i8* @global_var_4060

; 0x12ec
  store volatile i64 4844, i64* @_asm_program_counter
  %5 = zext i32 %3 to i64

; 0x12ef
  store volatile i64 4847, i64* @_asm_program_counter
  %6 = trunc i64 %5 to i32
  %7 = ashr i32 %6, 31
  %8 = zext i32 %7 to i64

; 0x12f0
  store volatile i64 4848, i64* @_asm_program_counter
  %9 = trunc i64 %8 to i32
  %10 = lshr i32 %9, 28
  %11 = zext i32 %10 to i64

; 0x12f3
  store volatile i64 4851, i64* @_asm_program_counter
  %12 = trunc i64 %5 to i32
  %13 = trunc i64 %11 to i32
  %14 = add i32 %12, %13
  %15 = zext i32 %14 to i64

; 0x12f5
  store volatile i64 4853, i64* @_asm_program_counter
  %16 = trunc i64 %15 to i32
  %17 = and i32 %16, 15
  %18 = zext i32 %17 to i64

; 0x12f8
  store volatile i64 4856, i64* @_asm_program_counter
  %19 = trunc i64 %18 to i32
  %20 = trunc i64 %11 to i32
  %21 = sub i32 %19, %20
  %22 = zext i32 %21 to i64

; 0x12fa
  store volatile i64 4858, i64* @_asm_program_counter
  %23 = trunc i64 %22 to i32
  %24 = sext i32 %23 to i64

; 0x12fc
  store volatile i64 4860, i64* @_asm_program_counter

; 0x1303
  store volatile i64 4867, i64* @_asm_program_counter
  %25 = mul i64 ptrtoint (i8* @global_var_4060 to i64), 1
  %26 = add i64 %24, %25
  %27 = inttoptr i64 %26 to i8*
  store i8 66, i8* %27

; 0x1307
  store volatile i64 4871, i64* @_asm_program_counter
  %28 = load i8, i8* @global_var_4060
  %29 = zext i8 %28 to i64

; 0x130e
  store volatile i64 4878, i64* @_asm_program_counter
  %30 = trunc i64 %29 to i8

; 0x1311
  store volatile i64 4881, i64* @_asm_program_counter
  %31 = sext i8 %30 to i64

; 0x1315
  store volatile i64 4885, i64* @_asm_program_counter
  %32 = zext i32 %3 to i64

; 0x1318
  store volatile i64 4888, i64* @_asm_program_counter
  %33 = trunc i64 %32 to i32
  %34 = zext i32 %33 to i64

; 0x131a
  store volatile i64 4890, i64* @_asm_program_counter

; 0x1321
  store volatile i64 4897, i64* @_asm_program_counter

; 0x1324
  store volatile i64 4900, i64* @_asm_program_counter

; 0x1329
  store volatile i64 4905, i64* @_asm_program_counter
  %35 = load i64, i64* @rcx
  %36 = load i64, i64* @r8
  %37 = load i64, i64* @r9
  %38 = call i64 @printf(i64 ptrtoint ([16 x i8]* @global_var_202a to i64), i64 %34, i64 %31, i64 %35, i64 %36, i64 %37)

; 0x132e
  store volatile i64 4910, i64* @_asm_program_counter

; 0x132f
  store volatile i64 4911, i64* @_asm_program_counter

; 0x1330
  store volatile i64 4912, i64* @_asm_program_counter
  ret i64 %38

; uselistorder directives
  uselistorder i64 %11, { 1, 0 }
  uselistorder i64 %5, { 1, 0 }
  uselistorder i32 %3, { 1, 0 }
  uselistorder i8* @global_var_4060, { 1, 2, 0 }
  uselistorder i32* @global_var_4010, { 1, 0 }
}

define i64 @function_1331() {
dec_label_pc_1331:

; 0x1331
  store volatile i64 4913, i64* @_asm_program_counter

; 0x1335
  store volatile i64 4917, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1336
  store volatile i64 4918, i64* @_asm_program_counter

; 0x1339
  store volatile i64 4921, i64* @_asm_program_counter

; 0x133d
  store volatile i64 4925, i64* @_asm_program_counter

; 0x1342
  store volatile i64 4930, i64* @_asm_program_counter
  %1 = load i64, i64* @rsi
  %2 = load i64, i64* @rdx
  %3 = load i64, i64* @rcx
  %4 = call i64 @malloc(i64 4, i64 %1, i64 %2, i64 %3)

; 0x1347
  store volatile i64 4935, i64* @_asm_program_counter

; 0x134b
  store volatile i64 4939, i64* @_asm_program_counter

; 0x134f
  store volatile i64 4943, i64* @_asm_program_counter
  %5 = inttoptr i64 %4 to i32*
  store i32 42, i32* %5

; 0x1355
  store volatile i64 4949, i64* @_asm_program_counter

; 0x1359
  store volatile i64 4953, i64* @_asm_program_counter
  %6 = inttoptr i64 %4 to i32*
  %7 = load i32, i32* %6
  %8 = zext i32 %7 to i64

; 0x135b
  store volatile i64 4955, i64* @_asm_program_counter
  %9 = trunc i64 %8 to i32
  %10 = sext i32 %9 to i64
  %11 = sext i64 %10 to i128

; 0x135e
  store volatile i64 4958, i64* @_asm_program_counter

; 0x1363
  store volatile i64 4963, i64* @_asm_program_counter
  %12 = load i64, i64* @rsi
  %13 = load i64, i64* @rdx
  %14 = load i64, i64* @rcx
  %15 = call i64 @malloc(i64 40, i64 %12, i64 %13, i64 %14)

; 0x1368
  store volatile i64 4968, i64* @_asm_program_counter

; 0x136c
  store volatile i64 4972, i64* @_asm_program_counter

; 0x1370
  store volatile i64 4976, i64* @_asm_program_counter
  %16 = inttoptr i64 %15 to i32*
  store i32 0, i32* %16

; 0x1376
  store volatile i64 4982, i64* @_asm_program_counter

; 0x137a
  store volatile i64 4986, i64* @_asm_program_counter
  %17 = add i64 %15, 20

; 0x137e
  store volatile i64 4990, i64* @_asm_program_counter
  %18 = inttoptr i64 %17 to i32*
  store i32 50, i32* %18

; 0x1384
  store volatile i64 4996, i64* @_asm_program_counter
  %19 = trunc i128 %11 to i64
  %20 = trunc i64 %19 to i32
  %21 = zext i32 %20 to i64

; 0x1387
  store volatile i64 4999, i64* @_asm_program_counter
  %22 = trunc i64 %21 to i32
  %23 = sext i32 %22 to i64

; 0x138a
  store volatile i64 5002, i64* @_asm_program_counter
  %24 = sext i64 %23 to i128
  %25 = mul i128 %24, 1717986919
  %26 = trunc i128 %25 to i64

; 0x1391
  store volatile i64 5009, i64* @_asm_program_counter
  %27 = lshr i64 %26, 32

; 0x1395
  store volatile i64 5013, i64* @_asm_program_counter
  %28 = trunc i64 %27 to i32
  %29 = ashr i32 %28, 2
  %30 = zext i32 %29 to i64

; 0x1398
  store volatile i64 5016, i64* @_asm_program_counter
  %31 = trunc i64 %21 to i32
  %32 = zext i32 %31 to i64

; 0x139a
  store volatile i64 5018, i64* @_asm_program_counter
  %33 = trunc i64 %32 to i32
  %34 = ashr i32 %33, 31
  %35 = zext i32 %34 to i64

; 0x139d
  store volatile i64 5021, i64* @_asm_program_counter
  %36 = trunc i64 %30 to i32
  %37 = trunc i64 %35 to i32
  %38 = sub i32 %36, %37
  %39 = zext i32 %38 to i64

; 0x139f
  store volatile i64 5023, i64* @_asm_program_counter
  %40 = trunc i64 %39 to i32
  %41 = zext i32 %40 to i64

; 0x13a1
  store volatile i64 5025, i64* @_asm_program_counter
  %42 = trunc i64 %41 to i32
  %43 = zext i32 %42 to i64

; 0x13a3
  store volatile i64 5027, i64* @_asm_program_counter
  %44 = trunc i64 %43 to i32
  %45 = shl i32 %44, 2
  %46 = zext i32 %45 to i64

; 0x13a6
  store volatile i64 5030, i64* @_asm_program_counter
  %47 = trunc i64 %46 to i32
  %48 = trunc i64 %41 to i32
  %49 = add i32 %47, %48
  %50 = zext i32 %49 to i64

; 0x13a8
  store volatile i64 5032, i64* @_asm_program_counter
  %51 = trunc i64 %50 to i32
  %52 = trunc i64 %50 to i32
  %53 = add i32 %51, %52
  %54 = zext i32 %53 to i64

; 0x13aa
  store volatile i64 5034, i64* @_asm_program_counter
  %55 = trunc i64 %21 to i32
  %56 = trunc i64 %54 to i32
  %57 = sub i32 %55, %56
  %58 = zext i32 %57 to i64

; 0x13ac
  store volatile i64 5036, i64* @_asm_program_counter
  %59 = trunc i64 %58 to i32
  %60 = zext i32 %59 to i64

; 0x13ae
  store volatile i64 5038, i64* @_asm_program_counter
  %61 = trunc i64 %60 to i32
  %62 = sext i32 %61 to i64

; 0x13b1
  store volatile i64 5041, i64* @_asm_program_counter
  %63 = mul i64 %62, 4

; 0x13b9
  store volatile i64 5049, i64* @_asm_program_counter

; 0x13bd
  store volatile i64 5053, i64* @_asm_program_counter
  %64 = add i64 %15, %63

; 0x13c0
  store volatile i64 5056, i64* @_asm_program_counter
  %65 = inttoptr i64 %64 to i32*
  store i32 99, i32* %65

; 0x13c6
  store volatile i64 5062, i64* @_asm_program_counter

; 0x13cb
  store volatile i64 5067, i64* @_asm_program_counter
  %66 = call i64 @malloc(i64 24, i64 %35, i64 %63, i64 %58)

; 0x13d0
  store volatile i64 5072, i64* @_asm_program_counter

; 0x13d4
  store volatile i64 5076, i64* @_asm_program_counter

; 0x13d8
  store volatile i64 5080, i64* @_asm_program_counter
  %67 = inttoptr i64 %66 to i32*
  store i32 1, i32* %67

; 0x13de
  store volatile i64 5086, i64* @_asm_program_counter

; 0x13e2
  store volatile i64 5090, i64* @_asm_program_counter
  %68 = trunc i128 %11 to i64
  %69 = trunc i64 %68 to i32
  %70 = zext i32 %69 to i64

; 0x13e5
  store volatile i64 5093, i64* @_asm_program_counter
  %71 = trunc i64 %70 to i32
  %72 = add i64 %66, 4
  %73 = inttoptr i64 %72 to i32*
  store i32 %71, i32* %73

; 0x13e8
  store volatile i64 5096, i64* @_asm_program_counter

; 0x13ec
  store volatile i64 5100, i64* @_asm_program_counter
  %74 = add i64 %66, 8

; 0x13f0
  store volatile i64 5104, i64* @_asm_program_counter
  %75 = inttoptr i64 %74 to i32*
  store i32 1885431144, i32* %75

; 0x13f6
  store volatile i64 5110, i64* @_asm_program_counter
  %76 = add i64 %66, 12
  %77 = inttoptr i64 %76 to i8*
  store i8 0, i8* %77

; 0x13fa
  store volatile i64 5114, i64* @_asm_program_counter

; 0x13fe
  store volatile i64 5118, i64* @_asm_program_counter
  %78 = inttoptr i64 %66 to i32*
  %79 = load i32, i32* %78
  %80 = zext i32 %79 to i64

; 0x1400
  store volatile i64 5120, i64* @_asm_program_counter
  %81 = trunc i64 %80 to i32

; 0x1403
  store volatile i64 5123, i64* @_asm_program_counter
  %82 = zext i32 %81 to i64

; 0x1406
  store volatile i64 5126, i64* @_asm_program_counter
  %83 = trunc i128 %11 to i64
  %84 = trunc i64 %83 to i32
  %85 = zext i32 %84 to i64

; 0x1409
  store volatile i64 5129, i64* @_asm_program_counter
  %86 = trunc i64 %85 to i32
  %87 = zext i32 %86 to i64

; 0x140b
  store volatile i64 5131, i64* @_asm_program_counter

; 0x1412
  store volatile i64 5138, i64* @_asm_program_counter

; 0x1415
  store volatile i64 5141, i64* @_asm_program_counter

; 0x141a
  store volatile i64 5146, i64* @_asm_program_counter
  %88 = load i64, i64* @r8
  %89 = load i64, i64* @r9
  %90 = call i64 @printf(i64 ptrtoint ([14 x i8]* @global_var_203a to i64), i64 %87, i64 %82, i64 %58, i64 %88, i64 %89)

; 0x141f
  store volatile i64 5151, i64* @_asm_program_counter

; 0x1423
  store volatile i64 5155, i64* @_asm_program_counter

; 0x1426
  store volatile i64 5158, i64* @_asm_program_counter
  %91 = call i64 @free(i64 %4)

; 0x142b
  store volatile i64 5163, i64* @_asm_program_counter

; 0x142f
  store volatile i64 5167, i64* @_asm_program_counter

; 0x1432
  store volatile i64 5170, i64* @_asm_program_counter
  %92 = call i64 @free(i64 %15)

; 0x1437
  store volatile i64 5175, i64* @_asm_program_counter

; 0x143b
  store volatile i64 5179, i64* @_asm_program_counter

; 0x143e
  store volatile i64 5182, i64* @_asm_program_counter
  %93 = call i64 @free(i64 %66)

; 0x1443
  store volatile i64 5187, i64* @_asm_program_counter

; 0x1444
  store volatile i64 5188, i64* @_asm_program_counter

; 0x1445
  store volatile i64 5189, i64* @_asm_program_counter
  ret i64 %93

; uselistorder directives
  uselistorder i64 %66, { 1, 2, 0, 3, 4, 5 }
  uselistorder i64 %63, { 1, 0 }
  uselistorder i64 %58, { 2, 1, 0 }
  uselistorder i64 %50, { 1, 0 }
  uselistorder i64 %41, { 1, 0 }
  uselistorder i64 %35, { 1, 0 }
  uselistorder i64 %21, { 2, 1, 0 }
  uselistorder i8 0, { 2, 3, 0, 1 }
  uselistorder i32 42, { 1, 0 }
}

define i64 @function_1446() {
dec_label_pc_1446:
  %stack_var_-8 = alloca i64

; 0x1446
  store volatile i64 5190, i64* @_asm_program_counter

; 0x144a
  store volatile i64 5194, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  store i64 %0, i64* %stack_var_-8

; 0x144b
  store volatile i64 5195, i64* @_asm_program_counter
  %1 = ptrtoint i64* %stack_var_-8 to i64

; 0x144e
  store volatile i64 5198, i64* @_asm_program_counter

; 0x1455
  store volatile i64 5205, i64* @_asm_program_counter
  %2 = call i64 @__readfsqword(i64 40)

; 0x145e
  store volatile i64 5214, i64* @_asm_program_counter

; 0x1462
  store volatile i64 5218, i64* @_asm_program_counter

; 0x1464
  store volatile i64 5220, i64* @_asm_program_counter
  %3 = sext i32 5 to i64
  %4 = trunc i64 %3 to i32

; 0x146e
  store volatile i64 5230, i64* @_asm_program_counter

; 0x1478
  store volatile i64 5240, i64* @_asm_program_counter

; 0x147f
  store volatile i64 5247, i64* @_asm_program_counter
  %5 = sext i32 %4 to i64
  %6 = trunc i64 %5 to i32
  %7 = zext i32 %6 to i64

; 0x1485
  store volatile i64 5253, i64* @_asm_program_counter
  %8 = trunc i64 %7 to i32
  %9 = sext i32 %8 to i64

; 0x1487
  store volatile i64 5255, i64* @_asm_program_counter
  %10 = mul i64 %9, 4
  %11 = add i64 %1, -144
  %12 = add i64 %11, %10
  %13 = inttoptr i64 %12 to i32*
  store i32 300, i32* %13

; 0x1492
  store volatile i64 5266, i64* @_asm_program_counter
  %14 = sext i32 %4 to i64
  %15 = trunc i64 %14 to i32
  %16 = zext i32 %15 to i64

; 0x1498
  store volatile i64 5272, i64* @_asm_program_counter
  %17 = trunc i64 %16 to i32
  %18 = add i32 %17, 2
  %19 = zext i32 %18 to i64

; 0x149b
  store volatile i64 5275, i64* @_asm_program_counter
  %20 = trunc i64 %19 to i32
  %21 = sext i32 %20 to i64

; 0x149d
  store volatile i64 5277, i64* @_asm_program_counter
  %22 = mul i64 %21, 4
  %23 = add i64 %1, -144
  %24 = add i64 %23, %22
  %25 = inttoptr i64 %24 to i32*
  store i32 400, i32* %25

; 0x14a8
  store volatile i64 5288, i64* @_asm_program_counter
  %26 = zext i32 100 to i64

; 0x14ae
  store volatile i64 5294, i64* @_asm_program_counter
  %27 = trunc i64 %26 to i32

; 0x14b4
  store volatile i64 5300, i64* @_asm_program_counter
  %28 = sext i32 %4 to i64
  %29 = trunc i64 %28 to i32
  %30 = zext i32 %29 to i64

; 0x14ba
  store volatile i64 5306, i64* @_asm_program_counter
  %31 = trunc i64 %30 to i32
  %32 = sext i32 %31 to i64

; 0x14bc
  store volatile i64 5308, i64* @_asm_program_counter
  %33 = mul i64 %32, 4
  %34 = add i64 %1, -144
  %35 = add i64 %34, %33
  %36 = inttoptr i64 %35 to i32*
  %37 = load i32, i32* %36
  %38 = zext i32 %37 to i64

; 0x14c3
  store volatile i64 5315, i64* @_asm_program_counter
  %39 = trunc i64 %38 to i32

; 0x14c9
  store volatile i64 5321, i64* @_asm_program_counter

; 0x14d0
  store volatile i64 5328, i64* @_asm_program_counter
  %40 = sext i32 %4 to i64
  %41 = trunc i64 %40 to i32
  %42 = zext i32 %41 to i64

; 0x14d6
  store volatile i64 5334, i64* @_asm_program_counter
  %43 = trunc i64 %42 to i32
  %44 = sext i32 %43 to i64

; 0x14d9
  store volatile i64 5337, i64* @_asm_program_counter

; 0x14dc
  store volatile i64 5340, i64* @_asm_program_counter
  %45 = shl i64 %44, 2

; 0x14e0
  store volatile i64 5344, i64* @_asm_program_counter
  %46 = add i64 %45, %44

; 0x14e3
  store volatile i64 5347, i64* @_asm_program_counter
  %47 = shl i64 %46, 2

; 0x14e7
  store volatile i64 5351, i64* @_asm_program_counter
  %48 = add i64 %47, %1

; 0x14ea
  store volatile i64 5354, i64* @_asm_program_counter
  %49 = sub i64 %48, 80

; 0x14ee
  store volatile i64 5358, i64* @_asm_program_counter
  %50 = inttoptr i64 %49 to i32*
  store i32 2, i32* %50

; 0x14f4
  store volatile i64 5364, i64* @_asm_program_counter
  %51 = zext i32 undef to i64

; 0x14f7
  store volatile i64 5367, i64* @_asm_program_counter
  %52 = trunc i64 %51 to i32

; 0x14fd
  store volatile i64 5373, i64* @_asm_program_counter
  %53 = zext i32 %52 to i64

; 0x1503
  store volatile i64 5379, i64* @_asm_program_counter
  %54 = zext i32 %39 to i64

; 0x1509
  store volatile i64 5385, i64* @_asm_program_counter
  %55 = zext i32 %27 to i64

; 0x150f
  store volatile i64 5391, i64* @_asm_program_counter
  %56 = trunc i64 %55 to i32
  %57 = zext i32 %56 to i64

; 0x1511
  store volatile i64 5393, i64* @_asm_program_counter

; 0x1518
  store volatile i64 5400, i64* @_asm_program_counter

; 0x151b
  store volatile i64 5403, i64* @_asm_program_counter

; 0x1520
  store volatile i64 5408, i64* @_asm_program_counter
  %58 = load i64, i64* @r8
  %59 = load i64, i64* @r9
  %60 = call i64 @printf(i64 ptrtoint ([19 x i8]* @global_var_2048 to i64), i64 %57, i64 %54, i64 %53, i64 %58, i64 %59)

; 0x1525
  store volatile i64 5413, i64* @_asm_program_counter

; 0x1526
  store volatile i64 5414, i64* @_asm_program_counter

; 0x152a
  store volatile i64 5418, i64* @_asm_program_counter
  %61 = call i64 @__readfsqword(i64 40)
  %62 = sub i64 %2, %61
  %63 = icmp eq i64 %62, 0
  store i64 %62, i64* @rax

; 0x1533
  store volatile i64 5427, i64* @_asm_program_counter
  br i1 %63, label %dec_label_pc_153a, label %dec_label_pc_1535

dec_label_pc_1535:                                ; preds = %dec_label_pc_1446

; 0x1535
  store volatile i64 5429, i64* @_asm_program_counter
  %64 = call i64 @__stack_chk_fail()
  store i64 %64, i64* @rax
  br label %dec_label_pc_153a

dec_label_pc_153a:                                ; preds = %dec_label_pc_1535, %dec_label_pc_1446

; 0x153a
  store volatile i64 5434, i64* @_asm_program_counter

; 0x153b
  store volatile i64 5435, i64* @_asm_program_counter
  %65 = load i64, i64* @rax
  ret i64 %65

; uselistorder directives
  uselistorder i64 %44, { 1, 0 }
  uselistorder i64 %1, { 3, 2, 1, 0 }
}

define i64 @function_153c() {
dec_label_pc_153c:

; 0x153c
  store volatile i64 5436, i64* @_asm_program_counter

; 0x1540
  store volatile i64 5440, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1541
  store volatile i64 5441, i64* @_asm_program_counter

; 0x1544
  store volatile i64 5444, i64* @_asm_program_counter

; 0x1548
  store volatile i64 5448, i64* @_asm_program_counter
  %1 = call i64 @__readfsqword(i64 40)

; 0x1551
  store volatile i64 5457, i64* @_asm_program_counter

; 0x1555
  store volatile i64 5461, i64* @_asm_program_counter

; 0x1557
  store volatile i64 5463, i64* @_asm_program_counter

; 0x155e
  store volatile i64 5470, i64* @_asm_program_counter

; 0x1565
  store volatile i64 5477, i64* @_asm_program_counter

; 0x1569
  store volatile i64 5481, i64* @_asm_program_counter

; 0x156d
  store volatile i64 5485, i64* @_asm_program_counter
  %2 = sext i32 1633906540 to i64
  %3 = trunc i64 %2 to i8

; 0x1573
  store volatile i64 5491, i64* @_asm_program_counter

; 0x1579
  store volatile i64 5497, i64* @_asm_program_counter
  %4 = zext i32 10 to i64

; 0x157c
  store volatile i64 5500, i64* @_asm_program_counter
  %5 = trunc i64 %4 to i32

; 0x157f
  store volatile i64 5503, i64* @_asm_program_counter
  %6 = zext i32 20 to i64

; 0x1582
  store volatile i64 5506, i64* @_asm_program_counter
  %7 = trunc i64 %6 to i32

; 0x1585
  store volatile i64 5509, i64* @_asm_program_counter
  %8 = sext i8 %3 to i64
  %9 = trunc i64 %8 to i8
  %10 = zext i8 %9 to i64

; 0x1589
  store volatile i64 5513, i64* @_asm_program_counter
  %11 = trunc i64 %10 to i8

; 0x158c
  store volatile i64 5516, i64* @_asm_program_counter

; 0x1590
  store volatile i64 5520, i64* @_asm_program_counter

; 0x1594
  store volatile i64 5524, i64* @_asm_program_counter

; 0x1598
  store volatile i64 5528, i64* @_asm_program_counter

; 0x159e
  store volatile i64 5534, i64* @_asm_program_counter

; 0x15a2
  store volatile i64 5538, i64* @_asm_program_counter

; 0x15a4
  store volatile i64 5540, i64* @_asm_program_counter

; 0x15a7
  store volatile i64 5543, i64* @_asm_program_counter
  %12 = zext i32 %7 to i64

; 0x15aa
  store volatile i64 5546, i64* @_asm_program_counter
  %13 = trunc i64 %12 to i32
  store i32 %13, i32* @global_var_4024

; 0x15b0
  store volatile i64 5552, i64* @_asm_program_counter
  %14 = load i32, i32* @global_var_4024
  %15 = zext i32 %14 to i64

; 0x15b6
  store volatile i64 5558, i64* @_asm_program_counter
  %16 = trunc i64 %15 to i32

; 0x15b9
  store volatile i64 5561, i64* @_asm_program_counter
  %17 = sext i8 %11 to i64

; 0x15bd
  store volatile i64 5565, i64* @_asm_program_counter
  %18 = zext i32 %16 to i64

; 0x15c0
  store volatile i64 5568, i64* @_asm_program_counter
  %19 = zext i32 %7 to i64

; 0x15c3
  store volatile i64 5571, i64* @_asm_program_counter
  %20 = zext i32 %5 to i64

; 0x15c6
  store volatile i64 5574, i64* @_asm_program_counter
  %21 = trunc i64 %18 to i32
  %22 = zext i32 %21 to i64

; 0x15c9
  store volatile i64 5577, i64* @_asm_program_counter
  %23 = trunc i64 %20 to i32
  %24 = zext i32 %23 to i64

; 0x15cb
  store volatile i64 5579, i64* @_asm_program_counter

; 0x15d2
  store volatile i64 5586, i64* @_asm_program_counter

; 0x15d5
  store volatile i64 5589, i64* @_asm_program_counter

; 0x15da
  store volatile i64 5594, i64* @_asm_program_counter
  %25 = load i64, i64* @r9
  %26 = call i64 @printf(i64 ptrtoint ([24 x i8]* @global_var_205b to i64), i64 %24, i64 %19, i64 %17, i64 %22, i64 %25)

; 0x15df
  store volatile i64 5599, i64* @_asm_program_counter

; 0x15e0
  store volatile i64 5600, i64* @_asm_program_counter

; 0x15e4
  store volatile i64 5604, i64* @_asm_program_counter
  %27 = call i64 @__readfsqword(i64 40)
  %28 = sub i64 %1, %27
  %29 = icmp eq i64 %28, 0
  store i64 %28, i64* @rax

; 0x15ed
  store volatile i64 5613, i64* @_asm_program_counter
  br i1 %29, label %dec_label_pc_15f4, label %dec_label_pc_15ef

dec_label_pc_15ef:                                ; preds = %dec_label_pc_153c

; 0x15ef
  store volatile i64 5615, i64* @_asm_program_counter
  %30 = call i64 @__stack_chk_fail()
  store i64 %30, i64* @rax
  br label %dec_label_pc_15f4

dec_label_pc_15f4:                                ; preds = %dec_label_pc_15ef, %dec_label_pc_153c

; 0x15f4
  store volatile i64 5620, i64* @_asm_program_counter

; 0x15f5
  store volatile i64 5621, i64* @_asm_program_counter
  %31 = load i64, i64* @rax
  ret i64 %31

; uselistorder directives
  uselistorder i32 %7, { 1, 0 }
  uselistorder i32* @global_var_4024, { 1, 0 }
}

define i64 @function_15f6() {
dec_label_pc_15f6:
  %stack_var_-56 = alloca i32
  %stack_var_-88 = alloca i32*
  %stack_var_-112 = alloca i32

; 0x15f6
  store volatile i64 5622, i64* @_asm_program_counter

; 0x15fa
  store volatile i64 5626, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x15fb
  store volatile i64 5627, i64* @_asm_program_counter

; 0x15fe
  store volatile i64 5630, i64* @_asm_program_counter

; 0x1602
  store volatile i64 5634, i64* @_asm_program_counter
  %1 = call i64 @__readfsqword(i64 40)

; 0x160b
  store volatile i64 5643, i64* @_asm_program_counter

; 0x160f
  store volatile i64 5647, i64* @_asm_program_counter

; 0x1611
  store volatile i64 5649, i64* @_asm_program_counter
  store i32 10, i32* %stack_var_-112

; 0x1618
  store volatile i64 5656, i64* @_asm_program_counter

; 0x161c
  store volatile i64 5660, i64* @_asm_program_counter
  %2 = ptrtoint i32* %stack_var_-112 to i64
  %3 = inttoptr i64 %2 to i32*
  store i32* %3, i32** %stack_var_-88

; 0x1620
  store volatile i64 5664, i64* @_asm_program_counter

; 0x1624
  store volatile i64 5668, i64* @_asm_program_counter
  %4 = ptrtoint i32** %stack_var_-88 to i64

; 0x1628
  store volatile i64 5672, i64* @_asm_program_counter

; 0x162c
  store volatile i64 5676, i64* @_asm_program_counter

; 0x1630
  store volatile i64 5680, i64* @_asm_program_counter
  %5 = load i32*, i32** %stack_var_-88
  %6 = ptrtoint i32* %5 to i64

; 0x1634
  store volatile i64 5684, i64* @_asm_program_counter
  %7 = inttoptr i64 %6 to i32*
  store i32 20, i32* %7

; 0x163a
  store volatile i64 5690, i64* @_asm_program_counter

; 0x163e
  store volatile i64 5694, i64* @_asm_program_counter
  %8 = inttoptr i64 %4 to i64*
  %9 = load i64, i64* %8

; 0x1641
  store volatile i64 5697, i64* @_asm_program_counter
  %10 = inttoptr i64 %9 to i32*
  store i32 30, i32* %10

; 0x1647
  store volatile i64 5703, i64* @_asm_program_counter

; 0x164b
  store volatile i64 5707, i64* @_asm_program_counter

; 0x164e
  store volatile i64 5710, i64* @_asm_program_counter
  %11 = inttoptr i64 %4 to i64*
  %12 = load i64, i64* %11

; 0x1651
  store volatile i64 5713, i64* @_asm_program_counter
  %13 = inttoptr i64 %12 to i32*
  store i32 40, i32* %13

; 0x1657
  store volatile i64 5719, i64* @_asm_program_counter
  %14 = load i32*, i32** %stack_var_-88
  %15 = ptrtoint i32* %14 to i64

; 0x165b
  store volatile i64 5723, i64* @_asm_program_counter
  %16 = inttoptr i64 %15 to i32*
  %17 = load i32, i32* %16
  %18 = zext i32 %17 to i64

; 0x165d
  store volatile i64 5725, i64* @_asm_program_counter
  %19 = trunc i64 %18 to i32

; 0x1660
  store volatile i64 5728, i64* @_asm_program_counter

; 0x1664
  store volatile i64 5732, i64* @_asm_program_counter
  %20 = inttoptr i64 %4 to i64*
  %21 = load i64, i64* %20

; 0x1667
  store volatile i64 5735, i64* @_asm_program_counter
  %22 = inttoptr i64 %21 to i32*
  %23 = load i32, i32* %22
  %24 = zext i32 %23 to i64

; 0x1669
  store volatile i64 5737, i64* @_asm_program_counter
  %25 = trunc i64 %24 to i32

; 0x166c
  store volatile i64 5740, i64* @_asm_program_counter

; 0x1670
  store volatile i64 5744, i64* @_asm_program_counter

; 0x1673
  store volatile i64 5747, i64* @_asm_program_counter
  %26 = inttoptr i64 %4 to i64*
  %27 = load i64, i64* %26

; 0x1676
  store volatile i64 5750, i64* @_asm_program_counter
  %28 = inttoptr i64 %27 to i32*
  %29 = load i32, i32* %28
  %30 = zext i32 %29 to i64

; 0x1678
  store volatile i64 5752, i64* @_asm_program_counter
  %31 = trunc i64 %30 to i32

; 0x167b
  store volatile i64 5755, i64* @_asm_program_counter
  store i32 0, i32* %stack_var_-56

; 0x1682
  store volatile i64 5762, i64* @_asm_program_counter

; 0x1689
  store volatile i64 5769, i64* @_asm_program_counter

; 0x1690
  store volatile i64 5776, i64* @_asm_program_counter

; 0x1697
  store volatile i64 5783, i64* @_asm_program_counter

; 0x169e
  store volatile i64 5790, i64* @_asm_program_counter

; 0x16a5
  store volatile i64 5797, i64* @_asm_program_counter

; 0x16ac
  store volatile i64 5804, i64* @_asm_program_counter

; 0x16b3
  store volatile i64 5811, i64* @_asm_program_counter

; 0x16ba
  store volatile i64 5818, i64* @_asm_program_counter

; 0x16c1
  store volatile i64 5825, i64* @_asm_program_counter

; 0x16c5
  store volatile i64 5829, i64* @_asm_program_counter
  %32 = ptrtoint i32* %stack_var_-56 to i64

; 0x16c9
  store volatile i64 5833, i64* @_asm_program_counter
  %33 = add i64 %32, 12

; 0x16ce
  store volatile i64 5838, i64* @_asm_program_counter

; 0x16d2
  store volatile i64 5842, i64* @_asm_program_counter
  %34 = inttoptr i64 %33 to i32*
  %35 = load i32, i32* %34
  %36 = zext i32 %35 to i64

; 0x16d4
  store volatile i64 5844, i64* @_asm_program_counter
  %37 = trunc i64 %36 to i32

; 0x16d7
  store volatile i64 5847, i64* @_asm_program_counter
  %38 = sub i64 %33, 4

; 0x16dc
  store volatile i64 5852, i64* @_asm_program_counter

; 0x16e0
  store volatile i64 5856, i64* @_asm_program_counter
  %39 = inttoptr i64 %38 to i32*
  %40 = load i32, i32* %39
  %41 = zext i32 %40 to i64

; 0x16e2
  store volatile i64 5858, i64* @_asm_program_counter
  %42 = trunc i64 %41 to i32

; 0x16e5
  store volatile i64 5861, i64* @_asm_program_counter
  %43 = zext i32 %42 to i64

; 0x16e8
  store volatile i64 5864, i64* @_asm_program_counter
  %44 = zext i32 %37 to i64

; 0x16eb
  store volatile i64 5867, i64* @_asm_program_counter
  %45 = zext i32 %31 to i64

; 0x16ee
  store volatile i64 5870, i64* @_asm_program_counter
  %46 = zext i32 %25 to i64

; 0x16f1
  store volatile i64 5873, i64* @_asm_program_counter
  %47 = zext i32 %19 to i64

; 0x16f4
  store volatile i64 5876, i64* @_asm_program_counter
  %48 = trunc i64 %43 to i32
  %49 = zext i32 %48 to i64

; 0x16f7
  store volatile i64 5879, i64* @_asm_program_counter
  %50 = trunc i64 %44 to i32
  %51 = zext i32 %50 to i64

; 0x16fa
  store volatile i64 5882, i64* @_asm_program_counter
  %52 = trunc i64 %47 to i32
  %53 = zext i32 %52 to i64

; 0x16fc
  store volatile i64 5884, i64* @_asm_program_counter

; 0x1703
  store volatile i64 5891, i64* @_asm_program_counter

; 0x1706
  store volatile i64 5894, i64* @_asm_program_counter

; 0x170b
  store volatile i64 5899, i64* @_asm_program_counter
  %54 = call i64 @printf(i64 ptrtoint ([29 x i8]* @global_var_2073 to i64), i64 %53, i64 %46, i64 %45, i64 %51, i64 %49)

; 0x1710
  store volatile i64 5904, i64* @_asm_program_counter

; 0x1711
  store volatile i64 5905, i64* @_asm_program_counter

; 0x1715
  store volatile i64 5909, i64* @_asm_program_counter
  %55 = call i64 @__readfsqword(i64 40)
  %56 = sub i64 %1, %55
  %57 = icmp eq i64 %56, 0
  store i64 %56, i64* @rax

; 0x171e
  store volatile i64 5918, i64* @_asm_program_counter
  br i1 %57, label %dec_label_pc_1725, label %dec_label_pc_1720

dec_label_pc_1720:                                ; preds = %dec_label_pc_15f6

; 0x1720
  store volatile i64 5920, i64* @_asm_program_counter
  %58 = call i64 @__stack_chk_fail()
  store i64 %58, i64* @rax
  br label %dec_label_pc_1725

dec_label_pc_1725:                                ; preds = %dec_label_pc_1720, %dec_label_pc_15f6

; 0x1725
  store volatile i64 5925, i64* @_asm_program_counter

; 0x1726
  store volatile i64 5926, i64* @_asm_program_counter
  %59 = load i64, i64* @rax
  ret i64 %59

; uselistorder directives
  uselistorder i64 %33, { 1, 0 }
  uselistorder i64 %4, { 3, 1, 2, 0 }
  uselistorder i32** %stack_var_-88, { 3, 2, 1, 0 }
  uselistorder i64 4, { 1, 2, 3, 4, 5, 6, 0 }
  uselistorder i64 12, { 1, 0 }
}

define i64 @function_1727() {
dec_label_pc_1727:
  %stack_var_-72 = alloca i64

; 0x1727
  store volatile i64 5927, i64* @_asm_program_counter

; 0x172b
  store volatile i64 5931, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x172c
  store volatile i64 5932, i64* @_asm_program_counter

; 0x172f
  store volatile i64 5935, i64* @_asm_program_counter
  %1 = ptrtoint i64* %stack_var_-72 to i64
  store i64 %1, i64* @rsp

; 0x1733
  store volatile i64 5939, i64* @_asm_program_counter
  %2 = call i64 @__readfsqword(i64 40)

; 0x173c
  store volatile i64 5948, i64* @_asm_program_counter

; 0x1740
  store volatile i64 5952, i64* @_asm_program_counter

; 0x1742
  store volatile i64 5954, i64* @_asm_program_counter

; 0x1749
  store volatile i64 5961, i64* @_asm_program_counter

; 0x174d
  store volatile i64 5965, i64* @_asm_program_counter

; 0x1754
  store volatile i64 5972, i64* @_asm_program_counter

; 0x1758
  store volatile i64 5976, i64* @_asm_program_counter

; 0x175c
  store volatile i64 5980, i64* @_asm_program_counter

; 0x1761
  store volatile i64 5985, i64* @_asm_program_counter
  %3 = sub i64 %1, 8
  %4 = inttoptr i64 %3 to i64*
  call void @__pseudo_call(i64 4585), !retdec.call_type !0, !retdec.indirect_target !1

; 0x1763
  store volatile i64 5987, i64* @_asm_program_counter

; 0x1767
  store volatile i64 5991, i64* @_asm_program_counter

; 0x176c
  store volatile i64 5996, i64* @_asm_program_counter

; 0x1771
  store volatile i64 6001, i64* @_asm_program_counter
  %5 = sub i64 %1, 8
  %6 = inttoptr i64 %5 to i64*
  call void @__pseudo_call(i64 4671), !retdec.call_type !0, !retdec.indirect_target !2

; 0x1773
  store volatile i64 6003, i64* @_asm_program_counter
  %7 = trunc i64 4671 to i32

; 0x1776
  store volatile i64 6006, i64* @_asm_program_counter

; 0x177d
  store volatile i64 6013, i64* @_asm_program_counter

; 0x1781
  store volatile i64 6017, i64* @_asm_program_counter

; 0x1788
  store volatile i64 6024, i64* @_asm_program_counter

; 0x178c
  store volatile i64 6028, i64* @_asm_program_counter

; 0x1790
  store volatile i64 6032, i64* @_asm_program_counter

; 0x1795
  store volatile i64 6037, i64* @_asm_program_counter
  %8 = sub i64 %1, 8
  %9 = inttoptr i64 %8 to i64*
  call void @__pseudo_call(i64 4585), !retdec.call_type !0, !retdec.indirect_target !3

; 0x1797
  store volatile i64 6039, i64* @_asm_program_counter

; 0x179b
  store volatile i64 6043, i64* @_asm_program_counter

; 0x17a0
  store volatile i64 6048, i64* @_asm_program_counter
  %10 = sub i64 %1, 8
  %11 = inttoptr i64 %10 to i64*
  call void @__pseudo_call(i64 4628), !retdec.call_type !0, !retdec.indirect_target !4

; 0x17a2
  store volatile i64 6050, i64* @_asm_program_counter

; 0x17a9
  store volatile i64 6057, i64* @_asm_program_counter
  store i64 4585, i64* @global_var_40a8

; 0x17b0
  store volatile i64 6064, i64* @_asm_program_counter
  %12 = load i64, i64* @global_var_40a8

; 0x17b7
  store volatile i64 6071, i64* @_asm_program_counter
  %13 = icmp eq i64 %12, 0

; 0x17ba
  store volatile i64 6074, i64* @_asm_program_counter
  br i1 %13, label %dec_label_pc_17c5, label %dec_label_pc_17bc

dec_label_pc_17bc:                                ; preds = %dec_label_pc_1727

; 0x17bc
  store volatile i64 6076, i64* @_asm_program_counter
  %14 = load i64, i64* @global_var_40a8

; 0x17c3
  store volatile i64 6083, i64* @_asm_program_counter
  %15 = load i64, i64* @rsp
  %16 = sub i64 %15, 8
  %17 = inttoptr i64 %16 to i64*
  call void @__pseudo_call(i64 %14), !retdec.call_type !0, !retdec.indirect_target !5
  br label %dec_label_pc_17c5

dec_label_pc_17c5:                                ; preds = %dec_label_pc_17bc, %dec_label_pc_1727

; 0x17c5
  store volatile i64 6085, i64* @_asm_program_counter
  %18 = zext i32 %7 to i64

; 0x17c8
  store volatile i64 6088, i64* @_asm_program_counter
  %19 = trunc i64 %18 to i32
  %20 = zext i32 %19 to i64

; 0x17ca
  store volatile i64 6090, i64* @_asm_program_counter

; 0x17d1
  store volatile i64 6097, i64* @_asm_program_counter

; 0x17d4
  store volatile i64 6100, i64* @_asm_program_counter

; 0x17d9
  store volatile i64 6105, i64* @_asm_program_counter
  %21 = load i64, i64* @rdx
  %22 = load i64, i64* @rcx
  %23 = load i64, i64* @r8
  %24 = load i64, i64* @r9
  %25 = call i64 @printf(i64 ptrtoint ([13 x i8]* @global_var_2090 to i64), i64 %20, i64 %21, i64 %22, i64 %23, i64 %24)

; 0x17de
  store volatile i64 6110, i64* @_asm_program_counter

; 0x17df
  store volatile i64 6111, i64* @_asm_program_counter

; 0x17e3
  store volatile i64 6115, i64* @_asm_program_counter
  %26 = call i64 @__readfsqword(i64 40)
  %27 = sub i64 %2, %26
  %28 = icmp eq i64 %27, 0
  store i64 %27, i64* @rax

; 0x17ec
  store volatile i64 6124, i64* @_asm_program_counter
  br i1 %28, label %dec_label_pc_17f3, label %dec_label_pc_17ee

dec_label_pc_17ee:                                ; preds = %dec_label_pc_17c5

; 0x17ee
  store volatile i64 6126, i64* @_asm_program_counter
  %29 = call i64 @__stack_chk_fail()
  store i64 %29, i64* @rax
  br label %dec_label_pc_17f3

dec_label_pc_17f3:                                ; preds = %dec_label_pc_17ee, %dec_label_pc_17c5

; 0x17f3
  store volatile i64 6131, i64* @_asm_program_counter

; 0x17f4
  store volatile i64 6132, i64* @_asm_program_counter
  %30 = load i64, i64* @rax
  ret i64 %30

; uselistorder directives
  uselistorder i64 %1, { 3, 2, 1, 0, 4 }
  uselistorder i64 4671, { 1, 0, 2 }
}

define i64 @function_17f5() {
dec_label_pc_17f5:
  %stack_var_-8 = alloca i64

; 0x17f5
  store volatile i64 6133, i64* @_asm_program_counter

; 0x17f9
  store volatile i64 6137, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  store i64 %0, i64* %stack_var_-8

; 0x17fa
  store volatile i64 6138, i64* @_asm_program_counter
  %1 = ptrtoint i64* %stack_var_-8 to i64
  store i64 %1, i64* @rbp

; 0x17fd
  store volatile i64 6141, i64* @_asm_program_counter

; 0x1801
  store volatile i64 6145, i64* @_asm_program_counter
  %2 = call i64 @__readfsqword(i64 40)

; 0x180a
  store volatile i64 6154, i64* @_asm_program_counter

; 0x180e
  store volatile i64 6158, i64* @_asm_program_counter

; 0x1810
  store volatile i64 6160, i64* @_asm_program_counter

; 0x1817
  store volatile i64 6167, i64* @_asm_program_counter
  br label %dec_label_pc_1866

dec_label_pc_1819:                                ; preds = %dec_label_pc_1866

; 0x1819
  store volatile i64 6169, i64* @_asm_program_counter
  %3 = zext i32 %stack_var_-108.0 to i64

; 0x181c
  store volatile i64 6172, i64* @_asm_program_counter
  %4 = trunc i64 %3 to i32
  %5 = sext i32 %4 to i64

; 0x181f
  store volatile i64 6175, i64* @_asm_program_counter

; 0x1822
  store volatile i64 6178, i64* @_asm_program_counter
  %6 = add i64 %5, %5

; 0x1825
  store volatile i64 6181, i64* @_asm_program_counter
  %7 = add i64 %6, %5

; 0x1828
  store volatile i64 6184, i64* @_asm_program_counter
  %8 = shl i64 %7, 3

; 0x182c
  store volatile i64 6188, i64* @_asm_program_counter
  %9 = load i64, i64* @rbp
  %10 = add i64 %8, %9

; 0x182f
  store volatile i64 6191, i64* @_asm_program_counter
  %11 = add i64 %10, -80

; 0x1833
  store volatile i64 6195, i64* @_asm_program_counter
  %12 = zext i32 %stack_var_-108.0 to i64

; 0x1836
  store volatile i64 6198, i64* @_asm_program_counter
  %13 = trunc i64 %12 to i32
  %14 = inttoptr i64 %11 to i32*
  store i32 %13, i32* %14

; 0x1838
  store volatile i64 6200, i64* @_asm_program_counter
  %15 = zext i32 %stack_var_-108.0 to i64

; 0x183b
  store volatile i64 6203, i64* @_asm_program_counter
  %16 = trunc i64 %15 to i32
  %17 = zext i32 %16 to i64

; 0x183d
  store volatile i64 6205, i64* @_asm_program_counter
  %18 = trunc i64 %17 to i32
  %19 = shl i32 %18, 2
  %20 = zext i32 %19 to i64

; 0x1840
  store volatile i64 6208, i64* @_asm_program_counter
  %21 = trunc i64 %20 to i32
  %22 = trunc i64 %15 to i32
  %23 = add i32 %21, %22
  %24 = zext i32 %23 to i64

; 0x1842
  store volatile i64 6210, i64* @_asm_program_counter
  %25 = trunc i64 %24 to i32
  %26 = trunc i64 %24 to i32
  %27 = add i32 %25, %26
  %28 = zext i32 %27 to i64

; 0x1844
  store volatile i64 6212, i64* @_asm_program_counter
  %29 = trunc i64 %28 to i32
  %30 = zext i32 %29 to i64
  store i64 %30, i64* @rcx

; 0x1846
  store volatile i64 6214, i64* @_asm_program_counter
  %31 = zext i32 %stack_var_-108.0 to i64

; 0x1849
  store volatile i64 6217, i64* @_asm_program_counter
  %32 = trunc i64 %31 to i32
  %33 = sext i32 %32 to i64
  store i64 %33, i64* @rdx

; 0x184c
  store volatile i64 6220, i64* @_asm_program_counter

; 0x184f
  store volatile i64 6223, i64* @_asm_program_counter
  %34 = add i64 %33, %33

; 0x1852
  store volatile i64 6226, i64* @_asm_program_counter
  %35 = add i64 %34, %33

; 0x1855
  store volatile i64 6229, i64* @_asm_program_counter
  %36 = shl i64 %35, 3

; 0x1859
  store volatile i64 6233, i64* @_asm_program_counter
  %37 = load i64, i64* @rbp
  %38 = add i64 %36, %37

; 0x185c
  store volatile i64 6236, i64* @_asm_program_counter
  %39 = sub i64 %38, 76

; 0x1860
  store volatile i64 6240, i64* @_asm_program_counter
  %40 = trunc i64 %30 to i32
  %41 = inttoptr i64 %39 to i32*
  store i32 %40, i32* %41

; 0x1862
  store volatile i64 6242, i64* @_asm_program_counter
  %42 = add i32 %stack_var_-108.0, 1
  br label %dec_label_pc_1866

dec_label_pc_1866:                                ; preds = %dec_label_pc_1819, %dec_label_pc_17f5
  %stack_var_-108.0 = phi i32 [ 0, %dec_label_pc_17f5 ], [ %42, %dec_label_pc_1819 ]

; 0x1866
  store volatile i64 6246, i64* @_asm_program_counter
  %43 = sub i32 %stack_var_-108.0, 2
  %44 = xor i32 %stack_var_-108.0, 2
  %45 = xor i32 %stack_var_-108.0, %43
  %46 = and i32 %44, %45
  %47 = icmp slt i32 %46, 0
  %48 = icmp eq i32 %43, 0
  %49 = icmp slt i32 %43, 0

; 0x186a
  store volatile i64 6250, i64* @_asm_program_counter
  %50 = icmp ne i1 %49, %47
  %51 = or i1 %48, %50
  br i1 %51, label %dec_label_pc_1819, label %dec_label_pc_186c

dec_label_pc_186c:                                ; preds = %dec_label_pc_1866

; 0x186c
  store volatile i64 6252, i64* @_asm_program_counter

; 0x1871
  store volatile i64 6257, i64* @_asm_program_counter
  %52 = load i64, i64* @rsi
  %53 = load i64, i64* @rdx
  %54 = load i64, i64* @rcx
  %55 = call i64 @malloc(i64 16, i64 %52, i64 %53, i64 %54)

; 0x1876
  store volatile i64 6262, i64* @_asm_program_counter

; 0x187a
  store volatile i64 6266, i64* @_asm_program_counter

; 0x187e
  store volatile i64 6270, i64* @_asm_program_counter
  %56 = inttoptr i64 %55 to i32*
  store i32 0, i32* %56

; 0x1884
  store volatile i64 6276, i64* @_asm_program_counter

; 0x1889
  store volatile i64 6281, i64* @_asm_program_counter
  %57 = load i64, i64* @rsi
  %58 = load i64, i64* @rdx
  %59 = load i64, i64* @rcx
  %60 = call i64 @malloc(i64 16, i64 %57, i64 %58, i64 %59)

; 0x188e
  store volatile i64 6286, i64* @_asm_program_counter

; 0x1891
  store volatile i64 6289, i64* @_asm_program_counter

; 0x1895
  store volatile i64 6293, i64* @_asm_program_counter
  %61 = add i64 %55, 8
  %62 = inttoptr i64 %61 to i64*
  store i64 %60, i64* %62

; 0x1899
  store volatile i64 6297, i64* @_asm_program_counter

; 0x189d
  store volatile i64 6301, i64* @_asm_program_counter
  %63 = add i64 %55, 8
  %64 = inttoptr i64 %63 to i64*
  %65 = load i64, i64* %64

; 0x18a1
  store volatile i64 6305, i64* @_asm_program_counter
  %66 = inttoptr i64 %65 to i32*
  store i32 1, i32* %66

; 0x18a7
  store volatile i64 6311, i64* @_asm_program_counter

; 0x18ab
  store volatile i64 6315, i64* @_asm_program_counter
  %67 = add i64 %55, 8
  %68 = inttoptr i64 %67 to i64*
  %69 = load i64, i64* %68

; 0x18af
  store volatile i64 6319, i64* @_asm_program_counter
  %70 = add i64 %69, 8
  %71 = inttoptr i64 %70 to i64*
  store i64 0, i64* %71

; 0x18b7
  store volatile i64 6327, i64* @_asm_program_counter

; 0x18bb
  store volatile i64 6331, i64* @_asm_program_counter
  %72 = inttoptr i64 %55 to i32*

; 0x18bf
  store volatile i64 6335, i64* @_asm_program_counter
  br label %dec_label_pc_18dc

dec_label_pc_18c1:                                ; preds = %dec_label_pc_18dc

; 0x18c1
  store volatile i64 6337, i64* @_asm_program_counter
  %73 = ptrtoint i32* %stack_var_-104.0 to i64

; 0x18c5
  store volatile i64 6341, i64* @_asm_program_counter
  %74 = inttoptr i64 %73 to i32*
  %75 = load i32, i32* %74
  %76 = zext i32 %75 to i64

; 0x18c7
  store volatile i64 6343, i64* @_asm_program_counter
  %77 = add i64 %76, 1
  %78 = trunc i64 %77 to i32
  %79 = zext i32 %78 to i64

; 0x18ca
  store volatile i64 6346, i64* @_asm_program_counter
  %80 = ptrtoint i32* %stack_var_-104.0 to i64

; 0x18ce
  store volatile i64 6350, i64* @_asm_program_counter
  %81 = trunc i64 %79 to i32
  %82 = inttoptr i64 %80 to i32*
  store i32 %81, i32* %82

; 0x18d0
  store volatile i64 6352, i64* @_asm_program_counter
  %83 = ptrtoint i32* %stack_var_-104.0 to i64

; 0x18d4
  store volatile i64 6356, i64* @_asm_program_counter
  %84 = add i64 %83, 8
  %85 = inttoptr i64 %84 to i64*
  %86 = load i64, i64* %85

; 0x18d8
  store volatile i64 6360, i64* @_asm_program_counter
  %87 = inttoptr i64 %86 to i32*
  br label %dec_label_pc_18dc

dec_label_pc_18dc:                                ; preds = %dec_label_pc_18c1, %dec_label_pc_186c
  %stack_var_-104.0 = phi i32* [ %72, %dec_label_pc_186c ], [ %87, %dec_label_pc_18c1 ]

; 0x18dc
  store volatile i64 6364, i64* @_asm_program_counter
  %88 = ptrtoint i32* %stack_var_-104.0 to i64
  %89 = icmp eq i64 %88, 0

; 0x18e1
  store volatile i64 6369, i64* @_asm_program_counter
  %90 = icmp eq i1 %89, false
  br i1 %90, label %dec_label_pc_18c1, label %dec_label_pc_18e3

dec_label_pc_18e3:                                ; preds = %dec_label_pc_18dc

; 0x18e3
  store volatile i64 6371, i64* @_asm_program_counter

; 0x18e7
  store volatile i64 6375, i64* @_asm_program_counter
  %91 = add i64 %55, 8
  %92 = inttoptr i64 %91 to i64*
  %93 = load i64, i64* %92

; 0x18eb
  store volatile i64 6379, i64* @_asm_program_counter

; 0x18ee
  store volatile i64 6382, i64* @_asm_program_counter
  %94 = call i64 @free(i64 %93)

; 0x18f3
  store volatile i64 6387, i64* @_asm_program_counter

; 0x18f7
  store volatile i64 6391, i64* @_asm_program_counter

; 0x18fa
  store volatile i64 6394, i64* @_asm_program_counter
  %95 = call i64 @free(i64 %55)

; 0x18ff
  store volatile i64 6399, i64* @_asm_program_counter

; 0x1906
  store volatile i64 6406, i64* @_asm_program_counter

; 0x1909
  store volatile i64 6409, i64* @_asm_program_counter
  %96 = call i64 @puts(i64 ptrtoint ([14 x i8]* @global_var_209d to i64))

; 0x190e
  store volatile i64 6414, i64* @_asm_program_counter

; 0x190f
  store volatile i64 6415, i64* @_asm_program_counter

; 0x1913
  store volatile i64 6419, i64* @_asm_program_counter
  %97 = call i64 @__readfsqword(i64 40)
  %98 = sub i64 %2, %97
  %99 = icmp eq i64 %98, 0
  store i64 %98, i64* @rax

; 0x191c
  store volatile i64 6428, i64* @_asm_program_counter
  br i1 %99, label %dec_label_pc_1923, label %dec_label_pc_191e

dec_label_pc_191e:                                ; preds = %dec_label_pc_18e3

; 0x191e
  store volatile i64 6430, i64* @_asm_program_counter
  %100 = call i64 @__stack_chk_fail()
  store i64 %100, i64* @rax
  br label %dec_label_pc_1923

dec_label_pc_1923:                                ; preds = %dec_label_pc_191e, %dec_label_pc_18e3

; 0x1923
  store volatile i64 6435, i64* @_asm_program_counter

; 0x1924
  store volatile i64 6436, i64* @_asm_program_counter
  %101 = load i64, i64* @rax
  ret i64 %101

; uselistorder directives
  uselistorder i32* %stack_var_-104.0, { 3, 2, 1, 0 }
  uselistorder i64 %55, { 1, 0, 2, 3, 4, 5, 6 }
  uselistorder i32 %stack_var_-108.0, { 5, 6, 7, 4, 3, 2, 1, 0 }
  uselistorder i64 %33, { 2, 1, 0, 3 }
  uselistorder i64 %24, { 1, 0 }
  uselistorder i64 %15, { 1, 0 }
  uselistorder i64 %5, { 2, 1, 0 }
  uselistorder i64 (i64)* @free, { 4, 3, 2, 1, 0, 5 }
  uselistorder i64 8, { 1, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
  uselistorder i64 (i64, i64, i64, i64)* @malloc, { 4, 3, 2, 1, 0, 5 }
  uselistorder i32 2, { 1, 2, 0, 3, 4, 5, 6 }
}

define i64 @function_1925() {
dec_label_pc_1925:
  %stack_var_-88 = alloca i64
  %stack_var_-56 = alloca i64
  %stack_var_-120 = alloca i64
  %stack_var_-8 = alloca i64

; 0x1925
  store volatile i64 6437, i64* @_asm_program_counter

; 0x1929
  store volatile i64 6441, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  store i64 %0, i64* %stack_var_-8

; 0x192a
  store volatile i64 6442, i64* @_asm_program_counter
  %1 = ptrtoint i64* %stack_var_-8 to i64
  store i64 %1, i64* @rbp

; 0x192d
  store volatile i64 6445, i64* @_asm_program_counter

; 0x1931
  store volatile i64 6449, i64* @_asm_program_counter
  %2 = call i64 @__readfsqword(i64 40)

; 0x193a
  store volatile i64 6458, i64* @_asm_program_counter

; 0x193e
  store volatile i64 6462, i64* @_asm_program_counter

; 0x1940
  store volatile i64 6464, i64* @_asm_program_counter

; 0x194a
  store volatile i64 6474, i64* @_asm_program_counter

; 0x1954
  store volatile i64 6484, i64* @_asm_program_counter
  store i64 6278066737626506568, i64* %stack_var_-120

; 0x1958
  store volatile i64 6488, i64* @_asm_program_counter

; 0x195c
  store volatile i64 6492, i64* @_asm_program_counter

; 0x1964
  store volatile i64 6500, i64* @_asm_program_counter

; 0x196c
  store volatile i64 6508, i64* @_asm_program_counter

; 0x1973
  store volatile i64 6515, i64* @_asm_program_counter
  br label %dec_label_pc_198c

dec_label_pc_1975:                                ; preds = %dec_label_pc_198c

; 0x1975
  store volatile i64 6517, i64* @_asm_program_counter
  %3 = zext i32 %stack_var_-124.0 to i64

; 0x1978
  store volatile i64 6520, i64* @_asm_program_counter
  %4 = trunc i64 %3 to i32
  %5 = sext i32 %4 to i64

; 0x197a
  store volatile i64 6522, i64* @_asm_program_counter
  %6 = load i64, i64* @rbp
  %7 = mul i64 %5, 1
  %8 = add i64 %6, -112
  %9 = add i64 %8, %7
  %10 = inttoptr i64 %9 to i8*
  %11 = load i8, i8* %10
  %12 = zext i8 %11 to i64

; 0x197f
  store volatile i64 6527, i64* @_asm_program_counter
  %13 = zext i32 %stack_var_-124.0 to i64

; 0x1982
  store volatile i64 6530, i64* @_asm_program_counter
  %14 = trunc i64 %13 to i32
  %15 = sext i32 %14 to i64

; 0x1984
  store volatile i64 6532, i64* @_asm_program_counter
  %16 = trunc i64 %12 to i8
  %17 = load i64, i64* @rbp
  %18 = mul i64 %15, 1
  %19 = add i64 %17, -80
  %20 = add i64 %19, %18
  %21 = inttoptr i64 %20 to i8*
  store i8 %16, i8* %21

; 0x1988
  store volatile i64 6536, i64* @_asm_program_counter
  %22 = add i32 %stack_var_-124.0, 1
  br label %dec_label_pc_198c

dec_label_pc_198c:                                ; preds = %dec_label_pc_1975, %dec_label_pc_1925
  %stack_var_-124.0 = phi i32 [ 0, %dec_label_pc_1925 ], [ %22, %dec_label_pc_1975 ]

; 0x198c
  store volatile i64 6540, i64* @_asm_program_counter
  %23 = sub i32 %stack_var_-124.0, 13
  %24 = xor i32 %stack_var_-124.0, 13
  %25 = xor i32 %stack_var_-124.0, %23
  %26 = and i32 %24, %25
  %27 = icmp slt i32 %26, 0
  %28 = icmp eq i32 %23, 0
  %29 = icmp slt i32 %23, 0

; 0x1990
  store volatile i64 6544, i64* @_asm_program_counter
  %30 = icmp ne i1 %29, %27
  %31 = or i1 %28, %30
  br i1 %31, label %dec_label_pc_1975, label %dec_label_pc_1992

dec_label_pc_1992:                                ; preds = %dec_label_pc_198c

; 0x1992
  store volatile i64 6546, i64* @_asm_program_counter
  %32 = ptrtoint i64* %stack_var_-120 to i64

; 0x1996
  store volatile i64 6550, i64* @_asm_program_counter

; 0x199a
  store volatile i64 6554, i64* @_asm_program_counter

; 0x199f
  store volatile i64 6559, i64* @_asm_program_counter

; 0x19a2
  store volatile i64 6562, i64* @_asm_program_counter

; 0x19a5
  store volatile i64 6565, i64* @_asm_program_counter
  %33 = call i64 @memcpy(i64* %stack_var_-56, i64* %stack_var_-120, i64 14, i64* %stack_var_-120)

; 0x19aa
  store volatile i64 6570, i64* @_asm_program_counter

; 0x19ae
  store volatile i64 6574, i64* @_asm_program_counter
  %34 = ptrtoint i64* %stack_var_-88 to i64

; 0x19b1
  store volatile i64 6577, i64* @_asm_program_counter

; 0x19b8
  store volatile i64 6584, i64* @_asm_program_counter

; 0x19bb
  store volatile i64 6587, i64* @_asm_program_counter

; 0x19c0
  store volatile i64 6592, i64* @_asm_program_counter
  %35 = load i64, i64* @r8
  %36 = load i64, i64* @r9
  %37 = call i64 @printf(i64 ptrtoint ([10 x i8]* @global_var_20ab to i64), i64 %34, i64 14, i64 %32, i64 %35, i64 %36)

; 0x19c5
  store volatile i64 6597, i64* @_asm_program_counter

; 0x19c6
  store volatile i64 6598, i64* @_asm_program_counter

; 0x19ca
  store volatile i64 6602, i64* @_asm_program_counter
  %38 = call i64 @__readfsqword(i64 40)
  %39 = sub i64 %2, %38
  %40 = icmp eq i64 %39, 0
  store i64 %39, i64* @rax

; 0x19d3
  store volatile i64 6611, i64* @_asm_program_counter
  br i1 %40, label %dec_label_pc_19da, label %dec_label_pc_19d5

dec_label_pc_19d5:                                ; preds = %dec_label_pc_1992

; 0x19d5
  store volatile i64 6613, i64* @_asm_program_counter
  %41 = call i64 @__stack_chk_fail()
  store i64 %41, i64* @rax
  br label %dec_label_pc_19da

dec_label_pc_19da:                                ; preds = %dec_label_pc_19d5, %dec_label_pc_1992

; 0x19da
  store volatile i64 6618, i64* @_asm_program_counter

; 0x19db
  store volatile i64 6619, i64* @_asm_program_counter
  %42 = load i64, i64* @rax
  ret i64 %42

; uselistorder directives
  uselistorder i32 %stack_var_-124.0, { 3, 4, 5, 2, 1, 0 }
  uselistorder i64 14, { 1, 0 }
}

define i64 @function_19dc(i64 %arg1) {
dec_label_pc_19dc:
  %stack_var_-32 = alloca i32
  %stack_var_-36 = alloca i32

; 0x19dc
  store volatile i64 6620, i64* @_asm_program_counter

; 0x19e0
  store volatile i64 6624, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x19e1
  store volatile i64 6625, i64* @_asm_program_counter

; 0x19e4
  store volatile i64 6628, i64* @_asm_program_counter

; 0x19e8
  store volatile i64 6632, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32
  %2 = sext i32 %1 to i64

; 0x19eb
  store volatile i64 6635, i64* @_asm_program_counter
  %3 = call i64 @__readfsqword(i64 40)

; 0x19f4
  store volatile i64 6644, i64* @_asm_program_counter

; 0x19f8
  store volatile i64 6648, i64* @_asm_program_counter

; 0x19fa
  store volatile i64 6650, i64* @_asm_program_counter
  store i32 10, i32* %stack_var_-36

; 0x1a01
  store volatile i64 6657, i64* @_asm_program_counter
  store i32 20, i32* %stack_var_-32

; 0x1a08
  store volatile i64 6664, i64* @_asm_program_counter
  %4 = xor i32 %1, 0
  %5 = and i32 %4, 0
  %6 = icmp slt i32 %5, 0
  %7 = icmp eq i32 %1, 0
  %8 = icmp slt i32 %1, 0

; 0x1a0c
  store volatile i64 6668, i64* @_asm_program_counter
  %9 = icmp ne i1 %8, %6
  %10 = or i1 %7, %9
  br i1 %10, label %dec_label_pc_1a16, label %dec_label_pc_1a0e

dec_label_pc_1a0e:                                ; preds = %dec_label_pc_19dc

; 0x1a0e
  store volatile i64 6670, i64* @_asm_program_counter
  %11 = load i32, i32* %stack_var_-36
  %12 = zext i32 %11 to i64

; 0x1a11
  store volatile i64 6673, i64* @_asm_program_counter
  %13 = trunc i64 %12 to i32

; 0x1a14
  store volatile i64 6676, i64* @_asm_program_counter
  br label %dec_label_pc_1a1c

dec_label_pc_1a16:                                ; preds = %dec_label_pc_19dc

; 0x1a16
  store volatile i64 6678, i64* @_asm_program_counter
  %14 = load i32, i32* %stack_var_-32
  %15 = zext i32 %14 to i64

; 0x1a19
  store volatile i64 6681, i64* @_asm_program_counter
  %16 = trunc i64 %15 to i32
  br label %dec_label_pc_1a1c

dec_label_pc_1a1c:                                ; preds = %dec_label_pc_1a16, %dec_label_pc_1a0e
  %stack_var_-28.0 = phi i32 [ %16, %dec_label_pc_1a16 ], [ %13, %dec_label_pc_1a0e ]

; 0x1a1c
  store volatile i64 6684, i64* @_asm_program_counter

; 0x1a24
  store volatile i64 6692, i64* @_asm_program_counter
  %17 = trunc i64 %2 to i32
  %18 = icmp eq i32 %17, 0

; 0x1a28
  store volatile i64 6696, i64* @_asm_program_counter
  br i1 %18, label %dec_label_pc_1a34, label %dec_label_pc_1a2a

dec_label_pc_1a2a:                                ; preds = %dec_label_pc_1a1c

; 0x1a2a
  store volatile i64 6698, i64* @_asm_program_counter

; 0x1a2e
  store volatile i64 6702, i64* @_asm_program_counter
  %19 = ptrtoint i32* %stack_var_-36 to i64
  %20 = inttoptr i64 %19 to i32*

; 0x1a32
  store volatile i64 6706, i64* @_asm_program_counter
  br label %dec_label_pc_1a3c

dec_label_pc_1a34:                                ; preds = %dec_label_pc_1a1c

; 0x1a34
  store volatile i64 6708, i64* @_asm_program_counter

; 0x1a38
  store volatile i64 6712, i64* @_asm_program_counter
  %21 = ptrtoint i32* %stack_var_-32 to i64
  %22 = inttoptr i64 %21 to i32*
  br label %dec_label_pc_1a3c

dec_label_pc_1a3c:                                ; preds = %dec_label_pc_1a34, %dec_label_pc_1a2a
  %stack_var_-24.0 = phi i32* [ %22, %dec_label_pc_1a34 ], [ %20, %dec_label_pc_1a2a ]

; 0x1a3c
  store volatile i64 6716, i64* @_asm_program_counter
  %23 = ptrtoint i32* %stack_var_-24.0 to i64

; 0x1a40
  store volatile i64 6720, i64* @_asm_program_counter
  %24 = inttoptr i64 %23 to i32*
  store i32 100, i32* %24

; 0x1a46
  store volatile i64 6726, i64* @_asm_program_counter
  %25 = zext i32 %stack_var_-28.0 to i64

; 0x1a49
  store volatile i64 6729, i64* @_asm_program_counter
  %26 = trunc i64 %25 to i32
  %27 = zext i32 %26 to i64

; 0x1a4b
  store volatile i64 6731, i64* @_asm_program_counter

; 0x1a52
  store volatile i64 6738, i64* @_asm_program_counter

; 0x1a55
  store volatile i64 6741, i64* @_asm_program_counter

; 0x1a5a
  store volatile i64 6746, i64* @_asm_program_counter
  %28 = load i64, i64* @rdx
  %29 = load i64, i64* @rcx
  %30 = load i64, i64* @r8
  %31 = load i64, i64* @r9
  %32 = call i64 @printf(i64 ptrtoint ([17 x i8]* @global_var_20b5 to i64), i64 %27, i64 %28, i64 %29, i64 %30, i64 %31)

; 0x1a5f
  store volatile i64 6751, i64* @_asm_program_counter

; 0x1a60
  store volatile i64 6752, i64* @_asm_program_counter

; 0x1a64
  store volatile i64 6756, i64* @_asm_program_counter
  %33 = call i64 @__readfsqword(i64 40)
  %34 = sub i64 %3, %33
  %35 = icmp eq i64 %34, 0
  store i64 %34, i64* @rax

; 0x1a6d
  store volatile i64 6765, i64* @_asm_program_counter
  br i1 %35, label %dec_label_pc_1a74, label %dec_label_pc_1a6f

dec_label_pc_1a6f:                                ; preds = %dec_label_pc_1a3c

; 0x1a6f
  store volatile i64 6767, i64* @_asm_program_counter
  %36 = call i64 @__stack_chk_fail()
  store i64 %36, i64* @rax
  br label %dec_label_pc_1a74

dec_label_pc_1a74:                                ; preds = %dec_label_pc_1a6f, %dec_label_pc_1a3c

; 0x1a74
  store volatile i64 6772, i64* @_asm_program_counter

; 0x1a75
  store volatile i64 6773, i64* @_asm_program_counter
  %37 = load i64, i64* @rax
  ret i64 %37

; uselistorder directives
  uselistorder i32 %1, { 2, 1, 3, 0 }
  uselistorder i64 ()* @__stack_chk_fail, { 6, 0, 1, 2, 3, 4, 5, 7 }
  uselistorder i64 (i64, i64, i64, i64, i64, i64)* @printf, { 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 11 }
  uselistorder i64* @rcx, { 4, 0, 1, 10, 5, 2, 3, 6, 7, 8, 9 }
  uselistorder i64* @rdx, { 4, 0, 1, 8, 5, 2, 3, 6, 7 }
  uselistorder i32 100, { 3, 1, 2, 0 }
  uselistorder i32 20, { 2, 3, 0, 1 }
  uselistorder i32 10, { 2, 3, 0, 1 }
  uselistorder i64 40, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 }
}

declare i64 @17()

define i64 @function_1a76(i64 %arg1, i64 %arg2) {
dec_label_pc_1a76:

; 0x1a76
  store volatile i64 6774, i64* @_asm_program_counter

; 0x1a7a
  store volatile i64 6778, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp

; 0x1a7b
  store volatile i64 6779, i64* @_asm_program_counter

; 0x1a7e
  store volatile i64 6782, i64* @_asm_program_counter

; 0x1a82
  store volatile i64 6786, i64* @_asm_program_counter
  %1 = trunc i64 %arg1 to i32

; 0x1a85
  store volatile i64 6789, i64* @_asm_program_counter

; 0x1a89
  store volatile i64 6793, i64* @_asm_program_counter

; 0x1a90
  store volatile i64 6800, i64* @_asm_program_counter

; 0x1a93
  store volatile i64 6803, i64* @_asm_program_counter
  %2 = call i64 @puts(i64 ptrtoint ([27 x i8]* @global_var_20c6 to i64))

; 0x1a98
  store volatile i64 6808, i64* @_asm_program_counter
  %3 = call i64 @function_126d()

; 0x1a9d
  store volatile i64 6813, i64* @_asm_program_counter
  %4 = call i64 @function_12c4()

; 0x1aa2
  store volatile i64 6818, i64* @_asm_program_counter
  %5 = call i64 @function_1331()

; 0x1aa7
  store volatile i64 6823, i64* @_asm_program_counter
  %6 = call i64 @function_1446()

; 0x1aac
  store volatile i64 6828, i64* @_asm_program_counter
  %7 = call i64 @function_153c()

; 0x1ab1
  store volatile i64 6833, i64* @_asm_program_counter
  %8 = call i64 @function_15f6()

; 0x1ab6
  store volatile i64 6838, i64* @_asm_program_counter
  %9 = call i64 @function_1727()

; 0x1abb
  store volatile i64 6843, i64* @_asm_program_counter
  %10 = call i64 @function_17f5()

; 0x1ac0
  store volatile i64 6848, i64* @_asm_program_counter
  %11 = call i64 @function_1925()

; 0x1ac5
  store volatile i64 6853, i64* @_asm_program_counter
  %12 = sub i32 %1, 1
  %13 = xor i32 %1, 1
  %14 = xor i32 %1, %12
  %15 = and i32 %13, %14
  %16 = icmp slt i32 %15, 0
  %17 = icmp eq i32 %12, 0
  %18 = icmp slt i32 %12, 0

; 0x1ac9
  store volatile i64 6857, i64* @_asm_program_counter
  %19 = icmp eq i1 %18, %16
  %20 = icmp eq i1 %17, false
  %21 = icmp eq i1 %19, %20
  %22 = zext i1 %21 to i8
  %23 = zext i8 %22 to i64
  %24 = and i64 %11, -256
  %25 = or i64 %24, %23

; 0x1acc
  store volatile i64 6860, i64* @_asm_program_counter
  %26 = trunc i64 %25 to i8
  %27 = zext i8 %26 to i64

; 0x1acf
  store volatile i64 6863, i64* @_asm_program_counter
  %28 = trunc i64 %27 to i32
  %29 = zext i32 %28 to i64

; 0x1ad1
  store volatile i64 6865, i64* @_asm_program_counter
  %30 = call i64 @function_19dc(i64 %29)

; 0x1ad6
  store volatile i64 6870, i64* @_asm_program_counter

; 0x1add
  store volatile i64 6877, i64* @_asm_program_counter

; 0x1ae0
  store volatile i64 6880, i64* @_asm_program_counter
  %31 = call i64 @puts(i64 ptrtoint ([28 x i8]* @global_var_20e1 to i64))

; 0x1ae5
  store volatile i64 6885, i64* @_asm_program_counter

; 0x1aea
  store volatile i64 6890, i64* @_asm_program_counter

; 0x1aeb
  store volatile i64 6891, i64* @_asm_program_counter
  ret i64 0

; uselistorder directives
  uselistorder i32 0, { 5, 6, 7, 8, 9, 10, 11, 4, 12, 13, 14, 15, 0, 16, 17, 18, 19, 1, 3, 20, 2 }
  uselistorder i32 1, { 15, 16, 2, 1, 17, 6, 5, 4, 3, 19, 18, 7, 8, 10, 0, 9, 11, 20, 21, 13, 12, 14 }
  uselistorder i64 (i64)* @puts, { 2, 1, 0, 3 }
  uselistorder i64 6774, { 1, 0 }
}

declare i64 @18()

define i64 @function_1aec() {
dec_label_pc_1aec:

; 0x1aec
  store volatile i64 6892, i64* @_asm_program_counter

; 0x1af0
  store volatile i64 6896, i64* @_asm_program_counter

; 0x1af4
  store volatile i64 6900, i64* @_asm_program_counter

; 0x1af8
  store volatile i64 6904, i64* @_asm_program_counter
  %0 = load i64, i64* @rax
  ret i64 %0

; uselistorder directives
  uselistorder i64* @rax, { 0, 1, 12, 13, 2, 14, 15, 3, 16, 17, 4, 18, 19, 5, 20, 21, 6, 22, 23, 7, 24, 25, 8, 9, 26, 27, 10, 28, 29, 32, 11, 30, 31 }
  uselistorder i64 0, { 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 1, 2, 3, 4, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 }
  uselistorder i64* @_asm_program_counter, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 75, 76, 77, 78, 79, 80, 81, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 118, 119, 120, 121, 122, 123, 124, 125, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656 }
}

declare i64 @free(i64)

declare i64 @19()

declare i64 @puts(i64)

declare i64 @20()

declare i64 @__stack_chk_fail()

declare i64 @printf(i64, i64, i64, i64, i64, i64)

declare i64 @21()

declare i64 @memcpy(i64*, i64*, i64, i64*)

declare i64 @22()

declare i64 @malloc(i64, i64, i64, i64)

declare i64 @23()

declare i64 @__libc_start_main(i64, i64, i64*, i32, i32, i64, i64*, i64)

declare i64 @24()

declare i64 @_ITM_deregisterTMCloneTable(i64)

declare i64 @25()

declare i64 @__gmon_start__()

declare i64 @_ITM_registerTMCloneTable(i64, i64)

declare i64 @26()

declare i64 @__cxa_finalize(i64)

declare i64 @27()

declare void @__pseudo_call(i64)

declare void @__pseudo_return(i64)

declare void @__pseudo_branch(i64)

declare void @__pseudo_cond_branch(i1, i64)

declare void @__frontend_reg_store.fpr(i3, x86_fp80)

declare x86_fp80 @__frontend_reg_load.fpr(i3)

; Function Attrs: nounwind readnone speculatable
declare i8 @llvm.ctpop.i8(i8) #0

declare i64 @__asm_hlt()

declare void @28()

declare i64 @__readfsqword(i64)

attributes #0 = { nounwind readnone speculatable }

!0 = !{!"indirect_call"}
!1 = !{i64 4585}
!2 = !{i64 4671}
!3 = distinct !{i64 4585}
!4 = !{i64 4628}
!5 = !{i64 %14}
