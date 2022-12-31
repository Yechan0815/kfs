#include <init.h>

struct vga_terminal terminal;

static uint8_t vga_color(enum vga_color fore, enum vga_color back) 
{
	return (back << 4) | fore;
}

static uint16_t vga_cell (unsigned char character, uint8_t color)
{
	return (uint16_t) (color << 8) | (uint16_t) character;
}

static void screen_init ()
{
	terminal.buffer = (uint16_t *) 0xB8000;
	terminal.x = 0;
	terminal.y = 0;
	for (uint8_t y = 0; y < VGA_HEIGHT; ++y)
	{
		for (uint8_t x = 0; x < VGA_WIDTH; ++x)
		{
			terminal.buffer[y * VGA_WIDTH + x] = vga_cell (' ', vga_color (VGA_COLOR_WHITE, VGA_COLOR_BLACK));
		}
	}
}

static void screen_putchar (char c, uint8_t color)
{
	int index;

	index = terminal.y * VGA_WIDTH + terminal.x;
	terminal.buffer[index] = vga_cell (c, color);
	++terminal.x;
	if (terminal.x >= VGA_WIDTH)
	{
		terminal.x = 0;
		++terminal.y;
	}
}

static void screen_putstr (char * str, uint8_t color)
{
	int length;

	length = 0;
	while (*(str + length))
	{
		screen_putchar (*(str + length), color);
		++length;
	}
}

void start_kernel ()
{
	screen_init ();

	screen_putstr ("test message", vga_color (VGA_COLOR_WHITE, VGA_COLOR_BLACK));
}
