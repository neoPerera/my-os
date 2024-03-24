#include "screen.h"
#include "ports.h"

void set_cursor_offset(int offset);
int get_cursor_offset();
void print_newline();
extern void __cdecl kprint(const char *message,int offset);
extern void kprint_c(const char *character, int offset);
void clear_screen()
{
    char *video_memory = (char *)VIDEO_ADDRESS;
    for (int j = 0; j < MAX_ROWS; j++)
    {

        for (int i = 0; i <= MAX_COLS; i++)
        {
            *video_memory = '-';
            video_memory++;
            *video_memory = WHITE_ON_BLACK;
            video_memory++;
        }
    }
    set_cursor_offset(0);
}

void kprint_str(const char *message) {
    int offset = get_cursor_offset();
    kprint("A", offset);
    offset += 2;
    set_cursor_offset(offset);
    return;
  
}

void kprint_char(char *character)
{
    int offset = get_cursor_offset();
    char *c = character;
    kprint_c(c, offset);
    offset += 2;
    set_cursor_offset(offset);
    return;
    
}
void print_newline()
{
    int offset = get_cursor_offset();
    int row = offset / (2 * MAX_COLS); // Compute the row number

    // Calculate the starting address of the next line
    int end_offset = (row + 1) * (2 * MAX_COLS);
    char *video_memory = (char *)VIDEO_ADDRESS;
    video_memory += offset;

    for (offset; offset < end_offset; offset += 2)
    {
        *video_memory = ' ';
        *(video_memory + 1) = WHITE_ON_BLACK;
        video_memory += 2;
    }

    // Set the cursor offset to the beginning of the next line
    set_cursor_offset(end_offset);
}

void set_cursor_offset(int offset)
{
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

int get_cursor_offset()
{
    /* Use the VGA ports to get the current cursor position
     * 1. Ask for high byte of the cursor offset (data 14)
     * 2. Ask for low byte (data 15)
     */
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2; /* Position * size of character cell */
}
