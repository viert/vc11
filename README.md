# VC11

VC11 is a custom tiny kernel for ZX Spectrum machines written in C/ASM.

All code compiles with z88dk (http://z88dk.org). This work has nothing to do with the word "Production" so far, 
main features are described below:

* up to 8 processes working concurrently
* zero-process (kernel loop), still does nothing
* various system calls implemented like create_process(), switch_context(), reap_process()

TODO:
* putc() function implementation (to be able to use puts/printf library functions)
* getk() function to read from keyboard
* multipage processes
