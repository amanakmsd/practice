#!/bin/bash

addToRecord()
{
	echo
	while true
	do
		echo "To add a record to your address book, please enter the information in this"
		echo "format: \"Last name,first name,email url,phone number,city,state,zip\" (no quotes or spaces)."
		echo "Example: Doe,John,johndoe@gmail.com,6501234567,london,IDK,345432"
		echo "If you'd like to quit, enter 'q'."
		echo "Enter last name"
		read lastName
		echo "Enter First Name"
		read firstName
		echo "Enter email id"
		read emailId
		echo "Enter Phone number"
		read phnNo
		echo "Enter City"
		read city
		echo "Enter State"
		read state
		echo "Enter Zip"
		read zip
		aInput="$lastName,$firstName,$emailId,$phnNo,$city,$state,$zip"
		if [ "$aInput" == 'q' ]
			then
			break
		fi
		echo
		echo $aInput >> $fileName
		echo "The entry was added to your address book."
		echo
	done
}

displayRecord()
{
	echo
	cat $fileName
	echo
}

editRecord()
{
	echo
	while true
	do
		echo "To edit a record, enter any search string, e.g. last name or email address (case sensitive)."
		echo "If you're done editing your address book, enter 'q' to quit."
		read eInput
		if [ "$eInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$eInput\":"
		grep -n "$eInput" $fileName
		RETURNSTATUS=`echo $?`
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "No records found for \"$eInput\""
		else
			echo
			echo "Enter the line number (the first number of the entry) that you'd like to edit."
			read lineNumber
			echo
			for line in `grep -n "$eInput" $fileName`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					echo "What would you like to change it to? Use the format:"
					echo "\"Last name,first name,email url,phone number,city,state,zip\" (no quotes or spaces)."
					read edit
					lineChange="${lineNumber}s"
					sed -i -e "$lineChange/.*/$edit/" $fileName
					echo
					echo "The change has been made."
				fi
			done
		fi
		echo
	done		
}

removeRecord()
{
	echo 
	while true
	do
		echo "To remove a record, enter any search string, e.g. last name or email address (case sensitive)."
		echo "If you're done, enter 'q' to quit."
		read rInput
		if [ "$rInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$rInput\":"
		grep -n "$rInput" $fileName
		RETURNSTATUS=`echo $?`
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "No records found for \"$rInput\""
		else
			echo
			echo "Enter the line number (the first number of the entry) of the record you want to remove."
			read lineNumber
			for line in `grep -n "$rInput" $fileName`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					lineRemove="${lineNumber}d"
					sed -i -e "$lineRemove" $fileName
					echo "The record was removed from the address book."
				fi
			done
		fi
		echo
	done
}

searchRecord()
{
	echo
	while true
	do
		echo "To search for a record, enter any search string, e.g. last name or email address (case sensitive)."
		echo "The format of a record is \"Last name,firstname,email address,phone number,city,state,zip\"."
		echo "If you'd like to quit, enter 'q'."
		read sInput
		if [ "$sInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing records for \"$sInput\":"
		grep "$sInput" $fileName
		RETURNSTATUS=`echo $?`
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "No records found for \"$sInput\"."
		fi
		echo
	done
}
getSortedEntriesBasedOnLastName(){
cat $fileName | sort -k1  -t ","
}

getSortedEntriesBasedOnZipCode(){
cat $fileName | sort -k7 -n  -t ","
}

echo
echo "Enter File name make sure to add .csv"
read fileName
echo >> $fileName
lastCharOfFile=`tail -c 1 $fileName` # checking to make sure the .csv file ends with newline character
if [ -n "$lastCharOfFile" ]
	then
	echo >> $fileName
fi
echo "Hello, what would you like to do with your address book?"
echo "Please enter one of the following letters:"
echo "a) to add a record"
echo "d) to display 1 or more records"
echo "e) to edit a record"
echo "l) to get sorted list based on last name"
echo "z) to get sorted list based on zip code"
echo "r) to remove a single record"
echo "s) to search for records"
echo
read input

case $input in
	a) addToRecord;;
	d) displayRecord;;
	e) editRecord;;
	r) removeRecord;;
	s) searchRecord;;
	l) getSortedEntriesBasedOnLastName;;
    z) getSortedEntriesBasedOnZipCode;;
esac

echo
# HERE doc
cat <<EOF   
Any changes you made have been saved.
Have a nice day!
EOF
echo
