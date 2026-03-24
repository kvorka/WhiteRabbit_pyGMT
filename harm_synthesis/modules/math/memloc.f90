module memloc
  use iso_fortran_env, only: dbl => real64
  use iso_c_binding,   only: c_ptr, c_sizeof, c_f_pointer
  implicit none; public
  
#if defined ( mem32 )
  integer, parameter :: alig = 32  !! avx2 alignement
#else
  integer, parameter :: alig = 16  !! default alignement fallback to SSE
#endif
  
  interface
    type(c_ptr) function malloc(alignement, n) bind(C, name='aligned_alloc')
      import         :: c_ptr
      integer, value :: alignement, n
    end function malloc
    
    subroutine free(ptr) bind(C, name="free")
      import             :: c_ptr
      type(c_ptr), value :: ptr
    end subroutine free
  end interface
  
end module memloc