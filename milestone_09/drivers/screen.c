#include "screen.h"
#include "low_level.h"
#include "../kernel/util.h" 

//	Private Functions
//	These would not be exposed to the kernel.
void print_char(char character, int col, int row, char attribute_byte);
int get_cursor();
void set_cursor(int offset);
int get_screen_offset(int col, int row);
int handle_scrolling(int cursor_offset);

//	Implemetation
void print_char(char character, int col, int row, char attribute_byte)
{
	unsigned char* vidmem = (unsigned char*) VIDEO_ADDRESS;
	
	if(!attribute_byte) {
		attribute_byte = WHITE_ON_BLACK;
	}

	int offset = 0;
	
	if(col >= 0 && row >= 0) {
		offset = get_screen_offset(col, row);
	} else {
		offset = get_cursor();
	}

	if (character == '\n') {
		row = offset / (2*MAX_COLS); 
		offset = get_screen_offset(0, row+1);
	} else {
		vidmem[offset] = character;
		vidmem[offset + 1] = attribute_byte;
		offset += 2;
	}


	offset = handle_scrolling(offset);

	set_cursor(offset);
}

int get_screen_offset(int col, int row)
{
	return 2*(row*MAX_COLS + col);
}

int get_cursor()
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;

	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);

	return offset*2;
	
}

void set_cursor(int offset)
{
	offset /= 2;

	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (offset >> 8));

	
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (offset & 0xff));
}

int handle_scrolling(int cursor_offset)
{
	if(cursor_offset < 2*MAX_COLS*MAX_ROWS)
		return cursor_offset;

	for (int i = 1; i < MAX_ROWS; i++)
		memory_copy(get_screen_offset(0, i) + VIDEO_ADDRESS,
			    get_screen_offset(0, i-1) + VIDEO_ADDRESS,
			    MAX_COLS*2);

	char* last_line = VIDEO_ADDRESS + get_screen_offset(0, MAX_ROWS-1);

	for (int i = 0; i < MAX_COLS*2; i++)
		last_line[i] = 0;

	cursor_offset -= 2*MAX_COLS;

	return cursor_offset;
}

//	Public Functions
//	These are the actual functions exposed to the kernel
void print_at(char* message, int col, int row)
{
	if(row >= 0 && col >= 0) {
		set_cursor(get_screen_offset(col, row));
	}

	for (int i = 0; message[i] != '\0'; i++) {
		print_char(message[i], -1, -1, WHITE_ON_BLACK);
	}
}

void print(char* message)
{
	print_at(message, -1, -1);
}

void clear_screen()
{
	for (int row = 0; row < MAX_ROWS; row++)
		for (int col = 0; col < MAX_COLS; col++)
			print_char(' ', col, row, WHITE_ON_BLACK);

	set_cursor(get_screen_offset(0, 0));

}

