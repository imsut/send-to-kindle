#!/bin/bash

recipe=
title="No Title"
gmail=
gmail_password=
kindle_email=

# account to access the contents (optional)
username=
password=

while getopts "r:t:g:q:k:u:p:" o; do
    case "$o" in
        r)
            recipe=$OPTARG
            ;;
        t)
            title=$OPTARG
            ;;
        g)
            gmail=$OPTARG
            ;;
        q)
            gmail_password=$OPTARG
            ;;
        k)
            kindle_email=$OPTARG
            ;;
        u)
            username=$OPTARG
            ;;
        p)
            password=$OPTARG
            ;;
        *)
            echo "Usage: $0 ..."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$recipe" ]; then
    echo "Recipe must be specified with -r option."
    exit 1
fi

if [ -z "$gmail" ]; then
    echo "Gmail address must be specified with -g option."
    exit 1
fi

if [ -z "$gmail_password" ]; then
    echo "Gmail password must be specified with -q option."
    exit 1
fi

if [ -z "$kindle_email" ]; then
    echo "Kindle email must be specified with -k option."
    exit 1
fi

if [ -n "$username" -a -n "$password" ]; then
    moreopts="--username $username --password $password"
else
    moreopts=""
fi


mobi=/tmp/file.mobi

echo "# Generating a mobi file with \"$recipe\"..."
ebook-convert \
    "$recipe" \
    $mobi \
    --output-profile=kindle_pw \
    --keep-ligatures \
    --smarten-punctuation

echo "# Sending the mobi file to Kindle ($kindle_email)..."
calibre-smtp \
    -a $mobi \
    -s "$title" \
    -r smtp.gmail.com \
    --port=587 \
    -u $gmail \
    -p $gmail_password \
    $gmail \
    $kindle_email \
    ""

echo "# Done."
