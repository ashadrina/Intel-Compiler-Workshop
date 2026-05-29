	.file	"multiply.c"
	.file	1 "/nfs/site/home/ashadrin/demo_materials/icx_demo/Intel-Compiler-Workshop/lab4/c/03-restrict" "multiply.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function matvec
.LCPI0_0:
	.quad	2                               # 0x2
	.quad	3                               # 0x3
	.quad	4                               # 0x4
	.quad	5                               # 0x5
	.text
	.globl	matvec
	.p2align	4
	.type	matvec,@function
matvec:                                 # 
.Lfunc_begin0:
	.loc	1 19 0                          # multiply.c:19:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: matvec:rows <- $edi
	#DEBUG_VALUE: matvec:cols <- $esi
	#DEBUG_VALUE: matvec:a <- $rdx
	#DEBUG_VALUE: matvec:b <- $rcx
	#DEBUG_VALUE: matvec:x <- $r8
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$328, %rsp                      # imm = 0x148
	.cfi_def_cfa_offset 384
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdx, -128(%rsp)                # 8-byte Spill
.Ltmp0:
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
                                        # kill: def $edi killed $edi def $rdi
	#DEBUG_VALUE: matvec:i <- 0
	.loc	1 31 19 prologue_end            # multiply.c:31:19
	testl	%edi, %edi
.Ltmp1:
	.loc	1 31 5 is_stmt 0                # multiply.c:31:5
	je	.LBB0_45
.Ltmp2:
# %bb.1:
	#DEBUG_VALUE: matvec:rows <- $edi
	#DEBUG_VALUE: matvec:cols <- $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- $rcx
	#DEBUG_VALUE: matvec:x <- $r8
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	testl	%esi, %esi
.Ltmp3:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	je	.LBB0_45
.Ltmp4:
# %bb.2:
	#DEBUG_VALUE: matvec:rows <- $edi
	#DEBUG_VALUE: matvec:cols <- $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- $rcx
	#DEBUG_VALUE: matvec:x <- $r8
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9                           # multiply.c:0:9
	movl	%esi, %r10d
	.loc	1 31 19 is_stmt 1               # multiply.c:31:19
	movslq	%edi, %rax
.Ltmp5:
	.loc	1 32 23                         # multiply.c:32:23
	movslq	%esi, %rbx
.Ltmp6:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	cmpl	$385, %edi                      # imm = 0x181
	movq	%r8, -88(%rsp)                  # 8-byte Spill
.Ltmp7:
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	.loc	1 0 9                           # multiply.c:0:9
	movq	%rcx, 144(%rsp)                 # 8-byte Spill
.Ltmp8:
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	movq	%rax, -24(%rsp)                 # 8-byte Spill
	movq	%rbx, -104(%rsp)                # 8-byte Spill
	.loc	1 32 9                          # multiply.c:32:9
	jb	.LBB0_25
.Ltmp9:
# %bb.3:
	#DEBUG_VALUE: matvec:rows <- $edi
	#DEBUG_VALUE: matvec:cols <- $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	leaq	-1(%rax), %r14
	movq	%r14, %rax
	shrq	$6, %rax
	movq	%rax, 184(%rsp)                 # 8-byte Spill
	leaq	-1(%rbx), %rax
	movq	%rax, 176(%rsp)                 # 8-byte Spill
	shrq	$6, %rax
	movq	%rax, 248(%rsp)                 # 8-byte Spill
	movq	%r10, %r15
	shlq	$6, %r15
.Ltmp10:
	.loc	1 33 21 is_stmt 1               # multiply.c:33:21
	vpbroadcastq	%r10, %ymm0
	vpmuludq	.LCPI0_0(%rip), %ymm0, %ymm0
.Ltmp11:
	.loc	1 32 9                          # multiply.c:32:9
	leaq	(,%r10,8), %r13
.Ltmp12:
	.loc	1 33 21                         # multiply.c:33:21
	leaq	(%r10,%r10), %rax
	leaq	(%rax,%rax,2), %r12
	movq	%r13, -40(%rsp)                 # 8-byte Spill
	subq	%r10, %r13
.Ltmp13:
	.loc	1 32 9                          # multiply.c:32:9
	vpextrq	$1, %xmm0, -120(%rsp)           # 8-byte Folded Spill
	vmovq	%xmm0, %r11
	vextracti128	$1, %ymm0, %xmm1
	vmovq	%xmm1, %rdx
	vpextrq	$1, %xmm1, %rsi
.Ltmp14:
	#DEBUG_VALUE: matvec:cols <- $r10d
	imulq	$56, %r10, %rbp
	movq	-128(%rsp), %r9                 # 8-byte Reload
	addq	%r9, %rbp
	movq	%r10, %rax
	shlq	$9, %rax
	movq	%rax, 168(%rsp)                 # 8-byte Spill
	leaq	(%r10,%r10,2), %rax
	shlq	$4, %rax
	addq	%r9, %rax
	leaq	(%r9,%rsi,8), %rdi
.Ltmp15:
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	%rax, %rsi
	.loc	1 32 9                          # multiply.c:32:9
	leaq	(%r9,%rdx,8), %rax
	movq	%rax, -16(%rsp)                 # 8-byte Spill
	movq	%rbp, %rdx
	movq	-120(%rsp), %rax                # 8-byte Reload
	leaq	(%r9,%rax,8), %rbp
	leaq	(%r9,%r11,8), %r11
	leaq	(%r9,%r10,8), %rax
	movq	%rax, -64(%rsp)                 # 8-byte Spill
	movq	$0, -72(%rsp)                   # 8-byte Folded Spill
	movq	%r9, -80(%rsp)                  # 8-byte Spill
	movq	-16(%rsp), %r9                  # 8-byte Reload
	xorl	%eax, %eax
	movq	%r15, 152(%rsp)                 # 8-byte Spill
	jmp	.LBB0_4
.Ltmp16:
	.loc	1 0 9                           # :0:9
.Ltmp17:
	.p2align	4
.LBB0_24:                               #   in Loop: Header=BB0_4 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	movq	216(%rsp), %rdx                 # 8-byte Reload
	movq	168(%rsp), %rax                 # 8-byte Reload
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	addq	%rax, %rdx
	movq	208(%rsp), %rsi                 # 8-byte Reload
	addq	%rax, %rsi
	movq	200(%rsp), %rdi                 # 8-byte Reload
	addq	%rax, %rdi
	movq	-16(%rsp), %r9                  # 8-byte Reload
	addq	%rax, %r9
	addq	%rax, %rbp
	addq	%rax, %r11
	addq	%rax, %r14
	movq	%r14, -64(%rsp)                 # 8-byte Spill
	addq	%rax, %r15
	movq	%r15, -80(%rsp)                 # 8-byte Spill
	movq	152(%rsp), %r15                 # 8-byte Reload
	addq	%r15, %r13
	movq	%r13, -72(%rsp)                 # 8-byte Spill
	movq	224(%rsp), %r13                 # 8-byte Reload
	addq	%r15, %r13
	movq	232(%rsp), %r12                 # 8-byte Reload
	addq	%r15, %r12
	movq	-112(%rsp), %r10                # 8-byte Reload
	addq	%r15, %r10
	movq	240(%rsp), %r14                 # 8-byte Reload
	addq	$-64, %r14
	movq	192(%rsp), %rax                 # 8-byte Reload
.Ltmp18:
	.loc	1 31 19 is_stmt 0               # multiply.c:31:19
	cmpq	184(%rsp), %rax                 # 8-byte Folded Reload
	leaq	1(%rax), %rax
.Ltmp19:
	.loc	1 31 5                          # multiply.c:31:5
	je	.LBB0_45
.Ltmp20:
.LBB0_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
                                        #       Child Loop BB0_7 Depth 3
                                        #         Child Loop BB0_11 Depth 4
                                        #         Child Loop BB0_9 Depth 4
                                        #       Child Loop BB0_16 Depth 3
                                        #         Child Loop BB0_18 Depth 4
                                        #         Child Loop BB0_21 Depth 4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	cmpq	$63, %r14
	movl	$63, %r8d
	movq	%r14, 240(%rsp)                 # 8-byte Spill
	cmovbq	%r14, %r8
	incl	%r8d
	shrl	$3, %r8d
	imulq	%r15, %r8
	movq	-80(%rsp), %r15                 # 8-byte Reload
	addq	%r15, %r8
	movq	%r8, 128(%rsp)                  # 8-byte Spill
	movq	%rax, 192(%rsp)                 # 8-byte Spill
	shlq	$6, %rax
	movq	%rax, -32(%rsp)                 # 8-byte Spill
	notq	%rax
	addq	-24(%rsp), %rax                 # 8-byte Folded Reload
	cmpq	$63, %rax
	movl	$63, %r8d
	movq	%rax, 256(%rsp)                 # 8-byte Spill
	cmovbq	%rax, %r8
	movq	%r8, 160(%rsp)                  # 8-byte Spill
	leaq	1(%r8), %rax
	movl	%eax, %r8d
	shrl	$3, %r8d
.Ltmp21:
	.loc	1 32 9                          # multiply.c:32:9
	decq	%r8
	movq	%r8, 304(%rsp)                  # 8-byte Spill
	andl	$120, %eax
	movq	%rax, 120(%rsp)                 # 8-byte Spill
	movq	%r10, -112(%rsp)                # 8-byte Spill
	movq	%r10, 112(%rsp)                 # 8-byte Spill
	movq	%r12, 232(%rsp)                 # 8-byte Spill
	movq	%r12, 104(%rsp)                 # 8-byte Spill
	movq	%r13, 224(%rsp)                 # 8-byte Spill
	movq	%r13, 96(%rsp)                  # 8-byte Spill
	movq	-72(%rsp), %r13                 # 8-byte Reload
	movq	%r13, 88(%rsp)                  # 8-byte Spill
	movq	176(%rsp), %r8                  # 8-byte Reload
	movq	-88(%rsp), %r12                 # 8-byte Reload
	movq	%r15, 80(%rsp)                  # 8-byte Spill
	movq	-64(%rsp), %r14                 # 8-byte Reload
	movq	%r14, 72(%rsp)                  # 8-byte Spill
	movq	%r11, 64(%rsp)                  # 8-byte Spill
	movq	%rbp, 56(%rsp)                  # 8-byte Spill
	movq	%r9, -16(%rsp)                  # 8-byte Spill
	movq	%r9, 48(%rsp)                   # 8-byte Spill
	movq	%rdi, 200(%rsp)                 # 8-byte Spill
	movq	%rdi, 40(%rsp)                  # 8-byte Spill
	movq	%rsi, 208(%rsp)                 # 8-byte Spill
	movq	%rsi, 32(%rsp)                  # 8-byte Spill
	movq	%rdx, 216(%rsp)                 # 8-byte Spill
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	xorl	%edx, %edx
	movq	%rbp, 272(%rsp)                 # 8-byte Spill
	movq	%r11, 264(%rsp)                 # 8-byte Spill
	movq	%r14, -64(%rsp)                 # 8-byte Spill
	movq	%r13, -72(%rsp)                 # 8-byte Spill
	movq	%r15, -80(%rsp)                 # 8-byte Spill
	jmp	.LBB0_5
.Ltmp22:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp23:
	.p2align	4
.LBB0_23:                               #   in Loop: Header=BB0_5 Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	addq	$512, 24(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 32(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 40(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 48(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 56(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 64(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 72(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, 80(%rsp)                  # 8-byte Folded Spill
                                        # imm = 0x200
	addq	$512, %r12                      # imm = 0x200
	movq	288(%rsp), %r8                  # 8-byte Reload
	addq	$-64, %r8
	addq	$64, 88(%rsp)                   # 8-byte Folded Spill
	addq	$64, 96(%rsp)                   # 8-byte Folded Spill
	addq	$64, 104(%rsp)                  # 8-byte Folded Spill
	addq	$64, 112(%rsp)                  # 8-byte Folded Spill
	addq	$512, %rbx                      # imm = 0x200
	movq	%rbx, 128(%rsp)                 # 8-byte Spill
	movq	280(%rsp), %rax                 # 8-byte Reload
.Ltmp24:
	.loc	1 31 19 is_stmt 0               # multiply.c:31:19
	cmpq	248(%rsp), %rax                 # 8-byte Folded Reload
	leaq	1(%rax), %rdx
	movq	-104(%rsp), %rbx                # 8-byte Reload
.Ltmp25:
	.loc	1 31 5                          # multiply.c:31:5
	je	.LBB0_24
.Ltmp26:
.LBB0_5:                                #   Parent Loop BB0_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_7 Depth 3
                                        #         Child Loop BB0_11 Depth 4
                                        #         Child Loop BB0_9 Depth 4
                                        #       Child Loop BB0_16 Depth 3
                                        #         Child Loop BB0_18 Depth 4
                                        #         Child Loop BB0_21 Depth 4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	cmpq	$63, %r8
	movl	$63, %eax
	movq	%r8, 288(%rsp)                  # 8-byte Spill
	cmovbq	%r8, %rax
	incq	%rax
	movq	%rdx, 280(%rsp)                 # 8-byte Spill
	shlq	$6, %rdx
	notq	%rdx
	addq	%rbx, %rdx
	cmpq	$63, %rdx
	movl	$63, %esi
	movq	%rdx, 320(%rsp)                 # 8-byte Spill
	cmovbq	%rdx, %rsi
	movq	%rsi, -96(%rsp)                 # 8-byte Spill
.Ltmp27:
	.loc	1 32 9                          # multiply.c:32:9
	cmpq	$7, 256(%rsp)                   # 8-byte Folded Reload
	jae	.LBB0_6
.Ltmp28:
.LBB0_14:                               #   in Loop: Header=BB0_5 Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	120(%rsp), %rdx                 # 8-byte Reload
	.loc	1 32 9                          # multiply.c:32:9
	cmpq	160(%rsp), %rdx                 # 8-byte Folded Reload
	movq	272(%rsp), %rbp                 # 8-byte Reload
	movq	264(%rsp), %r11                 # 8-byte Reload
	movq	-64(%rsp), %r14                 # 8-byte Reload
	movq	-72(%rsp), %r13                 # 8-byte Reload
	movq	-80(%rsp), %r15                 # 8-byte Reload
	movq	128(%rsp), %rbx                 # 8-byte Reload
	ja	.LBB0_23
.Ltmp29:
# %bb.15:                               #   in Loop: Header=BB0_5 Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	movl	%eax, %r10d
	andl	$120, %r10d
	shll	$3, %r10d
	movq	-96(%rsp), %rdx                 # 8-byte Reload
	incl	%edx
.Ltmp30:
	.loc	1 32 9                          # multiply.c:32:9
	andl	$120, %edx
	movq	%rbx, %rsi
	movq	120(%rsp), %rdi                 # 8-byte Reload
	jmp	.LBB0_16
.Ltmp31:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp32:
	.p2align	4
.LBB0_22:                               #   in Loop: Header=BB0_16 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 18 is_stmt 1               # multiply.c:33:18
	vmovsd	%xmm1, (%rcx,%r8,8)
.Ltmp33:
	.loc	1 32 9                          # multiply.c:32:9
	addq	-40(%rsp), %rsi                 # 8-byte Folded Reload
.Ltmp34:
	.loc	1 32 23 is_stmt 0               # multiply.c:32:23
	cmpq	160(%rsp), %rdi                 # 8-byte Folded Reload
	leaq	1(%rdi), %rdi
.Ltmp35:
	.loc	1 32 9                          # multiply.c:32:9
	je	.LBB0_23
.Ltmp36:
.LBB0_16:                               #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_18 Depth 4
                                        #         Child Loop BB0_21 Depth 4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9                           # multiply.c:0:9
	movq	-32(%rsp), %r8                  # 8-byte Reload
.Ltmp37:
	.loc	1 33 13 is_stmt 1               # multiply.c:33:13
	addq	%rdi, %r8
.Ltmp38:
	.loc	1 32 9                          # multiply.c:32:9
	vmovsd	(%rcx,%r8,8), %xmm1             # xmm1 = mem[0],zero
	cmpq	$7, 320(%rsp)                   # 8-byte Folded Reload
	jb	.LBB0_19
.Ltmp39:
# %bb.17:                               #   in Loop: Header=BB0_16 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	xorl	%r9d, %r9d
.Ltmp40:
	.p2align	4
.LBB0_18:                               #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        #       Parent Loop BB0_16 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovupd	(%r12,%r9), %ymm2
	vmovupd	32(%r12,%r9), %ymm3
	.loc	1 33 29 is_stmt 0               # multiply.c:33:29
	vmulpd	32(%rsi,%r9), %ymm3, %ymm3
	.loc	1 33 18                         # multiply.c:33:18
	vfmadd231pd	(%rsi,%r9), %ymm2, %ymm3 # ymm3 = (ymm2 * mem) + ymm3
	vextractf128	$1, %ymm3, %xmm2
	vaddpd	%xmm2, %xmm3, %xmm2
	vshufpd	$1, %xmm2, %xmm2, %xmm3         # xmm3 = xmm2[1,0]
	vaddsd	%xmm3, %xmm2, %xmm2
	vaddsd	%xmm2, %xmm1, %xmm1
.Ltmp41:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	addq	$64, %r9
	cmpq	%r9, %r10
.Ltmp42:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_18
.Ltmp43:
.LBB0_19:                               #   in Loop: Header=BB0_16 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	cmpq	-96(%rsp), %rdx                 # 8-byte Folded Reload
	ja	.LBB0_22
.Ltmp44:
# %bb.20:                               #   in Loop: Header=BB0_16 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	%rdx, %r9
.Ltmp45:
	.p2align	4
.LBB0_21:                               #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        #       Parent Loop BB0_16 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovsd	(%r12,%r9,8), %xmm2             # xmm2 = mem[0],zero
	.loc	1 33 18 is_stmt 0               # multiply.c:33:18
	vfmadd231sd	(%rsi,%r9,8), %xmm2, %xmm1 # xmm1 = (xmm2 * mem) + xmm1
.Ltmp46:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	incq	%r9
	cmpq	%r9, %rax
.Ltmp47:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_21
	jmp	.LBB0_22
.Ltmp48:
	.loc	1 0 9                           # :0:9
.Ltmp49:
	.p2align	4
.LBB0_6:                                #   in Loop: Header=BB0_5 Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	movq	-96(%rsp), %rdx                 # 8-byte Reload
.Ltmp50:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	incq	%rdx
	movq	%rdx, 296(%rsp)                 # 8-byte Spill
.Ltmp51:
	.loc	1 31 5                          # multiply.c:31:5
	movl	%edx, %r9d
	andl	$124, %r9d
	movq	112(%rsp), %rbp                 # 8-byte Reload
	movq	104(%rsp), %rbx                 # 8-byte Reload
	movq	96(%rsp), %rsi                  # 8-byte Reload
	movq	88(%rsp), %r11                  # 8-byte Reload
	movq	80(%rsp), %r10                  # 8-byte Reload
	movq	72(%rsp), %rdx                  # 8-byte Reload
	movq	%rdx, -48(%rsp)                 # 8-byte Spill
	movq	64(%rsp), %rdi                  # 8-byte Reload
	movq	56(%rsp), %r15                  # 8-byte Reload
	movq	48(%rsp), %r13                  # 8-byte Reload
	movq	40(%rsp), %r14                  # 8-byte Reload
	movq	32(%rsp), %r8                   # 8-byte Reload
	movq	%rax, 136(%rsp)                 # 8-byte Spill
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	%rax, -56(%rsp)                 # 8-byte Spill
	movq	136(%rsp), %rax                 # 8-byte Reload
	xorl	%edx, %edx
	movq	%r9, 312(%rsp)                  # 8-byte Spill
	jmp	.LBB0_7
.Ltmp52:
	.loc	1 0 5 is_stmt 0                 # :0:5
.Ltmp53:
	.p2align	4
.LBB0_13:                               #   in Loop: Header=BB0_7 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	movq	144(%rsp), %rcx                 # 8-byte Reload
.Ltmp54:
	.loc	1 33 18 is_stmt 1               # multiply.c:33:18
	vmovupd	%ymm2, (%rcx,%rdi,8)
	vmovupd	%ymm1, 32(%rcx,%rdi,8)
	movq	152(%rsp), %rdx                 # 8-byte Reload
.Ltmp55:
	.loc	1 32 9                          # multiply.c:32:9
	addq	%rdx, -56(%rsp)                 # 8-byte Folded Spill
	addq	%rdx, %r8
	addq	%rdx, %r14
	addq	%rdx, %r13
	addq	%rdx, %r15
	movq	-120(%rsp), %rdi                # 8-byte Reload
	addq	%rdx, %rdi
	addq	%rdx, -48(%rsp)                 # 8-byte Folded Spill
	movq	16(%rsp), %r10                  # 8-byte Reload
	addq	%rdx, %r10
	movq	-40(%rsp), %rdx                 # 8-byte Reload
	addq	%rdx, %r11
	addq	%rdx, %rsi
	addq	%rdx, %rbx
	addq	%rdx, %rbp
	movq	8(%rsp), %rdx                   # 8-byte Reload
.Ltmp56:
	.loc	1 32 23 is_stmt 0               # multiply.c:32:23
	cmpq	304(%rsp), %rdx                 # 8-byte Folded Reload
	leaq	1(%rdx), %rdx
	movq	312(%rsp), %r9                  # 8-byte Reload
.Ltmp57:
	.loc	1 32 9                          # multiply.c:32:9
	je	.LBB0_14
.Ltmp58:
.LBB0_7:                                #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_11 Depth 4
                                        #         Child Loop BB0_9 Depth 4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9                           # multiply.c:0:9
	movq	%rdi, -120(%rsp)                # 8-byte Spill
	movq	%rdx, %rdi
	movq	-32(%rsp), %rdx                 # 8-byte Reload
	movq	%rdi, 8(%rsp)                   # 8-byte Spill
.Ltmp59:
	.loc	1 33 13 is_stmt 1               # multiply.c:33:13
	leaq	(%rdx,%rdi,8), %rdi
.Ltmp60:
	.loc	1 32 9                          # multiply.c:32:9
	vmovupd	(%rcx,%rdi,8), %ymm2
	vmovupd	32(%rcx,%rdi,8), %ymm1
	testq	%r9, %r9
	movq	%r10, 16(%rsp)                  # 8-byte Spill
	je	.LBB0_8
.Ltmp61:
# %bb.10:                               #   in Loop: Header=BB0_7 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	%rdi, -8(%rsp)                  # 8-byte Spill
	movq	%rbp, (%rsp)                    # 8-byte Spill
	vxorpd	%xmm10, %xmm10, %xmm10
	xorl	%edx, %edx
	vxorpd	%xmm9, %xmm9, %xmm9
	vxorpd	%xmm8, %xmm8, %xmm8
	vxorpd	%xmm7, %xmm7, %xmm7
	vxorpd	%xmm6, %xmm6, %xmm6
	vxorpd	%xmm5, %xmm5, %xmm5
	vxorpd	%xmm4, %xmm4, %xmm4
	vxorpd	%xmm3, %xmm3, %xmm3
	movq	-128(%rsp), %rcx                # 8-byte Reload
	movq	%r8, %rbp
	movq	%r14, %r8
	movq	%r13, %r14
	movq	%r15, %r13
	movq	-120(%rsp), %r15                # 8-byte Reload
	movq	-48(%rsp), %rdi                 # 8-byte Reload
	movq	-56(%rsp), %rax                 # 8-byte Reload
.Ltmp62:
	.p2align	4
.LBB0_11:                               #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        #       Parent Loop BB0_7 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovupd	(%r12,%rdx,8), %ymm11
	.loc	1 33 18 is_stmt 0               # multiply.c:33:18
	vfmadd231pd	(%r10,%rdx,8), %ymm11, %ymm10 # ymm10 = (ymm11 * mem) + ymm10
	vfmadd231pd	(%rdi,%rdx,8), %ymm11, %ymm9 # ymm9 = (ymm11 * mem) + ymm9
	vfmadd231pd	(%r15,%rdx,8), %ymm11, %ymm8 # ymm8 = (ymm11 * mem) + ymm8
	vfmadd231pd	(%r13,%rdx,8), %ymm11, %ymm7 # ymm7 = (ymm11 * mem) + ymm7
	vfmadd231pd	(%r14,%rdx,8), %ymm11, %ymm6 # ymm6 = (ymm11 * mem) + ymm6
	vfmadd231pd	(%r8,%rdx,8), %ymm11, %ymm5 # ymm5 = (ymm11 * mem) + ymm5
	vfmadd231pd	(%rbp,%rdx,8), %ymm11, %ymm4 # ymm4 = (ymm11 * mem) + ymm4
	vfmadd231pd	(%rax,%rdx,8), %ymm11, %ymm3 # ymm3 = (ymm11 * mem) + ymm3
.Ltmp63:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	addq	$4, %rdx
	cmpq	%r9, %rdx
.Ltmp64:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jb	.LBB0_11
.Ltmp65:
# %bb.12:                               #   in Loop: Header=BB0_7 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	vextractf128	$1, %ymm10, %xmm11
	vextractf128	$1, %ymm9, %xmm12
	vaddpd	%xmm11, %xmm10, %xmm10
	vextractf128	$1, %ymm8, %xmm11
	vaddpd	%xmm12, %xmm9, %xmm9
	vextractf128	$1, %ymm7, %xmm12
	vaddpd	%xmm11, %xmm8, %xmm8
	vextractf128	$1, %ymm6, %xmm11
	vaddpd	%xmm7, %xmm12, %xmm7
	vshufpd	$1, %xmm2, %xmm2, %xmm12        # xmm12 = xmm2[1,0]
	vaddpd	%xmm6, %xmm11, %xmm6
	vshufpd	$1, %xmm10, %xmm10, %xmm11      # xmm11 = xmm10[1,0]
	vaddsd	%xmm11, %xmm10, %xmm10
	vshufpd	$1, %xmm9, %xmm9, %xmm11        # xmm11 = xmm9[1,0]
	vaddsd	%xmm11, %xmm9, %xmm9
	vshufpd	$1, %xmm8, %xmm8, %xmm11        # xmm11 = xmm8[1,0]
	vaddsd	%xmm11, %xmm8, %xmm8
	vshufpd	$1, %xmm7, %xmm7, %xmm11        # xmm11 = xmm7[1,0]
	vaddsd	%xmm7, %xmm11, %xmm7
	vshufpd	$1, %xmm6, %xmm6, %xmm11        # xmm11 = xmm6[1,0]
	vaddsd	%xmm6, %xmm11, %xmm6
	vextractf128	$1, %ymm2, %xmm11
	vaddsd	%xmm2, %xmm10, %xmm2
	vshufpd	$1, %xmm11, %xmm11, %xmm10      # xmm10 = xmm11[1,0]
	vaddsd	%xmm9, %xmm12, %xmm9
	vaddsd	%xmm8, %xmm11, %xmm8
	vaddsd	%xmm7, %xmm10, %xmm7
	vpunpcklqdq	%xmm9, %xmm2, %xmm2     # xmm2 = xmm2[0],xmm9[0]
	vpunpcklqdq	%xmm7, %xmm8, %xmm7     # xmm7 = xmm8[0],xmm7[0]
	vaddsd	%xmm6, %xmm1, %xmm6
	vshufpd	$1, %xmm1, %xmm1, %xmm8         # xmm8 = xmm1[1,0]
	vextractf128	$1, %ymm5, %xmm9
	vaddpd	%xmm5, %xmm9, %xmm5
	vshufpd	$1, %xmm5, %xmm5, %xmm9         # xmm9 = xmm5[1,0]
	vaddsd	%xmm5, %xmm9, %xmm5
	vaddsd	%xmm5, %xmm8, %xmm5
	vpunpcklqdq	%xmm5, %xmm6, %xmm5     # xmm5 = xmm6[0],xmm5[0]
	vextractf128	$1, %ymm1, %xmm1
	vextractf128	$1, %ymm4, %xmm6
	vaddpd	%xmm6, %xmm4, %xmm4
	vshufpd	$1, %xmm4, %xmm4, %xmm6         # xmm6 = xmm4[1,0]
	vaddsd	%xmm6, %xmm4, %xmm4
	vaddsd	%xmm4, %xmm1, %xmm4
	vshufpd	$1, %xmm1, %xmm1, %xmm1         # xmm1 = xmm1[1,0]
	vextractf128	$1, %ymm3, %xmm6
	vaddpd	%xmm6, %xmm3, %xmm3
	vshufpd	$1, %xmm3, %xmm3, %xmm6         # xmm6 = xmm3[1,0]
	vaddsd	%xmm6, %xmm3, %xmm3
	vaddsd	%xmm3, %xmm1, %xmm1
	vpunpcklqdq	%xmm1, %xmm4, %xmm1     # xmm1 = xmm4[0],xmm1[0]
	vinsertf128	$1, %xmm1, %ymm5, %ymm1
	vinsertf128	$1, %xmm7, %ymm2, %ymm2
	movq	%r9, %rdx
.Ltmp66:
	.loc	1 32 9                          # multiply.c:32:9
	cmpq	%r9, 296(%rsp)                  # 8-byte Folded Reload
	movq	%r13, %r15
	movq	%r14, %r13
	movq	%r8, %r14
	movq	%rbp, %r8
	movq	(%rsp), %rbp                    # 8-byte Reload
	movq	136(%rsp), %rax                 # 8-byte Reload
	movq	-8(%rsp), %rdi                  # 8-byte Reload
	jne	.LBB0_9
	jmp	.LBB0_13
.Ltmp67:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp68:
	.p2align	4
.LBB0_8:                                #   in Loop: Header=BB0_7 Depth=3
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	xorl	%edx, %edx
	movq	-128(%rsp), %rcx                # 8-byte Reload
.Ltmp69:
	.p2align	4
.LBB0_9:                                #   Parent Loop BB0_4 Depth=1
                                        #     Parent Loop BB0_5 Depth=2
                                        #       Parent Loop BB0_7 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 21 is_stmt 1               # multiply.c:33:21
	leaq	(%r11,%rdx), %r9
	leaq	(%rbp,%rdx), %r10
	vpbroadcastq	%r9, %ymm3
	vpaddq	%ymm3, %ymm0, %ymm4
	vmovq	%r10, %xmm5
	vpunpcklqdq	%xmm5, %xmm3, %xmm3     # xmm3 = xmm3[0],xmm5[0]
	vinserti128	$1, %xmm4, %ymm3, %ymm3
	vpxor	%xmm5, %xmm5, %xmm5
	kxnorw	%k0, %k0, %k1
	vgatherqpd	(%rcx,%ymm3,8), %ymm5 {%k1}
	leaq	(%rbx,%rdx), %r9
	leaq	(%rsi,%rdx), %r10
	vpbroadcastq	%r9, %ymm3
	vperm2i128	$49, %ymm3, %ymm4, %ymm3 # ymm3 = ymm4[2,3],ymm3[2,3]
	vpbroadcastq	%r10, %ymm4
	vpblendd	$192, %ymm4, %ymm3, %ymm3       # ymm3 = ymm3[0,1,2,3,4,5],ymm4[6,7]
	vpxor	%xmm4, %xmm4, %xmm4
	kxnorw	%k0, %k0, %k1
	vgatherqpd	(%rcx,%ymm3,8), %ymm4 {%k1}
	.loc	1 33 29 is_stmt 0               # multiply.c:33:29
	vbroadcastsd	(%r12,%rdx,8), %ymm3
	.loc	1 33 18                         # multiply.c:33:18
	vfmadd231pd	%ymm4, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm4) + ymm1
	vfmadd231pd	%ymm5, %ymm3, %ymm2     # ymm2 = (ymm3 * ymm5) + ymm2
.Ltmp70:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	incq	%rdx
	cmpq	%rdx, %rax
.Ltmp71:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_9
	jmp	.LBB0_13
.Ltmp72:
.LBB0_25:
	#DEBUG_VALUE: matvec:rows <- $edi
	#DEBUG_VALUE: matvec:cols <- $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9                           # multiply.c:0:9
	movq	%r10, -112(%rsp)                # 8-byte Spill
	movq	%rdi, -96(%rsp)                 # 8-byte Spill
.Ltmp73:
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	.loc	1 32 9                          # multiply.c:32:9
	cmpl	$8, %edi
	movq	%rcx, %r11
	jae	.LBB0_26
.Ltmp74:
.LBB0_35:
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9                           # multiply.c:0:9
	movq	-96(%rsp), %rdi                 # 8-byte Reload
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	movl	%edi, %eax
	andl	$504, %eax                      # imm = 0x1F8
	movq	-24(%rsp), %rbx                 # 8-byte Reload
	cmpq	%rbx, %rax
	movq	-88(%rsp), %r8                  # 8-byte Reload
	movq	-112(%rsp), %r10                # 8-byte Reload
	movq	-104(%rsp), %r14                # 8-byte Reload
	jne	.LBB0_36
.Ltmp75:
.LBB0_45:
	#DEBUG_VALUE: matvec:rows <- [DW_OP_LLVM_entry_value 1] $edi
	#DEBUG_VALUE: matvec:cols <- [DW_OP_LLVM_entry_value 1] $esi
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_LLVM_entry_value 1] $rcx
	#DEBUG_VALUE: matvec:x <- [DW_OP_LLVM_entry_value 1] $r8
	#DEBUG_VALUE: matvec:i <- 0
	.loc	1 36 1 epilogue_begin           # multiply.c:36:1
	addq	$328, %rsp                      # imm = 0x148
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Ltmp76:
.LBB0_26:
	.cfi_def_cfa_offset 384
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 1 is_stmt 0                 # multiply.c:0:1
	movq	-24(%rsp), %rax                 # 8-byte Reload
.Ltmp77:
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	shrq	$3, %rax
.Ltmp78:
	.loc	1 32 9                          # multiply.c:32:9
	decq	%rax
	movq	%rax, -48(%rsp)                 # 8-byte Spill
	movq	-112(%rsp), %rbx                # 8-byte Reload
	leaq	(,%rbx,8), %r10
.Ltmp79:
	.loc	1 33 21                         # multiply.c:33:21
	vpbroadcastq	%rbx, %ymm0
	vpmuludq	.LCPI0_0(%rip), %ymm0, %ymm0
	leaq	(%rbx,%rbx), %rax
	leaq	(%rax,%rax,2), %r9
	movq	%r10, -56(%rsp)                 # 8-byte Spill
	subq	%rbx, %r10
.Ltmp80:
	.loc	1 32 9                          # multiply.c:32:9
	vmovq	%xmm0, %rax
	vpextrq	$1, %xmm0, %rcx
	vextracti128	$1, %ymm0, %xmm1
	vmovq	%xmm1, %rdx
	vpextrq	$1, %xmm1, %r8
	movq	-104(%rsp), %rdi                # 8-byte Reload
.Ltmp81:
	.loc	1 31 5                          # multiply.c:31:5
	andq	$-4, %rdi
	movq	%rdi, -8(%rsp)                  # 8-byte Spill
.Ltmp82:
	.loc	1 32 9                          # multiply.c:32:9
	imulq	$56, %rbx, %r14
	movq	-128(%rsp), %rdi                # 8-byte Reload
	addq	%rdi, %r14
	movq	%rbx, %r15
	shlq	$6, %r15
	movq	%r15, (%rsp)                    # 8-byte Spill
	leaq	(%rbx,%rbx,2), %r15
	shlq	$4, %r15
	addq	%rdi, %r15
	leaq	(%rdi,%r8,8), %r12
	leaq	(%rdi,%rdx,8), %r13
	leaq	(%rdi,%rcx,8), %rbp
	leaq	(%rdi,%rax,8), %r8
	leaq	(%rdi,%rbx,8), %rax
	movq	$0, -120(%rsp)                  # 8-byte Folded Spill
	xorl	%ecx, %ecx
	movl	%esi, 8(%rsp)                   # 4-byte Spill
	jmp	.LBB0_27
.Ltmp83:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp84:
	.p2align	4
.LBB0_34:                               #   in Loop: Header=BB0_27 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	movq	16(%rsp), %rdx                  # 8-byte Reload
.Ltmp85:
	.loc	1 33 13 is_stmt 1               # multiply.c:33:13
	leaq	(,%rdx,8), %rcx
	movq	144(%rsp), %r11                 # 8-byte Reload
	.loc	1 33 18 is_stmt 0               # multiply.c:33:18
	vmovupd	%ymm2, (%r11,%rcx,8)
	vmovupd	%ymm1, 32(%r11,%rcx,8)
	movq	-32(%rsp), %r14                 # 8-byte Reload
	movq	(%rsp), %rcx                    # 8-byte Reload
.Ltmp86:
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	addq	%rcx, %r14
	movq	-40(%rsp), %r15                 # 8-byte Reload
	addq	%rcx, %r15
	addq	%rcx, %r12
	addq	%rcx, %r13
	addq	%rcx, %rbp
	addq	%rcx, %r8
	addq	%rcx, %rax
	addq	%rcx, %rdi
	movq	-120(%rsp), %rcx                # 8-byte Reload
	addq	-56(%rsp), %rcx                 # 8-byte Folded Reload
	movq	%rcx, -120(%rsp)                # 8-byte Spill
.Ltmp87:
	.loc	1 31 19 is_stmt 0               # multiply.c:31:19
	cmpq	-48(%rsp), %rdx                 # 8-byte Folded Reload
	leaq	1(%rdx), %rcx
	movl	8(%rsp), %esi                   # 4-byte Reload
.Ltmp88:
	.loc	1 31 5                          # multiply.c:31:5
	je	.LBB0_35
.Ltmp89:
.LBB0_27:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_32 Depth 2
                                        #     Child Loop BB0_30 Depth 2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 5                           # multiply.c:0:5
	movq	%rcx, 16(%rsp)                  # 8-byte Spill
.Ltmp90:
	.loc	1 33 13 is_stmt 1               # multiply.c:33:13
	shlq	$6, %rcx
.Ltmp91:
	.loc	1 32 9                          # multiply.c:32:9
	vmovupd	(%r11,%rcx), %ymm2
	vmovupd	32(%r11,%rcx), %ymm1
	cmpl	$4, %esi
	movq	%r14, -32(%rsp)                 # 8-byte Spill
	movq	%r15, -40(%rsp)                 # 8-byte Spill
	jae	.LBB0_31
.Ltmp92:
# %bb.28:                               #   in Loop: Header=BB0_27 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	xorl	%edx, %edx
	movq	-128(%rsp), %rbx                # 8-byte Reload
	movq	-112(%rsp), %r15                # 8-byte Reload
	jmp	.LBB0_29
.Ltmp93:
	.p2align	4
.LBB0_31:                               #   in Loop: Header=BB0_27 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	vxorpd	%xmm3, %xmm3, %xmm3
	vxorpd	%xmm4, %xmm4, %xmm4
	vxorpd	%xmm5, %xmm5, %xmm5
	vxorpd	%xmm6, %xmm6, %xmm6
	vxorpd	%xmm7, %xmm7, %xmm7
	vxorpd	%xmm8, %xmm8, %xmm8
	vxorpd	%xmm9, %xmm9, %xmm9
	vxorpd	%xmm10, %xmm10, %xmm10
	xorl	%ecx, %ecx
	movq	-88(%rsp), %rdx                 # 8-byte Reload
	movq	-8(%rsp), %rsi                  # 8-byte Reload
.Ltmp94:
	.p2align	4
.LBB0_32:                               #   Parent Loop BB0_27 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovupd	(%rdx,%rcx,8), %ymm11
	.loc	1 33 18 is_stmt 0               # multiply.c:33:18
	vfmadd231pd	(%rdi,%rcx,8), %ymm11, %ymm10 # ymm10 = (ymm11 * mem) + ymm10
	vfmadd231pd	(%rax,%rcx,8), %ymm11, %ymm9 # ymm9 = (ymm11 * mem) + ymm9
	vfmadd231pd	(%r8,%rcx,8), %ymm11, %ymm8 # ymm8 = (ymm11 * mem) + ymm8
	vfmadd231pd	(%rbp,%rcx,8), %ymm11, %ymm7 # ymm7 = (ymm11 * mem) + ymm7
	vfmadd231pd	(%r13,%rcx,8), %ymm11, %ymm6 # ymm6 = (ymm11 * mem) + ymm6
	vfmadd231pd	(%r12,%rcx,8), %ymm11, %ymm5 # ymm5 = (ymm11 * mem) + ymm5
	vfmadd231pd	(%r15,%rcx,8), %ymm11, %ymm4 # ymm4 = (ymm11 * mem) + ymm4
	vfmadd231pd	(%r14,%rcx,8), %ymm11, %ymm3 # ymm3 = (ymm11 * mem) + ymm3
.Ltmp95:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	addq	$4, %rcx
	cmpq	%rsi, %rcx
.Ltmp96:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jl	.LBB0_32
.Ltmp97:
# %bb.33:                               #   in Loop: Header=BB0_27 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 31 5 is_stmt 1                # multiply.c:31:5
	vextractf128	$1, %ymm10, %xmm11
	vextractf128	$1, %ymm9, %xmm12
	vaddpd	%xmm11, %xmm10, %xmm10
	vextractf128	$1, %ymm8, %xmm11
	vaddpd	%xmm12, %xmm9, %xmm9
	vextractf128	$1, %ymm7, %xmm12
	vaddpd	%xmm11, %xmm8, %xmm8
	vextractf128	$1, %ymm6, %xmm11
	vaddpd	%xmm7, %xmm12, %xmm7
	vshufpd	$1, %xmm2, %xmm2, %xmm12        # xmm12 = xmm2[1,0]
	vaddpd	%xmm6, %xmm11, %xmm6
	vshufpd	$1, %xmm10, %xmm10, %xmm11      # xmm11 = xmm10[1,0]
	vaddsd	%xmm11, %xmm10, %xmm10
	vshufpd	$1, %xmm9, %xmm9, %xmm11        # xmm11 = xmm9[1,0]
	vaddsd	%xmm11, %xmm9, %xmm9
	vshufpd	$1, %xmm8, %xmm8, %xmm11        # xmm11 = xmm8[1,0]
	vaddsd	%xmm11, %xmm8, %xmm8
	vshufpd	$1, %xmm7, %xmm7, %xmm11        # xmm11 = xmm7[1,0]
	vaddsd	%xmm7, %xmm11, %xmm7
	vshufpd	$1, %xmm6, %xmm6, %xmm11        # xmm11 = xmm6[1,0]
	vaddsd	%xmm6, %xmm11, %xmm6
	vextractf128	$1, %ymm2, %xmm11
	vaddsd	%xmm2, %xmm10, %xmm2
	vshufpd	$1, %xmm11, %xmm11, %xmm10      # xmm10 = xmm11[1,0]
	vaddsd	%xmm9, %xmm12, %xmm9
	vaddsd	%xmm8, %xmm11, %xmm8
	vaddsd	%xmm7, %xmm10, %xmm7
	vpunpcklqdq	%xmm9, %xmm2, %xmm2     # xmm2 = xmm2[0],xmm9[0]
	vpunpcklqdq	%xmm7, %xmm8, %xmm7     # xmm7 = xmm8[0],xmm7[0]
	vaddsd	%xmm6, %xmm1, %xmm6
	vshufpd	$1, %xmm1, %xmm1, %xmm8         # xmm8 = xmm1[1,0]
	vextractf128	$1, %ymm5, %xmm9
	vaddpd	%xmm5, %xmm9, %xmm5
	vshufpd	$1, %xmm5, %xmm5, %xmm9         # xmm9 = xmm5[1,0]
	vaddsd	%xmm5, %xmm9, %xmm5
	vaddsd	%xmm5, %xmm8, %xmm5
	vpunpcklqdq	%xmm5, %xmm6, %xmm5     # xmm5 = xmm6[0],xmm5[0]
	vextractf128	$1, %ymm1, %xmm1
	vextractf128	$1, %ymm4, %xmm6
	vaddpd	%xmm6, %xmm4, %xmm4
	vshufpd	$1, %xmm4, %xmm4, %xmm6         # xmm6 = xmm4[1,0]
	vaddsd	%xmm6, %xmm4, %xmm4
	vaddsd	%xmm4, %xmm1, %xmm4
	vshufpd	$1, %xmm1, %xmm1, %xmm1         # xmm1 = xmm1[1,0]
	vextractf128	$1, %ymm3, %xmm6
	vaddpd	%xmm6, %xmm3, %xmm3
	vshufpd	$1, %xmm3, %xmm3, %xmm6         # xmm6 = xmm3[1,0]
	vaddsd	%xmm6, %xmm3, %xmm3
	vaddsd	%xmm3, %xmm1, %xmm1
	vpunpcklqdq	%xmm1, %xmm4, %xmm1     # xmm1 = xmm4[0],xmm1[0]
	vinsertf128	$1, %xmm1, %ymm5, %ymm1
	vinsertf128	$1, %xmm7, %ymm2, %ymm2
	movq	%rsi, %rdx
.Ltmp98:
	.loc	1 32 9                          # multiply.c:32:9
	cmpq	-104(%rsp), %rsi                # 8-byte Folded Reload
	movq	-128(%rsp), %rbx                # 8-byte Reload
	movq	-112(%rsp), %r15                # 8-byte Reload
	je	.LBB0_34
.Ltmp99:
.LBB0_29:                               #   in Loop: Header=BB0_27 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	-104(%rsp), %rsi                # 8-byte Reload
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	subq	%rdx, %rsi
	movq	-88(%rsp), %rcx                 # 8-byte Reload
	leaq	(%rcx,%rdx,8), %rcx
	addq	-120(%rsp), %rdx                # 8-byte Folded Reload
.Ltmp100:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp101:
	.p2align	4
.LBB0_30:                               #   Parent Loop BB0_27 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 21 is_stmt 1               # multiply.c:33:21
	leaq	(%r15,%rdx), %r14
	vpbroadcastq	%rdx, %ymm3
	vpaddq	%ymm3, %ymm0, %ymm4
	vmovq	%r14, %xmm5
	vpunpcklqdq	%xmm5, %xmm3, %xmm3     # xmm3 = xmm3[0],xmm5[0]
	vinserti128	$1, %xmm4, %ymm3, %ymm3
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm5, %xmm5, %xmm5
	vgatherqpd	(%rbx,%ymm3,8), %ymm5 {%k1}
	leaq	(%r9,%rdx), %r14
	leaq	(%r10,%rdx), %r11
	vpbroadcastq	%r14, %ymm3
	vperm2i128	$49, %ymm3, %ymm4, %ymm3 # ymm3 = ymm4[2,3],ymm3[2,3]
	vpbroadcastq	%r11, %ymm4
	vpblendd	$192, %ymm4, %ymm3, %ymm3       # ymm3 = ymm3[0,1,2,3,4,5],ymm4[6,7]
	kxnorw	%k0, %k0, %k1
	vpxor	%xmm4, %xmm4, %xmm4
	vgatherqpd	(%rbx,%ymm3,8), %ymm4 {%k1}
	.loc	1 33 29 is_stmt 0               # multiply.c:33:29
	vbroadcastsd	(%rcx), %ymm3
	.loc	1 33 18                         # multiply.c:33:18
	vfmadd231pd	%ymm4, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm4) + ymm1
	vfmadd231pd	%ymm5, %ymm3, %ymm2     # ymm2 = (ymm3 * ymm5) + ymm2
.Ltmp102:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	incq	%rdx
	addq	$8, %rcx
	decq	%rsi
.Ltmp103:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_30
	jmp	.LBB0_34
.Ltmp104:
.LBB0_36:
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_constu 128, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	decq	%rbx
.Ltmp105:
	.loc	1 31 5                          # multiply.c:31:5
	movq	%r14, %rcx
	shrq	$3, %rcx
.Ltmp106:
	.loc	1 32 9                          # multiply.c:32:9
	movq	%r14, %rdx
	andq	$-8, %rdx
	shrl	$3, %edi
	andl	$63, %edi
	imulq	%r10, %rdi
	shlq	$6, %rdi
	addq	%rdi, -128(%rsp)                # 8-byte Folded Spill
.Ltmp107:
	#DEBUG_VALUE: matvec:a <- undef
	shlq	$3, %r10
	jmp	.LBB0_37
.Ltmp108:
	.loc	1 0 9 is_stmt 0                 # :0:9
.Ltmp109:
	.p2align	4
.LBB0_41:                               #   in Loop: Header=BB0_37 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	movq	-128(%rsp), %rdi                # 8-byte Reload
.Ltmp110:
.LBB0_44:                               #   in Loop: Header=BB0_37 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 18 is_stmt 1               # multiply.c:33:18
	vmovsd	%xmm0, (%r11,%rax,8)
.Ltmp111:
	.loc	1 31 5                          # multiply.c:31:5
	addq	%r10, %rdi
	movq	%rdi, -128(%rsp)                # 8-byte Spill
.Ltmp112:
	.loc	1 31 19 is_stmt 0               # multiply.c:31:19
	cmpq	%rbx, %rax
	leaq	1(%rax), %rax
.Ltmp113:
	.loc	1 31 5                          # multiply.c:31:5
	je	.LBB0_45
.Ltmp114:
.LBB0_37:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_39 Depth 2
                                        #     Child Loop BB0_43 Depth 2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	vmovsd	(%r11,%rax,8), %xmm0            # xmm0 = mem[0],zero
	cmpl	$8, %esi
	jb	.LBB0_40
.Ltmp115:
# %bb.38:                               #   in Loop: Header=BB0_37 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	%rcx, %r15
	xorl	%edi, %edi
	movq	-128(%rsp), %r9                 # 8-byte Reload
.Ltmp116:
	.p2align	4
.LBB0_39:                               #   Parent Loop BB0_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovupd	(%r8,%rdi), %ymm1
	vmovupd	32(%r8,%rdi), %ymm2
	.loc	1 33 29 is_stmt 0               # multiply.c:33:29
	vmulpd	32(%r9,%rdi), %ymm2, %ymm2
	.loc	1 33 18                         # multiply.c:33:18
	vfmadd231pd	(%r9,%rdi), %ymm1, %ymm2 # ymm2 = (ymm1 * mem) + ymm2
	vextractf128	$1, %ymm2, %xmm1
	vaddpd	%xmm1, %xmm2, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm2         # xmm2 = xmm1[1,0]
	vaddsd	%xmm2, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
.Ltmp117:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	addq	$64, %rdi
	decq	%r15
.Ltmp118:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_39
.Ltmp119:
.LBB0_40:                               #   in Loop: Header=BB0_37 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 32 9 is_stmt 1                # multiply.c:32:9
	cmpq	%r14, %rdx
	je	.LBB0_41
.Ltmp120:
# %bb.42:                               #   in Loop: Header=BB0_37 Depth=1
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 0 9 is_stmt 0                 # multiply.c:0:9
	movq	%rdx, %r9
	movq	-128(%rsp), %rdi                # 8-byte Reload
.Ltmp121:
	.p2align	4
.LBB0_43:                               #   Parent Loop BB0_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: matvec:rows <- [DW_OP_constu 96, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:cols <- [DW_OP_constu 112, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:a <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: matvec:b <- [DW_OP_plus_uconst 144] [$rsp+0]
	#DEBUG_VALUE: matvec:x <- [DW_OP_constu 88, DW_OP_minus] [$rsp+0]
	#DEBUG_VALUE: matvec:i <- 0
	#DEBUG_VALUE: matvec:j <- 0
	.loc	1 33 31 is_stmt 1               # multiply.c:33:31
	vmovsd	(%r8,%r9,8), %xmm1              # xmm1 = mem[0],zero
	.loc	1 33 18 is_stmt 0               # multiply.c:33:18
	vfmadd231sd	(%rdi,%r9,8), %xmm1, %xmm0 # xmm0 = (xmm1 * mem) + xmm0
.Ltmp122:
	.loc	1 32 23 is_stmt 1               # multiply.c:32:23
	incq	%r9
	cmpq	%r9, %r14
.Ltmp123:
	.loc	1 32 9 is_stmt 0                # multiply.c:32:9
	jne	.LBB0_43
	jmp	.LBB0_44
.Ltmp124:
.Lfunc_end0:
	.size	matvec, .Lfunc_end0-matvec
	.cfi_endproc
                                        # -- End function
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # super-register DW_OP_reg5
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp72-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # super-register DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp72-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # super-register DW_OP_reg5
	.quad	.Ltmp73-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	160                             # -96
	.byte	127                             # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # super-register DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	160                             # -96
	.byte	127                             # 
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp14-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # super-register DW_OP_reg4
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	90                              # super-register DW_OP_reg10
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp72-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # super-register DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp72-.Lfunc_begin0
	.quad	.Ltmp74-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # super-register DW_OP_reg4
	.quad	.Ltmp74-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	144                             # -112
	.byte	127                             # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # super-register DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	144                             # -112
	.byte	127                             # 
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp0-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	128                             # -128
	.byte	127                             # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	81                              # DW_OP_reg1
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp107-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	128                             # -128
	.byte	127                             # 
	.quad	.Ltmp108-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	81                              # DW_OP_reg1
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp8-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	82                              # DW_OP_reg2
	.quad	.Ltmp8-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	144                             # 144
	.byte	1                               # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	82                              # DW_OP_reg2
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	144                             # 144
	.byte	1                               # 
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp7-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	88                              # DW_OP_reg8
	.quad	.Ltmp7-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	168                             # -88
	.byte	127                             # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	88                              # DW_OP_reg8
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	168                             # -88
	.byte	127                             # 
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp2-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	17                              # DW_OP_consts
	.byte	0                               # 0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	17                              # DW_OP_consts
	.byte	0                               # 0
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	14                              # DW_FORM_strp
	.ascii	"\201v"                         # DW_AT_INTEL_comp_flags
	.byte	14                              # DW_FORM_strp
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	14                              # DW_FORM_strp
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.ascii	"\227B"                         # DW_AT_GNU_all_call_sites
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	4                               # DW_TAG_enumeration_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	40                              # DW_TAG_enumerator
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	28                              # DW_AT_const_value
	.byte	15                              # DW_FORM_udata
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	23                              # DW_FORM_sec_offset
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	28                              # DW_AT_const_value
	.byte	13                              # DW_FORM_sdata
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	23                              # DW_FORM_sec_offset
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	1                               # DW_TAG_array_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	33                              # DW_TAG_subrange_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	55                              # DW_TAG_restrict_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                               # DWARF version number
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	8                               # Address Size (in bytes)
	.byte	1                               # Abbrev [1] 0xb:0xeb DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.long	.Linfo_string1                  # DW_AT_INTEL_comp_flags
	.short	29                              # DW_AT_language
	.long	.Linfo_string2                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string3                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2e:0x91 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string7                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	17                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0x15 DW_TAG_enumeration_type
	.long	191                             # DW_AT_type
	.byte	4                               # DW_AT_byte_size
	.byte	1                               # DW_AT_decl_file
	.byte	29                              # DW_AT_decl_line
	.byte	4                               # Abbrev [4] 0x4b:0x6 DW_TAG_enumerator
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_const_value
	.byte	4                               # Abbrev [4] 0x51:0x6 DW_TAG_enumerator
	.long	.Linfo_string6                  # DW_AT_name
	.byte	1                               # DW_AT_const_value
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0x58:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	17                              # DW_AT_decl_line
	.long	191                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x67:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	17                              # DW_AT_decl_line
	.long	191                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x76:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	18                              # DW_AT_decl_line
	.long	198                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x85:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string13                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	18                              # DW_AT_decl_line
	.long	228                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x94:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc4                    # DW_AT_location
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	18                              # DW_AT_decl_line
	.long	233                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xa3:0xc DW_TAG_variable
	.byte	0                               # DW_AT_const_value
	.long	.Linfo_string15                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	20                              # DW_AT_decl_line
	.long	238                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0xaf:0xf DW_TAG_variable
	.long	.Ldebug_loc5                    # DW_AT_location
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	20                              # DW_AT_decl_line
	.long	238                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0xbf:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	9                               # Abbrev [9] 0xc6:0x5 DW_TAG_pointer_type
	.long	203                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0xcb:0xb DW_TAG_array_type
	.long	214                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0xd0:0x5 DW_TAG_subrange_type
	.long	221                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0xd6:0x7 DW_TAG_base_type
	.long	.Linfo_string11                 # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	12                              # Abbrev [12] 0xdd:0x7 DW_TAG_base_type
	.long	.Linfo_string12                 # DW_AT_name
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # DW_AT_encoding
	.byte	13                              # Abbrev [13] 0xe4:0x5 DW_TAG_restrict_type
	.long	233                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0xe9:0x5 DW_TAG_pointer_type
	.long	214                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xee:0x7 DW_TAG_base_type
	.long	.Linfo_string16                 # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang based Intel(R) oneAPI DPC++/C++ Compiler 2025.3.2 (2025.3.2.20260112)" # string offset=0
.Linfo_string1:
	.asciz	" --intel -O2 -x Host -S multiply.c -o multiply.s -g -O2 -fveclib=SVML" # string offset=76
.Linfo_string2:
	.asciz	"multiply.c"                    # string offset=146
.Linfo_string3:
	.asciz	"/nfs/site/home/ashadrin/demo_materials/icx_demo/Intel-Compiler-Workshop/lab4/c/03-restrict" # string offset=157
.Linfo_string4:
	.asciz	"unsigned int"                  # string offset=248
.Linfo_string5:
	.asciz	"inc_i"                         # string offset=261
.Linfo_string6:
	.asciz	"inc_j"                         # string offset=267
.Linfo_string7:
	.asciz	"matvec"                        # string offset=273
.Linfo_string8:
	.asciz	"rows"                          # string offset=280
.Linfo_string9:
	.asciz	"cols"                          # string offset=285
.Linfo_string10:
	.asciz	"a"                             # string offset=290
.Linfo_string11:
	.asciz	"double"                        # string offset=292
.Linfo_string12:
	.asciz	"__ARRAY_SIZE_TYPE__"           # string offset=299
.Linfo_string13:
	.asciz	"b"                             # string offset=319
.Linfo_string14:
	.asciz	"x"                             # string offset=321
.Linfo_string15:
	.asciz	"i"                             # string offset=323
.Linfo_string16:
	.asciz	"int"                           # string offset=325
.Linfo_string17:
	.asciz	"j"                             # string offset=329
	.ident	"Intel(R) oneAPI DPC++/C++ Compiler 2025.3.2 (2025.3.2.20260112)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
