#include <stdio.h>
#include <malloc.h>

char buf[100];
void MemoryDump(int start, int length)
{	
	void *vp = buf;
	int i = 0;
	while (i < length) {
		char *cp = ((char *)vp)+1;
		char c = *cp;
		printf("0x%2x	", c);
		i++;
	}
}



int main(int argc, char *argv[])	// Sample 10000 500 : // Command Ling ��ɾ�
									// 10000 : start �޸� �ּ�
									// 500	 : Dump�� �޸� ũ��
{
	int start = 0x09000000;
	int length = 500;
	char c = 'A';
	int	i = 10;
	float	a = 2.0;
	double	d = 3.14;
	//void *p = &i;		//���� �ּ��� ��
	void *p = malloc(100);	//Heap ������ �޸� ���� Ȯ�� / ���� �ٸ� �������� stack ������ ������

	*(double *)p = d;

	printf("c=	%8c		[0x%08x]\n",c, &c);
	printf("i =	%8d		[0x%08x]\n", i, &i);
	printf("a =	%8f		[0x%08x]\n", a, &a);
	printf("d =	%8lf	[0x%08x]\n", d, &d);
	printf("p =	%8lf	[0x%08x]\n", *(double*)p, &p);

	MemoryDump((int)buf, length);

	return 0;
}

