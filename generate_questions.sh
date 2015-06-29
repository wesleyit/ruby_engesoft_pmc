#!/bin/bash

FILE=$1
COUNTER=1

while read LINE
do
cat << EOF

<p>Pergunta ${COUNTER} - ${LINE} <br>
<input type="radio" name="pergunta_${COUNTER}" value="sim">sim
<input type="radio" name="pergunta_${COUNTER}" value="nao" checked>não
</p>

EOF
let "COUNTER++"
done < "$FILE"
