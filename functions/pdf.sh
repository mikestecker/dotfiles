#!/usr/bin/env bash

# PDF optimization
optipdf() {
  local pdf=$1
  local res="$(basename $pdf .pdf)-optimized.pdf"
  noglob gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -sOutputFile=$res $pdf
  local opti_size=$(du -k $res | cut -f1)
  local size=$(du -k $pdf | cut -f1)
  if [[ "$opti_size" -lt "$size" ]]; then
    echo " => optimized PDF of smaller size ($opti_size vs. $size) thus overwrite $pdf"
    mv $res $pdf
    git commit -s -m "reduce size of PDF '$pdf'" $pdf
  else
    echo " => already optimized PDF thus discarded"
    rm -f $res
  fi
}
alias reducepdf='optipdf'
alias optipng='optipng -o9 -zm1-9 -strip all'
alias optijpg='jpegoptim'
