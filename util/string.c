int strlen (const char * str)
{
	int length;

	length = 0;
	while (*(str + length))
		++length;
	return length;
}
