#include <stdio.h> 
#include <stdlib.h> 
#include <errno.h> 
#include <sys/ioctl.h> 
#include <sys/types.h> 
#include <sys/stat.h> 
#include <fcntl.h> 
#include <unistd.h> 
#include <linux/dvb/frontend.h> 
 
#define FRONTENDDEVICE "/dev/dvb/adapter%d/frontend%d" 
 
static char *usage_str = 
"\nusage: getLevel" 
" -a number : use given adapter (default 0)\n" 
" -f number : use given frontend (default 0)\n"; 
 
int main(int argc, char *argv[]) { 

	unsigned int adapter = 0, frontend = 0; 
	unsigned short int signal; 
	int fefd, opt; 
	char fedev[128]; 

	while ((opt = getopt(argc, argv, "ha:f:")) != -1) {
 		switch (opt) {
 			case '?':
 			case 'h':
 			default:
 				fprintf(stderr,"%s",usage_str);
	 			return 1;
 			case 'a':
 				adapter = strtoul(optarg, NULL, 0);
 				break;
 			case 'f':
 				frontend = strtoul(optarg, NULL, 0); break;
 		}
	}
 
snprintf(fedev, sizeof(fedev), FRONTENDDEVICE, adapter, frontend);

if ((fefd = open(fedev, O_RDONLY | O_NONBLOCK)) < 0) {
 	perror("opening frontend failed");
 	return 1;
}
 
if (ioctl(fefd, FE_READ_SIGNAL_STRENGTH, &signal) == -1){
 	fprintf(stderr,"IOCTL failed\n");
 	return 1;
}

close(fefd);
printf("%u\n",signal);
return 0;
}
