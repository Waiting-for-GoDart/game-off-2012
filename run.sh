#!/bin/sh

rm -rf client
mkdir client
cp game.html client/
go run server/server.go