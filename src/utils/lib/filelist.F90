!############################# Change Log ##################################
! 2.0.0
!
!###########################################################################
!  Copyright (C)  1990, 1995, 1999, 2000, 2003 - All Rights Reserved
!  Regional Atmospheric Modeling System - RAMS
!###########################################################################

! Newer version that just uses ls and C to form unique filenames

!!$subroutine RAMS_filelist(fnames, file_prefix, nfile)
!!$
!!$  implicit none
!!$  include "files.h"
!!$  integer :: nfile
!!$  integer, parameter :: maxfiles=2000 !According to src/brams/memory/grid_dims.f90
!!$  character(len=f_name_length) :: fnames(maxfiles), file_prefix
!!$  
!!$  character(len=f_name_length) :: file, command, cdir
!!$  character(len=30) :: tmpname
!!$  
!!$  integer :: iflag, iprelen, nc, nf, iun
!!$
!!$! this version uses nfile as flag for whether to stop if no files exist
!!$! if nfile.ge.0, then stop
!!$
!!$  iflag = nfile
!!$
!!$  nfile = 0
!!$
!!$  iprelen = len_trim(file_prefix)
!!$  if (iprelen==0) iprelen = len(file_prefix)
!!$      
!!$#if defined (PC_NT1)
!!$
!!$  ! First change all "/" to "\" so same namelist can be used 
!!$  !   for Unix/Linux/Windows
!!$   
!!$  do nc=1,iprelen
!!$     if (file_prefix(nc:nc)=='/') file_prefix(nc:nc) = '\'
!!$  enddo
!!$
!!$  command=  &
!!$       'dir /b '//file_prefix(1:len_trim(file_prefix))//' >c:\temp\RAMS_filelist'
!!$  call system(command)
!!$   
!!$  ! open the directory list
!!$ 
!!$  iun=98
!!$  open(unit=iun,file='c:\temp\RAMS_filelist',status='old',err=15)
!!$ 
!!$  ! read through the files
!!$  ! windows doesn't put directory names on "dir", so...
!!$
!!$  do nc=len_trim(file_prefix),1,-1
!!$     if(file_prefix(nc:nc).eq.'\') then
!!$         lndir=nc
!!$         cdir=file_prefix(1:lndir)
!!$         goto 25
!!$      endif
!!$   enddo
!!$   lndir=2
!!$   cdir='.\'
!!$25 continue
!!$   
!!$   do nf=1,maxfiles !1000000
!!$      read(iun,'(a128)',end=30,err=30) file
!!$      fnames(nf) = cdir(1:lndir)//file
!!$   enddo
!!$ 
!!$30 continue
!!$
!!$   close(iun)
!!$
!!$   command= 'del c:\temp\RAMS_filelist'
!!$   call system(command)
!!$      
!!$#else
!!$
!!$   ! Let C determine a unique filename
!!$   tmpname = '/tmp/XXXXXX'//char(0)
!!$   call form_tmpname(tmpname)
!!$ 
!!$
!!$   command = '/bin/ls -1 '//file_prefix(1:iprelen)//' > '//tmpname
!!$   call system(command)
!!$   command = 'chmod 777 '//tmpname
!!$   call system(command)
!!$
!!$   ! open the directory list and read through the files
!!$ 
!!$   iun = 98
!!$   open(unit=iun, file=tmpname, status='unknown', err=15)
!!$   rewind iun
!!$
!!$   do nf=1, maxfiles !1000000
!!$      read(iun,'(a128)',end=30,err=30) file
!!$      fnames(nf) = file
!!$   enddo
!!$      
!!$30 continue
!!$
!!$   close(iun)
!!$
!!$   command= '/bin/rm -f '//tmpname
!!$   call system(command)
!!$
!!$#endif
!!$
!!$   nfile = nf-1
!!$
!!$   if (nfile==0) then
!!$      print *, 'No RAMS files for prefix:',file_prefix
!!$      if (iflag>=0) call fatal_error('RAMS_filelist-no_files')
!!$   endif
!!$
!!$   return 
!!$      
!!$15 print *, 'RAMS_filelist: Error opening temporary RAMS_filelist'
!!$   call fatal_error('RAMS_filelist-/tmp file error : run again')
!!$   return
!!$      
!!$100 continue
!!$
!!$   return
!!$end subroutine RAMS_filelist
!!$
