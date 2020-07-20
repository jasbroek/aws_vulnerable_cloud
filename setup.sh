#!/bin/bash
ssh-keygen -b 4096 -t rsa -f ./assets/keys/ssh_key -q -N ""
chmod 400 ./assets/keys/ssh_key
