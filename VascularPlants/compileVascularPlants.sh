#! /bin/bash

## Convert UTB Ellenberg's indicator values pdf into a structured txt.

## Download the pdf if necessary
if [ ! -f zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf ]; then
    echo "File not found, download now:"
    wget https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf
fi


## Convert the pdf to txt within the range for vascular plants
pdftotext -layout -f 7 -l 67 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_VascularPlants.txt


## Format the txt
sed -i -r 's/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    /Zeigerwerte|Angaben/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    s/aqua-/aquatica)/g # complete Veronica [...] aquatica
    /^tica/d # delete line with hyphenated remainder
    $ d' Ellenberg_VascularPlants.txt # delete last line

sed -i '2,${ /Name/d }' Ellenberg_VascularPlants.txt # starting with the second line, remove all lines with keyword


## Replace multiple spaces with tabs (yields a tab delimited txt)
sed -i -r 's/\s{2,}/\t/g' Ellenberg_VascularPlants.txt
