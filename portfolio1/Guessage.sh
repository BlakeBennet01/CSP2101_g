#!/bin/bash

#Name: Blake Bennett
#Student ID: 10496066
#Unit: CSP2101 - Scripting Languages

#creates a range between 20 and 70 for the random number
#stores as variable $RANGE
RANGE=$((70-20+1))

#generates a random number between the specified $RANGE
#adds 20 to the output (so number != anything below 20)
#stores as variable $number
number=$(($(($RANDOM%$RANGE))+20))

#creates infinite while loop (condition=true)
while [ true ]
do
    #requests user input of number from 20 and 70
    #stores as variable $numberGuess
    read -p "Please enter a number from 20 to 70: " numberGuess
    
    #determines whether user input was within specified range (20 to 70)
    #if user input within specified range, continues to next if statement
    if [ $numberGuess -ge 20 -a $numberGuess -le 70 ]; then
        
        #if user input less than the $number, inform user and return to beginning of while loop
        if [ $numberGuess -lt $number ]; then
            echo -e "Your guess was too low.\n"

        #if user input greater than the $number, inform user and return to beginning of while loop
        elif [ $numberGuess -gt $number ]; then
            echo -e "Your guess was too high.\n"

        #if user input equal to the $number, inform user and break out of loop (end the program)
        else
            echo -e "You guessed correctly! The random number was $number!\n"
            break

        fi

    #if user input not within specified range, returns to beginning of while loop
    else
        echo -e "Your value was not within the specified range.\n"

    fi
done