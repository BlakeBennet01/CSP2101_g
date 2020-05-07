#!/bin/bash

#Name: Blake Bennett
#Student Number: 10496066
#Unit Name: Scripting Languages - CSP2101

if ! [ -f rectangle.txt ]; then
    echo -e "File 'rectangle.txt' does not exist\n"
    exit 0
else
    sed "1d" rectangle.txt > rectangle_f.txt
    count=0
    until (( $count >= 20 ));
    do
        IFS="," read name height width area colour
        sed -i -e "s/$name,$height,$width,$area,$colour/Name: $name\tHeight: $height\tWidth: $width\tArea: $area\tColour: $colour/" rectangle_f.txt
        count=$(($count + 1))
    done < rectangle_f.txt
fi

exit 0