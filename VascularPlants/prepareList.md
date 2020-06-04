# Prepare list of Ellenberg's values
## Download
Download the official list with Ellenberg's values for vascular plants, mosses and lichens from [Uni-Taschenbücher](https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf).

## Extract list for vascular plants
### Extract content
Convert the pdf into an open text file with [pdftotext](https://www.xpdfreader.com/pdftotext-man.html). The list with Ellenberg's values for vascular plants starts at page 7 and ends with page 67.
```bash
pdftotext -layout -f 7 -l 67 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf EllenbergsValues.txt
```

### Format the text file
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
    $ d' Ellenberg_VascularPlants.txt # delete last line

sed -i '2,${ /Name/d }' EllenbergsValues.txt # starting with the second line, remove all lines with keyword
sed -i -r 's/\s{2,}/\t/g' EllenbergsValues.txt # replace multiple spaces with tabs
```
