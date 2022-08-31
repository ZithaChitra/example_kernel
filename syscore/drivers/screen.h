// screen driver "interface" file

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// Attribute byte for our default color scheme
#define WHITE_ON_BLACK 0x0f


// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

// print char on screen at col, row, or at cursor position
void print_char(char character, int col, int row, char attribute_byte);

int get_screen_offset(int col, int row);

int get_cursor();

void set_cursor(int offset);

void print_at(char* message, int col, int row);

void print(char* message);

void clear_screen();

int handle_scrolling(int cursor_offset);


