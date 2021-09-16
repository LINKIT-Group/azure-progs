#!/bin/sh

HOME="/home"

if [ -z "$UID" ] || [ -z "$USER" ];then
    UID=0
    USER=root
fi

if [ $UID != 0 ] && [ $USER != 'root' ];then
    [ -z "$GID" ] && GID=$UID
    groupadd -r $USER -g $GID \
    && useradd -r -l -N -s /usr/sbin/nologin -d $HOME \
        -u $UID -g $GID $USER \
    && chown $USER:$USER $HOME \
    && exec gosu $USER /bin/bash -l
else
    /bin/bash -l
fi
