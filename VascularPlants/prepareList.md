# Prepare list of Ellenberg's values
To compile tab separated csv files with Ellenberg's values:
1. Download the list
1. Convert the pdf into an open text file with [pdftotext](https://www.xpdfreader.com/pdftotext-man.html).
1. Structure the text with [sed](https://www.gnu.org/software/sed/).

Separate files are created for vascular plants, Bryophyta and lichens as they differ in available indicators.
Later, they are merged into one file.

All steps are unified in `compileEllenbergsValues.sh` that is ready to run on a Linux shell.


## Download
Download the official list with Ellenberg's values for vascular plants, mosses and lichens from [Uni-Taschenbücher](https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf).

```bash
wget https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf
```

## Compile list for vascular plants
### Extract content
The list with Ellenberg's values for vascular plants starts at page 7 and ends at page 67.
```bash
pdftotext -layout -f 7 -l 67 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_VascularPlants.csv
```

### Format csv
First, remove leading space(s).
Next, remove all empty lines or those containing the keywords `Zeigerwerte` or `Angaben` and replace emdash '–' with regular dash '-'.
Then, complete the hyphenated *Veronica [...] aquatica*, delete line with its remainder in the following line and delete the last line.
Last, remove all but the first header and delimite the file by tabs by converting multiple spaces into tabs while keeping the single space in the taxon name.
```bash
sed -i -r 's/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    /Zeigerwerte|Angaben/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    s/aqua-/aquatica)/g # complete Veronica [...] aquatica
    /^tica/d # delete line with hyphenated remainder
    $ d' Ellenberg_VascularPlants.csv # delete last line

sed -i '2,${ /Name/d }' Ellenberg_VascularPlants.csv # skip first line and remove all lines with keyword
sed -i -r 's/\s{2,}/\t/g' Ellenberg_VascularPlants.csv # replace multiple spaces with tabs
```

## Compile list for Bryophyta
### Extract content
Convert the pdf into an open text file with [pdftotext](https://www.xpdfreader.com/pdftotext-man.html). The list with Ellenberg's values for Bryophyta starts at page 68 and ends at page 98.
```bash
pdftotext -layout -f 68 -l 98 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_Bryophyta.csv
```

### Format csv
First, remove the first nine lines and all leading space(s).
Correct the character encoding error in *Encalypta rhaptocarpa* var. *trachymitria*.
Next, remove all empty lines or those containing the keyword `Zeigerwerte` and replace emdash '–' with regular dash '-'.
Last, remove all but the first header and delimite the file by tabs by converting multiple spaces into tabs while keeping the single space in the taxon name.
```bash
sed -i -r '1,9d # remove first 9 lines
    s/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    s/rh\+D497aptocarpa/rhaptocarpa/ # correct character encoding
    /Zeigerwerte/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    $ d' Ellenberg_Bryophyta.csv # delete last line

sed -i '2,${ /Name/d }' Ellenberg_Bryophyta.csv # starting with the second line, remove all lines with keyword
sed -i -r 's/\s{2,}/\t/g' Ellenberg_Bryophyta.csv # replace multiple spaces with tabs
```

## Compile list for lichens
### Extract content
Convert the pdf into an open text file with [pdftotext](https://www.xpdfreader.com/pdftotext-man.html). The list with Ellenberg's values for lichens starts at page 99 and ends at page 110.
```bash
pdftotext -layout -f 99 -l 110 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf Ellenberg_Lichens.csv
```

### Format csv
First, remove the first twelfe lines and all leading space(s).
Next, remove all empty lines or those containing the keyword `Zeigerwerte` and replace emdash '–' with regular dash '-'.
Last, remove all but the first header and delimite the file by tabs by converting multiple spaces into tabs while keeping the single space in the taxon name.
```bash
sed -i -r '1,12d # remove first 12 lines
    s/^ *//g # remove leading space(s)
    /^$/d # remove all empty lines
    /Zeigerwerte/d # remove all lines with keyword
    s/–/-/g # replace emdash with dash
    $ d' Ellenberg_Lichens.csv # delete last line

sed -i '2,${ /Name/d }' Ellenberg_Lichens.csv # starting with the second line, remove all lines with keyword
sed -i -r 's/\s{2,}/\t/g' Ellenberg_Lichens.csv # replace multiple spaces with tabs
```
