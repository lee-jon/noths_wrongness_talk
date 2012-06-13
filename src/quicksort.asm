.text
.global _quicksort
.equ arr,8
.equ lower,12
.equ upper, 16
	#;;  reminder that [ebp+8] is start address, [ebp+12] is end address of partition
_quicksort:
	push %ebp
	mov %ebp,%esp
	#pushad

	movl %ebx,12(%ebp)		#; start of partition
	#;;  find pivot index:
ploop:
	cmp %ebx,16(%ebp)	#;  last cell of partition?
	jge qretrn		#;  no pivot, so exit
	movl %eax, 4(%ebx)	#;  A[i+1]
	cmp %eax, (%ebx)		#;  A[i]
	jl pfound		#;  A[i]>A[i+1], pivot found
	addl %ebx,4		#;  next cell
	jmp ploop
pfound:
	#;;  at this point, ebx holds mem address of pivot
	#;;  now partition into < and >= pivot via repeated swapping.
	#;;  use two counters:	 ebx and esi.  ebx always points to the
	#;;  first cell of second partition (what's >= pivot)
	movl %ecx,(%ebx)		#;  save pivot in ecx
	movl %esi,%ebx
	addl %esi,4		#;  next cell
tloop:				#;  partitioning loop
	cmp %ecx,(%esi)		#;  compare pivot against element
	jle noswap		#;  no swap if element >=pivot
	#;;  swap [ebx] and [esi], advance both
	movl %eax,(%ebx)
	pushl %eax		#;  use stack as temp
	movl %eax,(%esi)
	movl (%ebx),%eax
	popl %eax
	movl (%esi),%eax		#;  done swap
	addl %ebx,4		#;  next cell must still be >= pivot
noswap:
	addl %esi,4		#;  goto next cell, preserve ebx
	cmp %esi,16(%ebp)	#;  end of partition?
	jle tloop		#;  next iteration of partition loop

	#;;  at this point, ebx holds start addr of second partition
	#;;  (could be pivot itself).
	#;;  make recursive calls to quickaux:

	#;;  first partition:
	subl %ebx,4
	pushl %ebx		#;  end of first paritition
	movl %eax,12(%ebp)
	pushl %eax		#;  start of first partition
	call _quicksort
	addl %esp,8		#;  deallocate params
	#;;  second partition
	movl %eax,16(%ebp)
	pushl %eax		#;  end of second partition
	addl %ebx,4
	push %ebx		#;  start of second partition
	call _quicksort
	addl %esp,8

qretrn:
	#popad
	movl %esp,%ebp
	popl %ebp
	ret
#quickaux endp


	#;;  the quicksort procedure is just a wrapper around quickaux,
	#;;  for ease of integration into high level language.
	#;; void quicksort(int *A, int start, int end)
#quicksort proc
	pushl %ebp
	movl %ebp,%esp
	#pushad
	movl %ebx,8(%ebp)		#;  start addr of array
	movl %eax,16(%ebp)	#;  end index of partition
	imull %eax		#2;  multiply by 4: sizeof(int)==4
	addl %eax,%ebx		#;  eax holds end addr of partition
	movl %ecx,12(%ebp)	#;  start index of partition
	imull %ecx#2
	addl %ecx,%ebx		#;  start addr of partition
	pushl %eax		#;  quickaux expects start and end
	pushl %ecx		#;    addresses of partition as arguments.
	call _quicksort
	addl %esp,8
	#popad
	movl %esp,%ebp
	popl %ebp
	ret
#quicksort endp
#end
