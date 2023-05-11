#!/usr/bin/env bash

if is_available mvn; then
    alias mvn-list='mvn fr.jcgay.maven.plugins:buildplan-maven-plugin:list'
fi
