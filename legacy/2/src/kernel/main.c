#define _MAIN_C

#include "include/types.h"
#include "include/print.h"
#include "include/kernel.h"

int main (void)
{
	cls();
	putstr("OS: Hello World!");
	while(true);
	return 0;
}
