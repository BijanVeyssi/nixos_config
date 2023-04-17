#! /bin/sh

if [ $(setxkbmap -query | grep layout | tr -d ' ' | cut -d: -f2) = 'us' ]; then
    setxkbmap us_intl
else
    setxkbmap us
fi
