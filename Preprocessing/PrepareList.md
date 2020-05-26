# Prepare list of Ellenberg's values
## Download
Download the official list from [Uni-Taschenbücher](https://www.utb-shop.de/downloads/dl/file/id/27/zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf).

## Extract content
Convert the pdf into an open text file with [pdftotext](https://www.xpdfreader.com/pdftotext-man.html). The list with Ellenberg's values for vascular plants starts at page 7 and end with page 67.
```bash
pdftotext -layout -f 7 -l 67 zusatzkapitel_zeigerwerte_der_pflanzen_mitteleuropas.pdf EllenbergsValues.txt
```

## Format the text file
First, remove up to two spaces at the beginning of a line.
Next, remove all lines containing the keywords `Zeigerwerte` or `Angaben`.
Then, remove all but the first header.
And last, delimite the file by tabs by converting multiple spaces into tabs while keeping the single space in the taxon name.
```bash
for run in {1..2}; do sed -i 's/^\s//' EllenbergsValues.txt; done

sed -i -r '/^$/d # remove all empty lines
/Zeigerwerte|Angaben/d' EllenbergsValues.txt # remove all lines with keyword

sed -i '2,${ /Name/d }' EllenbergsValues.txt # starting with the second line, remove all lines with keyword
sed -i -r 's/\s{2,}/\t/g' EllenbergsValues.txt # replace multiple spaces with tabs
```
