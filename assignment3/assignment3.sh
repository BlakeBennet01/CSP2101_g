#Name: Blake Bennett
#Student Number: 10496066
#Unit Name: Scripting Languages - CSP2101

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#!/bin/bash

#Create findSize function - finds size of selected image(s)
findSize() {
    #Use parameter to retrieve appropriate image url from temp.txt
    URL=$(cat temp.txt | grep "DSC0$1")
    #-s= silent, -I= allows retrieval of 'content-header' information
    #Retrieve 'content-length' information (file size) from appropriate image url
    #Stored as "Content Length: (file size)" -> use awk to print variable $2 in decimal format
    fileSize=$(curl -sI $URL | grep -i content-length | awk '{ printf "%d", $2 }')
    #Divide by 1000 to get fileSize in kilobytes (bytes / 1000 = KB)
    fileSize=$(($fileSize / 1000))
    #Use sed to add fileSize onto image name and file type in same format
    sed -i "s/DSC0$1.jpg/DSC0$1.jpg.$fileSize/" imageList.txt
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#Retrieve data from website address
#Filter data so that only the hyperlinks remain
curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" | grep -Eo '(http|https)://[^"]+' > temp.txt

#Create infinite loop
until (( 1 > 2 )); do
#Request user input for number of section that they want to execute
    read -p "0) Quit program
1) Download a specific image
2) Download ALL thumbnails
3) Download images in a range
4) Download a specified number of images in a range (random)
Input number of desired function: " userChoice
    printf "\n"

#Download a specific image
#If user selects option 1
    if [ $userChoice = 1 ]; then
        #Create infinite loop
        y=0
        while [ $y -eq 0 ]; do
            #Request input of desired image number
            read -p "Please enter the number of the desired image (between 1533-2042): " userInput
            #Check if input is within specified range of 1533-2042
            if [ $userInput -ge 1533 ] && [ $userInput -le 2042 ]; then
                #Check if image url actually exists
                counter=$(grep -c "DSC0$userInput" temp.txt)
                #Image url does not exist
                if [ $counter -eq 0 ]; then
                    #Print error message and return to beginning of loop
                    echo -e "File does not exist. Please try again.\n"
                    continue
                #Image url does exist
                else
                    printf "\n"
                    #Download image to file userDownloads.txt
                    cat temp.txt | grep "DSC0$userInput" >> userDownloads.txt
                    #Formats url of image so it can be processed by awk
                    cat temp.txt | grep "DSC0$userInput" | sed 's,.*/,,' > imageList.txt
                    #Determine size of image using findSize function
                    findSize $userInput
                    #Use awk to print output in correct format
                    awk 'BEGIN {FS="."}
                    { print "Downloading", $1", with the file name", $1"."$2", with a file size of", $3, "KB.\nDownload Complete.\n" }' imageList.txt
                    #Break out of infinite loop
                    y=1
                fi
            else
                echo -e "Invalid input. Please try again.\n"
                continue
            fi
        done

#Download ALL thumbnails
#If user selects option 2
    elif [ $userChoice = 2 ]; then
        #Create a range between 1533-2042
        minRange=1533
        maxRange=2042
        rangeNum=$(($maxRange - $minRange))
        #Set a variable (x) to 0
        x=0
        #Repeats loop until x > rangeNum, i.e. checks for every possible image number within range
        until [ $x -gt $rangeNum ]; do
            #Check if image url actually exists
            counter=$(grep -c "DSC0$minRange" temp.txt)
            #Image url does not exist
            if [ $counter -eq 0 ]; then
                #Add one to both minInput and x variables and return to beginning of loop
                minRange=$(($minRange + 1))
                x=$(($x + 1))
                continue
            else
                #Download image to file userDownloads.txt
                cat temp.txt | grep "DSC0$minRange" >> userDownloads.txt
                #Formats url of image so it can be processed by awk
                cat temp.txt | grep "DSC0$minRange" | sed 's,.*/,,' > imageList.txt
                #Determine size of image using findSize function
                findSize $minRange
                #Use awk to print output in correct format
                awk 'BEGIN {FS="."}
                { print "Downloading", $1", with the file name", $1"."$2", with a file size of", $3, "KB.\nDownload Complete.\n" }' imageList.txt
                #Add one to both minInput and x variables
                minRange=$(($minRange + 1))
                x=$(($x + 1))
            fi
        done
        continue

#Download images in a range
#If user selects option 3
    elif [ $userChoice = 3 ]; then
        #Create infinite loop
        y=0
        while [ $y -eq 0 ]; do
            #Request input of minimum range number
            read -p "Please enter the minimum number (between 1533-2042) for the range: " minInput
            #Check if input is within specified range of 1533-2042
            if [ $minInput -ge 1533 -a $minInput -le 2042 ]; then
                #Request input of maximum range number
                read -p "Please enter the maximum number (between 1533-2042) for the range: " maxInput
                #Check if input is within specified range of 1533-2042 and that maxInput is larger than minInput
                if [ $maxInput -ge 1533 -a $maxInput -le 2042 ] && [ $maxInput -gt $minInput ]; then
                    #Create range indicator based on user's inputs
                    rangeNum=$(($maxInput - $minInput))
                    printf "\n"
                    #Set a variable (x) to 0
                    x=0
                    #Repeats loop until x > rangeNum, i.e. checks for every possible image number within given range
                    until [ $x -gt $rangeNum ]; do
                        #Check if image url actually exists
                        counter=$(grep -c "DSC0$minInput" temp.txt)
                        #Image url does not exist
                        if [ $counter -eq 0 ]; then
                            #Add one to both minInput and x variables and return to beginning of loop
                            minInput=$(($minInput + 1))
                            x=$(($x + 1))
                            continue
                        #Image url does exist
                        else
                            #Download image to file userDownloads.txt
                            cat temp.txt | grep "DSC0$minInput" >> userDownloads.txt
                            #Formats url of image so it can be processed by awk
                            cat temp.txt | grep "DSC0$minInput" | sed 's,.*/,,' > imageList.txt
                            #Determine size of image using findSize function
                            findSize $minInput
                            #Use awk to print output in correct format
                            awk 'BEGIN {FS="."}
                            { print "Downloading", $1", with the file name", $1"."$2", with a file size of", $3, "KB.\nDownload Complete.\n" }' imageList.txt
                            #Add one to both minInput and x variables
                            minInput=$(($minInput + 1))
                            x=$(($x + 1))
                        fi
                    done
                    #Break out of infinite loop
                    y=1
                else
                    echo -e "Invalid input. Please try again.\n"
                    continue
                fi
            else
                echo -e "Invalid input. Please try again.\n"
                continue
            fi
        done

#Download a specified number of images in a range (random)
#If user selects option 4
    elif [ $userChoice = 4 ]; then
        #Create infinite loop
        y=0
        while [ $y -eq 0 ]; do
            #Request input of minimum range number
            read -p "Please enter the minimum number (between 1533-2042) for the range: " minInput
            #Check if input is within specified range of 1533-2042
            if [ $minInput -ge 1533 -a $minInput -le 2042 ]; then
                #Request input of maximum range number
                read -p "Please enter the maximum number (between 1533-2042) for the range: " maxInput
                #Check if input is within specified range of 1533-2042 and that maxInput is larger than minInput
                if [ $maxInput -ge 1533 -a $maxInput -le 2042 ] && [ $maxInput -gt $minInput ]; then
                    #Create range indicator based on user's inputs
                    rangeNum=$(($maxInput - $minInput))
                    #Request input of number of random images to download
                    read -p "Please enter the number of random images you want to download: " numAmount
                    printf "\n"
                    #Set a variable (x) to 0
                    x=0
                    #Repeat loop until x = numAmount
                    until [ $x -eq $numAmount ]; do
                        #Generate random number within user's range and add it to the minInput value, store as randRange
                        randNum=$(($RANDOM%$rangeNum))
                        randRange=$(($minInput + $randNum))
                        #Check if image url exists
                        counter=$(grep -c "DSC0$randRange" temp.txt)
                        #Image url does not exist
                        if [ $counter -eq 0 ]; then
                            #Return to beginning of loop
                            continue
                        #Image url does exist
                        else
                            #Download image to file userDownloads.txt
                            cat temp.txt | grep "DSC0$randRange" >> userDownloads.txt
                            #Formats url of image so it can be processed by awk
                            cat temp.txt | grep "DSC0$randRange" | sed 's,.*/,,' > imageList.txt
                            #Determine size of image using findSize function
                            findSize $randRange
                            #Use awk to print output in correct format
                            awk 'BEGIN {FS="."}
                            { print "Downloading", $1", with the file name", $1"."$2", with a file size of", $3, "KB.\nDownload Complete.\n" }' imageList.txt
                            #Add 1 to x variable
                            x=$(($x + 1))
                        fi
                    done
                    #Break out of infinite loop
                    y=1
                else
                    echo -e "Invalid input. Please try again.\n"
                    continue
                fi
            else
                echo -e "Invalid input. Please try again.\n"
                continue
            fi
        done

#Quit program
#If user selects option 0
    elif [ $userChoice = 0 ]; then
        echo "Goodbye."
        break

#Reprompt user if input is invalid
    else
        echo "Invalid input."
        continue
    fi

done

exit 0




