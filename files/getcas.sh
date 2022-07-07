#!/bin/bash
url="https://casinit.herokuapp.com/starter.tgz"
projectType="cas-overlay"
dependencies=""
directory="overlay"
for arg in $@; do
  case "$arg" in
  --url|-u)
    url=$2
    shift 1
    ;;
  --type|-t)
    projectType=$2
    shift 1
    ;;
  --directory|--dir|-d)
    directory=$2
    shift 1
    ;;
  --casVersion|--cas)
    casVersion="-d casVersion=$2"
    shift 1
    ;;
  --bootVersion|--springBootVersion|--boot)
    bootVersion="-d bootVersion=$2"
    shift 1
    ;;
  --modules|--dependencies|--extensions|-m)
    dependencies="-d dependencies=$2"
    shift 1
    ;;
  *)
    shift
    ;;
  esac
done
rm -Rf ./${directory}
echo -e "Generating project ${projectType} with dependencies ${dependencies}..."
cmd="curl ${url} -d type=${projectType} -d baseDir=${directory} ${dependencies} ${casVersion} ${bootVersion} | tar -xzvf -"
echo -e "${cmd}"
eval "${cmd}"
ls
