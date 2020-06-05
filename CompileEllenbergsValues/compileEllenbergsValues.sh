#! /bin/bash

## Convert UTB's pdf of Ellenberg's indicator values into structured csv files.


################################################################################
## Download the pdf if necessary
if [ ! -f zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf ]; then
    echo "File not found in directory, download now:"
    wget https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf
fi


################################################################################
## Vascular plants
## Convert the pdf to csv within the range for vascular plants
pdftotext -layout -f 7 -l 67 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_VascularPlants.csv


## Format the csv
sed -i -r 's/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    /Zeigerwerte|Angaben/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    s/aqua-/aquatica)/g # complete Veronica [...] aquatica
    /^tica/d # delete line with hyphenated remainder
    s/Cuscuta lupuliformis *x *6 *6 *8 *8 *0 *Tvp *S/Cuscuta lupuliformis  x  6  6  8  -  8  0  Tvp  S/ # fill gap in C. lupuliformis
    s/nummularium ovatum \(num\. obs\.\) 8/nummularium ovatum \(num\. obs\.\)\t8/g # Add tab after Helianthemum n.
    $ d' Ellenberg_VascularPlants.csv # delete last line


sed -i '2,${ /Name/d }' Ellenberg_VascularPlants.csv # skip first line and remove all lines with keyword


## Replace multiple spaces with tabs (yields a tab delimited csv)
sed -i -r 's/\s{2,}/\t/g' Ellenberg_VascularPlants.csv


## Ensure tab for last column by negative lookbehind to comma (?<!,)
perl -i -pe 's/(?<!,) I/\tI/g' Ellenberg_VascularPlants.csv
perl -i -pe 's/(?<!,) W/\tW/g' Ellenberg_VascularPlants.csv
perl -i -pe 's/(?<!,) S/\tS/g' Ellenberg_VascularPlants.csv
perl -i -pe 's/(?<!,) V/\tV/g' Ellenberg_VascularPlants.csv



################################################################################
## Bryophyta
## Convert the pdf to csv within the range for Bryophyta
pdftotext -layout -f 68 -l 98 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_Bryophyta.csv


## Format the csv
sed -i -r '1,9d # remove first 9 lines
    s/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    s/rh\+D497aptocarpa/rhaptocarpa/ # correct character encoding
    /Zeigerwerte/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    $ d' Ellenberg_Bryophyta.csv # delete last line

sed -i '2,${ /Name/d }' Ellenberg_Bryophyta.csv # skip first line and remove all lines with keyword


## Replace multiple spaces with tabs (yields a tab delimited csv)
sed -i -r 's/\s{2,}/\t/g' Ellenberg_Bryophyta.csv


################################################################################
## Lichens
## Convert the pdf to csv within the range for vascular plants
pdftotext -layout -f 99 -l 110 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_Lichens.csv


## Format the csv
sed -i -r '1,12d # remove first 12 lines
    s/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    /Zeigerwerte/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    $ d' Ellenberg_Lichens.csv # delete last line

sed -i '2,${ /Name/d }' Ellenberg_Lichens.csv # skip first line and remove all lines with keyword


## Replace multiple spaces with tabs (yields a tab delimited csv)
sed -i -r 's/\s{2,}/\t/g' Ellenberg_Lichens.csv


################################################################################
