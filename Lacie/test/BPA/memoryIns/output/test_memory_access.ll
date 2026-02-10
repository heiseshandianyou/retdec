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

define i64 @function_1000() {
dec_label_pc_1000:

; 0x1000
  store volatile i64 4096, i64* @_asm_program_counter

; 0x1004
  store volatile i64 4100, i64* @_asm_program_counter
  %0 = load i64, i64* @rsp
  %1 = sub i64 %0, 8
  %2 = and i64 %0, 15
  %3 = sub i64 %2, 8
  %4 = icmp ugt i64 %3, 15
  %5 = icmp ult i64 %0, 8
  %6 = xor i64 %0, 8
  %7 = xor i64 %0, %1
  %8 = and i64 %6, %7
  %9 = icmp slt i64 %8, 0
  store i1 %4, i1* @az
  store i1 %5, i1* @cf
  store i1 %9, i1* @of
  %10 = icmp eq i64 %1, 0
  store i1 %10, i1* @zf
  %11 = icmp slt i64 %1, 0
  store i1 %11, i1* @sf
  %12 = trunc i64 %1 to i8
  %13 = call i8 @llvm.ctpop.i8(i8 %12)
  %14 = and i8 %13, 1
  %15 = icmp eq i8 %14, 0
  store i1 %15, i1* @pf
  store i64 %1, i64* @rsp

; 0x1008
  store volatile i64 4104, i64* @_asm_program_counter
  %16 = load i64, i64* inttoptr (i64 16360 to i64*)
  store i64 %16, i64* @rax

; 0x100f
  store volatile i64 4111, i64* @_asm_program_counter
  %17 = load i64, i64* @rax
  %18 = load i64, i64* @rax
  %19 = and i64 %17, %18
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %20 = icmp eq i64 %19, 0
  store i1 %20, i1* @zf
  %21 = icmp slt i64 %19, 0
  store i1 %21, i1* @sf
  %22 = trunc i64 %19 to i8
  %23 = call i8 @llvm.ctpop.i8(i8 %22)
  %24 = and i8 %23, 1
  %25 = icmp eq i8 %24, 0
  store i1 %25, i1* @pf

; 0x1012
  store volatile i64 4114, i64* @_asm_program_counter
  %26 = load i1, i1* @zf
  br i1 %26, label %dec_label_pc_1016, label %dec_label_pc_1014

dec_label_pc_1014:                                ; preds = %dec_label_pc_1000

; 0x1014
  store volatile i64 4116, i64* @_asm_program_counter
  %27 = call i64 @__gmon_start__()
  store i64 %27, i64* @rax
  br label %dec_label_pc_1016

dec_label_pc_1016:                                ; preds = %dec_label_pc_1014, %dec_label_pc_1000

; 0x1016
  store volatile i64 4118, i64* @_asm_program_counter
  %28 = load i64, i64* @rsp
  %29 = add i64 %28, 8
  %30 = and i64 %28, 15
  %31 = add i64 %30, 8
  %32 = icmp ugt i64 %31, 15
  %33 = icmp ult i64 %29, %28
  %34 = xor i64 %28, %29
  %35 = xor i64 8, %29
  %36 = and i64 %34, %35
  %37 = icmp slt i64 %36, 0
  store i1 %32, i1* @az
  store i1 %33, i1* @cf
  store i1 %37, i1* @of
  %38 = icmp eq i64 %29, 0
  store i1 %38, i1* @zf
  %39 = icmp slt i64 %29, 0
  store i1 %39, i1* @sf
  %40 = trunc i64 %29 to i8
  %41 = call i8 @llvm.ctpop.i8(i8 %40)
  %42 = and i8 %41, 1
  %43 = icmp eq i8 %42, 0
  store i1 %43, i1* @pf
  store i64 %29, i64* @rsp

; 0x101a
  store volatile i64 4122, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1090() {
dec_label_pc_1090:

; 0x1090
  store volatile i64 4240, i64* @_asm_program_counter

; 0x1094
  store volatile i64 4244, i64* @_asm_program_counter
  %0 = call i64 @__cxa_finalize()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10a0() {
dec_label_pc_10a0:

; 0x10a0
  store volatile i64 4256, i64* @_asm_program_counter

; 0x10a4
  store volatile i64 4260, i64* @_asm_program_counter
  %0 = call i64 @free()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10b0() {
dec_label_pc_10b0:

; 0x10b0
  store volatile i64 4272, i64* @_asm_program_counter

; 0x10b4
  store volatile i64 4276, i64* @_asm_program_counter
  %0 = call i64 @puts()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10c0() {
dec_label_pc_10c0:

; 0x10c0
  store volatile i64 4288, i64* @_asm_program_counter

; 0x10c4
  store volatile i64 4292, i64* @_asm_program_counter
  %0 = call i64 @__stack_chk_fail()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10d0() {
dec_label_pc_10d0:

; 0x10d0
  store volatile i64 4304, i64* @_asm_program_counter

; 0x10d4
  store volatile i64 4308, i64* @_asm_program_counter
  %0 = call i64 @printf()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10e0() {
dec_label_pc_10e0:

; 0x10e0
  store volatile i64 4320, i64* @_asm_program_counter

; 0x10e4
  store volatile i64 4324, i64* @_asm_program_counter
  %0 = call i64 @memcpy()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_10f0() {
dec_label_pc_10f0:

; 0x10f0
  store volatile i64 4336, i64* @_asm_program_counter

; 0x10f4
  store volatile i64 4340, i64* @_asm_program_counter
  %0 = call i64 @malloc()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @entry_point() {
dec_label_pc_1100:

; 0x1100
  store volatile i64 4352, i64* @_asm_program_counter

; 0x1104
  store volatile i64 4356, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = trunc i64 %0 to i32
  %2 = load i64, i64* @rbp
  %3 = trunc i64 %2 to i32
  %4 = xor i32 %1, %3
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %5 = icmp eq i32 %4, 0
  store i1 %5, i1* @zf
  %6 = icmp slt i32 %4, 0
  store i1 %6, i1* @sf
  %7 = trunc i32 %4 to i8
  %8 = call i8 @llvm.ctpop.i8(i8 %7)
  %9 = and i8 %8, 1
  %10 = icmp eq i8 %9, 0
  store i1 %10, i1* @pf
  %11 = zext i32 %4 to i64
  store i64 %11, i64* @rbp

; 0x1106
  store volatile i64 4358, i64* @_asm_program_counter
  %12 = load i64, i64* @rdx
  store i64 %12, i64* @r9

; 0x1109
  store volatile i64 4361, i64* @_asm_program_counter
  %13 = load i64, i64* @rsp
  %14 = inttoptr i64 %13 to i64*
  %15 = load i64, i64* %14
  store i64 %15, i64* @rsi
  %16 = add i64 %13, 8
  store i64 %16, i64* @rsp

; 0x110a
  store volatile i64 4362, i64* @_asm_program_counter
  %17 = load i64, i64* @rsp
  store i64 %17, i64* @rdx

; 0x110d
  store volatile i64 4365, i64* @_asm_program_counter
  %18 = load i64, i64* @rsp
  %19 = and i64 %18, -16
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %20 = icmp eq i64 %19, 0
  store i1 %20, i1* @zf
  %21 = icmp slt i64 %19, 0
  store i1 %21, i1* @sf
  %22 = trunc i64 %19 to i8
  %23 = call i8 @llvm.ctpop.i8(i8 %22)
  %24 = and i8 %23, 1
  %25 = icmp eq i8 %24, 0
  store i1 %25, i1* @pf
  store i64 %19, i64* @rsp

; 0x1111
  store volatile i64 4369, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = load i64, i64* @rsp
  %28 = sub i64 %27, 8
  %29 = inttoptr i64 %28 to i64*
  store i64 %26, i64* %29
  store i64 %28, i64* @rsp

; 0x1112
  store volatile i64 4370, i64* @_asm_program_counter
  %30 = load i64, i64* @rsp
  %31 = load i64, i64* @rsp
  %32 = sub i64 %31, 8
  %33 = inttoptr i64 %32 to i64*
  store i64 %30, i64* %33
  store i64 %32, i64* @rsp

; 0x1113
  store volatile i64 4371, i64* @_asm_program_counter
  %34 = load i64, i64* @r8
  %35 = trunc i64 %34 to i32
  %36 = load i64, i64* @r8
  %37 = trunc i64 %36 to i32
  %38 = xor i32 %35, %37
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %39 = icmp eq i32 %38, 0
  store i1 %39, i1* @zf
  %40 = icmp slt i32 %38, 0
  store i1 %40, i1* @sf
  %41 = trunc i32 %38 to i8
  %42 = call i8 @llvm.ctpop.i8(i8 %41)
  %43 = and i8 %42, 1
  %44 = icmp eq i8 %43, 0
  store i1 %44, i1* @pf
  %45 = zext i32 %38 to i64
  store i64 %45, i64* @r8

; 0x1116
  store volatile i64 4374, i64* @_asm_program_counter
  %46 = load i64, i64* @rcx
  %47 = trunc i64 %46 to i32
  %48 = load i64, i64* @rcx
  %49 = trunc i64 %48 to i32
  %50 = xor i32 %47, %49
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %51 = icmp eq i32 %50, 0
  store i1 %51, i1* @zf
  %52 = icmp slt i32 %50, 0
  store i1 %52, i1* @sf
  %53 = trunc i32 %50 to i8
  %54 = call i8 @llvm.ctpop.i8(i8 %53)
  %55 = and i8 %54, 1
  %56 = icmp eq i8 %55, 0
  store i1 %56, i1* @pf
  %57 = zext i32 %50 to i64
  store i64 %57, i64* @rcx

; 0x1118
  store volatile i64 4376, i64* @_asm_program_counter
  store i64 6774, i64* @rdi

; 0x111f
  store volatile i64 4383, i64* @_asm_program_counter
  %58 = call i64 @__libc_start_main()
  store i64 %58, i64* @rax

; 0x1125
  store volatile i64 4389, i64* @_asm_program_counter
  call void @__asm_hlt()
  unreachable
}

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
  %0 = load i64, i64* @rax
  %1 = load i64, i64* @rdi
  %2 = sub i64 %0, %1
  %3 = and i64 %0, 15
  %4 = and i64 %1, 15
  %5 = sub i64 %3, %4
  %6 = icmp ugt i64 %5, 15
  %7 = icmp ult i64 %0, %1
  %8 = xor i64 %0, %1
  %9 = xor i64 %0, %2
  %10 = and i64 %8, %9
  %11 = icmp slt i64 %10, 0
  store i1 %6, i1* @az
  store i1 %7, i1* @cf
  store i1 %11, i1* @of
  %12 = icmp eq i64 %2, 0
  store i1 %12, i1* @zf
  %13 = icmp slt i64 %2, 0
  store i1 %13, i1* @sf
  %14 = trunc i64 %2 to i8
  %15 = call i8 @llvm.ctpop.i8(i8 %14)
  %16 = and i8 %15, 1
  %17 = icmp eq i8 %16, 0
  store i1 %17, i1* @pf

; 0x1141
  store volatile i64 4417, i64* @_asm_program_counter
  %18 = load i1, i1* @zf
  br i1 %18, label %dec_label_pc_1158, label %dec_label_pc_1143

dec_label_pc_1143:                                ; preds = %dec_label_pc_1130

; 0x1143
  store volatile i64 4419, i64* @_asm_program_counter
  %19 = load i64, i64* inttoptr (i64 16352 to i64*)
  store i64 %19, i64* @rax

; 0x114a
  store volatile i64 4426, i64* @_asm_program_counter
  %20 = load i64, i64* @rax
  %21 = load i64, i64* @rax
  %22 = and i64 %20, %21
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %23 = icmp eq i64 %22, 0
  store i1 %23, i1* @zf
  %24 = icmp slt i64 %22, 0
  store i1 %24, i1* @sf
  %25 = trunc i64 %22 to i8
  %26 = call i8 @llvm.ctpop.i8(i8 %25)
  %27 = and i8 %26, 1
  %28 = icmp eq i8 %27, 0
  store i1 %28, i1* @pf

; 0x114d
  store volatile i64 4429, i64* @_asm_program_counter
  %29 = load i1, i1* @zf
  br i1 %29, label %dec_label_pc_1158, label %dec_label_pc_114f

dec_label_pc_114f:                                ; preds = %dec_label_pc_1143

; 0x114f
  store volatile i64 4431, i64* @_asm_program_counter
  %30 = call i64 @_ITM_deregisterTMCloneTable()
  store i64 %30, i64* @rax
  ret i64 undef

dec_label_pc_1158:                                ; preds = %dec_label_pc_1143, %dec_label_pc_1130

; 0x1158
  store volatile i64 4440, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1160() {
dec_label_pc_1160:

; 0x1160
  store volatile i64 4448, i64* @_asm_program_counter
  store i64 16440, i64* @rdi

; 0x1167
  store volatile i64 4455, i64* @_asm_program_counter
  store i64 16440, i64* @rsi

; 0x116e
  store volatile i64 4462, i64* @_asm_program_counter
  %0 = load i64, i64* @rsi
  %1 = load i64, i64* @rdi
  %2 = sub i64 %0, %1
  %3 = and i64 %0, 15
  %4 = and i64 %1, 15
  %5 = sub i64 %3, %4
  %6 = icmp ugt i64 %5, 15
  %7 = icmp ult i64 %0, %1
  %8 = xor i64 %0, %1
  %9 = xor i64 %0, %2
  %10 = and i64 %8, %9
  %11 = icmp slt i64 %10, 0
  store i1 %6, i1* @az
  store i1 %7, i1* @cf
  store i1 %11, i1* @of
  %12 = icmp eq i64 %2, 0
  store i1 %12, i1* @zf
  %13 = icmp slt i64 %2, 0
  store i1 %13, i1* @sf
  %14 = trunc i64 %2 to i8
  %15 = call i8 @llvm.ctpop.i8(i8 %14)
  %16 = and i8 %15, 1
  %17 = icmp eq i8 %16, 0
  store i1 %17, i1* @pf
  store i64 %2, i64* @rsi

; 0x1171
  store volatile i64 4465, i64* @_asm_program_counter
  %18 = load i64, i64* @rsi
  store i64 %18, i64* @rax

; 0x1174
  store volatile i64 4468, i64* @_asm_program_counter
  %19 = load i64, i64* @rsi
  %20 = load i1, i1* @of
  %21 = lshr i64 %19, 63
  %22 = icmp eq i64 %21, 0
  store i1 %22, i1* @zf
  %23 = icmp slt i64 %21, 0
  store i1 %23, i1* @sf
  %24 = trunc i64 %21 to i8
  %25 = call i8 @llvm.ctpop.i8(i8 %24)
  %26 = and i8 %25, 1
  %27 = icmp eq i8 %26, 0
  store i1 %27, i1* @pf
  store i64 %21, i64* @rsi
  %28 = and i64 4611686018427387904, %19
  %29 = icmp ne i64 %28, 0
  store i1 %29, i1* @cf
  %30 = icmp slt i64 %19, 0
  %31 = select i1 false, i1 %30, i1 %20
  store i1 %31, i1* @of

; 0x1178
  store volatile i64 4472, i64* @_asm_program_counter
  %32 = load i64, i64* @rax
  %33 = load i1, i1* @of
  %34 = ashr i64 %32, 3
  %35 = icmp eq i64 %34, 0
  store i1 %35, i1* @zf
  %36 = icmp slt i64 %34, 0
  store i1 %36, i1* @sf
  %37 = trunc i64 %34 to i8
  %38 = call i8 @llvm.ctpop.i8(i8 %37)
  %39 = and i8 %38, 1
  %40 = icmp eq i8 %39, 0
  store i1 %40, i1* @pf
  store i64 %34, i64* @rax
  %41 = and i64 4, %32
  %42 = icmp ne i64 %41, 0
  store i1 %42, i1* @cf
  %43 = select i1 false, i1 false, i1 %33
  store i1 %43, i1* @of

; 0x117c
  store volatile i64 4476, i64* @_asm_program_counter
  %44 = load i64, i64* @rsi
  %45 = load i64, i64* @rax
  %46 = add i64 %44, %45
  %47 = and i64 %44, 15
  %48 = and i64 %45, 15
  %49 = add i64 %47, %48
  %50 = icmp ugt i64 %49, 15
  %51 = icmp ult i64 %46, %44
  %52 = xor i64 %44, %46
  %53 = xor i64 %45, %46
  %54 = and i64 %52, %53
  %55 = icmp slt i64 %54, 0
  store i1 %50, i1* @az
  store i1 %51, i1* @cf
  store i1 %55, i1* @of
  %56 = icmp eq i64 %46, 0
  store i1 %56, i1* @zf
  %57 = icmp slt i64 %46, 0
  store i1 %57, i1* @sf
  %58 = trunc i64 %46 to i8
  %59 = call i8 @llvm.ctpop.i8(i8 %58)
  %60 = and i8 %59, 1
  %61 = icmp eq i8 %60, 0
  store i1 %61, i1* @pf
  store i64 %46, i64* @rsi

; 0x117f
  store volatile i64 4479, i64* @_asm_program_counter
  %62 = load i64, i64* @rsi
  %63 = load i1, i1* @of
  %64 = ashr i64 %62, 1
  %65 = icmp eq i64 %64, 0
  store i1 %65, i1* @zf
  %66 = icmp slt i64 %64, 0
  store i1 %66, i1* @sf
  %67 = trunc i64 %64 to i8
  %68 = call i8 @llvm.ctpop.i8(i8 %67)
  %69 = and i8 %68, 1
  %70 = icmp eq i8 %69, 0
  store i1 %70, i1* @pf
  store i64 %64, i64* @rsi
  %71 = and i64 1, %62
  %72 = icmp ne i64 %71, 0
  store i1 %72, i1* @cf
  %73 = select i1 true, i1 false, i1 %63
  store i1 %73, i1* @of

; 0x1182
  store volatile i64 4482, i64* @_asm_program_counter
  %74 = load i1, i1* @zf
  br i1 %74, label %dec_label_pc_1198, label %dec_label_pc_1184

dec_label_pc_1184:                                ; preds = %dec_label_pc_1160

; 0x1184
  store volatile i64 4484, i64* @_asm_program_counter
  %75 = load i64, i64* inttoptr (i64 16368 to i64*)
  store i64 %75, i64* @rax

; 0x118b
  store volatile i64 4491, i64* @_asm_program_counter
  %76 = load i64, i64* @rax
  %77 = load i64, i64* @rax
  %78 = and i64 %76, %77
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %79 = icmp eq i64 %78, 0
  store i1 %79, i1* @zf
  %80 = icmp slt i64 %78, 0
  store i1 %80, i1* @sf
  %81 = trunc i64 %78 to i8
  %82 = call i8 @llvm.ctpop.i8(i8 %81)
  %83 = and i8 %82, 1
  %84 = icmp eq i8 %83, 0
  store i1 %84, i1* @pf

; 0x118e
  store volatile i64 4494, i64* @_asm_program_counter
  %85 = load i1, i1* @zf
  br i1 %85, label %dec_label_pc_1198, label %dec_label_pc_1190

dec_label_pc_1190:                                ; preds = %dec_label_pc_1184

; 0x1190
  store volatile i64 4496, i64* @_asm_program_counter
  %86 = call i64 @_ITM_registerTMCloneTable()
  store i64 %86, i64* @rax
  ret i64 undef

dec_label_pc_1198:                                ; preds = %dec_label_pc_1184, %dec_label_pc_1160

; 0x1198
  store volatile i64 4504, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_11a0() {
dec_label_pc_11a0:

; 0x11a0
  store volatile i64 4512, i64* @_asm_program_counter

; 0x11a4
  store volatile i64 4516, i64* @_asm_program_counter
  %0 = load i8, i8* inttoptr (i64 16448 to i8*)
  %1 = sub i8 %0, 0
  %2 = and i8 %0, 15
  %3 = sub i8 %2, 0
  %4 = icmp ugt i8 %3, 15
  %5 = icmp ult i8 %0, 0
  %6 = xor i8 %0, 0
  %7 = xor i8 %0, %1
  %8 = and i8 %6, %7
  %9 = icmp slt i8 %8, 0
  store i1 %4, i1* @az
  store i1 %5, i1* @cf
  store i1 %9, i1* @of
  %10 = icmp eq i8 %1, 0
  store i1 %10, i1* @zf
  %11 = icmp slt i8 %1, 0
  store i1 %11, i1* @sf
  %12 = call i8 @llvm.ctpop.i8(i8 %1)
  %13 = and i8 %12, 1
  %14 = icmp eq i8 %13, 0
  store i1 %14, i1* @pf

; 0x11ab
  store volatile i64 4523, i64* @_asm_program_counter
  %15 = load i1, i1* @zf
  %16 = icmp eq i1 %15, false
  br i1 %16, label %dec_label_pc_11d8, label %dec_label_pc_11ad

dec_label_pc_11ad:                                ; preds = %dec_label_pc_11a0

; 0x11ad
  store volatile i64 4525, i64* @_asm_program_counter
  %17 = load i64, i64* @rbp
  %18 = load i64, i64* @rsp
  %19 = sub i64 %18, 8
  %20 = inttoptr i64 %19 to i64*
  store i64 %17, i64* %20
  store i64 %19, i64* @rsp

; 0x11ae
  store volatile i64 4526, i64* @_asm_program_counter
  %21 = load i64, i64* inttoptr (i64 16376 to i64*)
  %22 = sub i64 %21, 0
  %23 = and i64 %21, 15
  %24 = sub i64 %23, 0
  %25 = icmp ugt i64 %24, 15
  %26 = icmp ult i64 %21, 0
  %27 = xor i64 %21, 0
  %28 = xor i64 %21, %22
  %29 = and i64 %27, %28
  %30 = icmp slt i64 %29, 0
  store i1 %25, i1* @az
  store i1 %26, i1* @cf
  store i1 %30, i1* @of
  %31 = icmp eq i64 %22, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i64 %22, 0
  store i1 %32, i1* @sf
  %33 = trunc i64 %22 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf

; 0x11b6
  store volatile i64 4534, i64* @_asm_program_counter
  %37 = load i64, i64* @rsp
  store i64 %37, i64* @rbp

; 0x11b9
  store volatile i64 4537, i64* @_asm_program_counter
  %38 = load i1, i1* @zf
  br i1 %38, label %dec_label_pc_11c7, label %dec_label_pc_11bb

dec_label_pc_11bb:                                ; preds = %dec_label_pc_11ad

; 0x11bb
  store volatile i64 4539, i64* @_asm_program_counter
  %39 = load i64, i64* inttoptr (i64 16392 to i64*)
  store i64 %39, i64* @rdi

; 0x11c2
  store volatile i64 4546, i64* @_asm_program_counter
  %40 = call i64 @function_1090()
  store i64 %40, i64* @rax
  br label %dec_label_pc_11c7

dec_label_pc_11c7:                                ; preds = %dec_label_pc_11bb, %dec_label_pc_11ad

; 0x11c7
  store volatile i64 4551, i64* @_asm_program_counter
  %41 = call i64 @function_1130()
  store i64 %41, i64* @rax

; 0x11cc
  store volatile i64 4556, i64* @_asm_program_counter
  store i8 1, i8* inttoptr (i64 16448 to i8*)

; 0x11d3
  store volatile i64 4563, i64* @_asm_program_counter
  %42 = load i64, i64* @rsp
  %43 = inttoptr i64 %42 to i64*
  %44 = load i64, i64* %43
  store i64 %44, i64* @rbp
  %45 = add i64 %42, 8
  store i64 %45, i64* @rsp

; 0x11d4
  store volatile i64 4564, i64* @_asm_program_counter
  ret i64 undef

dec_label_pc_11d8:                                ; preds = %dec_label_pc_11a0

; 0x11d8
  store volatile i64 4568, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_11e0() {
dec_label_pc_11e0:

; 0x11e0
  store volatile i64 4576, i64* @_asm_program_counter

; 0x11e4
  store volatile i64 4580, i64* @_asm_program_counter
  %0 = call i64 @function_1160()
  store i64 %0, i64* @rax
  ret i64 undef
}

define i64 @function_11e9() {
dec_label_pc_11e9:

; 0x11e9
  store volatile i64 4585, i64* @_asm_program_counter

; 0x11ed
  store volatile i64 4589, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x11ee
  store volatile i64 4590, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x11f1
  store volatile i64 4593, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 16
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 16
  %11 = xor i64 %5, 16
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x11f5
  store volatile i64 4597, i64* @_asm_program_counter
  %21 = load i64, i64* @rdi
  %22 = trunc i64 %21 to i32
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -4
  %25 = inttoptr i64 %24 to i32*
  store i32 %22, i32* %25

; 0x11f8
  store volatile i64 4600, i64* @_asm_program_counter
  %26 = load i64, i64* @rbp
  %27 = add i64 %26, -4
  %28 = inttoptr i64 %27 to i32*
  %29 = load i32, i32* %28
  %30 = zext i32 %29 to i64
  store i64 %30, i64* @rax

; 0x11fb
  store volatile i64 4603, i64* @_asm_program_counter
  %31 = load i64, i64* @rax
  %32 = trunc i64 %31 to i32
  %33 = zext i32 %32 to i64
  store i64 %33, i64* @rsi

; 0x11fd
  store volatile i64 4605, i64* @_asm_program_counter
  store i64 8196, i64* @rax

; 0x1204
  store volatile i64 4612, i64* @_asm_program_counter
  %34 = load i64, i64* @rax
  store i64 %34, i64* @rdi

; 0x1207
  store volatile i64 4615, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x120c
  store volatile i64 4620, i64* @_asm_program_counter
  %35 = call i64 @function_10d0()
  store i64 %35, i64* @rax

; 0x1211
  store volatile i64 4625, i64* @_asm_program_counter

; 0x1212
  store volatile i64 4626, i64* @_asm_program_counter
  %36 = load i64, i64* @rbp
  %37 = inttoptr i64 %36 to i64*
  %38 = load i64, i64* %37
  %39 = add i64 %36, 8
  store i64 %38, i64* @rbp
  store i64 %39, i64* @rsp

; 0x1213
  store volatile i64 4627, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1214() {
dec_label_pc_1214:

; 0x1214
  store volatile i64 4628, i64* @_asm_program_counter

; 0x1218
  store volatile i64 4632, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1219
  store volatile i64 4633, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x121c
  store volatile i64 4636, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 16
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 16
  %11 = xor i64 %5, 16
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1220
  store volatile i64 4640, i64* @_asm_program_counter
  %21 = load i64, i64* @rdi
  %22 = trunc i64 %21 to i32
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -4
  %25 = inttoptr i64 %24 to i32*
  store i32 %22, i32* %25

; 0x1223
  store volatile i64 4643, i64* @_asm_program_counter
  %26 = load i64, i64* @rbp
  %27 = add i64 %26, -4
  %28 = inttoptr i64 %27 to i32*
  %29 = load i32, i32* %28
  %30 = zext i32 %29 to i64
  store i64 %30, i64* @rax

; 0x1226
  store volatile i64 4646, i64* @_asm_program_counter
  %31 = load i64, i64* @rax
  %32 = trunc i64 %31 to i32
  %33 = zext i32 %32 to i64
  store i64 %33, i64* @rsi

; 0x1228
  store volatile i64 4648, i64* @_asm_program_counter
  store i64 8210, i64* @rax

; 0x122f
  store volatile i64 4655, i64* @_asm_program_counter
  %34 = load i64, i64* @rax
  store i64 %34, i64* @rdi

; 0x1232
  store volatile i64 4658, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x1237
  store volatile i64 4663, i64* @_asm_program_counter
  %35 = call i64 @function_10d0()
  store i64 %35, i64* @rax

; 0x123c
  store volatile i64 4668, i64* @_asm_program_counter

; 0x123d
  store volatile i64 4669, i64* @_asm_program_counter
  %36 = load i64, i64* @rbp
  %37 = inttoptr i64 %36 to i64*
  %38 = load i64, i64* %37
  %39 = add i64 %36, 8
  store i64 %38, i64* @rbp
  store i64 %39, i64* @rsp

; 0x123e
  store volatile i64 4670, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_123f() {
dec_label_pc_123f:

; 0x123f
  store volatile i64 4671, i64* @_asm_program_counter

; 0x1243
  store volatile i64 4675, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1244
  store volatile i64 4676, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x1247
  store volatile i64 4679, i64* @_asm_program_counter
  %5 = load i64, i64* @rdi
  %6 = trunc i64 %5 to i32
  %7 = load i64, i64* @rbp
  %8 = add i64 %7, -4
  %9 = inttoptr i64 %8 to i32*
  store i32 %6, i32* %9

; 0x124a
  store volatile i64 4682, i64* @_asm_program_counter
  %10 = load i64, i64* @rsi
  %11 = trunc i64 %10 to i32
  %12 = load i64, i64* @rbp
  %13 = add i64 %12, -8
  %14 = inttoptr i64 %13 to i32*
  store i32 %11, i32* %14

; 0x124d
  store volatile i64 4685, i64* @_asm_program_counter
  %15 = load i64, i64* @rbp
  %16 = add i64 %15, -4
  %17 = inttoptr i64 %16 to i32*
  %18 = load i32, i32* %17
  %19 = zext i32 %18 to i64
  store i64 %19, i64* @rdx

; 0x1250
  store volatile i64 4688, i64* @_asm_program_counter
  %20 = load i64, i64* @rbp
  %21 = add i64 %20, -8
  %22 = inttoptr i64 %21 to i32*
  %23 = load i32, i32* %22
  %24 = zext i32 %23 to i64
  store i64 %24, i64* @rax

; 0x1253
  store volatile i64 4691, i64* @_asm_program_counter
  %25 = load i64, i64* @rax
  %26 = trunc i64 %25 to i32
  %27 = load i64, i64* @rdx
  %28 = trunc i64 %27 to i32
  %29 = add i32 %26, %28
  %30 = and i32 %26, 15
  %31 = and i32 %28, 15
  %32 = add i32 %30, %31
  %33 = icmp ugt i32 %32, 15
  %34 = icmp ult i32 %29, %26
  %35 = xor i32 %26, %29
  %36 = xor i32 %28, %29
  %37 = and i32 %35, %36
  %38 = icmp slt i32 %37, 0
  store i1 %33, i1* @az
  store i1 %34, i1* @cf
  store i1 %38, i1* @of
  %39 = icmp eq i32 %29, 0
  store i1 %39, i1* @zf
  %40 = icmp slt i32 %29, 0
  store i1 %40, i1* @sf
  %41 = trunc i32 %29 to i8
  %42 = call i8 @llvm.ctpop.i8(i8 %41)
  %43 = and i8 %42, 1
  %44 = icmp eq i8 %43, 0
  store i1 %44, i1* @pf
  %45 = zext i32 %29 to i64
  store i64 %45, i64* @rax

; 0x1255
  store volatile i64 4693, i64* @_asm_program_counter
  %46 = load i64, i64* @rsp
  %47 = inttoptr i64 %46 to i64*
  %48 = load i64, i64* %47
  store i64 %48, i64* @rbp
  %49 = add i64 %46, 8
  store i64 %49, i64* @rsp

; 0x1256
  store volatile i64 4694, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1257() {
dec_label_pc_1257:

; 0x1257
  store volatile i64 4695, i64* @_asm_program_counter

; 0x125b
  store volatile i64 4699, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x125c
  store volatile i64 4700, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x125f
  store volatile i64 4703, i64* @_asm_program_counter
  %5 = load i64, i64* @rdi
  %6 = trunc i64 %5 to i32
  %7 = load i64, i64* @rbp
  %8 = add i64 %7, -4
  %9 = inttoptr i64 %8 to i32*
  store i32 %6, i32* %9

; 0x1262
  store volatile i64 4706, i64* @_asm_program_counter
  %10 = load i64, i64* @rsi
  %11 = trunc i64 %10 to i32
  %12 = load i64, i64* @rbp
  %13 = add i64 %12, -8
  %14 = inttoptr i64 %13 to i32*
  store i32 %11, i32* %14

; 0x1265
  store volatile i64 4709, i64* @_asm_program_counter
  %15 = load i64, i64* @rbp
  %16 = add i64 %15, -4
  %17 = inttoptr i64 %16 to i32*
  %18 = load i32, i32* %17
  %19 = zext i32 %18 to i64
  store i64 %19, i64* @rax

; 0x1268
  store volatile i64 4712, i64* @_asm_program_counter
  %20 = load i64, i64* @rax
  %21 = trunc i64 %20 to i32
  %22 = load i64, i64* @rbp
  %23 = add i64 %22, -8
  %24 = inttoptr i64 %23 to i32*
  %25 = load i32, i32* %24
  %26 = sub i32 %21, %25
  %27 = and i32 %21, 15
  %28 = and i32 %25, 15
  %29 = sub i32 %27, %28
  %30 = icmp ugt i32 %29, 15
  %31 = icmp ult i32 %21, %25
  %32 = xor i32 %21, %25
  %33 = xor i32 %21, %26
  %34 = and i32 %32, %33
  %35 = icmp slt i32 %34, 0
  store i1 %30, i1* @az
  store i1 %31, i1* @cf
  store i1 %35, i1* @of
  %36 = icmp eq i32 %26, 0
  store i1 %36, i1* @zf
  %37 = icmp slt i32 %26, 0
  store i1 %37, i1* @sf
  %38 = trunc i32 %26 to i8
  %39 = call i8 @llvm.ctpop.i8(i8 %38)
  %40 = and i8 %39, 1
  %41 = icmp eq i8 %40, 0
  store i1 %41, i1* @pf
  %42 = zext i32 %26 to i64
  store i64 %42, i64* @rax

; 0x126b
  store volatile i64 4715, i64* @_asm_program_counter
  %43 = load i64, i64* @rsp
  %44 = inttoptr i64 %43 to i64*
  %45 = load i64, i64* %44
  store i64 %45, i64* @rbp
  %46 = add i64 %43, 8
  store i64 %46, i64* @rsp

; 0x126c
  store volatile i64 4716, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_126d() {
dec_label_pc_126d:

; 0x126d
  store volatile i64 4717, i64* @_asm_program_counter

; 0x1271
  store volatile i64 4721, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1272
  store volatile i64 4722, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x1275
  store volatile i64 4725, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 16
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 16
  %11 = xor i64 %5, 16
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1279
  store volatile i64 4729, i64* @_asm_program_counter
  %21 = load i64, i64* @rbp
  %22 = add i64 %21, -12
  %23 = inttoptr i64 %22 to i32*
  store i32 10, i32* %23

; 0x1280
  store volatile i64 4736, i64* @_asm_program_counter
  %24 = load i64, i64* @rbp
  %25 = add i64 %24, -8
  %26 = inttoptr i64 %25 to i32*
  store i32 20, i32* %26

; 0x1287
  store volatile i64 4743, i64* @_asm_program_counter
  %27 = load i64, i64* @rbp
  %28 = add i64 %27, -12
  %29 = inttoptr i64 %28 to i32*
  %30 = load i32, i32* %29
  %31 = zext i32 %30 to i64
  store i64 %31, i64* @rdx

; 0x128a
  store volatile i64 4746, i64* @_asm_program_counter
  %32 = load i64, i64* @rbp
  %33 = add i64 %32, -8
  %34 = inttoptr i64 %33 to i32*
  %35 = load i32, i32* %34
  %36 = zext i32 %35 to i64
  store i64 %36, i64* @rax

; 0x128d
  store volatile i64 4749, i64* @_asm_program_counter
  %37 = load i64, i64* @rax
  %38 = trunc i64 %37 to i32
  %39 = load i64, i64* @rdx
  %40 = trunc i64 %39 to i32
  %41 = add i32 %38, %40
  %42 = and i32 %38, 15
  %43 = and i32 %40, 15
  %44 = add i32 %42, %43
  %45 = icmp ugt i32 %44, 15
  %46 = icmp ult i32 %41, %38
  %47 = xor i32 %38, %41
  %48 = xor i32 %40, %41
  %49 = and i32 %47, %48
  %50 = icmp slt i32 %49, 0
  store i1 %45, i1* @az
  store i1 %46, i1* @cf
  store i1 %50, i1* @of
  %51 = icmp eq i32 %41, 0
  store i1 %51, i1* @zf
  %52 = icmp slt i32 %41, 0
  store i1 %52, i1* @sf
  %53 = trunc i32 %41 to i8
  %54 = call i8 @llvm.ctpop.i8(i8 %53)
  %55 = and i8 %54, 1
  %56 = icmp eq i8 %55, 0
  store i1 %56, i1* @pf
  %57 = zext i32 %41 to i64
  store i64 %57, i64* @rax

; 0x128f
  store volatile i64 4751, i64* @_asm_program_counter
  %58 = load i64, i64* @rax
  %59 = trunc i64 %58 to i32
  %60 = load i64, i64* @rbp
  %61 = add i64 %60, -4
  %62 = inttoptr i64 %61 to i32*
  store i32 %59, i32* %62

; 0x1292
  store volatile i64 4754, i64* @_asm_program_counter
  %63 = load i64, i64* @rbp
  %64 = add i64 %63, -4
  %65 = inttoptr i64 %64 to i32*
  %66 = load i32, i32* %65
  %67 = zext i32 %66 to i64
  store i64 %67, i64* @rax

; 0x1295
  store volatile i64 4757, i64* @_asm_program_counter
  %68 = load i64, i64* @rax
  %69 = trunc i64 %68 to i32
  %70 = load i64, i64* @rbp
  %71 = add i64 %70, -12
  %72 = inttoptr i64 %71 to i32*
  store i32 %69, i32* %72

; 0x1298
  store volatile i64 4760, i64* @_asm_program_counter
  %73 = load i64, i64* @rbp
  %74 = add i64 %73, -16
  %75 = inttoptr i64 %74 to i32*
  store i32 100, i32* %75

; 0x129f
  store volatile i64 4767, i64* @_asm_program_counter
  %76 = load i64, i64* @rbp
  %77 = add i64 %76, -16
  %78 = inttoptr i64 %77 to i32*
  %79 = load i32, i32* %78
  %80 = zext i32 %79 to i64
  store i64 %80, i64* @rax

; 0x12a2
  store volatile i64 4770, i64* @_asm_program_counter
  %81 = load i64, i64* @rax
  %82 = trunc i64 %81 to i32
  %83 = add i32 %82, 1
  %84 = and i32 %82, 15
  %85 = add i32 %84, 1
  %86 = icmp ugt i32 %85, 15
  %87 = icmp ult i32 %83, %82
  %88 = xor i32 %82, %83
  %89 = xor i32 1, %83
  %90 = and i32 %88, %89
  %91 = icmp slt i32 %90, 0
  store i1 %86, i1* @az
  store i1 %87, i1* @cf
  store i1 %91, i1* @of
  %92 = icmp eq i32 %83, 0
  store i1 %92, i1* @zf
  %93 = icmp slt i32 %83, 0
  store i1 %93, i1* @sf
  %94 = trunc i32 %83 to i8
  %95 = call i8 @llvm.ctpop.i8(i8 %94)
  %96 = and i8 %95, 1
  %97 = icmp eq i8 %96, 0
  store i1 %97, i1* @pf
  %98 = zext i32 %83 to i64
  store i64 %98, i64* @rax

; 0x12a5
  store volatile i64 4773, i64* @_asm_program_counter
  %99 = load i64, i64* @rax
  %100 = trunc i64 %99 to i32
  %101 = load i64, i64* @rbp
  %102 = add i64 %101, -16
  %103 = inttoptr i64 %102 to i32*
  store i32 %100, i32* %103

; 0x12a8
  store volatile i64 4776, i64* @_asm_program_counter
  %104 = load i64, i64* @rbp
  %105 = add i64 %104, -4
  %106 = inttoptr i64 %105 to i32*
  %107 = load i32, i32* %106
  %108 = zext i32 %107 to i64
  store i64 %108, i64* @rax

; 0x12ab
  store volatile i64 4779, i64* @_asm_program_counter
  %109 = load i64, i64* @rax
  %110 = trunc i64 %109 to i32
  %111 = zext i32 %110 to i64
  store i64 %111, i64* @rsi

; 0x12ad
  store volatile i64 4781, i64* @_asm_program_counter
  store i64 8223, i64* @rax

; 0x12b4
  store volatile i64 4788, i64* @_asm_program_counter
  %112 = load i64, i64* @rax
  store i64 %112, i64* @rdi

; 0x12b7
  store volatile i64 4791, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x12bc
  store volatile i64 4796, i64* @_asm_program_counter
  %113 = call i64 @function_10d0()
  store i64 %113, i64* @rax

; 0x12c1
  store volatile i64 4801, i64* @_asm_program_counter

; 0x12c2
  store volatile i64 4802, i64* @_asm_program_counter
  %114 = load i64, i64* @rbp
  %115 = inttoptr i64 %114 to i64*
  %116 = load i64, i64* %115
  %117 = add i64 %114, 8
  store i64 %116, i64* @rbp
  store i64 %117, i64* @rsp

; 0x12c3
  store volatile i64 4803, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_12c4() {
dec_label_pc_12c4:

; 0x12c4
  store volatile i64 4804, i64* @_asm_program_counter

; 0x12c8
  store volatile i64 4808, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x12c9
  store volatile i64 4809, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x12cc
  store volatile i64 4812, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 16
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 16
  %11 = xor i64 %5, 16
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x12d0
  store volatile i64 4816, i64* @_asm_program_counter
  %21 = load i32, i32* inttoptr (i64 16400 to i32*)
  %22 = zext i32 %21 to i64
  store i64 %22, i64* @rax

; 0x12d6
  store volatile i64 4822, i64* @_asm_program_counter
  %23 = load i64, i64* @rax
  %24 = trunc i64 %23 to i32
  %25 = load i64, i64* @rbp
  %26 = add i64 %25, -4
  %27 = inttoptr i64 %26 to i32*
  store i32 %24, i32* %27

; 0x12d9
  store volatile i64 4825, i64* @_asm_program_counter
  %28 = load i64, i64* @rbp
  %29 = add i64 %28, -4
  %30 = inttoptr i64 %29 to i32*
  %31 = load i32, i32* %30
  %32 = zext i32 %31 to i64
  store i64 %32, i64* @rax

; 0x12dc
  store volatile i64 4828, i64* @_asm_program_counter
  %33 = load i64, i64* @rax
  %34 = trunc i64 %33 to i32
  %35 = add i32 %34, 1
  %36 = and i32 %34, 15
  %37 = add i32 %36, 1
  %38 = icmp ugt i32 %37, 15
  %39 = icmp ult i32 %35, %34
  %40 = xor i32 %34, %35
  %41 = xor i32 1, %35
  %42 = and i32 %40, %41
  %43 = icmp slt i32 %42, 0
  store i1 %38, i1* @az
  store i1 %39, i1* @cf
  store i1 %43, i1* @of
  %44 = icmp eq i32 %35, 0
  store i1 %44, i1* @zf
  %45 = icmp slt i32 %35, 0
  store i1 %45, i1* @sf
  %46 = trunc i32 %35 to i8
  %47 = call i8 @llvm.ctpop.i8(i8 %46)
  %48 = and i8 %47, 1
  %49 = icmp eq i8 %48, 0
  store i1 %49, i1* @pf
  %50 = zext i32 %35 to i64
  store i64 %50, i64* @rax

; 0x12df
  store volatile i64 4831, i64* @_asm_program_counter
  %51 = load i64, i64* @rax
  %52 = trunc i64 %51 to i32
  store i32 %52, i32* inttoptr (i64 16400 to i32*)

; 0x12e5
  store volatile i64 4837, i64* @_asm_program_counter
  store i8 65, i8* inttoptr (i64 16480 to i8*)

; 0x12ec
  store volatile i64 4844, i64* @_asm_program_counter
  %53 = load i64, i64* @rbp
  %54 = add i64 %53, -4
  %55 = inttoptr i64 %54 to i32*
  %56 = load i32, i32* %55
  %57 = zext i32 %56 to i64
  store i64 %57, i64* @rax

; 0x12ef
  store volatile i64 4847, i64* @_asm_program_counter
  %58 = load i64, i64* @rax
  %59 = trunc i64 %58 to i32
  %60 = ashr i32 %59, 31
  %61 = zext i32 %60 to i64
  store i64 %61, i64* @rdx

; 0x12f0
  store volatile i64 4848, i64* @_asm_program_counter
  %62 = load i64, i64* @rdx
  %63 = trunc i64 %62 to i32
  %64 = load i1, i1* @of
  %65 = lshr i32 %63, 28
  %66 = icmp eq i32 %65, 0
  store i1 %66, i1* @zf
  %67 = icmp slt i32 %65, 0
  store i1 %67, i1* @sf
  %68 = trunc i32 %65 to i8
  %69 = call i8 @llvm.ctpop.i8(i8 %68)
  %70 = and i8 %69, 1
  %71 = icmp eq i8 %70, 0
  store i1 %71, i1* @pf
  %72 = zext i32 %65 to i64
  store i64 %72, i64* @rdx
  %73 = and i32 134217728, %63
  %74 = icmp ne i32 %73, 0
  store i1 %74, i1* @cf
  %75 = icmp slt i32 %63, 0
  %76 = select i1 false, i1 %75, i1 %64
  store i1 %76, i1* @of

; 0x12f3
  store volatile i64 4851, i64* @_asm_program_counter
  %77 = load i64, i64* @rax
  %78 = trunc i64 %77 to i32
  %79 = load i64, i64* @rdx
  %80 = trunc i64 %79 to i32
  %81 = add i32 %78, %80
  %82 = and i32 %78, 15
  %83 = and i32 %80, 15
  %84 = add i32 %82, %83
  %85 = icmp ugt i32 %84, 15
  %86 = icmp ult i32 %81, %78
  %87 = xor i32 %78, %81
  %88 = xor i32 %80, %81
  %89 = and i32 %87, %88
  %90 = icmp slt i32 %89, 0
  store i1 %85, i1* @az
  store i1 %86, i1* @cf
  store i1 %90, i1* @of
  %91 = icmp eq i32 %81, 0
  store i1 %91, i1* @zf
  %92 = icmp slt i32 %81, 0
  store i1 %92, i1* @sf
  %93 = trunc i32 %81 to i8
  %94 = call i8 @llvm.ctpop.i8(i8 %93)
  %95 = and i8 %94, 1
  %96 = icmp eq i8 %95, 0
  store i1 %96, i1* @pf
  %97 = zext i32 %81 to i64
  store i64 %97, i64* @rax

; 0x12f5
  store volatile i64 4853, i64* @_asm_program_counter
  %98 = load i64, i64* @rax
  %99 = trunc i64 %98 to i32
  %100 = and i32 %99, 15
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %101 = icmp eq i32 %100, 0
  store i1 %101, i1* @zf
  %102 = icmp slt i32 %100, 0
  store i1 %102, i1* @sf
  %103 = trunc i32 %100 to i8
  %104 = call i8 @llvm.ctpop.i8(i8 %103)
  %105 = and i8 %104, 1
  %106 = icmp eq i8 %105, 0
  store i1 %106, i1* @pf
  %107 = zext i32 %100 to i64
  store i64 %107, i64* @rax

; 0x12f8
  store volatile i64 4856, i64* @_asm_program_counter
  %108 = load i64, i64* @rax
  %109 = trunc i64 %108 to i32
  %110 = load i64, i64* @rdx
  %111 = trunc i64 %110 to i32
  %112 = sub i32 %109, %111
  %113 = and i32 %109, 15
  %114 = and i32 %111, 15
  %115 = sub i32 %113, %114
  %116 = icmp ugt i32 %115, 15
  %117 = icmp ult i32 %109, %111
  %118 = xor i32 %109, %111
  %119 = xor i32 %109, %112
  %120 = and i32 %118, %119
  %121 = icmp slt i32 %120, 0
  store i1 %116, i1* @az
  store i1 %117, i1* @cf
  store i1 %121, i1* @of
  %122 = icmp eq i32 %112, 0
  store i1 %122, i1* @zf
  %123 = icmp slt i32 %112, 0
  store i1 %123, i1* @sf
  %124 = trunc i32 %112 to i8
  %125 = call i8 @llvm.ctpop.i8(i8 %124)
  %126 = and i8 %125, 1
  %127 = icmp eq i8 %126, 0
  store i1 %127, i1* @pf
  %128 = zext i32 %112 to i64
  store i64 %128, i64* @rax

; 0x12fa
  store volatile i64 4858, i64* @_asm_program_counter
  %129 = load i64, i64* @rax
  %130 = trunc i64 %129 to i32
  %131 = sext i32 %130 to i64
  store i64 %131, i64* @rax

; 0x12fc
  store volatile i64 4860, i64* @_asm_program_counter
  store i64 16480, i64* @rdx

; 0x1303
  store volatile i64 4867, i64* @_asm_program_counter
  %132 = load i64, i64* @rax
  %133 = load i64, i64* @rdx
  %134 = mul i64 %133, 1
  %135 = add i64 %132, %134
  %136 = inttoptr i64 %135 to i8*
  store i8 66, i8* %136

; 0x1307
  store volatile i64 4871, i64* @_asm_program_counter
  %137 = load i8, i8* inttoptr (i64 16480 to i8*)
  %138 = zext i8 %137 to i64
  store i64 %138, i64* @rax

; 0x130e
  store volatile i64 4878, i64* @_asm_program_counter
  %139 = load i64, i64* @rax
  %140 = trunc i64 %139 to i8
  %141 = load i64, i64* @rbp
  %142 = add i64 %141, -5
  %143 = inttoptr i64 %142 to i8*
  store i8 %140, i8* %143

; 0x1311
  store volatile i64 4881, i64* @_asm_program_counter
  %144 = load i64, i64* @rbp
  %145 = add i64 %144, -5
  %146 = inttoptr i64 %145 to i8*
  %147 = load i8, i8* %146
  %148 = sext i8 %147 to i64
  store i64 %148, i64* @rdx

; 0x1315
  store volatile i64 4885, i64* @_asm_program_counter
  %149 = load i64, i64* @rbp
  %150 = add i64 %149, -4
  %151 = inttoptr i64 %150 to i32*
  %152 = load i32, i32* %151
  %153 = zext i32 %152 to i64
  store i64 %153, i64* @rax

; 0x1318
  store volatile i64 4888, i64* @_asm_program_counter
  %154 = load i64, i64* @rax
  %155 = trunc i64 %154 to i32
  %156 = zext i32 %155 to i64
  store i64 %156, i64* @rsi

; 0x131a
  store volatile i64 4890, i64* @_asm_program_counter
  store i64 8234, i64* @rax

; 0x1321
  store volatile i64 4897, i64* @_asm_program_counter
  %157 = load i64, i64* @rax
  store i64 %157, i64* @rdi

; 0x1324
  store volatile i64 4900, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x1329
  store volatile i64 4905, i64* @_asm_program_counter
  %158 = call i64 @function_10d0()
  store i64 %158, i64* @rax

; 0x132e
  store volatile i64 4910, i64* @_asm_program_counter

; 0x132f
  store volatile i64 4911, i64* @_asm_program_counter
  %159 = load i64, i64* @rbp
  %160 = inttoptr i64 %159 to i64*
  %161 = load i64, i64* %160
  %162 = add i64 %159, 8
  store i64 %161, i64* @rbp
  store i64 %162, i64* @rsp

; 0x1330
  store volatile i64 4912, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1331() {
dec_label_pc_1331:

; 0x1331
  store volatile i64 4913, i64* @_asm_program_counter

; 0x1335
  store volatile i64 4917, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1336
  store volatile i64 4918, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x1339
  store volatile i64 4921, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 32
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 32
  %11 = xor i64 %5, 32
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x133d
  store volatile i64 4925, i64* @_asm_program_counter
  store i64 4, i64* @rdi

; 0x1342
  store volatile i64 4930, i64* @_asm_program_counter
  %21 = call i64 @function_10f0()
  store i64 %21, i64* @rax

; 0x1347
  store volatile i64 4935, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -24
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x134b
  store volatile i64 4939, i64* @_asm_program_counter
  %26 = load i64, i64* @rbp
  %27 = add i64 %26, -24
  %28 = inttoptr i64 %27 to i64*
  %29 = load i64, i64* %28
  store i64 %29, i64* @rax

; 0x134f
  store volatile i64 4943, i64* @_asm_program_counter
  %30 = load i64, i64* @rax
  %31 = inttoptr i64 %30 to i32*
  store i32 42, i32* %31

; 0x1355
  store volatile i64 4949, i64* @_asm_program_counter
  %32 = load i64, i64* @rbp
  %33 = add i64 %32, -24
  %34 = inttoptr i64 %33 to i64*
  %35 = load i64, i64* %34
  store i64 %35, i64* @rax

; 0x1359
  store volatile i64 4953, i64* @_asm_program_counter
  %36 = load i64, i64* @rax
  %37 = inttoptr i64 %36 to i32*
  %38 = load i32, i32* %37
  %39 = zext i32 %38 to i64
  store i64 %39, i64* @rax

; 0x135b
  store volatile i64 4955, i64* @_asm_program_counter
  %40 = load i64, i64* @rax
  %41 = trunc i64 %40 to i32
  %42 = load i64, i64* @rbp
  %43 = add i64 %42, -32
  %44 = inttoptr i64 %43 to i32*
  store i32 %41, i32* %44

; 0x135e
  store volatile i64 4958, i64* @_asm_program_counter
  store i64 40, i64* @rdi

; 0x1363
  store volatile i64 4963, i64* @_asm_program_counter
  %45 = call i64 @function_10f0()
  store i64 %45, i64* @rax

; 0x1368
  store volatile i64 4968, i64* @_asm_program_counter
  %46 = load i64, i64* @rax
  %47 = load i64, i64* @rbp
  %48 = add i64 %47, -16
  %49 = inttoptr i64 %48 to i64*
  store i64 %46, i64* %49

; 0x136c
  store volatile i64 4972, i64* @_asm_program_counter
  %50 = load i64, i64* @rbp
  %51 = add i64 %50, -16
  %52 = inttoptr i64 %51 to i64*
  %53 = load i64, i64* %52
  store i64 %53, i64* @rax

; 0x1370
  store volatile i64 4976, i64* @_asm_program_counter
  %54 = load i64, i64* @rax
  %55 = inttoptr i64 %54 to i32*
  store i32 0, i32* %55

; 0x1376
  store volatile i64 4982, i64* @_asm_program_counter
  %56 = load i64, i64* @rbp
  %57 = add i64 %56, -16
  %58 = inttoptr i64 %57 to i64*
  %59 = load i64, i64* %58
  store i64 %59, i64* @rax

; 0x137a
  store volatile i64 4986, i64* @_asm_program_counter
  %60 = load i64, i64* @rax
  %61 = add i64 %60, 20
  %62 = and i64 %60, 15
  %63 = add i64 %62, 4
  %64 = icmp ugt i64 %63, 15
  %65 = icmp ult i64 %61, %60
  %66 = xor i64 %60, %61
  %67 = xor i64 20, %61
  %68 = and i64 %66, %67
  %69 = icmp slt i64 %68, 0
  store i1 %64, i1* @az
  store i1 %65, i1* @cf
  store i1 %69, i1* @of
  %70 = icmp eq i64 %61, 0
  store i1 %70, i1* @zf
  %71 = icmp slt i64 %61, 0
  store i1 %71, i1* @sf
  %72 = trunc i64 %61 to i8
  %73 = call i8 @llvm.ctpop.i8(i8 %72)
  %74 = and i8 %73, 1
  %75 = icmp eq i8 %74, 0
  store i1 %75, i1* @pf
  store i64 %61, i64* @rax

; 0x137e
  store volatile i64 4990, i64* @_asm_program_counter
  %76 = load i64, i64* @rax
  %77 = inttoptr i64 %76 to i32*
  store i32 50, i32* %77

; 0x1384
  store volatile i64 4996, i64* @_asm_program_counter
  %78 = load i64, i64* @rbp
  %79 = add i64 %78, -32
  %80 = inttoptr i64 %79 to i32*
  %81 = load i32, i32* %80
  %82 = zext i32 %81 to i64
  store i64 %82, i64* @rcx

; 0x1387
  store volatile i64 4999, i64* @_asm_program_counter
  %83 = load i64, i64* @rcx
  %84 = trunc i64 %83 to i32
  %85 = sext i32 %84 to i64
  store i64 %85, i64* @rax

; 0x138a
  store volatile i64 5002, i64* @_asm_program_counter
  %86 = load i64, i64* @rax
  %87 = load i64, i64* @rax
  %88 = sext i64 %87 to i128
  %89 = mul i128 %88, 1717986919
  %90 = trunc i128 %89 to i64
  store i64 %90, i64* @rax
  %91 = trunc i128 %89 to i64
  %92 = sext i64 %91 to i128
  %93 = icmp ne i128 %89, %92
  store i1 %93, i1* @of
  store i1 %93, i1* @cf

; 0x1391
  store volatile i64 5009, i64* @_asm_program_counter
  %94 = load i64, i64* @rax
  %95 = load i1, i1* @of
  %96 = lshr i64 %94, 32
  %97 = icmp eq i64 %96, 0
  store i1 %97, i1* @zf
  %98 = icmp slt i64 %96, 0
  store i1 %98, i1* @sf
  %99 = trunc i64 %96 to i8
  %100 = call i8 @llvm.ctpop.i8(i8 %99)
  %101 = and i8 %100, 1
  %102 = icmp eq i8 %101, 0
  store i1 %102, i1* @pf
  store i64 %96, i64* @rax
  %103 = and i64 2147483648, %94
  %104 = icmp ne i64 %103, 0
  store i1 %104, i1* @cf
  %105 = icmp slt i64 %94, 0
  %106 = select i1 false, i1 %105, i1 %95
  store i1 %106, i1* @of

; 0x1395
  store volatile i64 5013, i64* @_asm_program_counter
  %107 = load i64, i64* @rax
  %108 = trunc i64 %107 to i32
  %109 = load i1, i1* @of
  %110 = ashr i32 %108, 2
  %111 = icmp eq i32 %110, 0
  store i1 %111, i1* @zf
  %112 = icmp slt i32 %110, 0
  store i1 %112, i1* @sf
  %113 = trunc i32 %110 to i8
  %114 = call i8 @llvm.ctpop.i8(i8 %113)
  %115 = and i8 %114, 1
  %116 = icmp eq i8 %115, 0
  store i1 %116, i1* @pf
  %117 = zext i32 %110 to i64
  store i64 %117, i64* @rax
  %118 = and i32 2, %108
  %119 = icmp ne i32 %118, 0
  store i1 %119, i1* @cf
  %120 = select i1 false, i1 false, i1 %109
  store i1 %120, i1* @of

; 0x1398
  store volatile i64 5016, i64* @_asm_program_counter
  %121 = load i64, i64* @rcx
  %122 = trunc i64 %121 to i32
  %123 = zext i32 %122 to i64
  store i64 %123, i64* @rsi

; 0x139a
  store volatile i64 5018, i64* @_asm_program_counter
  %124 = load i64, i64* @rsi
  %125 = trunc i64 %124 to i32
  %126 = load i1, i1* @of
  %127 = ashr i32 %125, 31
  %128 = icmp eq i32 %127, 0
  store i1 %128, i1* @zf
  %129 = icmp slt i32 %127, 0
  store i1 %129, i1* @sf
  %130 = trunc i32 %127 to i8
  %131 = call i8 @llvm.ctpop.i8(i8 %130)
  %132 = and i8 %131, 1
  %133 = icmp eq i8 %132, 0
  store i1 %133, i1* @pf
  %134 = zext i32 %127 to i64
  store i64 %134, i64* @rsi
  %135 = and i32 1073741824, %125
  %136 = icmp ne i32 %135, 0
  store i1 %136, i1* @cf
  %137 = select i1 false, i1 false, i1 %126
  store i1 %137, i1* @of

; 0x139d
  store volatile i64 5021, i64* @_asm_program_counter
  %138 = load i64, i64* @rax
  %139 = trunc i64 %138 to i32
  %140 = load i64, i64* @rsi
  %141 = trunc i64 %140 to i32
  %142 = sub i32 %139, %141
  %143 = and i32 %139, 15
  %144 = and i32 %141, 15
  %145 = sub i32 %143, %144
  %146 = icmp ugt i32 %145, 15
  %147 = icmp ult i32 %139, %141
  %148 = xor i32 %139, %141
  %149 = xor i32 %139, %142
  %150 = and i32 %148, %149
  %151 = icmp slt i32 %150, 0
  store i1 %146, i1* @az
  store i1 %147, i1* @cf
  store i1 %151, i1* @of
  %152 = icmp eq i32 %142, 0
  store i1 %152, i1* @zf
  %153 = icmp slt i32 %142, 0
  store i1 %153, i1* @sf
  %154 = trunc i32 %142 to i8
  %155 = call i8 @llvm.ctpop.i8(i8 %154)
  %156 = and i8 %155, 1
  %157 = icmp eq i8 %156, 0
  store i1 %157, i1* @pf
  %158 = zext i32 %142 to i64
  store i64 %158, i64* @rax

; 0x139f
  store volatile i64 5023, i64* @_asm_program_counter
  %159 = load i64, i64* @rax
  %160 = trunc i64 %159 to i32
  %161 = zext i32 %160 to i64
  store i64 %161, i64* @rdx

; 0x13a1
  store volatile i64 5025, i64* @_asm_program_counter
  %162 = load i64, i64* @rdx
  %163 = trunc i64 %162 to i32
  %164 = zext i32 %163 to i64
  store i64 %164, i64* @rax

; 0x13a3
  store volatile i64 5027, i64* @_asm_program_counter
  %165 = load i64, i64* @rax
  %166 = trunc i64 %165 to i32
  %167 = load i1, i1* @of
  %168 = shl i32 %166, 2
  %169 = icmp eq i32 %168, 0
  store i1 %169, i1* @zf
  %170 = icmp slt i32 %168, 0
  store i1 %170, i1* @sf
  %171 = trunc i32 %168 to i8
  %172 = call i8 @llvm.ctpop.i8(i8 %171)
  %173 = and i8 %172, 1
  %174 = icmp eq i8 %173, 0
  store i1 %174, i1* @pf
  %175 = zext i32 %168 to i64
  store i64 %175, i64* @rax
  %176 = shl i32 %166, 1
  %177 = lshr i32 %176, 31
  %178 = trunc i32 %177 to i1
  store i1 %178, i1* @cf
  %179 = lshr i32 %168, 31
  %180 = icmp ne i32 %179, %177
  %181 = select i1 false, i1 %180, i1 %167
  store i1 %181, i1* @of

; 0x13a6
  store volatile i64 5030, i64* @_asm_program_counter
  %182 = load i64, i64* @rax
  %183 = trunc i64 %182 to i32
  %184 = load i64, i64* @rdx
  %185 = trunc i64 %184 to i32
  %186 = add i32 %183, %185
  %187 = and i32 %183, 15
  %188 = and i32 %185, 15
  %189 = add i32 %187, %188
  %190 = icmp ugt i32 %189, 15
  %191 = icmp ult i32 %186, %183
  %192 = xor i32 %183, %186
  %193 = xor i32 %185, %186
  %194 = and i32 %192, %193
  %195 = icmp slt i32 %194, 0
  store i1 %190, i1* @az
  store i1 %191, i1* @cf
  store i1 %195, i1* @of
  %196 = icmp eq i32 %186, 0
  store i1 %196, i1* @zf
  %197 = icmp slt i32 %186, 0
  store i1 %197, i1* @sf
  %198 = trunc i32 %186 to i8
  %199 = call i8 @llvm.ctpop.i8(i8 %198)
  %200 = and i8 %199, 1
  %201 = icmp eq i8 %200, 0
  store i1 %201, i1* @pf
  %202 = zext i32 %186 to i64
  store i64 %202, i64* @rax

; 0x13a8
  store volatile i64 5032, i64* @_asm_program_counter
  %203 = load i64, i64* @rax
  %204 = trunc i64 %203 to i32
  %205 = load i64, i64* @rax
  %206 = trunc i64 %205 to i32
  %207 = add i32 %204, %206
  %208 = and i32 %204, 15
  %209 = and i32 %206, 15
  %210 = add i32 %208, %209
  %211 = icmp ugt i32 %210, 15
  %212 = icmp ult i32 %207, %204
  %213 = xor i32 %204, %207
  %214 = xor i32 %206, %207
  %215 = and i32 %213, %214
  %216 = icmp slt i32 %215, 0
  store i1 %211, i1* @az
  store i1 %212, i1* @cf
  store i1 %216, i1* @of
  %217 = icmp eq i32 %207, 0
  store i1 %217, i1* @zf
  %218 = icmp slt i32 %207, 0
  store i1 %218, i1* @sf
  %219 = trunc i32 %207 to i8
  %220 = call i8 @llvm.ctpop.i8(i8 %219)
  %221 = and i8 %220, 1
  %222 = icmp eq i8 %221, 0
  store i1 %222, i1* @pf
  %223 = zext i32 %207 to i64
  store i64 %223, i64* @rax

; 0x13aa
  store volatile i64 5034, i64* @_asm_program_counter
  %224 = load i64, i64* @rcx
  %225 = trunc i64 %224 to i32
  %226 = load i64, i64* @rax
  %227 = trunc i64 %226 to i32
  %228 = sub i32 %225, %227
  %229 = and i32 %225, 15
  %230 = and i32 %227, 15
  %231 = sub i32 %229, %230
  %232 = icmp ugt i32 %231, 15
  %233 = icmp ult i32 %225, %227
  %234 = xor i32 %225, %227
  %235 = xor i32 %225, %228
  %236 = and i32 %234, %235
  %237 = icmp slt i32 %236, 0
  store i1 %232, i1* @az
  store i1 %233, i1* @cf
  store i1 %237, i1* @of
  %238 = icmp eq i32 %228, 0
  store i1 %238, i1* @zf
  %239 = icmp slt i32 %228, 0
  store i1 %239, i1* @sf
  %240 = trunc i32 %228 to i8
  %241 = call i8 @llvm.ctpop.i8(i8 %240)
  %242 = and i8 %241, 1
  %243 = icmp eq i8 %242, 0
  store i1 %243, i1* @pf
  %244 = zext i32 %228 to i64
  store i64 %244, i64* @rcx

; 0x13ac
  store volatile i64 5036, i64* @_asm_program_counter
  %245 = load i64, i64* @rcx
  %246 = trunc i64 %245 to i32
  %247 = zext i32 %246 to i64
  store i64 %247, i64* @rdx

; 0x13ae
  store volatile i64 5038, i64* @_asm_program_counter
  %248 = load i64, i64* @rdx
  %249 = trunc i64 %248 to i32
  %250 = sext i32 %249 to i64
  store i64 %250, i64* @rax

; 0x13b1
  store volatile i64 5041, i64* @_asm_program_counter
  %251 = load i64, i64* @rax
  %252 = mul i64 %251, 4
  store i64 %252, i64* @rdx

; 0x13b9
  store volatile i64 5049, i64* @_asm_program_counter
  %253 = load i64, i64* @rbp
  %254 = add i64 %253, -16
  %255 = inttoptr i64 %254 to i64*
  %256 = load i64, i64* %255
  store i64 %256, i64* @rax

; 0x13bd
  store volatile i64 5053, i64* @_asm_program_counter
  %257 = load i64, i64* @rax
  %258 = load i64, i64* @rdx
  %259 = add i64 %257, %258
  %260 = and i64 %257, 15
  %261 = and i64 %258, 15
  %262 = add i64 %260, %261
  %263 = icmp ugt i64 %262, 15
  %264 = icmp ult i64 %259, %257
  %265 = xor i64 %257, %259
  %266 = xor i64 %258, %259
  %267 = and i64 %265, %266
  %268 = icmp slt i64 %267, 0
  store i1 %263, i1* @az
  store i1 %264, i1* @cf
  store i1 %268, i1* @of
  %269 = icmp eq i64 %259, 0
  store i1 %269, i1* @zf
  %270 = icmp slt i64 %259, 0
  store i1 %270, i1* @sf
  %271 = trunc i64 %259 to i8
  %272 = call i8 @llvm.ctpop.i8(i8 %271)
  %273 = and i8 %272, 1
  %274 = icmp eq i8 %273, 0
  store i1 %274, i1* @pf
  store i64 %259, i64* @rax

; 0x13c0
  store volatile i64 5056, i64* @_asm_program_counter
  %275 = load i64, i64* @rax
  %276 = inttoptr i64 %275 to i32*
  store i32 99, i32* %276

; 0x13c6
  store volatile i64 5062, i64* @_asm_program_counter
  store i64 24, i64* @rdi

; 0x13cb
  store volatile i64 5067, i64* @_asm_program_counter
  %277 = call i64 @function_10f0()
  store i64 %277, i64* @rax

; 0x13d0
  store volatile i64 5072, i64* @_asm_program_counter
  %278 = load i64, i64* @rax
  %279 = load i64, i64* @rbp
  %280 = add i64 %279, -8
  %281 = inttoptr i64 %280 to i64*
  store i64 %278, i64* %281

; 0x13d4
  store volatile i64 5076, i64* @_asm_program_counter
  %282 = load i64, i64* @rbp
  %283 = add i64 %282, -8
  %284 = inttoptr i64 %283 to i64*
  %285 = load i64, i64* %284
  store i64 %285, i64* @rax

; 0x13d8
  store volatile i64 5080, i64* @_asm_program_counter
  %286 = load i64, i64* @rax
  %287 = inttoptr i64 %286 to i32*
  store i32 1, i32* %287

; 0x13de
  store volatile i64 5086, i64* @_asm_program_counter
  %288 = load i64, i64* @rbp
  %289 = add i64 %288, -8
  %290 = inttoptr i64 %289 to i64*
  %291 = load i64, i64* %290
  store i64 %291, i64* @rax

; 0x13e2
  store volatile i64 5090, i64* @_asm_program_counter
  %292 = load i64, i64* @rbp
  %293 = add i64 %292, -32
  %294 = inttoptr i64 %293 to i32*
  %295 = load i32, i32* %294
  %296 = zext i32 %295 to i64
  store i64 %296, i64* @rdx

; 0x13e5
  store volatile i64 5093, i64* @_asm_program_counter
  %297 = load i64, i64* @rdx
  %298 = trunc i64 %297 to i32
  %299 = load i64, i64* @rax
  %300 = add i64 %299, 4
  %301 = inttoptr i64 %300 to i32*
  store i32 %298, i32* %301

; 0x13e8
  store volatile i64 5096, i64* @_asm_program_counter
  %302 = load i64, i64* @rbp
  %303 = add i64 %302, -8
  %304 = inttoptr i64 %303 to i64*
  %305 = load i64, i64* %304
  store i64 %305, i64* @rax

; 0x13ec
  store volatile i64 5100, i64* @_asm_program_counter
  %306 = load i64, i64* @rax
  %307 = add i64 %306, 8
  %308 = and i64 %306, 15
  %309 = add i64 %308, 8
  %310 = icmp ugt i64 %309, 15
  %311 = icmp ult i64 %307, %306
  %312 = xor i64 %306, %307
  %313 = xor i64 8, %307
  %314 = and i64 %312, %313
  %315 = icmp slt i64 %314, 0
  store i1 %310, i1* @az
  store i1 %311, i1* @cf
  store i1 %315, i1* @of
  %316 = icmp eq i64 %307, 0
  store i1 %316, i1* @zf
  %317 = icmp slt i64 %307, 0
  store i1 %317, i1* @sf
  %318 = trunc i64 %307 to i8
  %319 = call i8 @llvm.ctpop.i8(i8 %318)
  %320 = and i8 %319, 1
  %321 = icmp eq i8 %320, 0
  store i1 %321, i1* @pf
  store i64 %307, i64* @rax

; 0x13f0
  store volatile i64 5104, i64* @_asm_program_counter
  %322 = load i64, i64* @rax
  %323 = inttoptr i64 %322 to i32*
  store i32 1885431144, i32* %323

; 0x13f6
  store volatile i64 5110, i64* @_asm_program_counter
  %324 = load i64, i64* @rax
  %325 = add i64 %324, 4
  %326 = inttoptr i64 %325 to i8*
  store i8 0, i8* %326

; 0x13fa
  store volatile i64 5114, i64* @_asm_program_counter
  %327 = load i64, i64* @rbp
  %328 = add i64 %327, -8
  %329 = inttoptr i64 %328 to i64*
  %330 = load i64, i64* %329
  store i64 %330, i64* @rax

; 0x13fe
  store volatile i64 5118, i64* @_asm_program_counter
  %331 = load i64, i64* @rax
  %332 = inttoptr i64 %331 to i32*
  %333 = load i32, i32* %332
  %334 = zext i32 %333 to i64
  store i64 %334, i64* @rax

; 0x1400
  store volatile i64 5120, i64* @_asm_program_counter
  %335 = load i64, i64* @rax
  %336 = trunc i64 %335 to i32
  %337 = load i64, i64* @rbp
  %338 = add i64 %337, -28
  %339 = inttoptr i64 %338 to i32*
  store i32 %336, i32* %339

; 0x1403
  store volatile i64 5123, i64* @_asm_program_counter
  %340 = load i64, i64* @rbp
  %341 = add i64 %340, -28
  %342 = inttoptr i64 %341 to i32*
  %343 = load i32, i32* %342
  %344 = zext i32 %343 to i64
  store i64 %344, i64* @rdx

; 0x1406
  store volatile i64 5126, i64* @_asm_program_counter
  %345 = load i64, i64* @rbp
  %346 = add i64 %345, -32
  %347 = inttoptr i64 %346 to i32*
  %348 = load i32, i32* %347
  %349 = zext i32 %348 to i64
  store i64 %349, i64* @rax

; 0x1409
  store volatile i64 5129, i64* @_asm_program_counter
  %350 = load i64, i64* @rax
  %351 = trunc i64 %350 to i32
  %352 = zext i32 %351 to i64
  store i64 %352, i64* @rsi

; 0x140b
  store volatile i64 5131, i64* @_asm_program_counter
  store i64 8250, i64* @rax

; 0x1412
  store volatile i64 5138, i64* @_asm_program_counter
  %353 = load i64, i64* @rax
  store i64 %353, i64* @rdi

; 0x1415
  store volatile i64 5141, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x141a
  store volatile i64 5146, i64* @_asm_program_counter
  %354 = call i64 @function_10d0()
  store i64 %354, i64* @rax

; 0x141f
  store volatile i64 5151, i64* @_asm_program_counter
  %355 = load i64, i64* @rbp
  %356 = add i64 %355, -24
  %357 = inttoptr i64 %356 to i64*
  %358 = load i64, i64* %357
  store i64 %358, i64* @rax

; 0x1423
  store volatile i64 5155, i64* @_asm_program_counter
  %359 = load i64, i64* @rax
  store i64 %359, i64* @rdi

; 0x1426
  store volatile i64 5158, i64* @_asm_program_counter
  %360 = call i64 @function_10a0()
  store i64 %360, i64* @rax

; 0x142b
  store volatile i64 5163, i64* @_asm_program_counter
  %361 = load i64, i64* @rbp
  %362 = add i64 %361, -16
  %363 = inttoptr i64 %362 to i64*
  %364 = load i64, i64* %363
  store i64 %364, i64* @rax

; 0x142f
  store volatile i64 5167, i64* @_asm_program_counter
  %365 = load i64, i64* @rax
  store i64 %365, i64* @rdi

; 0x1432
  store volatile i64 5170, i64* @_asm_program_counter
  %366 = call i64 @function_10a0()
  store i64 %366, i64* @rax

; 0x1437
  store volatile i64 5175, i64* @_asm_program_counter
  %367 = load i64, i64* @rbp
  %368 = add i64 %367, -8
  %369 = inttoptr i64 %368 to i64*
  %370 = load i64, i64* %369
  store i64 %370, i64* @rax

; 0x143b
  store volatile i64 5179, i64* @_asm_program_counter
  %371 = load i64, i64* @rax
  store i64 %371, i64* @rdi

; 0x143e
  store volatile i64 5182, i64* @_asm_program_counter
  %372 = call i64 @function_10a0()
  store i64 %372, i64* @rax

; 0x1443
  store volatile i64 5187, i64* @_asm_program_counter

; 0x1444
  store volatile i64 5188, i64* @_asm_program_counter
  %373 = load i64, i64* @rbp
  %374 = inttoptr i64 %373 to i64*
  %375 = load i64, i64* %374
  %376 = add i64 %373, 8
  store i64 %375, i64* @rbp
  store i64 %376, i64* @rsp

; 0x1445
  store volatile i64 5189, i64* @_asm_program_counter
  ret i64 undef
}

define i64 @function_1446() {
dec_label_pc_1446:

; 0x1446
  store volatile i64 5190, i64* @_asm_program_counter

; 0x144a
  store volatile i64 5194, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x144b
  store volatile i64 5195, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x144e
  store volatile i64 5198, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 160
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 160
  %11 = xor i64 %5, 160
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1455
  store volatile i64 5205, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x145e
  store volatile i64 5214, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x1462
  store volatile i64 5218, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1464
  store volatile i64 5220, i64* @_asm_program_counter
  %38 = load i64, i64* @rbp
  %39 = add i64 %38, -160
  %40 = inttoptr i64 %39 to i32*
  store i32 5, i32* %40

; 0x146e
  store volatile i64 5230, i64* @_asm_program_counter
  %41 = load i64, i64* @rbp
  %42 = add i64 %41, -144
  %43 = inttoptr i64 %42 to i32*
  store i32 100, i32* %43

; 0x1478
  store volatile i64 5240, i64* @_asm_program_counter
  %44 = load i64, i64* @rbp
  %45 = add i64 %44, -84
  %46 = inttoptr i64 %45 to i32*
  store i32 200, i32* %46

; 0x147f
  store volatile i64 5247, i64* @_asm_program_counter
  %47 = load i64, i64* @rbp
  %48 = add i64 %47, -160
  %49 = inttoptr i64 %48 to i32*
  %50 = load i32, i32* %49
  %51 = zext i32 %50 to i64
  store i64 %51, i64* @rax

; 0x1485
  store volatile i64 5253, i64* @_asm_program_counter
  %52 = load i64, i64* @rax
  %53 = trunc i64 %52 to i32
  %54 = sext i32 %53 to i64
  store i64 %54, i64* @rax

; 0x1487
  store volatile i64 5255, i64* @_asm_program_counter
  %55 = load i64, i64* @rbp
  %56 = load i64, i64* @rax
  %57 = mul i64 %56, 4
  %58 = add i64 %55, -144
  %59 = add i64 %58, %57
  %60 = inttoptr i64 %59 to i32*
  store i32 300, i32* %60

; 0x1492
  store volatile i64 5266, i64* @_asm_program_counter
  %61 = load i64, i64* @rbp
  %62 = add i64 %61, -160
  %63 = inttoptr i64 %62 to i32*
  %64 = load i32, i32* %63
  %65 = zext i32 %64 to i64
  store i64 %65, i64* @rax

; 0x1498
  store volatile i64 5272, i64* @_asm_program_counter
  %66 = load i64, i64* @rax
  %67 = trunc i64 %66 to i32
  %68 = add i32 %67, 2
  %69 = and i32 %67, 15
  %70 = add i32 %69, 2
  %71 = icmp ugt i32 %70, 15
  %72 = icmp ult i32 %68, %67
  %73 = xor i32 %67, %68
  %74 = xor i32 2, %68
  %75 = and i32 %73, %74
  %76 = icmp slt i32 %75, 0
  store i1 %71, i1* @az
  store i1 %72, i1* @cf
  store i1 %76, i1* @of
  %77 = icmp eq i32 %68, 0
  store i1 %77, i1* @zf
  %78 = icmp slt i32 %68, 0
  store i1 %78, i1* @sf
  %79 = trunc i32 %68 to i8
  %80 = call i8 @llvm.ctpop.i8(i8 %79)
  %81 = and i8 %80, 1
  %82 = icmp eq i8 %81, 0
  store i1 %82, i1* @pf
  %83 = zext i32 %68 to i64
  store i64 %83, i64* @rax

; 0x149b
  store volatile i64 5275, i64* @_asm_program_counter
  %84 = load i64, i64* @rax
  %85 = trunc i64 %84 to i32
  %86 = sext i32 %85 to i64
  store i64 %86, i64* @rax

; 0x149d
  store volatile i64 5277, i64* @_asm_program_counter
  %87 = load i64, i64* @rbp
  %88 = load i64, i64* @rax
  %89 = mul i64 %88, 4
  %90 = add i64 %87, -144
  %91 = add i64 %90, %89
  %92 = inttoptr i64 %91 to i32*
  store i32 400, i32* %92

; 0x14a8
  store volatile i64 5288, i64* @_asm_program_counter
  %93 = load i64, i64* @rbp
  %94 = add i64 %93, -144
  %95 = inttoptr i64 %94 to i32*
  %96 = load i32, i32* %95
  %97 = zext i32 %96 to i64
  store i64 %97, i64* @rax

; 0x14ae
  store volatile i64 5294, i64* @_asm_program_counter
  %98 = load i64, i64* @rax
  %99 = trunc i64 %98 to i32
  %100 = load i64, i64* @rbp
  %101 = add i64 %100, -156
  %102 = inttoptr i64 %101 to i32*
  store i32 %99, i32* %102

; 0x14b4
  store volatile i64 5300, i64* @_asm_program_counter
  %103 = load i64, i64* @rbp
  %104 = add i64 %103, -160
  %105 = inttoptr i64 %104 to i32*
  %106 = load i32, i32* %105
  %107 = zext i32 %106 to i64
  store i64 %107, i64* @rax

; 0x14ba
  store volatile i64 5306, i64* @_asm_program_counter
  %108 = load i64, i64* @rax
  %109 = trunc i64 %108 to i32
  %110 = sext i32 %109 to i64
  store i64 %110, i64* @rax

; 0x14bc
  store volatile i64 5308, i64* @_asm_program_counter
  %111 = load i64, i64* @rbp
  %112 = load i64, i64* @rax
  %113 = mul i64 %112, 4
  %114 = add i64 %111, -144
  %115 = add i64 %114, %113
  %116 = inttoptr i64 %115 to i32*
  %117 = load i32, i32* %116
  %118 = zext i32 %117 to i64
  store i64 %118, i64* @rax

; 0x14c3
  store volatile i64 5315, i64* @_asm_program_counter
  %119 = load i64, i64* @rax
  %120 = trunc i64 %119 to i32
  %121 = load i64, i64* @rbp
  %122 = add i64 %121, -152
  %123 = inttoptr i64 %122 to i32*
  store i32 %120, i32* %123

; 0x14c9
  store volatile i64 5321, i64* @_asm_program_counter
  %124 = load i64, i64* @rbp
  %125 = add i64 %124, -80
  %126 = inttoptr i64 %125 to i32*
  store i32 1, i32* %126

; 0x14d0
  store volatile i64 5328, i64* @_asm_program_counter
  %127 = load i64, i64* @rbp
  %128 = add i64 %127, -160
  %129 = inttoptr i64 %128 to i32*
  %130 = load i32, i32* %129
  %131 = zext i32 %130 to i64
  store i64 %131, i64* @rax

; 0x14d6
  store volatile i64 5334, i64* @_asm_program_counter
  %132 = load i64, i64* @rax
  %133 = trunc i64 %132 to i32
  %134 = sext i32 %133 to i64
  store i64 %134, i64* @rdx

; 0x14d9
  store volatile i64 5337, i64* @_asm_program_counter
  %135 = load i64, i64* @rdx
  store i64 %135, i64* @rax

; 0x14dc
  store volatile i64 5340, i64* @_asm_program_counter
  %136 = load i64, i64* @rax
  %137 = load i1, i1* @of
  %138 = shl i64 %136, 2
  %139 = icmp eq i64 %138, 0
  store i1 %139, i1* @zf
  %140 = icmp slt i64 %138, 0
  store i1 %140, i1* @sf
  %141 = trunc i64 %138 to i8
  %142 = call i8 @llvm.ctpop.i8(i8 %141)
  %143 = and i8 %142, 1
  %144 = icmp eq i8 %143, 0
  store i1 %144, i1* @pf
  store i64 %138, i64* @rax
  %145 = shl i64 %136, 1
  %146 = lshr i64 %145, 63
  %147 = trunc i64 %146 to i1
  store i1 %147, i1* @cf
  %148 = lshr i64 %138, 63
  %149 = icmp ne i64 %148, %146
  %150 = select i1 false, i1 %149, i1 %137
  store i1 %150, i1* @of

; 0x14e0
  store volatile i64 5344, i64* @_asm_program_counter
  %151 = load i64, i64* @rax
  %152 = load i64, i64* @rdx
  %153 = add i64 %151, %152
  %154 = and i64 %151, 15
  %155 = and i64 %152, 15
  %156 = add i64 %154, %155
  %157 = icmp ugt i64 %156, 15
  %158 = icmp ult i64 %153, %151
  %159 = xor i64 %151, %153
  %160 = xor i64 %152, %153
  %161 = and i64 %159, %160
  %162 = icmp slt i64 %161, 0
  store i1 %157, i1* @az
  store i1 %158, i1* @cf
  store i1 %162, i1* @of
  %163 = icmp eq i64 %153, 0
  store i1 %163, i1* @zf
  %164 = icmp slt i64 %153, 0
  store i1 %164, i1* @sf
  %165 = trunc i64 %153 to i8
  %166 = call i8 @llvm.ctpop.i8(i8 %165)
  %167 = and i8 %166, 1
  %168 = icmp eq i8 %167, 0
  store i1 %168, i1* @pf
  store i64 %153, i64* @rax

; 0x14e3
  store volatile i64 5347, i64* @_asm_program_counter
  %169 = load i64, i64* @rax
  %170 = load i1, i1* @of
  %171 = shl i64 %169, 2
  %172 = icmp eq i64 %171, 0
  store i1 %172, i1* @zf
  %173 = icmp slt i64 %171, 0
  store i1 %173, i1* @sf
  %174 = trunc i64 %171 to i8
  %175 = call i8 @llvm.ctpop.i8(i8 %174)
  %176 = and i8 %175, 1
  %177 = icmp eq i8 %176, 0
  store i1 %177, i1* @pf
  store i64 %171, i64* @rax
  %178 = shl i64 %169, 1
  %179 = lshr i64 %178, 63
  %180 = trunc i64 %179 to i1
  store i1 %180, i1* @cf
  %181 = lshr i64 %171, 63
  %182 = icmp ne i64 %181, %179
  %183 = select i1 false, i1 %182, i1 %170
  store i1 %183, i1* @of

; 0x14e7
  store volatile i64 5351, i64* @_asm_program_counter
  %184 = load i64, i64* @rax
  %185 = load i64, i64* @rbp
  %186 = add i64 %184, %185
  %187 = and i64 %184, 15
  %188 = and i64 %185, 15
  %189 = add i64 %187, %188
  %190 = icmp ugt i64 %189, 15
  %191 = icmp ult i64 %186, %184
  %192 = xor i64 %184, %186
  %193 = xor i64 %185, %186
  %194 = and i64 %192, %193
  %195 = icmp slt i64 %194, 0
  store i1 %190, i1* @az
  store i1 %191, i1* @cf
  store i1 %195, i1* @of
  %196 = icmp eq i64 %186, 0
  store i1 %196, i1* @zf
  %197 = icmp slt i64 %186, 0
  store i1 %197, i1* @sf
  %198 = trunc i64 %186 to i8
  %199 = call i8 @llvm.ctpop.i8(i8 %198)
  %200 = and i8 %199, 1
  %201 = icmp eq i8 %200, 0
  store i1 %201, i1* @pf
  store i64 %186, i64* @rax

; 0x14ea
  store volatile i64 5354, i64* @_asm_program_counter
  %202 = load i64, i64* @rax
  %203 = sub i64 %202, 80
  %204 = and i64 %202, 15
  %205 = sub i64 %204, 0
  %206 = icmp ugt i64 %205, 15
  %207 = icmp ult i64 %202, 80
  %208 = xor i64 %202, 80
  %209 = xor i64 %202, %203
  %210 = and i64 %208, %209
  %211 = icmp slt i64 %210, 0
  store i1 %206, i1* @az
  store i1 %207, i1* @cf
  store i1 %211, i1* @of
  %212 = icmp eq i64 %203, 0
  store i1 %212, i1* @zf
  %213 = icmp slt i64 %203, 0
  store i1 %213, i1* @sf
  %214 = trunc i64 %203 to i8
  %215 = call i8 @llvm.ctpop.i8(i8 %214)
  %216 = and i8 %215, 1
  %217 = icmp eq i8 %216, 0
  store i1 %217, i1* @pf
  store i64 %203, i64* @rax

; 0x14ee
  store volatile i64 5358, i64* @_asm_program_counter
  %218 = load i64, i64* @rax
  %219 = inttoptr i64 %218 to i32*
  store i32 2, i32* %219

; 0x14f4
  store volatile i64 5364, i64* @_asm_program_counter
  %220 = load i64, i64* @rbp
  %221 = add i64 %220, -56
  %222 = inttoptr i64 %221 to i32*
  %223 = load i32, i32* %222
  %224 = zext i32 %223 to i64
  store i64 %224, i64* @rax

; 0x14f7
  store volatile i64 5367, i64* @_asm_program_counter
  %225 = load i64, i64* @rax
  %226 = trunc i64 %225 to i32
  %227 = load i64, i64* @rbp
  %228 = add i64 %227, -148
  %229 = inttoptr i64 %228 to i32*
  store i32 %226, i32* %229

; 0x14fd
  store volatile i64 5373, i64* @_asm_program_counter
  %230 = load i64, i64* @rbp
  %231 = add i64 %230, -148
  %232 = inttoptr i64 %231 to i32*
  %233 = load i32, i32* %232
  %234 = zext i32 %233 to i64
  store i64 %234, i64* @rcx

; 0x1503
  store volatile i64 5379, i64* @_asm_program_counter
  %235 = load i64, i64* @rbp
  %236 = add i64 %235, -152
  %237 = inttoptr i64 %236 to i32*
  %238 = load i32, i32* %237
  %239 = zext i32 %238 to i64
  store i64 %239, i64* @rdx

; 0x1509
  store volatile i64 5385, i64* @_asm_program_counter
  %240 = load i64, i64* @rbp
  %241 = add i64 %240, -156
  %242 = inttoptr i64 %241 to i32*
  %243 = load i32, i32* %242
  %244 = zext i32 %243 to i64
  store i64 %244, i64* @rax

; 0x150f
  store volatile i64 5391, i64* @_asm_program_counter
  %245 = load i64, i64* @rax
  %246 = trunc i64 %245 to i32
  %247 = zext i32 %246 to i64
  store i64 %247, i64* @rsi

; 0x1511
  store volatile i64 5393, i64* @_asm_program_counter
  store i64 8264, i64* @rax

; 0x1518
  store volatile i64 5400, i64* @_asm_program_counter
  %248 = load i64, i64* @rax
  store i64 %248, i64* @rdi

; 0x151b
  store volatile i64 5403, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x1520
  store volatile i64 5408, i64* @_asm_program_counter
  %249 = call i64 @function_10d0()
  store i64 %249, i64* @rax

; 0x1525
  store volatile i64 5413, i64* @_asm_program_counter

; 0x1526
  store volatile i64 5414, i64* @_asm_program_counter
  %250 = load i64, i64* @rbp
  %251 = add i64 %250, -8
  %252 = inttoptr i64 %251 to i64*
  %253 = load i64, i64* %252
  store i64 %253, i64* @rax

; 0x152a
  store volatile i64 5418, i64* @_asm_program_counter
  %254 = load i64, i64* @rax
  %255 = call i64 @__readfsqword(i64 40)
  %256 = sub i64 %254, %255
  %257 = and i64 %254, 15
  %258 = and i64 %255, 15
  %259 = sub i64 %257, %258
  %260 = icmp ugt i64 %259, 15
  %261 = icmp ult i64 %254, %255
  %262 = xor i64 %254, %255
  %263 = xor i64 %254, %256
  %264 = and i64 %262, %263
  %265 = icmp slt i64 %264, 0
  store i1 %260, i1* @az
  store i1 %261, i1* @cf
  store i1 %265, i1* @of
  %266 = icmp eq i64 %256, 0
  store i1 %266, i1* @zf
  %267 = icmp slt i64 %256, 0
  store i1 %267, i1* @sf
  %268 = trunc i64 %256 to i8
  %269 = call i8 @llvm.ctpop.i8(i8 %268)
  %270 = and i8 %269, 1
  %271 = icmp eq i8 %270, 0
  store i1 %271, i1* @pf
  store i64 %256, i64* @rax

; 0x1533
  store volatile i64 5427, i64* @_asm_program_counter
  %272 = load i1, i1* @zf
  br i1 %272, label %dec_label_pc_153a, label %dec_label_pc_1535

dec_label_pc_1535:                                ; preds = %dec_label_pc_1446

; 0x1535
  store volatile i64 5429, i64* @_asm_program_counter
  %273 = call i64 @function_10c0()
  store i64 %273, i64* @rax
  br label %dec_label_pc_153a

dec_label_pc_153a:                                ; preds = %dec_label_pc_1535, %dec_label_pc_1446

; 0x153a
  store volatile i64 5434, i64* @_asm_program_counter
  %274 = load i64, i64* @rbp
  %275 = inttoptr i64 %274 to i64*
  %276 = load i64, i64* %275
  %277 = add i64 %274, 8
  store i64 %276, i64* @rbp
  store i64 %277, i64* @rsp

; 0x153b
  store volatile i64 5435, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %255, { 3, 2, 1, 0 }
}

define i64 @function_153c() {
dec_label_pc_153c:

; 0x153c
  store volatile i64 5436, i64* @_asm_program_counter

; 0x1540
  store volatile i64 5440, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1541
  store volatile i64 5441, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x1544
  store volatile i64 5444, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 64
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 64
  %11 = xor i64 %5, 64
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1548
  store volatile i64 5448, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x1551
  store volatile i64 5457, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x1555
  store volatile i64 5461, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1557
  store volatile i64 5463, i64* @_asm_program_counter
  %38 = load i64, i64* @rbp
  %39 = add i64 %38, -32
  %40 = inttoptr i64 %39 to i32*
  store i32 10, i32* %40

; 0x155e
  store volatile i64 5470, i64* @_asm_program_counter
  %41 = load i64, i64* @rbp
  %42 = add i64 %41, -28
  %43 = inttoptr i64 %42 to i32*
  store i32 20, i32* %43

; 0x1565
  store volatile i64 5477, i64* @_asm_program_counter
  %44 = load i64, i64* @rbp
  %45 = add i64 %44, -32
  store i64 %45, i64* @rax

; 0x1569
  store volatile i64 5481, i64* @_asm_program_counter
  %46 = load i64, i64* @rax
  %47 = add i64 %46, 8
  %48 = and i64 %46, 15
  %49 = add i64 %48, 8
  %50 = icmp ugt i64 %49, 15
  %51 = icmp ult i64 %47, %46
  %52 = xor i64 %46, %47
  %53 = xor i64 8, %47
  %54 = and i64 %52, %53
  %55 = icmp slt i64 %54, 0
  store i1 %50, i1* @az
  store i1 %51, i1* @cf
  store i1 %55, i1* @of
  %56 = icmp eq i64 %47, 0
  store i1 %56, i1* @zf
  %57 = icmp slt i64 %47, 0
  store i1 %57, i1* @sf
  %58 = trunc i64 %47 to i8
  %59 = call i8 @llvm.ctpop.i8(i8 %58)
  %60 = and i8 %59, 1
  %61 = icmp eq i8 %60, 0
  store i1 %61, i1* @pf
  store i64 %47, i64* @rax

; 0x156d
  store volatile i64 5485, i64* @_asm_program_counter
  %62 = load i64, i64* @rax
  %63 = inttoptr i64 %62 to i32*
  store i32 1633906540, i32* %63

; 0x1573
  store volatile i64 5491, i64* @_asm_program_counter
  %64 = load i64, i64* @rax
  %65 = add i64 %64, 4
  %66 = inttoptr i64 %65 to i16*
  store i16 108, i16* %66

; 0x1579
  store volatile i64 5497, i64* @_asm_program_counter
  %67 = load i64, i64* @rbp
  %68 = add i64 %67, -32
  %69 = inttoptr i64 %68 to i32*
  %70 = load i32, i32* %69
  %71 = zext i32 %70 to i64
  store i64 %71, i64* @rax

; 0x157c
  store volatile i64 5500, i64* @_asm_program_counter
  %72 = load i64, i64* @rax
  %73 = trunc i64 %72 to i32
  %74 = load i64, i64* @rbp
  %75 = add i64 %74, -56
  %76 = inttoptr i64 %75 to i32*
  store i32 %73, i32* %76

; 0x157f
  store volatile i64 5503, i64* @_asm_program_counter
  %77 = load i64, i64* @rbp
  %78 = add i64 %77, -28
  %79 = inttoptr i64 %78 to i32*
  %80 = load i32, i32* %79
  %81 = zext i32 %80 to i64
  store i64 %81, i64* @rax

; 0x1582
  store volatile i64 5506, i64* @_asm_program_counter
  %82 = load i64, i64* @rax
  %83 = trunc i64 %82 to i32
  %84 = load i64, i64* @rbp
  %85 = add i64 %84, -52
  %86 = inttoptr i64 %85 to i32*
  store i32 %83, i32* %86

; 0x1585
  store volatile i64 5509, i64* @_asm_program_counter
  %87 = load i64, i64* @rbp
  %88 = add i64 %87, -24
  %89 = inttoptr i64 %88 to i8*
  %90 = load i8, i8* %89
  %91 = zext i8 %90 to i64
  store i64 %91, i64* @rax

; 0x1589
  store volatile i64 5513, i64* @_asm_program_counter
  %92 = load i64, i64* @rax
  %93 = trunc i64 %92 to i8
  %94 = load i64, i64* @rbp
  %95 = add i64 %94, -57
  %96 = inttoptr i64 %95 to i8*
  store i8 %93, i8* %96

; 0x158c
  store volatile i64 5516, i64* @_asm_program_counter
  %97 = load i64, i64* @rbp
  %98 = add i64 %97, -32
  store i64 %98, i64* @rax

; 0x1590
  store volatile i64 5520, i64* @_asm_program_counter
  %99 = load i64, i64* @rax
  %100 = load i64, i64* @rbp
  %101 = add i64 %100, -40
  %102 = inttoptr i64 %101 to i64*
  store i64 %99, i64* %102

; 0x1594
  store volatile i64 5524, i64* @_asm_program_counter
  %103 = load i64, i64* @rbp
  %104 = add i64 %103, -40
  %105 = inttoptr i64 %104 to i64*
  %106 = load i64, i64* %105
  store i64 %106, i64* @rax

; 0x1598
  store volatile i64 5528, i64* @_asm_program_counter
  %107 = load i64, i64* @rax
  %108 = inttoptr i64 %107 to i32*
  store i32 30, i32* %108

; 0x159e
  store volatile i64 5534, i64* @_asm_program_counter
  %109 = load i64, i64* @rbp
  %110 = add i64 %109, -40
  %111 = inttoptr i64 %110 to i64*
  %112 = load i64, i64* %111
  store i64 %112, i64* @rax

; 0x15a2
  store volatile i64 5538, i64* @_asm_program_counter
  %113 = load i64, i64* @rax
  %114 = inttoptr i64 %113 to i32*
  %115 = load i32, i32* %114
  %116 = zext i32 %115 to i64
  store i64 %116, i64* @rax

; 0x15a4
  store volatile i64 5540, i64* @_asm_program_counter
  %117 = load i64, i64* @rax
  %118 = trunc i64 %117 to i32
  %119 = load i64, i64* @rbp
  %120 = add i64 %119, -48
  %121 = inttoptr i64 %120 to i32*
  store i32 %118, i32* %121

; 0x15a7
  store volatile i64 5543, i64* @_asm_program_counter
  %122 = load i64, i64* @rbp
  %123 = add i64 %122, -52
  %124 = inttoptr i64 %123 to i32*
  %125 = load i32, i32* %124
  %126 = zext i32 %125 to i64
  store i64 %126, i64* @rax

; 0x15aa
  store volatile i64 5546, i64* @_asm_program_counter
  %127 = load i64, i64* @rax
  %128 = trunc i64 %127 to i32
  store i32 %128, i32* inttoptr (i64 16420 to i32*)

; 0x15b0
  store volatile i64 5552, i64* @_asm_program_counter
  %129 = load i32, i32* inttoptr (i64 16420 to i32*)
  %130 = zext i32 %129 to i64
  store i64 %130, i64* @rax

; 0x15b6
  store volatile i64 5558, i64* @_asm_program_counter
  %131 = load i64, i64* @rax
  %132 = trunc i64 %131 to i32
  %133 = load i64, i64* @rbp
  %134 = add i64 %133, -44
  %135 = inttoptr i64 %134 to i32*
  store i32 %132, i32* %135

; 0x15b9
  store volatile i64 5561, i64* @_asm_program_counter
  %136 = load i64, i64* @rbp
  %137 = add i64 %136, -57
  %138 = inttoptr i64 %137 to i8*
  %139 = load i8, i8* %138
  %140 = sext i8 %139 to i64
  store i64 %140, i64* @rcx

; 0x15bd
  store volatile i64 5565, i64* @_asm_program_counter
  %141 = load i64, i64* @rbp
  %142 = add i64 %141, -44
  %143 = inttoptr i64 %142 to i32*
  %144 = load i32, i32* %143
  %145 = zext i32 %144 to i64
  store i64 %145, i64* @rsi

; 0x15c0
  store volatile i64 5568, i64* @_asm_program_counter
  %146 = load i64, i64* @rbp
  %147 = add i64 %146, -52
  %148 = inttoptr i64 %147 to i32*
  %149 = load i32, i32* %148
  %150 = zext i32 %149 to i64
  store i64 %150, i64* @rdx

; 0x15c3
  store volatile i64 5571, i64* @_asm_program_counter
  %151 = load i64, i64* @rbp
  %152 = add i64 %151, -56
  %153 = inttoptr i64 %152 to i32*
  %154 = load i32, i32* %153
  %155 = zext i32 %154 to i64
  store i64 %155, i64* @rax

; 0x15c6
  store volatile i64 5574, i64* @_asm_program_counter
  %156 = load i64, i64* @rsi
  %157 = trunc i64 %156 to i32
  %158 = zext i32 %157 to i64
  store i64 %158, i64* @r8

; 0x15c9
  store volatile i64 5577, i64* @_asm_program_counter
  %159 = load i64, i64* @rax
  %160 = trunc i64 %159 to i32
  %161 = zext i32 %160 to i64
  store i64 %161, i64* @rsi

; 0x15cb
  store volatile i64 5579, i64* @_asm_program_counter
  store i64 8283, i64* @rax

; 0x15d2
  store volatile i64 5586, i64* @_asm_program_counter
  %162 = load i64, i64* @rax
  store i64 %162, i64* @rdi

; 0x15d5
  store volatile i64 5589, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x15da
  store volatile i64 5594, i64* @_asm_program_counter
  %163 = call i64 @function_10d0()
  store i64 %163, i64* @rax

; 0x15df
  store volatile i64 5599, i64* @_asm_program_counter

; 0x15e0
  store volatile i64 5600, i64* @_asm_program_counter
  %164 = load i64, i64* @rbp
  %165 = add i64 %164, -8
  %166 = inttoptr i64 %165 to i64*
  %167 = load i64, i64* %166
  store i64 %167, i64* @rax

; 0x15e4
  store volatile i64 5604, i64* @_asm_program_counter
  %168 = load i64, i64* @rax
  %169 = call i64 @__readfsqword(i64 40)
  %170 = sub i64 %168, %169
  %171 = and i64 %168, 15
  %172 = and i64 %169, 15
  %173 = sub i64 %171, %172
  %174 = icmp ugt i64 %173, 15
  %175 = icmp ult i64 %168, %169
  %176 = xor i64 %168, %169
  %177 = xor i64 %168, %170
  %178 = and i64 %176, %177
  %179 = icmp slt i64 %178, 0
  store i1 %174, i1* @az
  store i1 %175, i1* @cf
  store i1 %179, i1* @of
  %180 = icmp eq i64 %170, 0
  store i1 %180, i1* @zf
  %181 = icmp slt i64 %170, 0
  store i1 %181, i1* @sf
  %182 = trunc i64 %170 to i8
  %183 = call i8 @llvm.ctpop.i8(i8 %182)
  %184 = and i8 %183, 1
  %185 = icmp eq i8 %184, 0
  store i1 %185, i1* @pf
  store i64 %170, i64* @rax

; 0x15ed
  store volatile i64 5613, i64* @_asm_program_counter
  %186 = load i1, i1* @zf
  br i1 %186, label %dec_label_pc_15f4, label %dec_label_pc_15ef

dec_label_pc_15ef:                                ; preds = %dec_label_pc_153c

; 0x15ef
  store volatile i64 5615, i64* @_asm_program_counter
  %187 = call i64 @function_10c0()
  store i64 %187, i64* @rax
  br label %dec_label_pc_15f4

dec_label_pc_15f4:                                ; preds = %dec_label_pc_15ef, %dec_label_pc_153c

; 0x15f4
  store volatile i64 5620, i64* @_asm_program_counter
  %188 = load i64, i64* @rbp
  %189 = inttoptr i64 %188 to i64*
  %190 = load i64, i64* %189
  %191 = add i64 %188, 8
  store i64 %190, i64* @rbp
  store i64 %191, i64* @rsp

; 0x15f5
  store volatile i64 5621, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %169, { 3, 2, 1, 0 }
}

define i64 @function_15f6() {
dec_label_pc_15f6:

; 0x15f6
  store volatile i64 5622, i64* @_asm_program_counter

; 0x15fa
  store volatile i64 5626, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x15fb
  store volatile i64 5627, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x15fe
  store volatile i64 5630, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 112
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 112
  %11 = xor i64 %5, 112
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1602
  store volatile i64 5634, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x160b
  store volatile i64 5643, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x160f
  store volatile i64 5647, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1611
  store volatile i64 5649, i64* @_asm_program_counter
  %38 = load i64, i64* @rbp
  %39 = add i64 %38, -104
  %40 = inttoptr i64 %39 to i32*
  store i32 10, i32* %40

; 0x1618
  store volatile i64 5656, i64* @_asm_program_counter
  %41 = load i64, i64* @rbp
  %42 = add i64 %41, -104
  store i64 %42, i64* @rax

; 0x161c
  store volatile i64 5660, i64* @_asm_program_counter
  %43 = load i64, i64* @rax
  %44 = load i64, i64* @rbp
  %45 = add i64 %44, -80
  %46 = inttoptr i64 %45 to i64*
  store i64 %43, i64* %46

; 0x1620
  store volatile i64 5664, i64* @_asm_program_counter
  %47 = load i64, i64* @rbp
  %48 = add i64 %47, -80
  store i64 %48, i64* @rax

; 0x1624
  store volatile i64 5668, i64* @_asm_program_counter
  %49 = load i64, i64* @rax
  %50 = load i64, i64* @rbp
  %51 = add i64 %50, -72
  %52 = inttoptr i64 %51 to i64*
  store i64 %49, i64* %52

; 0x1628
  store volatile i64 5672, i64* @_asm_program_counter
  %53 = load i64, i64* @rbp
  %54 = add i64 %53, -72
  store i64 %54, i64* @rax

; 0x162c
  store volatile i64 5676, i64* @_asm_program_counter
  %55 = load i64, i64* @rax
  %56 = load i64, i64* @rbp
  %57 = add i64 %56, -64
  %58 = inttoptr i64 %57 to i64*
  store i64 %55, i64* %58

; 0x1630
  store volatile i64 5680, i64* @_asm_program_counter
  %59 = load i64, i64* @rbp
  %60 = add i64 %59, -80
  %61 = inttoptr i64 %60 to i64*
  %62 = load i64, i64* %61
  store i64 %62, i64* @rax

; 0x1634
  store volatile i64 5684, i64* @_asm_program_counter
  %63 = load i64, i64* @rax
  %64 = inttoptr i64 %63 to i32*
  store i32 20, i32* %64

; 0x163a
  store volatile i64 5690, i64* @_asm_program_counter
  %65 = load i64, i64* @rbp
  %66 = add i64 %65, -72
  %67 = inttoptr i64 %66 to i64*
  %68 = load i64, i64* %67
  store i64 %68, i64* @rax

; 0x163e
  store volatile i64 5694, i64* @_asm_program_counter
  %69 = load i64, i64* @rax
  %70 = inttoptr i64 %69 to i64*
  %71 = load i64, i64* %70
  store i64 %71, i64* @rax

; 0x1641
  store volatile i64 5697, i64* @_asm_program_counter
  %72 = load i64, i64* @rax
  %73 = inttoptr i64 %72 to i32*
  store i32 30, i32* %73

; 0x1647
  store volatile i64 5703, i64* @_asm_program_counter
  %74 = load i64, i64* @rbp
  %75 = add i64 %74, -64
  %76 = inttoptr i64 %75 to i64*
  %77 = load i64, i64* %76
  store i64 %77, i64* @rax

; 0x164b
  store volatile i64 5707, i64* @_asm_program_counter
  %78 = load i64, i64* @rax
  %79 = inttoptr i64 %78 to i64*
  %80 = load i64, i64* %79
  store i64 %80, i64* @rax

; 0x164e
  store volatile i64 5710, i64* @_asm_program_counter
  %81 = load i64, i64* @rax
  %82 = inttoptr i64 %81 to i64*
  %83 = load i64, i64* %82
  store i64 %83, i64* @rax

; 0x1651
  store volatile i64 5713, i64* @_asm_program_counter
  %84 = load i64, i64* @rax
  %85 = inttoptr i64 %84 to i32*
  store i32 40, i32* %85

; 0x1657
  store volatile i64 5719, i64* @_asm_program_counter
  %86 = load i64, i64* @rbp
  %87 = add i64 %86, -80
  %88 = inttoptr i64 %87 to i64*
  %89 = load i64, i64* %88
  store i64 %89, i64* @rax

; 0x165b
  store volatile i64 5723, i64* @_asm_program_counter
  %90 = load i64, i64* @rax
  %91 = inttoptr i64 %90 to i32*
  %92 = load i32, i32* %91
  %93 = zext i32 %92 to i64
  store i64 %93, i64* @rax

; 0x165d
  store volatile i64 5725, i64* @_asm_program_counter
  %94 = load i64, i64* @rax
  %95 = trunc i64 %94 to i32
  %96 = load i64, i64* @rbp
  %97 = add i64 %96, -100
  %98 = inttoptr i64 %97 to i32*
  store i32 %95, i32* %98

; 0x1660
  store volatile i64 5728, i64* @_asm_program_counter
  %99 = load i64, i64* @rbp
  %100 = add i64 %99, -72
  %101 = inttoptr i64 %100 to i64*
  %102 = load i64, i64* %101
  store i64 %102, i64* @rax

; 0x1664
  store volatile i64 5732, i64* @_asm_program_counter
  %103 = load i64, i64* @rax
  %104 = inttoptr i64 %103 to i64*
  %105 = load i64, i64* %104
  store i64 %105, i64* @rax

; 0x1667
  store volatile i64 5735, i64* @_asm_program_counter
  %106 = load i64, i64* @rax
  %107 = inttoptr i64 %106 to i32*
  %108 = load i32, i32* %107
  %109 = zext i32 %108 to i64
  store i64 %109, i64* @rax

; 0x1669
  store volatile i64 5737, i64* @_asm_program_counter
  %110 = load i64, i64* @rax
  %111 = trunc i64 %110 to i32
  %112 = load i64, i64* @rbp
  %113 = add i64 %112, -96
  %114 = inttoptr i64 %113 to i32*
  store i32 %111, i32* %114

; 0x166c
  store volatile i64 5740, i64* @_asm_program_counter
  %115 = load i64, i64* @rbp
  %116 = add i64 %115, -64
  %117 = inttoptr i64 %116 to i64*
  %118 = load i64, i64* %117
  store i64 %118, i64* @rax

; 0x1670
  store volatile i64 5744, i64* @_asm_program_counter
  %119 = load i64, i64* @rax
  %120 = inttoptr i64 %119 to i64*
  %121 = load i64, i64* %120
  store i64 %121, i64* @rax

; 0x1673
  store volatile i64 5747, i64* @_asm_program_counter
  %122 = load i64, i64* @rax
  %123 = inttoptr i64 %122 to i64*
  %124 = load i64, i64* %123
  store i64 %124, i64* @rax

; 0x1676
  store volatile i64 5750, i64* @_asm_program_counter
  %125 = load i64, i64* @rax
  %126 = inttoptr i64 %125 to i32*
  %127 = load i32, i32* %126
  %128 = zext i32 %127 to i64
  store i64 %128, i64* @rax

; 0x1678
  store volatile i64 5752, i64* @_asm_program_counter
  %129 = load i64, i64* @rax
  %130 = trunc i64 %129 to i32
  %131 = load i64, i64* @rbp
  %132 = add i64 %131, -92
  %133 = inttoptr i64 %132 to i32*
  store i32 %130, i32* %133

; 0x167b
  store volatile i64 5755, i64* @_asm_program_counter
  %134 = load i64, i64* @rbp
  %135 = add i64 %134, -48
  %136 = inttoptr i64 %135 to i32*
  store i32 0, i32* %136

; 0x1682
  store volatile i64 5762, i64* @_asm_program_counter
  %137 = load i64, i64* @rbp
  %138 = add i64 %137, -44
  %139 = inttoptr i64 %138 to i32*
  store i32 1, i32* %139

; 0x1689
  store volatile i64 5769, i64* @_asm_program_counter
  %140 = load i64, i64* @rbp
  %141 = add i64 %140, -40
  %142 = inttoptr i64 %141 to i32*
  store i32 2, i32* %142

; 0x1690
  store volatile i64 5776, i64* @_asm_program_counter
  %143 = load i64, i64* @rbp
  %144 = add i64 %143, -36
  %145 = inttoptr i64 %144 to i32*
  store i32 3, i32* %145

; 0x1697
  store volatile i64 5783, i64* @_asm_program_counter
  %146 = load i64, i64* @rbp
  %147 = add i64 %146, -32
  %148 = inttoptr i64 %147 to i32*
  store i32 4, i32* %148

; 0x169e
  store volatile i64 5790, i64* @_asm_program_counter
  %149 = load i64, i64* @rbp
  %150 = add i64 %149, -28
  %151 = inttoptr i64 %150 to i32*
  store i32 5, i32* %151

; 0x16a5
  store volatile i64 5797, i64* @_asm_program_counter
  %152 = load i64, i64* @rbp
  %153 = add i64 %152, -24
  %154 = inttoptr i64 %153 to i32*
  store i32 6, i32* %154

; 0x16ac
  store volatile i64 5804, i64* @_asm_program_counter
  %155 = load i64, i64* @rbp
  %156 = add i64 %155, -20
  %157 = inttoptr i64 %156 to i32*
  store i32 7, i32* %157

; 0x16b3
  store volatile i64 5811, i64* @_asm_program_counter
  %158 = load i64, i64* @rbp
  %159 = add i64 %158, -16
  %160 = inttoptr i64 %159 to i32*
  store i32 8, i32* %160

; 0x16ba
  store volatile i64 5818, i64* @_asm_program_counter
  %161 = load i64, i64* @rbp
  %162 = add i64 %161, -12
  %163 = inttoptr i64 %162 to i32*
  store i32 9, i32* %163

; 0x16c1
  store volatile i64 5825, i64* @_asm_program_counter
  %164 = load i64, i64* @rbp
  %165 = add i64 %164, -48
  store i64 %165, i64* @rax

; 0x16c5
  store volatile i64 5829, i64* @_asm_program_counter
  %166 = load i64, i64* @rax
  %167 = load i64, i64* @rbp
  %168 = add i64 %167, -56
  %169 = inttoptr i64 %168 to i64*
  store i64 %166, i64* %169

; 0x16c9
  store volatile i64 5833, i64* @_asm_program_counter
  %170 = load i64, i64* @rbp
  %171 = add i64 %170, -56
  %172 = inttoptr i64 %171 to i64*
  %173 = load i64, i64* %172
  %174 = add i64 %173, 12
  %175 = and i64 %173, 15
  %176 = add i64 %175, 12
  %177 = icmp ugt i64 %176, 15
  %178 = icmp ult i64 %174, %173
  %179 = xor i64 %173, %174
  %180 = xor i64 12, %174
  %181 = and i64 %179, %180
  %182 = icmp slt i64 %181, 0
  store i1 %177, i1* @az
  store i1 %178, i1* @cf
  store i1 %182, i1* @of
  %183 = icmp eq i64 %174, 0
  store i1 %183, i1* @zf
  %184 = icmp slt i64 %174, 0
  store i1 %184, i1* @sf
  %185 = trunc i64 %174 to i8
  %186 = call i8 @llvm.ctpop.i8(i8 %185)
  %187 = and i8 %186, 1
  %188 = icmp eq i8 %187, 0
  store i1 %188, i1* @pf
  %189 = load i64, i64* @rbp
  %190 = add i64 %189, -56
  %191 = inttoptr i64 %190 to i64*
  store i64 %174, i64* %191

; 0x16ce
  store volatile i64 5838, i64* @_asm_program_counter
  %192 = load i64, i64* @rbp
  %193 = add i64 %192, -56
  %194 = inttoptr i64 %193 to i64*
  %195 = load i64, i64* %194
  store i64 %195, i64* @rax

; 0x16d2
  store volatile i64 5842, i64* @_asm_program_counter
  %196 = load i64, i64* @rax
  %197 = inttoptr i64 %196 to i32*
  %198 = load i32, i32* %197
  %199 = zext i32 %198 to i64
  store i64 %199, i64* @rax

; 0x16d4
  store volatile i64 5844, i64* @_asm_program_counter
  %200 = load i64, i64* @rax
  %201 = trunc i64 %200 to i32
  %202 = load i64, i64* @rbp
  %203 = add i64 %202, -88
  %204 = inttoptr i64 %203 to i32*
  store i32 %201, i32* %204

; 0x16d7
  store volatile i64 5847, i64* @_asm_program_counter
  %205 = load i64, i64* @rbp
  %206 = add i64 %205, -56
  %207 = inttoptr i64 %206 to i64*
  %208 = load i64, i64* %207
  %209 = sub i64 %208, 4
  %210 = and i64 %208, 15
  %211 = sub i64 %210, 4
  %212 = icmp ugt i64 %211, 15
  %213 = icmp ult i64 %208, 4
  %214 = xor i64 %208, 4
  %215 = xor i64 %208, %209
  %216 = and i64 %214, %215
  %217 = icmp slt i64 %216, 0
  store i1 %212, i1* @az
  store i1 %213, i1* @cf
  store i1 %217, i1* @of
  %218 = icmp eq i64 %209, 0
  store i1 %218, i1* @zf
  %219 = icmp slt i64 %209, 0
  store i1 %219, i1* @sf
  %220 = trunc i64 %209 to i8
  %221 = call i8 @llvm.ctpop.i8(i8 %220)
  %222 = and i8 %221, 1
  %223 = icmp eq i8 %222, 0
  store i1 %223, i1* @pf
  %224 = load i64, i64* @rbp
  %225 = add i64 %224, -56
  %226 = inttoptr i64 %225 to i64*
  store i64 %209, i64* %226

; 0x16dc
  store volatile i64 5852, i64* @_asm_program_counter
  %227 = load i64, i64* @rbp
  %228 = add i64 %227, -56
  %229 = inttoptr i64 %228 to i64*
  %230 = load i64, i64* %229
  store i64 %230, i64* @rax

; 0x16e0
  store volatile i64 5856, i64* @_asm_program_counter
  %231 = load i64, i64* @rax
  %232 = inttoptr i64 %231 to i32*
  %233 = load i32, i32* %232
  %234 = zext i32 %233 to i64
  store i64 %234, i64* @rax

; 0x16e2
  store volatile i64 5858, i64* @_asm_program_counter
  %235 = load i64, i64* @rax
  %236 = trunc i64 %235 to i32
  %237 = load i64, i64* @rbp
  %238 = add i64 %237, -84
  %239 = inttoptr i64 %238 to i32*
  store i32 %236, i32* %239

; 0x16e5
  store volatile i64 5861, i64* @_asm_program_counter
  %240 = load i64, i64* @rbp
  %241 = add i64 %240, -84
  %242 = inttoptr i64 %241 to i32*
  %243 = load i32, i32* %242
  %244 = zext i32 %243 to i64
  store i64 %244, i64* @rdi

; 0x16e8
  store volatile i64 5864, i64* @_asm_program_counter
  %245 = load i64, i64* @rbp
  %246 = add i64 %245, -88
  %247 = inttoptr i64 %246 to i32*
  %248 = load i32, i32* %247
  %249 = zext i32 %248 to i64
  store i64 %249, i64* @rsi

; 0x16eb
  store volatile i64 5867, i64* @_asm_program_counter
  %250 = load i64, i64* @rbp
  %251 = add i64 %250, -92
  %252 = inttoptr i64 %251 to i32*
  %253 = load i32, i32* %252
  %254 = zext i32 %253 to i64
  store i64 %254, i64* @rcx

; 0x16ee
  store volatile i64 5870, i64* @_asm_program_counter
  %255 = load i64, i64* @rbp
  %256 = add i64 %255, -96
  %257 = inttoptr i64 %256 to i32*
  %258 = load i32, i32* %257
  %259 = zext i32 %258 to i64
  store i64 %259, i64* @rdx

; 0x16f1
  store volatile i64 5873, i64* @_asm_program_counter
  %260 = load i64, i64* @rbp
  %261 = add i64 %260, -100
  %262 = inttoptr i64 %261 to i32*
  %263 = load i32, i32* %262
  %264 = zext i32 %263 to i64
  store i64 %264, i64* @rax

; 0x16f4
  store volatile i64 5876, i64* @_asm_program_counter
  %265 = load i64, i64* @rdi
  %266 = trunc i64 %265 to i32
  %267 = zext i32 %266 to i64
  store i64 %267, i64* @r9

; 0x16f7
  store volatile i64 5879, i64* @_asm_program_counter
  %268 = load i64, i64* @rsi
  %269 = trunc i64 %268 to i32
  %270 = zext i32 %269 to i64
  store i64 %270, i64* @r8

; 0x16fa
  store volatile i64 5882, i64* @_asm_program_counter
  %271 = load i64, i64* @rax
  %272 = trunc i64 %271 to i32
  %273 = zext i32 %272 to i64
  store i64 %273, i64* @rsi

; 0x16fc
  store volatile i64 5884, i64* @_asm_program_counter
  store i64 8307, i64* @rax

; 0x1703
  store volatile i64 5891, i64* @_asm_program_counter
  %274 = load i64, i64* @rax
  store i64 %274, i64* @rdi

; 0x1706
  store volatile i64 5894, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x170b
  store volatile i64 5899, i64* @_asm_program_counter
  %275 = call i64 @function_10d0()
  store i64 %275, i64* @rax

; 0x1710
  store volatile i64 5904, i64* @_asm_program_counter

; 0x1711
  store volatile i64 5905, i64* @_asm_program_counter
  %276 = load i64, i64* @rbp
  %277 = add i64 %276, -8
  %278 = inttoptr i64 %277 to i64*
  %279 = load i64, i64* %278
  store i64 %279, i64* @rax

; 0x1715
  store volatile i64 5909, i64* @_asm_program_counter
  %280 = load i64, i64* @rax
  %281 = call i64 @__readfsqword(i64 40)
  %282 = sub i64 %280, %281
  %283 = and i64 %280, 15
  %284 = and i64 %281, 15
  %285 = sub i64 %283, %284
  %286 = icmp ugt i64 %285, 15
  %287 = icmp ult i64 %280, %281
  %288 = xor i64 %280, %281
  %289 = xor i64 %280, %282
  %290 = and i64 %288, %289
  %291 = icmp slt i64 %290, 0
  store i1 %286, i1* @az
  store i1 %287, i1* @cf
  store i1 %291, i1* @of
  %292 = icmp eq i64 %282, 0
  store i1 %292, i1* @zf
  %293 = icmp slt i64 %282, 0
  store i1 %293, i1* @sf
  %294 = trunc i64 %282 to i8
  %295 = call i8 @llvm.ctpop.i8(i8 %294)
  %296 = and i8 %295, 1
  %297 = icmp eq i8 %296, 0
  store i1 %297, i1* @pf
  store i64 %282, i64* @rax

; 0x171e
  store volatile i64 5918, i64* @_asm_program_counter
  %298 = load i1, i1* @zf
  br i1 %298, label %dec_label_pc_1725, label %dec_label_pc_1720

dec_label_pc_1720:                                ; preds = %dec_label_pc_15f6

; 0x1720
  store volatile i64 5920, i64* @_asm_program_counter
  %299 = call i64 @function_10c0()
  store i64 %299, i64* @rax
  br label %dec_label_pc_1725

dec_label_pc_1725:                                ; preds = %dec_label_pc_1720, %dec_label_pc_15f6

; 0x1725
  store volatile i64 5925, i64* @_asm_program_counter
  %300 = load i64, i64* @rbp
  %301 = inttoptr i64 %300 to i64*
  %302 = load i64, i64* %301
  %303 = add i64 %300, 8
  store i64 %302, i64* @rbp
  store i64 %303, i64* @rsp

; 0x1726
  store volatile i64 5926, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %281, { 3, 2, 1, 0 }
}

define i64 @function_1727() {
dec_label_pc_1727:

; 0x1727
  store volatile i64 5927, i64* @_asm_program_counter

; 0x172b
  store volatile i64 5931, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x172c
  store volatile i64 5932, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x172f
  store volatile i64 5935, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 64
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 64
  %11 = xor i64 %5, 64
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1733
  store volatile i64 5939, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x173c
  store volatile i64 5948, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x1740
  store volatile i64 5952, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1742
  store volatile i64 5954, i64* @_asm_program_counter
  store i64 4585, i64* @rax

; 0x1749
  store volatile i64 5961, i64* @_asm_program_counter
  %38 = load i64, i64* @rax
  %39 = load i64, i64* @rbp
  %40 = add i64 %39, -48
  %41 = inttoptr i64 %40 to i64*
  store i64 %38, i64* %41

; 0x174d
  store volatile i64 5965, i64* @_asm_program_counter
  store i64 4671, i64* @rax

; 0x1754
  store volatile i64 5972, i64* @_asm_program_counter
  %42 = load i64, i64* @rax
  %43 = load i64, i64* @rbp
  %44 = add i64 %43, -40
  %45 = inttoptr i64 %44 to i64*
  store i64 %42, i64* %45

; 0x1758
  store volatile i64 5976, i64* @_asm_program_counter
  %46 = load i64, i64* @rbp
  %47 = add i64 %46, -48
  %48 = inttoptr i64 %47 to i64*
  %49 = load i64, i64* %48
  store i64 %49, i64* @rax

; 0x175c
  store volatile i64 5980, i64* @_asm_program_counter
  store i64 100, i64* @rdi

; 0x1761
  store volatile i64 5985, i64* @_asm_program_counter
  %50 = load i64, i64* @rsp
  %51 = sub i64 %50, 8
  %52 = inttoptr i64 %51 to i64*
  %53 = load i64, i64* @rax
  call void @__pseudo_call(i64 %53), !retdec.call_type !0, !retdec.indirect_target !1

; 0x1763
  store volatile i64 5987, i64* @_asm_program_counter
  %54 = load i64, i64* @rbp
  %55 = add i64 %54, -40
  %56 = inttoptr i64 %55 to i64*
  %57 = load i64, i64* %56
  store i64 %57, i64* @rax

; 0x1767
  store volatile i64 5991, i64* @_asm_program_counter
  store i64 20, i64* @rsi

; 0x176c
  store volatile i64 5996, i64* @_asm_program_counter
  store i64 10, i64* @rdi

; 0x1771
  store volatile i64 6001, i64* @_asm_program_counter
  %58 = load i64, i64* @rsp
  %59 = sub i64 %58, 8
  %60 = inttoptr i64 %59 to i64*
  %61 = load i64, i64* @rax
  call void @__pseudo_call(i64 %61), !retdec.call_type !0, !retdec.indirect_target !2

; 0x1773
  store volatile i64 6003, i64* @_asm_program_counter
  %62 = load i64, i64* @rax
  %63 = trunc i64 %62 to i32
  %64 = load i64, i64* @rbp
  %65 = add i64 %64, -52
  %66 = inttoptr i64 %65 to i32*
  store i32 %63, i32* %66

; 0x1776
  store volatile i64 6006, i64* @_asm_program_counter
  store i64 4585, i64* @rax

; 0x177d
  store volatile i64 6013, i64* @_asm_program_counter
  %67 = load i64, i64* @rax
  %68 = load i64, i64* @rbp
  %69 = add i64 %68, -32
  %70 = inttoptr i64 %69 to i64*
  store i64 %67, i64* %70

; 0x1781
  store volatile i64 6017, i64* @_asm_program_counter
  store i64 4628, i64* @rax

; 0x1788
  store volatile i64 6024, i64* @_asm_program_counter
  %71 = load i64, i64* @rax
  %72 = load i64, i64* @rbp
  %73 = add i64 %72, -24
  %74 = inttoptr i64 %73 to i64*
  store i64 %71, i64* %74

; 0x178c
  store volatile i64 6028, i64* @_asm_program_counter
  %75 = load i64, i64* @rbp
  %76 = add i64 %75, -32
  %77 = inttoptr i64 %76 to i64*
  %78 = load i64, i64* %77
  store i64 %78, i64* @rax

; 0x1790
  store volatile i64 6032, i64* @_asm_program_counter
  store i64 1, i64* @rdi

; 0x1795
  store volatile i64 6037, i64* @_asm_program_counter
  %79 = load i64, i64* @rsp
  %80 = sub i64 %79, 8
  %81 = inttoptr i64 %80 to i64*
  %82 = load i64, i64* @rax
  call void @__pseudo_call(i64 %82), !retdec.call_type !0, !retdec.indirect_target !3

; 0x1797
  store volatile i64 6039, i64* @_asm_program_counter
  %83 = load i64, i64* @rbp
  %84 = add i64 %83, -24
  %85 = inttoptr i64 %84 to i64*
  %86 = load i64, i64* %85
  store i64 %86, i64* @rax

; 0x179b
  store volatile i64 6043, i64* @_asm_program_counter
  store i64 2, i64* @rdi

; 0x17a0
  store volatile i64 6048, i64* @_asm_program_counter
  %87 = load i64, i64* @rsp
  %88 = sub i64 %87, 8
  %89 = inttoptr i64 %88 to i64*
  %90 = load i64, i64* @rax
  call void @__pseudo_call(i64 %90), !retdec.call_type !0, !retdec.indirect_target !4

; 0x17a2
  store volatile i64 6050, i64* @_asm_program_counter
  store i64 4585, i64* @rax

; 0x17a9
  store volatile i64 6057, i64* @_asm_program_counter
  %91 = load i64, i64* @rax
  store i64 %91, i64* inttoptr (i64 16552 to i64*)

; 0x17b0
  store volatile i64 6064, i64* @_asm_program_counter
  %92 = load i64, i64* inttoptr (i64 16552 to i64*)
  store i64 %92, i64* @rax

; 0x17b7
  store volatile i64 6071, i64* @_asm_program_counter
  %93 = load i64, i64* @rax
  %94 = load i64, i64* @rax
  %95 = and i64 %93, %94
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %96 = icmp eq i64 %95, 0
  store i1 %96, i1* @zf
  %97 = icmp slt i64 %95, 0
  store i1 %97, i1* @sf
  %98 = trunc i64 %95 to i8
  %99 = call i8 @llvm.ctpop.i8(i8 %98)
  %100 = and i8 %99, 1
  %101 = icmp eq i8 %100, 0
  store i1 %101, i1* @pf

; 0x17ba
  store volatile i64 6074, i64* @_asm_program_counter
  %102 = load i1, i1* @zf
  br i1 %102, label %dec_label_pc_17c5, label %dec_label_pc_17bc

dec_label_pc_17bc:                                ; preds = %dec_label_pc_1727

; 0x17bc
  store volatile i64 6076, i64* @_asm_program_counter
  %103 = load i64, i64* inttoptr (i64 16552 to i64*)
  store i64 %103, i64* @rax

; 0x17c3
  store volatile i64 6083, i64* @_asm_program_counter
  %104 = load i64, i64* @rsp
  %105 = sub i64 %104, 8
  %106 = inttoptr i64 %105 to i64*
  %107 = load i64, i64* @rax
  call void @__pseudo_call(i64 %107), !retdec.call_type !0, !retdec.indirect_target !5
  br label %dec_label_pc_17c5

dec_label_pc_17c5:                                ; preds = %dec_label_pc_17bc, %dec_label_pc_1727

; 0x17c5
  store volatile i64 6085, i64* @_asm_program_counter
  %108 = load i64, i64* @rbp
  %109 = add i64 %108, -52
  %110 = inttoptr i64 %109 to i32*
  %111 = load i32, i32* %110
  %112 = zext i32 %111 to i64
  store i64 %112, i64* @rax

; 0x17c8
  store volatile i64 6088, i64* @_asm_program_counter
  %113 = load i64, i64* @rax
  %114 = trunc i64 %113 to i32
  %115 = zext i32 %114 to i64
  store i64 %115, i64* @rsi

; 0x17ca
  store volatile i64 6090, i64* @_asm_program_counter
  store i64 8336, i64* @rax

; 0x17d1
  store volatile i64 6097, i64* @_asm_program_counter
  %116 = load i64, i64* @rax
  store i64 %116, i64* @rdi

; 0x17d4
  store volatile i64 6100, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x17d9
  store volatile i64 6105, i64* @_asm_program_counter
  %117 = call i64 @function_10d0()
  store i64 %117, i64* @rax

; 0x17de
  store volatile i64 6110, i64* @_asm_program_counter

; 0x17df
  store volatile i64 6111, i64* @_asm_program_counter
  %118 = load i64, i64* @rbp
  %119 = add i64 %118, -8
  %120 = inttoptr i64 %119 to i64*
  %121 = load i64, i64* %120
  store i64 %121, i64* @rax

; 0x17e3
  store volatile i64 6115, i64* @_asm_program_counter
  %122 = load i64, i64* @rax
  %123 = call i64 @__readfsqword(i64 40)
  %124 = sub i64 %122, %123
  %125 = and i64 %122, 15
  %126 = and i64 %123, 15
  %127 = sub i64 %125, %126
  %128 = icmp ugt i64 %127, 15
  %129 = icmp ult i64 %122, %123
  %130 = xor i64 %122, %123
  %131 = xor i64 %122, %124
  %132 = and i64 %130, %131
  %133 = icmp slt i64 %132, 0
  store i1 %128, i1* @az
  store i1 %129, i1* @cf
  store i1 %133, i1* @of
  %134 = icmp eq i64 %124, 0
  store i1 %134, i1* @zf
  %135 = icmp slt i64 %124, 0
  store i1 %135, i1* @sf
  %136 = trunc i64 %124 to i8
  %137 = call i8 @llvm.ctpop.i8(i8 %136)
  %138 = and i8 %137, 1
  %139 = icmp eq i8 %138, 0
  store i1 %139, i1* @pf
  store i64 %124, i64* @rax

; 0x17ec
  store volatile i64 6124, i64* @_asm_program_counter
  %140 = load i1, i1* @zf
  br i1 %140, label %dec_label_pc_17f3, label %dec_label_pc_17ee

dec_label_pc_17ee:                                ; preds = %dec_label_pc_17c5

; 0x17ee
  store volatile i64 6126, i64* @_asm_program_counter
  %141 = call i64 @function_10c0()
  store i64 %141, i64* @rax
  br label %dec_label_pc_17f3

dec_label_pc_17f3:                                ; preds = %dec_label_pc_17ee, %dec_label_pc_17c5

; 0x17f3
  store volatile i64 6131, i64* @_asm_program_counter
  %142 = load i64, i64* @rbp
  %143 = inttoptr i64 %142 to i64*
  %144 = load i64, i64* %143
  %145 = add i64 %142, 8
  store i64 %144, i64* @rbp
  store i64 %145, i64* @rsp

; 0x17f4
  store volatile i64 6132, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %123, { 3, 2, 1, 0 }
}

define i64 @function_17f5() {
dec_label_pc_17f5:

; 0x17f5
  store volatile i64 6133, i64* @_asm_program_counter

; 0x17f9
  store volatile i64 6137, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x17fa
  store volatile i64 6138, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x17fd
  store volatile i64 6141, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 112
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 112
  %11 = xor i64 %5, 112
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1801
  store volatile i64 6145, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x180a
  store volatile i64 6154, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x180e
  store volatile i64 6158, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1810
  store volatile i64 6160, i64* @_asm_program_counter
  %38 = load i64, i64* @rbp
  %39 = add i64 %38, -100
  %40 = inttoptr i64 %39 to i32*
  store i32 0, i32* %40

; 0x1817
  store volatile i64 6167, i64* @_asm_program_counter
  br label %dec_label_pc_1866

dec_label_pc_1819:                                ; preds = %dec_label_pc_1866

; 0x1819
  store volatile i64 6169, i64* @_asm_program_counter
  %41 = load i64, i64* @rbp
  %42 = add i64 %41, -100
  %43 = inttoptr i64 %42 to i32*
  %44 = load i32, i32* %43
  %45 = zext i32 %44 to i64
  store i64 %45, i64* @rax

; 0x181c
  store volatile i64 6172, i64* @_asm_program_counter
  %46 = load i64, i64* @rax
  %47 = trunc i64 %46 to i32
  %48 = sext i32 %47 to i64
  store i64 %48, i64* @rdx

; 0x181f
  store volatile i64 6175, i64* @_asm_program_counter
  %49 = load i64, i64* @rdx
  store i64 %49, i64* @rax

; 0x1822
  store volatile i64 6178, i64* @_asm_program_counter
  %50 = load i64, i64* @rax
  %51 = load i64, i64* @rax
  %52 = add i64 %50, %51
  %53 = and i64 %50, 15
  %54 = and i64 %51, 15
  %55 = add i64 %53, %54
  %56 = icmp ugt i64 %55, 15
  %57 = icmp ult i64 %52, %50
  %58 = xor i64 %50, %52
  %59 = xor i64 %51, %52
  %60 = and i64 %58, %59
  %61 = icmp slt i64 %60, 0
  store i1 %56, i1* @az
  store i1 %57, i1* @cf
  store i1 %61, i1* @of
  %62 = icmp eq i64 %52, 0
  store i1 %62, i1* @zf
  %63 = icmp slt i64 %52, 0
  store i1 %63, i1* @sf
  %64 = trunc i64 %52 to i8
  %65 = call i8 @llvm.ctpop.i8(i8 %64)
  %66 = and i8 %65, 1
  %67 = icmp eq i8 %66, 0
  store i1 %67, i1* @pf
  store i64 %52, i64* @rax

; 0x1825
  store volatile i64 6181, i64* @_asm_program_counter
  %68 = load i64, i64* @rax
  %69 = load i64, i64* @rdx
  %70 = add i64 %68, %69
  %71 = and i64 %68, 15
  %72 = and i64 %69, 15
  %73 = add i64 %71, %72
  %74 = icmp ugt i64 %73, 15
  %75 = icmp ult i64 %70, %68
  %76 = xor i64 %68, %70
  %77 = xor i64 %69, %70
  %78 = and i64 %76, %77
  %79 = icmp slt i64 %78, 0
  store i1 %74, i1* @az
  store i1 %75, i1* @cf
  store i1 %79, i1* @of
  %80 = icmp eq i64 %70, 0
  store i1 %80, i1* @zf
  %81 = icmp slt i64 %70, 0
  store i1 %81, i1* @sf
  %82 = trunc i64 %70 to i8
  %83 = call i8 @llvm.ctpop.i8(i8 %82)
  %84 = and i8 %83, 1
  %85 = icmp eq i8 %84, 0
  store i1 %85, i1* @pf
  store i64 %70, i64* @rax

; 0x1828
  store volatile i64 6184, i64* @_asm_program_counter
  %86 = load i64, i64* @rax
  %87 = load i1, i1* @of
  %88 = shl i64 %86, 3
  %89 = icmp eq i64 %88, 0
  store i1 %89, i1* @zf
  %90 = icmp slt i64 %88, 0
  store i1 %90, i1* @sf
  %91 = trunc i64 %88 to i8
  %92 = call i8 @llvm.ctpop.i8(i8 %91)
  %93 = and i8 %92, 1
  %94 = icmp eq i8 %93, 0
  store i1 %94, i1* @pf
  store i64 %88, i64* @rax
  %95 = shl i64 %86, 2
  %96 = lshr i64 %95, 63
  %97 = trunc i64 %96 to i1
  store i1 %97, i1* @cf
  %98 = lshr i64 %88, 63
  %99 = icmp ne i64 %98, %96
  %100 = select i1 false, i1 %99, i1 %87
  store i1 %100, i1* @of

; 0x182c
  store volatile i64 6188, i64* @_asm_program_counter
  %101 = load i64, i64* @rax
  %102 = load i64, i64* @rbp
  %103 = add i64 %101, %102
  %104 = and i64 %101, 15
  %105 = and i64 %102, 15
  %106 = add i64 %104, %105
  %107 = icmp ugt i64 %106, 15
  %108 = icmp ult i64 %103, %101
  %109 = xor i64 %101, %103
  %110 = xor i64 %102, %103
  %111 = and i64 %109, %110
  %112 = icmp slt i64 %111, 0
  store i1 %107, i1* @az
  store i1 %108, i1* @cf
  store i1 %112, i1* @of
  %113 = icmp eq i64 %103, 0
  store i1 %113, i1* @zf
  %114 = icmp slt i64 %103, 0
  store i1 %114, i1* @sf
  %115 = trunc i64 %103 to i8
  %116 = call i8 @llvm.ctpop.i8(i8 %115)
  %117 = and i8 %116, 1
  %118 = icmp eq i8 %117, 0
  store i1 %118, i1* @pf
  store i64 %103, i64* @rax

; 0x182f
  store volatile i64 6191, i64* @_asm_program_counter
  %119 = load i64, i64* @rax
  %120 = add i64 %119, -80
  store i64 %120, i64* @rdx

; 0x1833
  store volatile i64 6195, i64* @_asm_program_counter
  %121 = load i64, i64* @rbp
  %122 = add i64 %121, -100
  %123 = inttoptr i64 %122 to i32*
  %124 = load i32, i32* %123
  %125 = zext i32 %124 to i64
  store i64 %125, i64* @rax

; 0x1836
  store volatile i64 6198, i64* @_asm_program_counter
  %126 = load i64, i64* @rax
  %127 = trunc i64 %126 to i32
  %128 = load i64, i64* @rdx
  %129 = inttoptr i64 %128 to i32*
  store i32 %127, i32* %129

; 0x1838
  store volatile i64 6200, i64* @_asm_program_counter
  %130 = load i64, i64* @rbp
  %131 = add i64 %130, -100
  %132 = inttoptr i64 %131 to i32*
  %133 = load i32, i32* %132
  %134 = zext i32 %133 to i64
  store i64 %134, i64* @rdx

; 0x183b
  store volatile i64 6203, i64* @_asm_program_counter
  %135 = load i64, i64* @rdx
  %136 = trunc i64 %135 to i32
  %137 = zext i32 %136 to i64
  store i64 %137, i64* @rax

; 0x183d
  store volatile i64 6205, i64* @_asm_program_counter
  %138 = load i64, i64* @rax
  %139 = trunc i64 %138 to i32
  %140 = load i1, i1* @of
  %141 = shl i32 %139, 2
  %142 = icmp eq i32 %141, 0
  store i1 %142, i1* @zf
  %143 = icmp slt i32 %141, 0
  store i1 %143, i1* @sf
  %144 = trunc i32 %141 to i8
  %145 = call i8 @llvm.ctpop.i8(i8 %144)
  %146 = and i8 %145, 1
  %147 = icmp eq i8 %146, 0
  store i1 %147, i1* @pf
  %148 = zext i32 %141 to i64
  store i64 %148, i64* @rax
  %149 = shl i32 %139, 1
  %150 = lshr i32 %149, 31
  %151 = trunc i32 %150 to i1
  store i1 %151, i1* @cf
  %152 = lshr i32 %141, 31
  %153 = icmp ne i32 %152, %150
  %154 = select i1 false, i1 %153, i1 %140
  store i1 %154, i1* @of

; 0x1840
  store volatile i64 6208, i64* @_asm_program_counter
  %155 = load i64, i64* @rax
  %156 = trunc i64 %155 to i32
  %157 = load i64, i64* @rdx
  %158 = trunc i64 %157 to i32
  %159 = add i32 %156, %158
  %160 = and i32 %156, 15
  %161 = and i32 %158, 15
  %162 = add i32 %160, %161
  %163 = icmp ugt i32 %162, 15
  %164 = icmp ult i32 %159, %156
  %165 = xor i32 %156, %159
  %166 = xor i32 %158, %159
  %167 = and i32 %165, %166
  %168 = icmp slt i32 %167, 0
  store i1 %163, i1* @az
  store i1 %164, i1* @cf
  store i1 %168, i1* @of
  %169 = icmp eq i32 %159, 0
  store i1 %169, i1* @zf
  %170 = icmp slt i32 %159, 0
  store i1 %170, i1* @sf
  %171 = trunc i32 %159 to i8
  %172 = call i8 @llvm.ctpop.i8(i8 %171)
  %173 = and i8 %172, 1
  %174 = icmp eq i8 %173, 0
  store i1 %174, i1* @pf
  %175 = zext i32 %159 to i64
  store i64 %175, i64* @rax

; 0x1842
  store volatile i64 6210, i64* @_asm_program_counter
  %176 = load i64, i64* @rax
  %177 = trunc i64 %176 to i32
  %178 = load i64, i64* @rax
  %179 = trunc i64 %178 to i32
  %180 = add i32 %177, %179
  %181 = and i32 %177, 15
  %182 = and i32 %179, 15
  %183 = add i32 %181, %182
  %184 = icmp ugt i32 %183, 15
  %185 = icmp ult i32 %180, %177
  %186 = xor i32 %177, %180
  %187 = xor i32 %179, %180
  %188 = and i32 %186, %187
  %189 = icmp slt i32 %188, 0
  store i1 %184, i1* @az
  store i1 %185, i1* @cf
  store i1 %189, i1* @of
  %190 = icmp eq i32 %180, 0
  store i1 %190, i1* @zf
  %191 = icmp slt i32 %180, 0
  store i1 %191, i1* @sf
  %192 = trunc i32 %180 to i8
  %193 = call i8 @llvm.ctpop.i8(i8 %192)
  %194 = and i8 %193, 1
  %195 = icmp eq i8 %194, 0
  store i1 %195, i1* @pf
  %196 = zext i32 %180 to i64
  store i64 %196, i64* @rax

; 0x1844
  store volatile i64 6212, i64* @_asm_program_counter
  %197 = load i64, i64* @rax
  %198 = trunc i64 %197 to i32
  %199 = zext i32 %198 to i64
  store i64 %199, i64* @rcx

; 0x1846
  store volatile i64 6214, i64* @_asm_program_counter
  %200 = load i64, i64* @rbp
  %201 = add i64 %200, -100
  %202 = inttoptr i64 %201 to i32*
  %203 = load i32, i32* %202
  %204 = zext i32 %203 to i64
  store i64 %204, i64* @rax

; 0x1849
  store volatile i64 6217, i64* @_asm_program_counter
  %205 = load i64, i64* @rax
  %206 = trunc i64 %205 to i32
  %207 = sext i32 %206 to i64
  store i64 %207, i64* @rdx

; 0x184c
  store volatile i64 6220, i64* @_asm_program_counter
  %208 = load i64, i64* @rdx
  store i64 %208, i64* @rax

; 0x184f
  store volatile i64 6223, i64* @_asm_program_counter
  %209 = load i64, i64* @rax
  %210 = load i64, i64* @rax
  %211 = add i64 %209, %210
  %212 = and i64 %209, 15
  %213 = and i64 %210, 15
  %214 = add i64 %212, %213
  %215 = icmp ugt i64 %214, 15
  %216 = icmp ult i64 %211, %209
  %217 = xor i64 %209, %211
  %218 = xor i64 %210, %211
  %219 = and i64 %217, %218
  %220 = icmp slt i64 %219, 0
  store i1 %215, i1* @az
  store i1 %216, i1* @cf
  store i1 %220, i1* @of
  %221 = icmp eq i64 %211, 0
  store i1 %221, i1* @zf
  %222 = icmp slt i64 %211, 0
  store i1 %222, i1* @sf
  %223 = trunc i64 %211 to i8
  %224 = call i8 @llvm.ctpop.i8(i8 %223)
  %225 = and i8 %224, 1
  %226 = icmp eq i8 %225, 0
  store i1 %226, i1* @pf
  store i64 %211, i64* @rax

; 0x1852
  store volatile i64 6226, i64* @_asm_program_counter
  %227 = load i64, i64* @rax
  %228 = load i64, i64* @rdx
  %229 = add i64 %227, %228
  %230 = and i64 %227, 15
  %231 = and i64 %228, 15
  %232 = add i64 %230, %231
  %233 = icmp ugt i64 %232, 15
  %234 = icmp ult i64 %229, %227
  %235 = xor i64 %227, %229
  %236 = xor i64 %228, %229
  %237 = and i64 %235, %236
  %238 = icmp slt i64 %237, 0
  store i1 %233, i1* @az
  store i1 %234, i1* @cf
  store i1 %238, i1* @of
  %239 = icmp eq i64 %229, 0
  store i1 %239, i1* @zf
  %240 = icmp slt i64 %229, 0
  store i1 %240, i1* @sf
  %241 = trunc i64 %229 to i8
  %242 = call i8 @llvm.ctpop.i8(i8 %241)
  %243 = and i8 %242, 1
  %244 = icmp eq i8 %243, 0
  store i1 %244, i1* @pf
  store i64 %229, i64* @rax

; 0x1855
  store volatile i64 6229, i64* @_asm_program_counter
  %245 = load i64, i64* @rax
  %246 = load i1, i1* @of
  %247 = shl i64 %245, 3
  %248 = icmp eq i64 %247, 0
  store i1 %248, i1* @zf
  %249 = icmp slt i64 %247, 0
  store i1 %249, i1* @sf
  %250 = trunc i64 %247 to i8
  %251 = call i8 @llvm.ctpop.i8(i8 %250)
  %252 = and i8 %251, 1
  %253 = icmp eq i8 %252, 0
  store i1 %253, i1* @pf
  store i64 %247, i64* @rax
  %254 = shl i64 %245, 2
  %255 = lshr i64 %254, 63
  %256 = trunc i64 %255 to i1
  store i1 %256, i1* @cf
  %257 = lshr i64 %247, 63
  %258 = icmp ne i64 %257, %255
  %259 = select i1 false, i1 %258, i1 %246
  store i1 %259, i1* @of

; 0x1859
  store volatile i64 6233, i64* @_asm_program_counter
  %260 = load i64, i64* @rax
  %261 = load i64, i64* @rbp
  %262 = add i64 %260, %261
  %263 = and i64 %260, 15
  %264 = and i64 %261, 15
  %265 = add i64 %263, %264
  %266 = icmp ugt i64 %265, 15
  %267 = icmp ult i64 %262, %260
  %268 = xor i64 %260, %262
  %269 = xor i64 %261, %262
  %270 = and i64 %268, %269
  %271 = icmp slt i64 %270, 0
  store i1 %266, i1* @az
  store i1 %267, i1* @cf
  store i1 %271, i1* @of
  %272 = icmp eq i64 %262, 0
  store i1 %272, i1* @zf
  %273 = icmp slt i64 %262, 0
  store i1 %273, i1* @sf
  %274 = trunc i64 %262 to i8
  %275 = call i8 @llvm.ctpop.i8(i8 %274)
  %276 = and i8 %275, 1
  %277 = icmp eq i8 %276, 0
  store i1 %277, i1* @pf
  store i64 %262, i64* @rax

; 0x185c
  store volatile i64 6236, i64* @_asm_program_counter
  %278 = load i64, i64* @rax
  %279 = sub i64 %278, 76
  %280 = and i64 %278, 15
  %281 = sub i64 %280, 12
  %282 = icmp ugt i64 %281, 15
  %283 = icmp ult i64 %278, 76
  %284 = xor i64 %278, 76
  %285 = xor i64 %278, %279
  %286 = and i64 %284, %285
  %287 = icmp slt i64 %286, 0
  store i1 %282, i1* @az
  store i1 %283, i1* @cf
  store i1 %287, i1* @of
  %288 = icmp eq i64 %279, 0
  store i1 %288, i1* @zf
  %289 = icmp slt i64 %279, 0
  store i1 %289, i1* @sf
  %290 = trunc i64 %279 to i8
  %291 = call i8 @llvm.ctpop.i8(i8 %290)
  %292 = and i8 %291, 1
  %293 = icmp eq i8 %292, 0
  store i1 %293, i1* @pf
  store i64 %279, i64* @rax

; 0x1860
  store volatile i64 6240, i64* @_asm_program_counter
  %294 = load i64, i64* @rcx
  %295 = trunc i64 %294 to i32
  %296 = load i64, i64* @rax
  %297 = inttoptr i64 %296 to i32*
  store i32 %295, i32* %297

; 0x1862
  store volatile i64 6242, i64* @_asm_program_counter
  %298 = load i64, i64* @rbp
  %299 = add i64 %298, -100
  %300 = inttoptr i64 %299 to i32*
  %301 = load i32, i32* %300
  %302 = add i32 %301, 1
  %303 = and i32 %301, 15
  %304 = add i32 %303, 1
  %305 = icmp ugt i32 %304, 15
  %306 = icmp ult i32 %302, %301
  %307 = xor i32 %301, %302
  %308 = xor i32 1, %302
  %309 = and i32 %307, %308
  %310 = icmp slt i32 %309, 0
  store i1 %305, i1* @az
  store i1 %306, i1* @cf
  store i1 %310, i1* @of
  %311 = icmp eq i32 %302, 0
  store i1 %311, i1* @zf
  %312 = icmp slt i32 %302, 0
  store i1 %312, i1* @sf
  %313 = trunc i32 %302 to i8
  %314 = call i8 @llvm.ctpop.i8(i8 %313)
  %315 = and i8 %314, 1
  %316 = icmp eq i8 %315, 0
  store i1 %316, i1* @pf
  %317 = load i64, i64* @rbp
  %318 = add i64 %317, -100
  %319 = inttoptr i64 %318 to i32*
  store i32 %302, i32* %319
  br label %dec_label_pc_1866

dec_label_pc_1866:                                ; preds = %dec_label_pc_1819, %dec_label_pc_17f5

; 0x1866
  store volatile i64 6246, i64* @_asm_program_counter
  %320 = load i64, i64* @rbp
  %321 = add i64 %320, -100
  %322 = inttoptr i64 %321 to i32*
  %323 = load i32, i32* %322
  %324 = sub i32 %323, 2
  %325 = and i32 %323, 15
  %326 = sub i32 %325, 2
  %327 = icmp ugt i32 %326, 15
  %328 = icmp ult i32 %323, 2
  %329 = xor i32 %323, 2
  %330 = xor i32 %323, %324
  %331 = and i32 %329, %330
  %332 = icmp slt i32 %331, 0
  store i1 %327, i1* @az
  store i1 %328, i1* @cf
  store i1 %332, i1* @of
  %333 = icmp eq i32 %324, 0
  store i1 %333, i1* @zf
  %334 = icmp slt i32 %324, 0
  store i1 %334, i1* @sf
  %335 = trunc i32 %324 to i8
  %336 = call i8 @llvm.ctpop.i8(i8 %335)
  %337 = and i8 %336, 1
  %338 = icmp eq i8 %337, 0
  store i1 %338, i1* @pf

; 0x186a
  store volatile i64 6250, i64* @_asm_program_counter
  %339 = load i1, i1* @zf
  %340 = load i1, i1* @sf
  %341 = load i1, i1* @of
  %342 = icmp ne i1 %340, %341
  %343 = or i1 %339, %342
  br i1 %343, label %dec_label_pc_1819, label %dec_label_pc_186c

dec_label_pc_186c:                                ; preds = %dec_label_pc_1866

; 0x186c
  store volatile i64 6252, i64* @_asm_program_counter
  store i64 16, i64* @rdi

; 0x1871
  store volatile i64 6257, i64* @_asm_program_counter
  %344 = call i64 @function_10f0()
  store i64 %344, i64* @rax

; 0x1876
  store volatile i64 6262, i64* @_asm_program_counter
  %345 = load i64, i64* @rax
  %346 = load i64, i64* @rbp
  %347 = add i64 %346, -88
  %348 = inttoptr i64 %347 to i64*
  store i64 %345, i64* %348

; 0x187a
  store volatile i64 6266, i64* @_asm_program_counter
  %349 = load i64, i64* @rbp
  %350 = add i64 %349, -88
  %351 = inttoptr i64 %350 to i64*
  %352 = load i64, i64* %351
  store i64 %352, i64* @rax

; 0x187e
  store volatile i64 6270, i64* @_asm_program_counter
  %353 = load i64, i64* @rax
  %354 = inttoptr i64 %353 to i32*
  store i32 0, i32* %354

; 0x1884
  store volatile i64 6276, i64* @_asm_program_counter
  store i64 16, i64* @rdi

; 0x1889
  store volatile i64 6281, i64* @_asm_program_counter
  %355 = call i64 @function_10f0()
  store i64 %355, i64* @rax

; 0x188e
  store volatile i64 6286, i64* @_asm_program_counter
  %356 = load i64, i64* @rax
  store i64 %356, i64* @rdx

; 0x1891
  store volatile i64 6289, i64* @_asm_program_counter
  %357 = load i64, i64* @rbp
  %358 = add i64 %357, -88
  %359 = inttoptr i64 %358 to i64*
  %360 = load i64, i64* %359
  store i64 %360, i64* @rax

; 0x1895
  store volatile i64 6293, i64* @_asm_program_counter
  %361 = load i64, i64* @rdx
  %362 = load i64, i64* @rax
  %363 = add i64 %362, 8
  %364 = inttoptr i64 %363 to i64*
  store i64 %361, i64* %364

; 0x1899
  store volatile i64 6297, i64* @_asm_program_counter
  %365 = load i64, i64* @rbp
  %366 = add i64 %365, -88
  %367 = inttoptr i64 %366 to i64*
  %368 = load i64, i64* %367
  store i64 %368, i64* @rax

; 0x189d
  store volatile i64 6301, i64* @_asm_program_counter
  %369 = load i64, i64* @rax
  %370 = add i64 %369, 8
  %371 = inttoptr i64 %370 to i64*
  %372 = load i64, i64* %371
  store i64 %372, i64* @rax

; 0x18a1
  store volatile i64 6305, i64* @_asm_program_counter
  %373 = load i64, i64* @rax
  %374 = inttoptr i64 %373 to i32*
  store i32 1, i32* %374

; 0x18a7
  store volatile i64 6311, i64* @_asm_program_counter
  %375 = load i64, i64* @rbp
  %376 = add i64 %375, -88
  %377 = inttoptr i64 %376 to i64*
  %378 = load i64, i64* %377
  store i64 %378, i64* @rax

; 0x18ab
  store volatile i64 6315, i64* @_asm_program_counter
  %379 = load i64, i64* @rax
  %380 = add i64 %379, 8
  %381 = inttoptr i64 %380 to i64*
  %382 = load i64, i64* %381
  store i64 %382, i64* @rax

; 0x18af
  store volatile i64 6319, i64* @_asm_program_counter
  %383 = load i64, i64* @rax
  %384 = add i64 %383, 8
  %385 = inttoptr i64 %384 to i64*
  store i64 0, i64* %385

; 0x18b7
  store volatile i64 6327, i64* @_asm_program_counter
  %386 = load i64, i64* @rbp
  %387 = add i64 %386, -88
  %388 = inttoptr i64 %387 to i64*
  %389 = load i64, i64* %388
  store i64 %389, i64* @rax

; 0x18bb
  store volatile i64 6331, i64* @_asm_program_counter
  %390 = load i64, i64* @rax
  %391 = load i64, i64* @rbp
  %392 = add i64 %391, -96
  %393 = inttoptr i64 %392 to i64*
  store i64 %390, i64* %393

; 0x18bf
  store volatile i64 6335, i64* @_asm_program_counter
  br label %dec_label_pc_18dc

dec_label_pc_18c1:                                ; preds = %dec_label_pc_18dc

; 0x18c1
  store volatile i64 6337, i64* @_asm_program_counter
  %394 = load i64, i64* @rbp
  %395 = add i64 %394, -96
  %396 = inttoptr i64 %395 to i64*
  %397 = load i64, i64* %396
  store i64 %397, i64* @rax

; 0x18c5
  store volatile i64 6341, i64* @_asm_program_counter
  %398 = load i64, i64* @rax
  %399 = inttoptr i64 %398 to i32*
  %400 = load i32, i32* %399
  %401 = zext i32 %400 to i64
  store i64 %401, i64* @rax

; 0x18c7
  store volatile i64 6343, i64* @_asm_program_counter
  %402 = load i64, i64* @rax
  %403 = add i64 %402, 1
  %404 = trunc i64 %403 to i32
  %405 = zext i32 %404 to i64
  store i64 %405, i64* @rdx

; 0x18ca
  store volatile i64 6346, i64* @_asm_program_counter
  %406 = load i64, i64* @rbp
  %407 = add i64 %406, -96
  %408 = inttoptr i64 %407 to i64*
  %409 = load i64, i64* %408
  store i64 %409, i64* @rax

; 0x18ce
  store volatile i64 6350, i64* @_asm_program_counter
  %410 = load i64, i64* @rdx
  %411 = trunc i64 %410 to i32
  %412 = load i64, i64* @rax
  %413 = inttoptr i64 %412 to i32*
  store i32 %411, i32* %413

; 0x18d0
  store volatile i64 6352, i64* @_asm_program_counter
  %414 = load i64, i64* @rbp
  %415 = add i64 %414, -96
  %416 = inttoptr i64 %415 to i64*
  %417 = load i64, i64* %416
  store i64 %417, i64* @rax

; 0x18d4
  store volatile i64 6356, i64* @_asm_program_counter
  %418 = load i64, i64* @rax
  %419 = add i64 %418, 8
  %420 = inttoptr i64 %419 to i64*
  %421 = load i64, i64* %420
  store i64 %421, i64* @rax

; 0x18d8
  store volatile i64 6360, i64* @_asm_program_counter
  %422 = load i64, i64* @rax
  %423 = load i64, i64* @rbp
  %424 = add i64 %423, -96
  %425 = inttoptr i64 %424 to i64*
  store i64 %422, i64* %425
  br label %dec_label_pc_18dc

dec_label_pc_18dc:                                ; preds = %dec_label_pc_18c1, %dec_label_pc_186c

; 0x18dc
  store volatile i64 6364, i64* @_asm_program_counter
  %426 = load i64, i64* @rbp
  %427 = add i64 %426, -96
  %428 = inttoptr i64 %427 to i64*
  %429 = load i64, i64* %428
  %430 = sub i64 %429, 0
  %431 = and i64 %429, 15
  %432 = sub i64 %431, 0
  %433 = icmp ugt i64 %432, 15
  %434 = icmp ult i64 %429, 0
  %435 = xor i64 %429, 0
  %436 = xor i64 %429, %430
  %437 = and i64 %435, %436
  %438 = icmp slt i64 %437, 0
  store i1 %433, i1* @az
  store i1 %434, i1* @cf
  store i1 %438, i1* @of
  %439 = icmp eq i64 %430, 0
  store i1 %439, i1* @zf
  %440 = icmp slt i64 %430, 0
  store i1 %440, i1* @sf
  %441 = trunc i64 %430 to i8
  %442 = call i8 @llvm.ctpop.i8(i8 %441)
  %443 = and i8 %442, 1
  %444 = icmp eq i8 %443, 0
  store i1 %444, i1* @pf

; 0x18e1
  store volatile i64 6369, i64* @_asm_program_counter
  %445 = load i1, i1* @zf
  %446 = icmp eq i1 %445, false
  br i1 %446, label %dec_label_pc_18c1, label %dec_label_pc_18e3

dec_label_pc_18e3:                                ; preds = %dec_label_pc_18dc

; 0x18e3
  store volatile i64 6371, i64* @_asm_program_counter
  %447 = load i64, i64* @rbp
  %448 = add i64 %447, -88
  %449 = inttoptr i64 %448 to i64*
  %450 = load i64, i64* %449
  store i64 %450, i64* @rax

; 0x18e7
  store volatile i64 6375, i64* @_asm_program_counter
  %451 = load i64, i64* @rax
  %452 = add i64 %451, 8
  %453 = inttoptr i64 %452 to i64*
  %454 = load i64, i64* %453
  store i64 %454, i64* @rax

; 0x18eb
  store volatile i64 6379, i64* @_asm_program_counter
  %455 = load i64, i64* @rax
  store i64 %455, i64* @rdi

; 0x18ee
  store volatile i64 6382, i64* @_asm_program_counter
  %456 = call i64 @function_10a0()
  store i64 %456, i64* @rax

; 0x18f3
  store volatile i64 6387, i64* @_asm_program_counter
  %457 = load i64, i64* @rbp
  %458 = add i64 %457, -88
  %459 = inttoptr i64 %458 to i64*
  %460 = load i64, i64* %459
  store i64 %460, i64* @rax

; 0x18f7
  store volatile i64 6391, i64* @_asm_program_counter
  %461 = load i64, i64* @rax
  store i64 %461, i64* @rdi

; 0x18fa
  store volatile i64 6394, i64* @_asm_program_counter
  %462 = call i64 @function_10a0()
  store i64 %462, i64* @rax

; 0x18ff
  store volatile i64 6399, i64* @_asm_program_counter
  store i64 8349, i64* @rax

; 0x1906
  store volatile i64 6406, i64* @_asm_program_counter
  %463 = load i64, i64* @rax
  store i64 %463, i64* @rdi

; 0x1909
  store volatile i64 6409, i64* @_asm_program_counter
  %464 = call i64 @function_10b0()
  store i64 %464, i64* @rax

; 0x190e
  store volatile i64 6414, i64* @_asm_program_counter

; 0x190f
  store volatile i64 6415, i64* @_asm_program_counter
  %465 = load i64, i64* @rbp
  %466 = add i64 %465, -8
  %467 = inttoptr i64 %466 to i64*
  %468 = load i64, i64* %467
  store i64 %468, i64* @rax

; 0x1913
  store volatile i64 6419, i64* @_asm_program_counter
  %469 = load i64, i64* @rax
  %470 = call i64 @__readfsqword(i64 40)
  %471 = sub i64 %469, %470
  %472 = and i64 %469, 15
  %473 = and i64 %470, 15
  %474 = sub i64 %472, %473
  %475 = icmp ugt i64 %474, 15
  %476 = icmp ult i64 %469, %470
  %477 = xor i64 %469, %470
  %478 = xor i64 %469, %471
  %479 = and i64 %477, %478
  %480 = icmp slt i64 %479, 0
  store i1 %475, i1* @az
  store i1 %476, i1* @cf
  store i1 %480, i1* @of
  %481 = icmp eq i64 %471, 0
  store i1 %481, i1* @zf
  %482 = icmp slt i64 %471, 0
  store i1 %482, i1* @sf
  %483 = trunc i64 %471 to i8
  %484 = call i8 @llvm.ctpop.i8(i8 %483)
  %485 = and i8 %484, 1
  %486 = icmp eq i8 %485, 0
  store i1 %486, i1* @pf
  store i64 %471, i64* @rax

; 0x191c
  store volatile i64 6428, i64* @_asm_program_counter
  %487 = load i1, i1* @zf
  br i1 %487, label %dec_label_pc_1923, label %dec_label_pc_191e

dec_label_pc_191e:                                ; preds = %dec_label_pc_18e3

; 0x191e
  store volatile i64 6430, i64* @_asm_program_counter
  %488 = call i64 @function_10c0()
  store i64 %488, i64* @rax
  br label %dec_label_pc_1923

dec_label_pc_1923:                                ; preds = %dec_label_pc_191e, %dec_label_pc_18e3

; 0x1923
  store volatile i64 6435, i64* @_asm_program_counter
  %489 = load i64, i64* @rbp
  %490 = inttoptr i64 %489 to i64*
  %491 = load i64, i64* %490
  %492 = add i64 %489, 8
  store i64 %491, i64* @rbp
  store i64 %492, i64* @rsp

; 0x1924
  store volatile i64 6436, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %470, { 3, 2, 1, 0 }
  uselistorder i32 2, { 1, 2, 3, 4, 0, 5, 6, 7, 8, 9, 10, 11, 12 }
  uselistorder i64 -100, { 6, 0, 1, 2, 3, 4, 5, 7, 8, 9 }
}

define i64 @function_1925() {
dec_label_pc_1925:

; 0x1925
  store volatile i64 6437, i64* @_asm_program_counter

; 0x1929
  store volatile i64 6441, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x192a
  store volatile i64 6442, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x192d
  store volatile i64 6445, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = add i64 %5, -128
  %7 = and i64 %5, 15
  %8 = add i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %6, %5
  %11 = xor i64 %5, %6
  %12 = xor i64 -128, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1931
  store volatile i64 6449, i64* @_asm_program_counter
  %21 = call i64 @__readfsqword(i64 40)
  store i64 %21, i64* @rax

; 0x193a
  store volatile i64 6458, i64* @_asm_program_counter
  %22 = load i64, i64* @rax
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -8
  %25 = inttoptr i64 %24 to i64*
  store i64 %22, i64* %25

; 0x193e
  store volatile i64 6462, i64* @_asm_program_counter
  %26 = load i64, i64* @rax
  %27 = trunc i64 %26 to i32
  %28 = load i64, i64* @rax
  %29 = trunc i64 %28 to i32
  %30 = xor i32 %27, %29
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %31 = icmp eq i32 %30, 0
  store i1 %31, i1* @zf
  %32 = icmp slt i32 %30, 0
  store i1 %32, i1* @sf
  %33 = trunc i32 %30 to i8
  %34 = call i8 @llvm.ctpop.i8(i8 %33)
  %35 = and i8 %34, 1
  %36 = icmp eq i8 %35, 0
  store i1 %36, i1* @pf
  %37 = zext i32 %30 to i64
  store i64 %37, i64* @rax

; 0x1940
  store volatile i64 6464, i64* @_asm_program_counter
  store i64 6278066737626506568, i64* @rax

; 0x194a
  store volatile i64 6474, i64* @_asm_program_counter
  store i64 143418749551, i64* @rdx

; 0x1954
  store volatile i64 6484, i64* @_asm_program_counter
  %38 = load i64, i64* @rax
  %39 = load i64, i64* @rbp
  %40 = add i64 %39, -112
  %41 = inttoptr i64 %40 to i64*
  store i64 %38, i64* %41

; 0x1958
  store volatile i64 6488, i64* @_asm_program_counter
  %42 = load i64, i64* @rdx
  %43 = load i64, i64* @rbp
  %44 = add i64 %43, -104
  %45 = inttoptr i64 %44 to i64*
  store i64 %42, i64* %45

; 0x195c
  store volatile i64 6492, i64* @_asm_program_counter
  %46 = load i64, i64* @rbp
  %47 = add i64 %46, -96
  %48 = inttoptr i64 %47 to i64*
  store i64 0, i64* %48

; 0x1964
  store volatile i64 6500, i64* @_asm_program_counter
  %49 = load i64, i64* @rbp
  %50 = add i64 %49, -88
  %51 = inttoptr i64 %50 to i64*
  store i64 0, i64* %51

; 0x196c
  store volatile i64 6508, i64* @_asm_program_counter
  %52 = load i64, i64* @rbp
  %53 = add i64 %52, -116
  %54 = inttoptr i64 %53 to i32*
  store i32 0, i32* %54

; 0x1973
  store volatile i64 6515, i64* @_asm_program_counter
  br label %dec_label_pc_198c

dec_label_pc_1975:                                ; preds = %dec_label_pc_198c

; 0x1975
  store volatile i64 6517, i64* @_asm_program_counter
  %55 = load i64, i64* @rbp
  %56 = add i64 %55, -116
  %57 = inttoptr i64 %56 to i32*
  %58 = load i32, i32* %57
  %59 = zext i32 %58 to i64
  store i64 %59, i64* @rax

; 0x1978
  store volatile i64 6520, i64* @_asm_program_counter
  %60 = load i64, i64* @rax
  %61 = trunc i64 %60 to i32
  %62 = sext i32 %61 to i64
  store i64 %62, i64* @rax

; 0x197a
  store volatile i64 6522, i64* @_asm_program_counter
  %63 = load i64, i64* @rbp
  %64 = load i64, i64* @rax
  %65 = mul i64 %64, 1
  %66 = add i64 %63, -112
  %67 = add i64 %66, %65
  %68 = inttoptr i64 %67 to i8*
  %69 = load i8, i8* %68
  %70 = zext i8 %69 to i64
  store i64 %70, i64* @rdx

; 0x197f
  store volatile i64 6527, i64* @_asm_program_counter
  %71 = load i64, i64* @rbp
  %72 = add i64 %71, -116
  %73 = inttoptr i64 %72 to i32*
  %74 = load i32, i32* %73
  %75 = zext i32 %74 to i64
  store i64 %75, i64* @rax

; 0x1982
  store volatile i64 6530, i64* @_asm_program_counter
  %76 = load i64, i64* @rax
  %77 = trunc i64 %76 to i32
  %78 = sext i32 %77 to i64
  store i64 %78, i64* @rax

; 0x1984
  store volatile i64 6532, i64* @_asm_program_counter
  %79 = load i64, i64* @rdx
  %80 = trunc i64 %79 to i8
  %81 = load i64, i64* @rbp
  %82 = load i64, i64* @rax
  %83 = mul i64 %82, 1
  %84 = add i64 %81, -80
  %85 = add i64 %84, %83
  %86 = inttoptr i64 %85 to i8*
  store i8 %80, i8* %86

; 0x1988
  store volatile i64 6536, i64* @_asm_program_counter
  %87 = load i64, i64* @rbp
  %88 = add i64 %87, -116
  %89 = inttoptr i64 %88 to i32*
  %90 = load i32, i32* %89
  %91 = add i32 %90, 1
  %92 = and i32 %90, 15
  %93 = add i32 %92, 1
  %94 = icmp ugt i32 %93, 15
  %95 = icmp ult i32 %91, %90
  %96 = xor i32 %90, %91
  %97 = xor i32 1, %91
  %98 = and i32 %96, %97
  %99 = icmp slt i32 %98, 0
  store i1 %94, i1* @az
  store i1 %95, i1* @cf
  store i1 %99, i1* @of
  %100 = icmp eq i32 %91, 0
  store i1 %100, i1* @zf
  %101 = icmp slt i32 %91, 0
  store i1 %101, i1* @sf
  %102 = trunc i32 %91 to i8
  %103 = call i8 @llvm.ctpop.i8(i8 %102)
  %104 = and i8 %103, 1
  %105 = icmp eq i8 %104, 0
  store i1 %105, i1* @pf
  %106 = load i64, i64* @rbp
  %107 = add i64 %106, -116
  %108 = inttoptr i64 %107 to i32*
  store i32 %91, i32* %108
  br label %dec_label_pc_198c

dec_label_pc_198c:                                ; preds = %dec_label_pc_1975, %dec_label_pc_1925

; 0x198c
  store volatile i64 6540, i64* @_asm_program_counter
  %109 = load i64, i64* @rbp
  %110 = add i64 %109, -116
  %111 = inttoptr i64 %110 to i32*
  %112 = load i32, i32* %111
  %113 = sub i32 %112, 13
  %114 = and i32 %112, 15
  %115 = sub i32 %114, 13
  %116 = icmp ugt i32 %115, 15
  %117 = icmp ult i32 %112, 13
  %118 = xor i32 %112, 13
  %119 = xor i32 %112, %113
  %120 = and i32 %118, %119
  %121 = icmp slt i32 %120, 0
  store i1 %116, i1* @az
  store i1 %117, i1* @cf
  store i1 %121, i1* @of
  %122 = icmp eq i32 %113, 0
  store i1 %122, i1* @zf
  %123 = icmp slt i32 %113, 0
  store i1 %123, i1* @sf
  %124 = trunc i32 %113 to i8
  %125 = call i8 @llvm.ctpop.i8(i8 %124)
  %126 = and i8 %125, 1
  %127 = icmp eq i8 %126, 0
  store i1 %127, i1* @pf

; 0x1990
  store volatile i64 6544, i64* @_asm_program_counter
  %128 = load i1, i1* @zf
  %129 = load i1, i1* @sf
  %130 = load i1, i1* @of
  %131 = icmp ne i1 %129, %130
  %132 = or i1 %128, %131
  br i1 %132, label %dec_label_pc_1975, label %dec_label_pc_1992

dec_label_pc_1992:                                ; preds = %dec_label_pc_198c

; 0x1992
  store volatile i64 6546, i64* @_asm_program_counter
  %133 = load i64, i64* @rbp
  %134 = add i64 %133, -112
  store i64 %134, i64* @rcx

; 0x1996
  store volatile i64 6550, i64* @_asm_program_counter
  %135 = load i64, i64* @rbp
  %136 = add i64 %135, -48
  store i64 %136, i64* @rax

; 0x199a
  store volatile i64 6554, i64* @_asm_program_counter
  store i64 14, i64* @rdx

; 0x199f
  store volatile i64 6559, i64* @_asm_program_counter
  %137 = load i64, i64* @rcx
  store i64 %137, i64* @rsi

; 0x19a2
  store volatile i64 6562, i64* @_asm_program_counter
  %138 = load i64, i64* @rax
  store i64 %138, i64* @rdi

; 0x19a5
  store volatile i64 6565, i64* @_asm_program_counter
  %139 = call i64 @function_10e0()
  store i64 %139, i64* @rax

; 0x19aa
  store volatile i64 6570, i64* @_asm_program_counter
  %140 = load i64, i64* @rbp
  %141 = add i64 %140, -80
  store i64 %141, i64* @rax

; 0x19ae
  store volatile i64 6574, i64* @_asm_program_counter
  %142 = load i64, i64* @rax
  store i64 %142, i64* @rsi

; 0x19b1
  store volatile i64 6577, i64* @_asm_program_counter
  store i64 8363, i64* @rax

; 0x19b8
  store volatile i64 6584, i64* @_asm_program_counter
  %143 = load i64, i64* @rax
  store i64 %143, i64* @rdi

; 0x19bb
  store volatile i64 6587, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x19c0
  store volatile i64 6592, i64* @_asm_program_counter
  %144 = call i64 @function_10d0()
  store i64 %144, i64* @rax

; 0x19c5
  store volatile i64 6597, i64* @_asm_program_counter

; 0x19c6
  store volatile i64 6598, i64* @_asm_program_counter
  %145 = load i64, i64* @rbp
  %146 = add i64 %145, -8
  %147 = inttoptr i64 %146 to i64*
  %148 = load i64, i64* %147
  store i64 %148, i64* @rax

; 0x19ca
  store volatile i64 6602, i64* @_asm_program_counter
  %149 = load i64, i64* @rax
  %150 = call i64 @__readfsqword(i64 40)
  %151 = sub i64 %149, %150
  %152 = and i64 %149, 15
  %153 = and i64 %150, 15
  %154 = sub i64 %152, %153
  %155 = icmp ugt i64 %154, 15
  %156 = icmp ult i64 %149, %150
  %157 = xor i64 %149, %150
  %158 = xor i64 %149, %151
  %159 = and i64 %157, %158
  %160 = icmp slt i64 %159, 0
  store i1 %155, i1* @az
  store i1 %156, i1* @cf
  store i1 %160, i1* @of
  %161 = icmp eq i64 %151, 0
  store i1 %161, i1* @zf
  %162 = icmp slt i64 %151, 0
  store i1 %162, i1* @sf
  %163 = trunc i64 %151 to i8
  %164 = call i8 @llvm.ctpop.i8(i8 %163)
  %165 = and i8 %164, 1
  %166 = icmp eq i8 %165, 0
  store i1 %166, i1* @pf
  store i64 %151, i64* @rax

; 0x19d3
  store volatile i64 6611, i64* @_asm_program_counter
  %167 = load i1, i1* @zf
  br i1 %167, label %dec_label_pc_19da, label %dec_label_pc_19d5

dec_label_pc_19d5:                                ; preds = %dec_label_pc_1992

; 0x19d5
  store volatile i64 6613, i64* @_asm_program_counter
  %168 = call i64 @function_10c0()
  store i64 %168, i64* @rax
  br label %dec_label_pc_19da

dec_label_pc_19da:                                ; preds = %dec_label_pc_19d5, %dec_label_pc_1992

; 0x19da
  store volatile i64 6618, i64* @_asm_program_counter
  %169 = load i64, i64* @rbp
  %170 = inttoptr i64 %169 to i64*
  %171 = load i64, i64* %170
  %172 = add i64 %169, 8
  store i64 %171, i64* @rbp
  store i64 %172, i64* @rsp

; 0x19db
  store volatile i64 6619, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %150, { 3, 2, 1, 0 }
  uselistorder i64 -80, { 1, 0, 2, 3, 4, 5, 6, 7 }
  uselistorder i64 -116, { 4, 0, 1, 2, 3, 5 }
  uselistorder i64 -96, { 0, 5, 1, 2, 3, 4, 6, 7, 8 }
  uselistorder i64 -112, { 1, 0, 2 }
  uselistorder i64* @rdx, { 2, 0, 1, 3, 4, 5, 6, 18, 19, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 }
}

define i64 @function_19dc() {
dec_label_pc_19dc:

; 0x19dc
  store volatile i64 6620, i64* @_asm_program_counter

; 0x19e0
  store volatile i64 6624, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x19e1
  store volatile i64 6625, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x19e4
  store volatile i64 6628, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 48
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 48
  %11 = xor i64 %5, 48
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x19e8
  store volatile i64 6632, i64* @_asm_program_counter
  %21 = load i64, i64* @rdi
  %22 = trunc i64 %21 to i32
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -36
  %25 = inttoptr i64 %24 to i32*
  store i32 %22, i32* %25

; 0x19eb
  store volatile i64 6635, i64* @_asm_program_counter
  %26 = call i64 @__readfsqword(i64 40)
  store i64 %26, i64* @rax

; 0x19f4
  store volatile i64 6644, i64* @_asm_program_counter
  %27 = load i64, i64* @rax
  %28 = load i64, i64* @rbp
  %29 = add i64 %28, -8
  %30 = inttoptr i64 %29 to i64*
  store i64 %27, i64* %30

; 0x19f8
  store volatile i64 6648, i64* @_asm_program_counter
  %31 = load i64, i64* @rax
  %32 = trunc i64 %31 to i32
  %33 = load i64, i64* @rax
  %34 = trunc i64 %33 to i32
  %35 = xor i32 %32, %34
  store i1 false, i1* @az
  store i1 false, i1* @cf
  store i1 false, i1* @of
  %36 = icmp eq i32 %35, 0
  store i1 %36, i1* @zf
  %37 = icmp slt i32 %35, 0
  store i1 %37, i1* @sf
  %38 = trunc i32 %35 to i8
  %39 = call i8 @llvm.ctpop.i8(i8 %38)
  %40 = and i8 %39, 1
  %41 = icmp eq i8 %40, 0
  store i1 %41, i1* @pf
  %42 = zext i32 %35 to i64
  store i64 %42, i64* @rax

; 0x19fa
  store volatile i64 6650, i64* @_asm_program_counter
  %43 = load i64, i64* @rbp
  %44 = add i64 %43, -28
  %45 = inttoptr i64 %44 to i32*
  store i32 10, i32* %45

; 0x1a01
  store volatile i64 6657, i64* @_asm_program_counter
  %46 = load i64, i64* @rbp
  %47 = add i64 %46, -24
  %48 = inttoptr i64 %47 to i32*
  store i32 20, i32* %48

; 0x1a08
  store volatile i64 6664, i64* @_asm_program_counter
  %49 = load i64, i64* @rbp
  %50 = add i64 %49, -36
  %51 = inttoptr i64 %50 to i32*
  %52 = load i32, i32* %51
  %53 = sub i32 %52, 0
  %54 = and i32 %52, 15
  %55 = sub i32 %54, 0
  %56 = icmp ugt i32 %55, 15
  %57 = icmp ult i32 %52, 0
  %58 = xor i32 %52, 0
  %59 = xor i32 %52, %53
  %60 = and i32 %58, %59
  %61 = icmp slt i32 %60, 0
  store i1 %56, i1* @az
  store i1 %57, i1* @cf
  store i1 %61, i1* @of
  %62 = icmp eq i32 %53, 0
  store i1 %62, i1* @zf
  %63 = icmp slt i32 %53, 0
  store i1 %63, i1* @sf
  %64 = trunc i32 %53 to i8
  %65 = call i8 @llvm.ctpop.i8(i8 %64)
  %66 = and i8 %65, 1
  %67 = icmp eq i8 %66, 0
  store i1 %67, i1* @pf

; 0x1a0c
  store volatile i64 6668, i64* @_asm_program_counter
  %68 = load i1, i1* @zf
  %69 = load i1, i1* @sf
  %70 = load i1, i1* @of
  %71 = icmp ne i1 %69, %70
  %72 = or i1 %68, %71
  br i1 %72, label %dec_label_pc_1a16, label %dec_label_pc_1a0e

dec_label_pc_1a0e:                                ; preds = %dec_label_pc_19dc

; 0x1a0e
  store volatile i64 6670, i64* @_asm_program_counter
  %73 = load i64, i64* @rbp
  %74 = add i64 %73, -28
  %75 = inttoptr i64 %74 to i32*
  %76 = load i32, i32* %75
  %77 = zext i32 %76 to i64
  store i64 %77, i64* @rax

; 0x1a11
  store volatile i64 6673, i64* @_asm_program_counter
  %78 = load i64, i64* @rax
  %79 = trunc i64 %78 to i32
  %80 = load i64, i64* @rbp
  %81 = add i64 %80, -20
  %82 = inttoptr i64 %81 to i32*
  store i32 %79, i32* %82

; 0x1a14
  store volatile i64 6676, i64* @_asm_program_counter
  br label %dec_label_pc_1a1c

dec_label_pc_1a16:                                ; preds = %dec_label_pc_19dc

; 0x1a16
  store volatile i64 6678, i64* @_asm_program_counter
  %83 = load i64, i64* @rbp
  %84 = add i64 %83, -24
  %85 = inttoptr i64 %84 to i32*
  %86 = load i32, i32* %85
  %87 = zext i32 %86 to i64
  store i64 %87, i64* @rax

; 0x1a19
  store volatile i64 6681, i64* @_asm_program_counter
  %88 = load i64, i64* @rax
  %89 = trunc i64 %88 to i32
  %90 = load i64, i64* @rbp
  %91 = add i64 %90, -20
  %92 = inttoptr i64 %91 to i32*
  store i32 %89, i32* %92
  br label %dec_label_pc_1a1c

dec_label_pc_1a1c:                                ; preds = %dec_label_pc_1a16, %dec_label_pc_1a0e

; 0x1a1c
  store volatile i64 6684, i64* @_asm_program_counter
  %93 = load i64, i64* @rbp
  %94 = add i64 %93, -16
  %95 = inttoptr i64 %94 to i64*
  store i64 0, i64* %95

; 0x1a24
  store volatile i64 6692, i64* @_asm_program_counter
  %96 = load i64, i64* @rbp
  %97 = add i64 %96, -36
  %98 = inttoptr i64 %97 to i32*
  %99 = load i32, i32* %98
  %100 = sub i32 %99, 0
  %101 = and i32 %99, 15
  %102 = sub i32 %101, 0
  %103 = icmp ugt i32 %102, 15
  %104 = icmp ult i32 %99, 0
  %105 = xor i32 %99, 0
  %106 = xor i32 %99, %100
  %107 = and i32 %105, %106
  %108 = icmp slt i32 %107, 0
  store i1 %103, i1* @az
  store i1 %104, i1* @cf
  store i1 %108, i1* @of
  %109 = icmp eq i32 %100, 0
  store i1 %109, i1* @zf
  %110 = icmp slt i32 %100, 0
  store i1 %110, i1* @sf
  %111 = trunc i32 %100 to i8
  %112 = call i8 @llvm.ctpop.i8(i8 %111)
  %113 = and i8 %112, 1
  %114 = icmp eq i8 %113, 0
  store i1 %114, i1* @pf

; 0x1a28
  store volatile i64 6696, i64* @_asm_program_counter
  %115 = load i1, i1* @zf
  br i1 %115, label %dec_label_pc_1a34, label %dec_label_pc_1a2a

dec_label_pc_1a2a:                                ; preds = %dec_label_pc_1a1c

; 0x1a2a
  store volatile i64 6698, i64* @_asm_program_counter
  %116 = load i64, i64* @rbp
  %117 = add i64 %116, -28
  store i64 %117, i64* @rax

; 0x1a2e
  store volatile i64 6702, i64* @_asm_program_counter
  %118 = load i64, i64* @rax
  %119 = load i64, i64* @rbp
  %120 = add i64 %119, -16
  %121 = inttoptr i64 %120 to i64*
  store i64 %118, i64* %121

; 0x1a32
  store volatile i64 6706, i64* @_asm_program_counter
  br label %dec_label_pc_1a3c

dec_label_pc_1a34:                                ; preds = %dec_label_pc_1a1c

; 0x1a34
  store volatile i64 6708, i64* @_asm_program_counter
  %122 = load i64, i64* @rbp
  %123 = add i64 %122, -24
  store i64 %123, i64* @rax

; 0x1a38
  store volatile i64 6712, i64* @_asm_program_counter
  %124 = load i64, i64* @rax
  %125 = load i64, i64* @rbp
  %126 = add i64 %125, -16
  %127 = inttoptr i64 %126 to i64*
  store i64 %124, i64* %127
  br label %dec_label_pc_1a3c

dec_label_pc_1a3c:                                ; preds = %dec_label_pc_1a34, %dec_label_pc_1a2a

; 0x1a3c
  store volatile i64 6716, i64* @_asm_program_counter
  %128 = load i64, i64* @rbp
  %129 = add i64 %128, -16
  %130 = inttoptr i64 %129 to i64*
  %131 = load i64, i64* %130
  store i64 %131, i64* @rax

; 0x1a40
  store volatile i64 6720, i64* @_asm_program_counter
  %132 = load i64, i64* @rax
  %133 = inttoptr i64 %132 to i32*
  store i32 100, i32* %133

; 0x1a46
  store volatile i64 6726, i64* @_asm_program_counter
  %134 = load i64, i64* @rbp
  %135 = add i64 %134, -20
  %136 = inttoptr i64 %135 to i32*
  %137 = load i32, i32* %136
  %138 = zext i32 %137 to i64
  store i64 %138, i64* @rax

; 0x1a49
  store volatile i64 6729, i64* @_asm_program_counter
  %139 = load i64, i64* @rax
  %140 = trunc i64 %139 to i32
  %141 = zext i32 %140 to i64
  store i64 %141, i64* @rsi

; 0x1a4b
  store volatile i64 6731, i64* @_asm_program_counter
  store i64 8373, i64* @rax

; 0x1a52
  store volatile i64 6738, i64* @_asm_program_counter
  %142 = load i64, i64* @rax
  store i64 %142, i64* @rdi

; 0x1a55
  store volatile i64 6741, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x1a5a
  store volatile i64 6746, i64* @_asm_program_counter
  %143 = call i64 @function_10d0()
  store i64 %143, i64* @rax

; 0x1a5f
  store volatile i64 6751, i64* @_asm_program_counter

; 0x1a60
  store volatile i64 6752, i64* @_asm_program_counter
  %144 = load i64, i64* @rbp
  %145 = add i64 %144, -8
  %146 = inttoptr i64 %145 to i64*
  %147 = load i64, i64* %146
  store i64 %147, i64* @rax

; 0x1a64
  store volatile i64 6756, i64* @_asm_program_counter
  %148 = load i64, i64* @rax
  %149 = call i64 @__readfsqword(i64 40)
  %150 = sub i64 %148, %149
  %151 = and i64 %148, 15
  %152 = and i64 %149, 15
  %153 = sub i64 %151, %152
  %154 = icmp ugt i64 %153, 15
  %155 = icmp ult i64 %148, %149
  %156 = xor i64 %148, %149
  %157 = xor i64 %148, %150
  %158 = and i64 %156, %157
  %159 = icmp slt i64 %158, 0
  store i1 %154, i1* @az
  store i1 %155, i1* @cf
  store i1 %159, i1* @of
  %160 = icmp eq i64 %150, 0
  store i1 %160, i1* @zf
  %161 = icmp slt i64 %150, 0
  store i1 %161, i1* @sf
  %162 = trunc i64 %150 to i8
  %163 = call i8 @llvm.ctpop.i8(i8 %162)
  %164 = and i8 %163, 1
  %165 = icmp eq i8 %164, 0
  store i1 %165, i1* @pf
  store i64 %150, i64* @rax

; 0x1a6d
  store volatile i64 6765, i64* @_asm_program_counter
  %166 = load i1, i1* @zf
  br i1 %166, label %dec_label_pc_1a74, label %dec_label_pc_1a6f

dec_label_pc_1a6f:                                ; preds = %dec_label_pc_1a3c

; 0x1a6f
  store volatile i64 6767, i64* @_asm_program_counter
  %167 = call i64 @function_10c0()
  store i64 %167, i64* @rax
  br label %dec_label_pc_1a74

dec_label_pc_1a74:                                ; preds = %dec_label_pc_1a6f, %dec_label_pc_1a3c

; 0x1a74
  store volatile i64 6772, i64* @_asm_program_counter
  %168 = load i64, i64* @rbp
  %169 = inttoptr i64 %168 to i64*
  %170 = load i64, i64* %169
  %171 = add i64 %168, 8
  store i64 %170, i64* @rbp
  store i64 %171, i64* @rsp

; 0x1a75
  store volatile i64 6773, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i64 %149, { 3, 2, 1, 0 }
}

define i64 @function_1a76() {
dec_label_pc_1a76:

; 0x1a76
  store volatile i64 6774, i64* @_asm_program_counter

; 0x1a7a
  store volatile i64 6778, i64* @_asm_program_counter
  %0 = load i64, i64* @rbp
  %1 = load i64, i64* @rsp
  %2 = sub i64 %1, 8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3
  store i64 %2, i64* @rsp

; 0x1a7b
  store volatile i64 6779, i64* @_asm_program_counter
  %4 = load i64, i64* @rsp
  store i64 %4, i64* @rbp

; 0x1a7e
  store volatile i64 6782, i64* @_asm_program_counter
  %5 = load i64, i64* @rsp
  %6 = sub i64 %5, 16
  %7 = and i64 %5, 15
  %8 = sub i64 %7, 0
  %9 = icmp ugt i64 %8, 15
  %10 = icmp ult i64 %5, 16
  %11 = xor i64 %5, 16
  %12 = xor i64 %5, %6
  %13 = and i64 %11, %12
  %14 = icmp slt i64 %13, 0
  store i1 %9, i1* @az
  store i1 %10, i1* @cf
  store i1 %14, i1* @of
  %15 = icmp eq i64 %6, 0
  store i1 %15, i1* @zf
  %16 = icmp slt i64 %6, 0
  store i1 %16, i1* @sf
  %17 = trunc i64 %6 to i8
  %18 = call i8 @llvm.ctpop.i8(i8 %17)
  %19 = and i8 %18, 1
  %20 = icmp eq i8 %19, 0
  store i1 %20, i1* @pf
  store i64 %6, i64* @rsp

; 0x1a82
  store volatile i64 6786, i64* @_asm_program_counter
  %21 = load i64, i64* @rdi
  %22 = trunc i64 %21 to i32
  %23 = load i64, i64* @rbp
  %24 = add i64 %23, -4
  %25 = inttoptr i64 %24 to i32*
  store i32 %22, i32* %25

; 0x1a85
  store volatile i64 6789, i64* @_asm_program_counter
  %26 = load i64, i64* @rsi
  %27 = load i64, i64* @rbp
  %28 = add i64 %27, -16
  %29 = inttoptr i64 %28 to i64*
  store i64 %26, i64* %29

; 0x1a89
  store volatile i64 6793, i64* @_asm_program_counter
  store i64 8390, i64* @rax

; 0x1a90
  store volatile i64 6800, i64* @_asm_program_counter
  %30 = load i64, i64* @rax
  store i64 %30, i64* @rdi

; 0x1a93
  store volatile i64 6803, i64* @_asm_program_counter
  %31 = call i64 @function_10b0()
  store i64 %31, i64* @rax

; 0x1a98
  store volatile i64 6808, i64* @_asm_program_counter
  %32 = call i64 @function_126d()
  store i64 %32, i64* @rax

; 0x1a9d
  store volatile i64 6813, i64* @_asm_program_counter
  %33 = call i64 @function_12c4()
  store i64 %33, i64* @rax

; 0x1aa2
  store volatile i64 6818, i64* @_asm_program_counter
  %34 = call i64 @function_1331()
  store i64 %34, i64* @rax

; 0x1aa7
  store volatile i64 6823, i64* @_asm_program_counter
  %35 = call i64 @function_1446()
  store i64 %35, i64* @rax

; 0x1aac
  store volatile i64 6828, i64* @_asm_program_counter
  %36 = call i64 @function_153c()
  store i64 %36, i64* @rax

; 0x1ab1
  store volatile i64 6833, i64* @_asm_program_counter
  %37 = call i64 @function_15f6()
  store i64 %37, i64* @rax

; 0x1ab6
  store volatile i64 6838, i64* @_asm_program_counter
  %38 = call i64 @function_1727()
  store i64 %38, i64* @rax

; 0x1abb
  store volatile i64 6843, i64* @_asm_program_counter
  %39 = call i64 @function_17f5()
  store i64 %39, i64* @rax

; 0x1ac0
  store volatile i64 6848, i64* @_asm_program_counter
  %40 = call i64 @function_1925()
  store i64 %40, i64* @rax

; 0x1ac5
  store volatile i64 6853, i64* @_asm_program_counter
  %41 = load i64, i64* @rbp
  %42 = add i64 %41, -4
  %43 = inttoptr i64 %42 to i32*
  %44 = load i32, i32* %43
  %45 = sub i32 %44, 1
  %46 = and i32 %44, 15
  %47 = sub i32 %46, 1
  %48 = icmp ugt i32 %47, 15
  %49 = icmp ult i32 %44, 1
  %50 = xor i32 %44, 1
  %51 = xor i32 %44, %45
  %52 = and i32 %50, %51
  %53 = icmp slt i32 %52, 0
  store i1 %48, i1* @az
  store i1 %49, i1* @cf
  store i1 %53, i1* @of
  %54 = icmp eq i32 %45, 0
  store i1 %54, i1* @zf
  %55 = icmp slt i32 %45, 0
  store i1 %55, i1* @sf
  %56 = trunc i32 %45 to i8
  %57 = call i8 @llvm.ctpop.i8(i8 %56)
  %58 = and i8 %57, 1
  %59 = icmp eq i8 %58, 0
  store i1 %59, i1* @pf

; 0x1ac9
  store volatile i64 6857, i64* @_asm_program_counter
  %60 = load i1, i1* @zf
  %61 = load i1, i1* @sf
  %62 = load i1, i1* @of
  %63 = icmp eq i1 %61, %62
  %64 = icmp eq i1 %60, false
  %65 = and i1 %63, %64
  %66 = zext i1 %65 to i8
  %67 = zext i8 %66 to i64
  %68 = load i64, i64* @rax
  %69 = and i64 %68, -256
  %70 = or i64 %69, %67
  store i64 %70, i64* @rax

; 0x1acc
  store volatile i64 6860, i64* @_asm_program_counter
  %71 = load i64, i64* @rax
  %72 = trunc i64 %71 to i8
  %73 = zext i8 %72 to i64
  store i64 %73, i64* @rax

; 0x1acf
  store volatile i64 6863, i64* @_asm_program_counter
  %74 = load i64, i64* @rax
  %75 = trunc i64 %74 to i32
  %76 = zext i32 %75 to i64
  store i64 %76, i64* @rdi

; 0x1ad1
  store volatile i64 6865, i64* @_asm_program_counter
  %77 = call i64 @function_19dc()
  store i64 %77, i64* @rax

; 0x1ad6
  store volatile i64 6870, i64* @_asm_program_counter
  store i64 8417, i64* @rax

; 0x1add
  store volatile i64 6877, i64* @_asm_program_counter
  %78 = load i64, i64* @rax
  store i64 %78, i64* @rdi

; 0x1ae0
  store volatile i64 6880, i64* @_asm_program_counter
  %79 = call i64 @function_10b0()
  store i64 %79, i64* @rax

; 0x1ae5
  store volatile i64 6885, i64* @_asm_program_counter
  store i64 0, i64* @rax

; 0x1aea
  store volatile i64 6890, i64* @_asm_program_counter
  %80 = load i64, i64* @rbp
  %81 = inttoptr i64 %80 to i64*
  %82 = load i64, i64* %81
  %83 = add i64 %80, 8
  store i64 %82, i64* @rbp
  store i64 %83, i64* @rsp

; 0x1aeb
  store volatile i64 6891, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i32 0, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 22, 23, 24, 19, 20, 21, 25, 26, 27, 39, 40, 41, 42, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111 }
  uselistorder i32 15, { 0, 1, 2, 3, 4, 5, 8, 9, 6, 7, 18, 19, 10, 11, 12, 13, 14, 15, 16, 17, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53 }
  uselistorder i32 1, { 0, 1, 2, 3, 4, 5, 6, 11, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
  uselistorder i64* @rax, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 47, 48, 49, 50, 51, 52, 53, 54, 68, 69, 70, 71, 72, 73, 74, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 508, 509, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507 }
  uselistorder i64* @rbp, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 37, 38, 39, 40, 41, 31, 32, 33, 34, 35, 36, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 56, 57, 58, 59, 52, 53, 54, 55, 68, 69, 70, 71, 72, 73, 74, 75, 60, 61, 62, 63, 64, 65, 66, 67, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276 }
}

define i64 @function_1aec() {
dec_label_pc_1aec:

; 0x1aec
  store volatile i64 6892, i64* @_asm_program_counter

; 0x1af0
  store volatile i64 6896, i64* @_asm_program_counter
  %0 = load i64, i64* @rsp
  %1 = sub i64 %0, 8
  %2 = and i64 %0, 15
  %3 = sub i64 %2, 8
  %4 = icmp ugt i64 %3, 15
  %5 = icmp ult i64 %0, 8
  %6 = xor i64 %0, 8
  %7 = xor i64 %0, %1
  %8 = and i64 %6, %7
  %9 = icmp slt i64 %8, 0
  store i1 %4, i1* @az
  store i1 %5, i1* @cf
  store i1 %9, i1* @of
  %10 = icmp eq i64 %1, 0
  store i1 %10, i1* @zf
  %11 = icmp slt i64 %1, 0
  store i1 %11, i1* @sf
  %12 = trunc i64 %1 to i8
  %13 = call i8 @llvm.ctpop.i8(i8 %12)
  %14 = and i8 %13, 1
  %15 = icmp eq i8 %14, 0
  store i1 %15, i1* @pf
  store i64 %1, i64* @rsp

; 0x1af4
  store volatile i64 6900, i64* @_asm_program_counter
  %16 = load i64, i64* @rsp
  %17 = add i64 %16, 8
  %18 = and i64 %16, 15
  %19 = add i64 %18, 8
  %20 = icmp ugt i64 %19, 15
  %21 = icmp ult i64 %17, %16
  %22 = xor i64 %16, %17
  %23 = xor i64 8, %17
  %24 = and i64 %22, %23
  %25 = icmp slt i64 %24, 0
  store i1 %20, i1* @az
  store i1 %21, i1* @cf
  store i1 %25, i1* @of
  %26 = icmp eq i64 %17, 0
  store i1 %26, i1* @zf
  %27 = icmp slt i64 %17, 0
  store i1 %27, i1* @sf
  %28 = trunc i64 %17 to i8
  %29 = call i8 @llvm.ctpop.i8(i8 %28)
  %30 = and i8 %29, 1
  %31 = icmp eq i8 %30, 0
  store i1 %31, i1* @pf
  store i64 %17, i64* @rsp

; 0x1af8
  store volatile i64 6904, i64* @_asm_program_counter
  ret i64 undef

; uselistorder directives
  uselistorder i1* @pf, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 29, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 92, 93, 94, 95, 89, 90, 91 }
  uselistorder i8 0, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 29, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 100, 101, 102, 103, 97, 98, 99 }
  uselistorder i8 1, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 29, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 93, 94, 95, 96, 90, 91, 92 }
  uselistorder i8 (i8)* @llvm.ctpop.i8, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 29, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 92, 93, 94, 95, 89, 90, 91 }
  uselistorder i1* @sf, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 11, 15, 16, 17, 18, 32, 33, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 96, 97, 98, 99, 93, 94, 95 }
  uselistorder i1* @zf, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 13, 18, 19, 20, 21, 22, 23, 37, 38, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 113, 114, 115, 116, 109, 110, 111, 112 }
  uselistorder i1* @of, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 11, 15, 16, 17, 18, 35, 36, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 110, 111, 112, 113, 107, 108, 109 }
  uselistorder i1* @cf, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 29, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 93, 94, 95, 96, 90, 91, 92 }
  uselistorder i1 false, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 52, 53, 54, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102 }
  uselistorder i1* @az, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 9, 12, 13, 14, 15, 26, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 79, 80, 81, 82, 76, 77, 78 }
  uselistorder i64 8, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 63, 64, 65, 56, 57, 58, 59, 60, 61, 62 }
  uselistorder i64* @rsp, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 102, 103, 104, 105 }
  uselistorder i64 0, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 65, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 203, 204, 195, 196, 197, 198, 199, 200, 201, 202, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273 }
  uselistorder i64* @_asm_program_counter, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 75, 76, 77, 78, 79, 80, 81, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 118, 119, 120, 121, 122, 123, 124, 125, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656 }
}

declare i64 @free()

declare i64 @puts()

declare i64 @__stack_chk_fail()

declare i64 @printf()

declare i64 @memcpy()

declare i64 @malloc()

declare i64 @__libc_start_main()

declare i64 @_ITM_deregisterTMCloneTable()

declare i64 @__gmon_start__()

declare i64 @_ITM_registerTMCloneTable()

declare i64 @__cxa_finalize()

declare void @__pseudo_call(i64)

declare void @__pseudo_return(i64)

declare void @__pseudo_branch(i64)

declare void @__pseudo_cond_branch(i1, i64)

declare void @__frontend_reg_store.fpr(i3, x86_fp80)

declare x86_fp80 @__frontend_reg_load.fpr(i3)

; Function Attrs: nounwind readnone speculatable
declare i8 @llvm.ctpop.i8(i8) #0

declare void @__asm_hlt()

declare i64 @__readfsqword(i64)

attributes #0 = { nounwind readnone speculatable }

!0 = !{!"indirect_call"}
!1 = !{i64 %53}
!2 = !{i64 %61}
!3 = !{i64 %82}
!4 = !{i64 %90}
!5 = !{i64 %107}
