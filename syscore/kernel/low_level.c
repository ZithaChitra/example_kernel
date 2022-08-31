/*
    __I/O Programming__ (ref: https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

    So the question is how we read and write the registers of our
    device controllers (i.e tell our devices what to do) programatically?
    In Intel architecture systems the registers of device controllers are mapped
    into an I/O address space, that is different from main memory address space,
    then variants of the I/O instructions 'in' and 'out' are used to read and 
    write data to the I/O addresses that are mapped to specific controller registers.

    For example, the floppy disk controller usually has its DOR register mapped to
    I/O address 0x3f2, so we could switch on the motor of the first drive with the
    following instructions:

    mov dx, 0x3f2       ; Must use dx to store port address
    in al, dx           ; Read contents of port address
    or al, 00001000b    ; Switch on the motor bit
    out dx, al          Update DOR of the device


    A problem with I/O is that we cannot express the low-level instructions in 
    C language, so we use inline assembly. 
 */


unsigned char 
port_byte_in(unsigned short port)
{
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}


void 
port_byte_out(unsigned short port, unsigned char data)
{
    __asm__("out %%al, %%dx" : : "al" (data), "d" (port));
}


// unsigned short 
// port_word_in(unsigned short port)
// {
//     unsigned short result;
//     __asm__("in %%dx, %%ax" : "=ax" (result) : "dx" (port));
//     return result;
// }


unsigned short port_word_in ( unsigned short port ) {
unsigned short result ;
__asm__( "in %% dx , %% ax" : "=a" ( result ) : "d" ( port ));
return result ;
}

void
port_word_out(unsigned short port, unsigned short data)
{
    __asm__("out %%ax, %%dx" :  : "ax" (data), "dx" (port));
}












