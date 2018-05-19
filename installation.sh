#! /bin/bash
clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Checking dependencies..."

for i in curl sendemail
do
	if ! [ -x "$(command -v $i)" ]; then
	  echo "Error: $i is not installed." >&2
	  exit 1
	fi
done

echo "Dependencies Ok"
echo "-------------------------------------"
echo "" 
echo "Times to execute the test, if in two tries the service is down, it will considered as DOWN. (Higher= more accured)"
read EXECUTION_TIMES
echo "EXECUTION_TIMES=$EXECUTION_TIMES" > .env

echo "Gmail Address this will receive the email"
read GMAIL_ADDRESS
echo "GMAIL_ADDRESS=$GMAIL_ADDRESS" >> .env

echo "Gmail Password"
read GMAIL_PASSWORD
echo "GMAIL_PASSWORD=$GMAIL_PASSWORD" >> .env

echo "Sender address (useful if you want to filter this email in your inbox."
read EMAIL_SENDER
echo "EMAIL_SENDER=$EMAIL_SENDER" >> .env

echo "_______________"
echo "Perfect: I'll setup your crontab... (Y/n)"
read confirmation
if [ $confirmation == "Y" -o $confirmation == "y" ] 
then
	echo "This will execute every 15min, you can change it with crontab -e"
	sudo (crontab -l; echo "*/15 * * * * $DIR/check.sh") | crontab -
else
	echo "Ok, no crontab configured, you can add it later setting up the check.sh file"
fi

echo "You can add domains to check with the add.sh script, or passing a file named domainsToTest.txt with the domains to check"

