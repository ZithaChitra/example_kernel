// screen driver "implementation" file

#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/util.h"
#include "screen.h"

// print char on screen at col, row, or at cursor position
void
print_char(char character, int col, int row, char attribute_byte)
{
    unsigned char *vidmem = (unsigned char*) VIDEO_ADDRESS;

    if(!attribute_byte){
        attribute_byte = WHITE_ON_BLACK;
    }

    // get the video mem offset for the screen location
    int offset;
    // if col and row are non-negative use them for offset
    if(col >= 0 && row >= 0){
        offset = get_screen_offset(col, row);
        // otherwise use the current cursor position
    }else{
        offset = get_cursor();
    }


    // if we see a newline char, set offset to the end of
    // current row, so it will be advanced to the first col of next row
    if(character == '\n'){
        int rows = offset / (2 * MAX_COLS);
        // Otherwise write the char and it's attribute byte to 
        // video memory at our calculated offset
    }else{
        vidmem[offset] = character;
        vidmem[offset + 1] = attribute_byte;
    }


    // Update the offset to the next character cell, which is
    // is two bytes ahead of current cell 
    offset += 2;
    // make scrolling adjustment, for when we reach the bottom 
    // of the screen
    offset = handle_scrolling(offset);
    // update the cursor position on the screen device
    set_cursor(offset);
    return;

}

int
get_screen_offset(int col, int row)
{
    // TODO
    // This is similar to get_cursor, only now we write
    // bytes to those internal device registers.
    // port_byte_out(REG_SCREEN_CTRL, 14);
    // port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    // port_byte_out(REG_SCREEN_CTRL, 15);
}


int
get_cursor()
{
    // The device uses it's control register as an index
    // to select it's internal registers, of which we are
    // interested in.
    // reg 14: which is the high byte of the cursor 's offset
    // reg 15: which is the low byte of the cursor's offset
    // Once the internal register has been selected, we may read or 
    // write a byte on the data register.
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    // Since the character offset reported by the VGA hardware is the
    // number of characters, we multiply by two to convert it to 
    // a character cell offset.
    return offset * 2;
}



void
set_cursor(int offset)
{
    offset /= 2;    // Convert from cell offset to char offset
    // TODO
    // This is similar to get_cursor, only now we write 
    // bytes to those internal device registers
    return;
}


void
print_at(char* message, int col, int row)
{
    // update the cursor if row and col not negative
    if(col >= 0 && row >= 0){
        set_cursor(get_screen_offset(col, row));
    }
    // Loop through each char of the message and print it.
    int i = 0;
    while(message[i] != 0){
        print_char(message[i++], col, row, WHITE_ON_BLACK);
    }
    return;
}



void 
print(char* message)
{
    print_at(message, -1, -1);
}


void // clears screebn by writing blank characters at every position
clear_screen()
{
    int row = 0;
    int col = 0;

    /* Loop through video memory and write blank characters */
    for(row=0; row < MAX_ROWS; row++){
        for(col=0; col < MAX_COLS; col++){
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }

    // Move cursor back to the top left
    set_cursor(get_screen_offset(0, 0));
}





int /* Advance the text cursor , scrolling the video buffer if necessary . */
handle_scrolling(int cursor_offset)
{
    // If the cursor is within the screen, return it unmodified
    if(cursor_offset < MAX_ROWS * MAX_COLS * 2){
        return cursor_offset;
    }


    /* Shuffle the rows back one. */
    int i;
    for(i=1; i < MAX_ROWS; i++){
        memory_copy(get_screen_offset(0, i) + VIDEO_ADDRESS,
                    get_screen_offset(0, i-1) + VIDEO_ADDRESS,
                    MAX_COLS*2);

    }

    /* Blank the last line by setting all bytes to 0 */
    char * last_line = get_screen_offset (0 , MAX_ROWS -1) + VIDEO_ADDRESS ;
    for (i =0; i < MAX_COLS *2; i ++) {
        last_line [ i] = 0;
    }
    
    // Move the offset back one row , such that it is now on the last
    // row , rather than off the edge of the screen .
    cursor_offset -= 2* MAX_COLS ;
    // Return the updated cursor position .
    return cursor_offset ;

}





























