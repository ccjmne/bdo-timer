#! /usr/bin/env bash

# Get only the following glyphs: 0123456789+-,.
readonly outfit=$(curl -L 'https://fonts.googleapis.com/css2?family=Outfit:wght@400&text=0123456789%2B-%2C.' | rg --pcre2 --no-line-number --no-column --only-matching '(?<=url\()[^)]+')

# Get only the following glyphs: ∞
readonly syne=$(curl -L 'https://fonts.googleapis.com/css2?family=Syne:wght@500&text=%E2%88%9E' | rg --pcre2 --no-line-number --no-column --only-matching '(?<=url\()[^)]+')

curl -L "$outfit" -o outfit.ttf
curl -L "$syne" -o syne.ttf

woff2_compress outfit.ttf
woff2_compress syne.ttf

rm *.ttf
mv *.woff2 static
