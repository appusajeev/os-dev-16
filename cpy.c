#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>
int main(int argc,char *argv[])
{
	int i,size,k=2,ftab,sect=3;

	char buf[512];
	char vbuf;
	int dev,fil_descr,off=0;

	fil_descr=open(argv[2],O_RDONLY);
	assert(fil_descr>0);
	read(fil_descr,buf,512);
	close(fil_descr);

	printf("Bootsector file: %s\n",argv[2]);
	

	dev=open(argv[1],O_RDWR);
	assert(dev>0);
	write(dev,buf,512);


	ftab = open("filetable",O_CREAT|O_RDWR);
	sprintf(buf,"{");
	write(ftab,buf,1);
	
	for(i=3;i<argc;i++)
	{	
		

		off=off+ (k * 512);
		lseek(dev,off,SEEK_SET);
		fil_descr=open(argv[i],O_RDONLY);
		assert(fil_descr>0);
		size=0;		
		while((read(fil_descr,&vbuf,1))!=0) 
		{
			size++;
			write(dev,&vbuf,1);
		
		}
		k = (size>512)?2:1;

		sprintf(buf,"%s-%d,",argv[i],sect);
		write(ftab,buf,strlen(buf));
		printf("Input file \'%s\' written at offset %d\n",argv[i],off);
		close(fil_descr);
	
		sect = sect + k;
	}
	sprintf(buf,"}");
	write(ftab,buf,1);

	lseek(ftab,0,SEEK_SET);
	read(ftab,buf,512);

	lseek(dev,512,SEEK_SET);
	write(dev,buf,512);	
	close (dev);
	close(ftab);	
}
