#!/usr/bin/env bash
clear

# Este script requiere sendemail y curl

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source .env

touch reportToSend.txt

# Execute x times

j=${EXECUTION_TIMES}

for j in `seq 1 1 $j`
do

        j=$(( j+1 ))


                for i in `cat $DIR/domainsToTest.txt`
                do
                echo $i
                http_code=`curl -s -o /dev/null -w "%{http_code}" $i | grep "^5\|^0"`

                        if [ -z $http_code ]
                        then

                                echo "Ok."
                        else
                                if [ $http_code -eq 520 ]
                                then
                                	echo "Error 520: ignored"
                                else
                                	echo "The website $i give ERROR $http_code" >> reportToSend.txt
                                	echo "Error 5xx or server down on $i"
                                fi
                        fi

                done

done

if [ -z "`cat reportToSend.txt`" ]
then
        echo "Great! There is no errors"
else
        sendemail -t ${GMAIL_ADDRESS} -s smtp.gmail.com:587 -f ${EMAIL_SENDER} -u "SOMETHING IS DOWN..." -m "`cat reportToSend.txt`" -xp "${GMAIL_PASSWORD}" -xu "${GMAIL_ADDRESS}"
fi

# Delete temp file
rm reportToSend.txt
