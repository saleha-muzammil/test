V Find(int key)
{
	int pos = HashFunc(key, htable->size);
	int collisions = 0;
	while (htable->table[pos].info != Empty &&
		htable->table[pos].element != key)
	{
		pos = pos + 2 * ++collisions - 1;
		if (pos >= htable->size)
			pos = pos - htable->size;
	}
	return pos;
}