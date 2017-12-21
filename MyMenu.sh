#!/bin/bash 
show_menu()
{
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}**********************APP MENU***********************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Connect MYSQL ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Import Data In HDFS ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Import Data In HIVE ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} Show Data In HIVE ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5)${MENU} Pin Code ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 6)${MENU} State ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 7)${MENU} Area${NORMAL}"
    echo -e "${MENU}**${NUMBER} 8)${MENU} Utility${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt
}
function option_picked() 
{
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE="$1"  #modified to post the correct option selected
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

function getpinCodeBank(){
	echo "in getPinCodebank"
	echo $1
	echo $2
	#hive -e "Select * from AppData where PinCode = $1 AND Bank = '$2'"
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "To Connect to DB and Get all databases present: look for name utility";
        sqoop list-databases --connect "jdbc:mysql://localhost" --username root --password password;
	show_menu;
        ;;

        2) clear;
        option_picked "Now lets import the AppData table in our hdfs file system ";
        sqoop import --connect "jdbc:mysql://localhost/utility" --username root --password password --table AppData --target-dir /menu/AppData;
        show_menu;
        ;;
            
        3) clear;
        option_picked "Now We can import the utility DB in our Hive table Structure to be able to Query";
        sqoop import --connect "jdbc:mysql://localhost/utility" --username root --password password --table AppData --hive-import --hive-table utility.AppData ;
        show_menu;
        ;;
	
        4) clear;
        option_picked "Going to show the Sample Data from imported Table";
        echo "Enter the number of entries you require"
        read entries
        echo "You've selected ${entries}"
	    hive -e "select *  from utility.AppData where ID <= $entries" 
        show_menu;
        ;;
            
	    5) clear;
        option_picked "Search Based on PinCode";
        echo "Please Enter the Pin Code"
	    read pinCode
	    echo "PinCode is ${pinCode}"
        echo -e "${MENU}Select One Option From Below To Search In Pin Code${NORMAL}"
        echo -e "${MENU}**${NUMBER} 1)${MENU} Bank ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 2)${MENU} Restaurant ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 3)${MENU} Hospital ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 4)${MENU} School ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 5)${MENU} Shopping Mall ${NORMAL}"
	    read n
	    case $n in
                1)	echo "Please Enter the bank name"
                    read bankName                    	
		    hive -e "Select * from utility.AppData where PinCode = $pinCode AND LOWER(bank) LIKE LOWER(CONCAT('%', '${bankName}','%'))"
                    ;;		
                    
                2) 	echo "Please Enter the Restaurant name"
                    read resName                    	
                    hive -e "select * from utility.AppData where Pincode=$pinCode AND LOWER(restaurant) LIKE LOWER(CONCAT('%','${resName}','%'))"
                    ;;
                    
                3) 	echo "Please Enter the Hospital name"
                    read hosName                    	
                    hive -e "Select * from utility.AppData where PinCode = $pinCode AND LOWER(hospital) LIKE LOWER(CONCAT('%', '${hosName}','%'))"
                    ;;
                    
                4) 	echo "Please Enter the school name"
                    read schoolName                    	
                    hive -e "Select * from utility.AppData where PinCode = $pinCode AND LOWER(school) LIKE LOWER(CONCAT('%', '${schoolName}','%'))"
                    ;;
                    
                5) 	echo "Please Enter the Shopping Mall name"
                    read mallName                    
                    hive -e "Select * from utility.AppData where PinCode = $pinCode AND LOWER(shoppingmall) LIKE LOWER(CONCAT('%', '${mallName}','%'))"
                    ;;
                    
                *) echo "Please Select one among the option[1-5]";;
                esac
                show_menu;
                    ;;
                    
        6) clear;
        option_picked "Search based on State";
	    echo "Please enter the State name"
	    read stateName
	    echo "Entered State Name is ${stateName}"
	    #echo "In this state what do you want to search"
	    #echo "Select one:  1)Shopping Mall 2)Restaurant 3)Hospital 4)School 5) Bank "
        echo -e "${MENU}Select One Option From Below To Search In State${NORMAL}"
        echo -e "${MENU}**${NUMBER} 1)${MENU} Shopping Mall ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 2)${MENU} Restaurant ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 3)${MENU} Hospital ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 4)${MENU} School ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 5)${MENU} Bank ${NORMAL}"
	    read n
	    case $n in
                1)	echo "Please Enter the Shopping Mall Name"
                    read mallName                    	
                    hive -e "Select * from utility.AppData where LOWER(state) LIKE LOWER(CONCAT('%', '${stateName}','%')) AND LOWER(shoppingmall) LIKE LOWER(CONCAT('%', '${mallName}','%'))"
                    ;;			
                    
                2) 	echo "Please Enter the Restaurant name"
                    read resName                    	
                    hive -e "Select * from utility.AppData where LOWER(state) LIKE LOWER(CONCAT('%', '${stateName}','%')) AND LOWER(restaurant) LIKE LOWER(CONCAT('%','${resName}','%'))"
                    ;;
                    
                3) 	echo "Please Enter the Hospital name"
                    read hosName                    	
                    hive -e "Select * from utility.AppData where LOWER(state) LIKE LOWER(CONCAT('%', '${stateName}','%')) AND LOWER(hospital) LIKE LOWER(CONCAT('%', '${hosName}','%'))"
                    ;;
                    
                4) 	echo "Please Enter the school name"
                    read schoolName                    	
                    hive -e "Select * from utility.AppData where LOWER(state) LIKE LOWER(CONCAT('%', '${stateName}','%')) AND LOWER(school) LIKE LOWER(CONCAT('%', '${schoolName}','%'))"
                    ;;
                    
                5) 	echo "Please Enter the Bank name"
                    read bankName                    	
                    hive -e "Select * from utility.AppData where LOWER(state) LIKE LOWER(CONCAT('%', '${stateName}','%')) AND LOWER(bank) LIKE LOWER(CONCAT('%', '${bankName}','%'))"
                    ;;
                *) echo "Please Select one among the option[1-5]";;
        esac
        show_menu;
        ;;
        
        7) clear;
        option_picked "Search Based on Area";
	    echo "Please Enter the Area Name"
	    read areaName
	    echo "Entered Area Name is ${areaName}"
	    echo "inThis State what do you want to search"
	    echo "select One Among  1)Pincode 2)Restaurant 3)Hospital 4)School 5) Bank "
	    read n
	    case $n in
                1)	echo "Please Enter the Pincode"
                    read pincode
                    hive -e "Select * from utility.AppData where LOWER(location) LIKE LOWER(CONCAT('%', '${areaName}','%')) AND pincode LIKE CONCAT('%','${pincode}','%')"
                    ;;			
                    
                2) 	echo "Please Enter the Restaurant name"
                    read resName                    	
                    hive -e "Select * from utility.AppData where LOWER(location) LIKE LOWER(CONCAT('%', '${areaName}','%')) AND LOWER(restaurant) LIKE LOWER(CONCAT('%','${resName}','%'))"
                    ;;
                    
                3) 	echo "Please Enter the Hospital name"
                    read hosName                    	
                    hive -e "Select * from utility.AppData where LOWER(location) LIKE LOWER(CONCAT('%', '${areaName}','%')) AND LOWER(hospital) LIKE LOWER(CONCAT('%', '${hosName}','%'))"
                    ;;
                    
                4) 	echo "Please Enter the school name"
                    read schoolName                    	
                    hive -e "Select * from utility.AppData where LOWER(location) LIKE LOWER(CONCAT('%', '${areaName}','%')) AND LOWER(school) LIKE LOWER(CONCAT('%', '${schoolName}','%'))"
                    ;;
                    
                5) 	echo "Please Enter the Bank name"
                    read bankName	
                    hive -e "Select * from utility.AppData where LOWER(location) LIKE LOWER(CONCAT('%', '${areaName}','%')) AND LOWER(bank) LIKE LOWER(CONCAT('%', '${bankName}','%'))"
                    ;;
                    
                *) echo "Please Select one among the option[1-5]";;
        esac
        show_menu;
        ;;
        
	    8) clear;
        option_picked "Search Based on Utility";
        echo -e "${MENU}Select One Option From Below To Search In Utility${NORMAL}"
        echo -e "${MENU}**${NUMBER} 1)${MENU} Bank ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 2)${MENU} Restaurant ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 3)${MENU} Hospital ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 4)${MENU} School ${NORMAL}"
        echo -e "${MENU}**${NUMBER} 5)${MENU} Shopping Mall ${NORMAL}"
	    read n
	    case $n in
                1)  echo "Please Enter the bank name"
                    read bankName                    	
                    hive -e "Select * from utility.AppData where LOWER(bank) LIKE LOWER(CONCAT('%', '${bankName}','%'))"
                    ;;			
                    
                2)  echo "Please Enter the Restaurant name"
                    read resName                    	
                    hive -e "select * from utility.AppData where LOWER(restaurant) LIKE LOWER(CONCAT('%','${resName}','%'))"
                    ;;
                    
                3)  echo "Please Enter the Hospital name"
                    read hosName                    	
                    hive -e "Select * from utility.AppData where LOWER(hospital) LIKE LOWER(CONCAT('%', '${hosName}','%'))"
                    ;;
                    
                4)  echo "Please Enter the school name"
                    read schoolName                    	
                    hive -e "Select * from utility.AppData where LOWER(school) LIKE LOWER(CONCAT('%', '${schoolName}','%'))"
                    ;;
                    
                5)  echo "Please Enter the Shopping Mall name"
                    read mallName                    
                    hive -e "Select * from utility.AppData where LOWER(shoppingmall) LIKE LOWER(CONCAT('%', '${mallName}','%'))"
                    ;;
                    
                *) echo "Please Select one among the option[1-5]";;
                esac
                show_menu;
                    ;;



        \n) exit;
        ;;

        *) clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi



done


