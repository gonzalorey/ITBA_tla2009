#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char * argv[])
{
	int pid;
	char buf1[200], buf2[200];

	if(argc != 3)
	{
		printf("Wrong number of arguments\n");
		exit(1);
	}
	
	if((pid = fork()) < 0)
	{
		perror("fork");
		exit(1);
	}
	
	/* build the first command using the file from the first arg */
	sprintf(buf1, "cat %s | ./pre > ./samples/trans-file.txt", argv[1]);
	sprintf(buf2, "cat ./samples/trans-file.txt | ./post > %s", argv[2]);
	
	if(pid != 0)
	{
		/* I'm the parent */
		system(buf1);
		sleep(1);
	}
	else
	{
		/* I'm the child */
		sleep(1);
		system(buf2);
	}
	
	return 0;
}