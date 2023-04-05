#!/bin/sh

pwd

mkdir tmp
cp -r ./data/* ./tmp

cd tmp

echo '###############################################################'
echo '[Default tesseract output]'
echo 'tesseract foo.bar.exp0.tif stdout -l eng --psm 6'
echo ' '
tesseract foo.bar.exp0.tif stdout -l eng --psm 6

echo ' '
echo '###############################################################'
echo '[Train tesseract]'

echo '-------------------'
echo '2) ...'
tesseract foo.bar.exp0.tif foo.bar.exp0 --psm 6 box.train

echo '-------------------'
echo '3) ...'
unicharset_extractor foo.bar.exp0.box

echo '-------------------'
echo '4) ...'
echo "bar 0 0 0 0 0" > font_properties

echo '-------------------'
echo '5) ...'
mftraining -F font_properties -U unicharset -O foo.unicharset foo.bar.exp0.tr
cntraining foo.bar.exp0.tr

echo '-------------------'
echo '6) ...'
mv shapetable foo.shapetable
mv inttemp foo.inttemp
mv pffmtable foo.pffmtable
mv normproto foo.normproto
combine_tessdata foo.

echo '-------------------'
echo 'Setup tessdata with foo.traineddata'
cp ./foo.traineddata ./tessdata

echo '###############################################################'
echo '[Trained tesseract output]'
echo 'tesseract foo.bar.exp0.tif stdout -l foo --psm 6 --tessdata-dir ./tessdata/'
echo ' '
tesseract foo.bar.exp0.tif stdout -l foo --psm 6 --tessdata-dir ./tessdata/

# return back
cd ../