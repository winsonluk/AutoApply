#!/bin/bash
DATE="$(date +%H)"
if [ $DATE -lt 12 ]; then
  time="morning"
elif [ $DATE -lt 18 ]; then
  time="afternoon"
else
  time="evening"
fi
day="$(date -v+3d -v+tue +%m\/%d)"
day="${day:1}"
echo -e "EMAIL? (y/n): \c "
read email
if [ "$email" == "y" ]; then
  echo -e "UCSD? (y/n): \c "
  read ucsd
  if [ "$ucsd" == "y" ]; then
    echo -e "NAME: \c "
    read name
    echo -e "COMPANY: \c "
    read company
    echo -e "SOURCE: \c "
    read source
    EMAIL="$(sed -e "s#NAME#$name#g" -e "s#TIME#$time#" -e "s#DAY#$day#g" -e "s#COMPANY#$company#g" -e "s#SOURCE#$source#" src/Email/ucsdEmail.txt)"
  else
    echo -e "NAME: \c "
    read name
    echo -e "COMPANY: \c "
    read company
    echo -e "ADDRESS: \c "
    read address
    echo -e "CITY: \c "
    read city
    echo -e "STATE: \c "
    read state
    echo -e "ZIP: \c "
    read zip
    echo -e "ROLE: \c "
    read role
    EMAIL="$(sed -e "s#NAME#$name#g" -e "s#TIME#$time#" -e "s#DAY#$day#g" -e "s#COMPANY#$company#g" src/Email/recruiterEmail.txt)"
    cp -r src/Cover\ Letter/* .
    sed -i'' -e "s#COMPANY#$company#g" coverletter.tex
    sed -i'' -e "s#ADDRESS#$address#g" coverletter.tex
    sed -i'' -e "s#CITY#$city#g" coverletter.tex
    sed -i'' -e "s#STATE#$state#g" coverletter.tex
    sed -i'' -e "s#ZIP#$zip#g" coverletter.tex
    sed -i'' -e "s#ROLE#$role#g" coverletter.tex
    xelatex coverletter.tex
    sed -i '/About/,$!d' coverletter.tex
    sed -i '/office/q' coverletter.tex
    sed -i 's/\\lettersection{//g' coverletter.tex
    sed -i 's/}//g' coverletter.tex
    sed -i 's/\\//g' coverletter.tex
    sed -i'' -e "/Why/{n;d}" coverletter.tex
    mv coverletter.pdf output
    mv coverletter.tex output
    rm awesome-cv.cls circle.yml coverletter.* fontawesome.sty icon.png Makefile
    rm -rf fonts 2> /dev/null; rm -rf fonts
  fi
else
    echo -e "COMPANY: \c "
    read company
    echo -e "ADDRESS: \c "
    read address
    echo -e "CITY: \c "
    read city
    echo -e "STATE: \c "
    read state
    echo -e "ZIP: \c "
    read zip
    echo -e "ROLE: \c "
    read role
    cp -r src/Cover\ Letter/* .
    sed -i'' -e "s#COMPANY#$company#g" coverletter.tex
    sed -i'' -e "s#ADDRESS#$address#g" coverletter.tex
    sed -i'' -e "s#CITY#$city#g" coverletter.tex
    sed -i'' -e "s#STATE#$state#g" coverletter.tex
    sed -i'' -e "s#ZIP#$zip#g" coverletter.tex
    sed -i'' -e "s#ROLE#$role#g" coverletter.tex
    xelatex coverletter.tex
    sed -i '/About/,$!d' coverletter.tex
    sed -i '/office/q' coverletter.tex
    sed -i 's/\\lettersection{//g' coverletter.tex
    sed -i 's/}//g' coverletter.tex
    sed -i 's/\\//g' coverletter.tex
    sed -i'' -e "/Why/{n;d}" coverletter.tex
    mv coverletter.pdf output
    mv coverletter.tex output
    rm awesome-cv.cls circle.yml coverletter.* fontawesome.sty icon.png Makefile
    rm -rf fonts 2> /dev/null; rm -rf fonts
fi
cp src/Resume/WinsonLuk_Resume.pdf output
cp src/Transcript/WinsonLuk_UnofficialTranscript.pdf output
cp src/Transcript/WinsonLuk_OfficialTranscript.pdf output
cat output/coverletter.tex | clip.exe
cat output/coverletter.tex | pbcopy
if [ "$email" == "y" ]; then
    echo "${EMAIL}"
fi
