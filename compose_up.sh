#!/bin/bash

#mount working dir
if [ ! -d ./work ]; then
	mkdir work
fi

#pub key
cp ~/.ssh/authorized_keys id_rsa.pub

#make .env
./make_env.sh

#compose up
docker compose up -d