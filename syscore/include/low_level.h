// 8 bit read and write
unsigned char port_byte_in(unsigned short port);
void port_byte_out(unsigned short port, unsigned char data);

// 16 bit read and write
unsigned short port_word_in(unsigned short port);
void port_word_out(unsigned short port, unsigned short data);
