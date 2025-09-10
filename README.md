# sushi

hello vros from SIT IS. this was created for my NYP CSAD test as practice, but the concepts taught here are quite fundamental and good to know, so it's good practice for the future pentesting module.

build:

    sudo docker build . -t cane:sushi

run:

    sudo docker run --rm cane:sushi

flag format: 
 
	CANE{...}

then to begin, just identify the ip the docker is running on, and `nmap` it.
8 flags in total, happy pwning
