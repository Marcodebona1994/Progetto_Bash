#!/bin/bash

#VR390286
#MARCO DE BONA
#marcodebona1994@gmail.com
#id794jho@studenti.univr.it
#DATA REALIZZAZIONE 23/05/2016 
#RUBRICA TELEFONICA

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White


tput sgr0
#variabile per lo stop dei colori
x='\e[0m'
clear
#stampa del menu
function menu(){
        
        echo -e "$BWhite--------------------------------------------------------------------------------------- "
        echo
        echo "                                 GESTIONE RUBRICA TELEFONICA                            "
        echo
        echo "---------------------------------------------------------------------------------------- "
        tput sgr0
        echo
	echo "Digitare il numero dell'operazione richiesta "
	echo
	echo "MENU : "
	echo 
	echo -e "      $BBlue 1)$x : Aggiungere un contatto "
	echo -e "      $BBlue 2)$x : Rimuovere contatto "
	echo -e "      $BBlue 3)$x : Stampa la rubrica "
	echo -e "      $BBlue 4)$x : Stampa la rubrica fornendo l'indice della colonna da ordinare "
	echo -e "      $BBlue 5)$x : Ricerca contatti tramite stringa "
	echo -e "      $BBlue 6)$x : Elencare tutti i contatti inseriti dopo una certa data "
	echo -e "      $BBlue 7)$x : Aprire agenda_marco_debona.txt con gedit "
	echo -e "      $BBlue 8)$x : Crea Cartella Contatti "
	echo
	echo -e "$BWhite--------------------------------------------------------------------------------------$x " 
	
	echo
	echo -e "      $BBlue 9)$x : Chiudi il programma "
	echo
	echo -e "$BWhite--------------------------------------------------------------------------------------$x " 
	echo
	
	
	selection
}
#selezione
function selection(){

        read txt

	case $txt in 
	1) 
	  clear
	  echo
	  echo -e "$BWhite---------------- INSERIMENTO CONTATTO TELEFONICO IN RUBRICA ---------------$x "
	  
	  name ;;
	2)
	  if [[ -e agenda_marco_debona.txt ]] ; then
		clear
		echo
		echo -e "$BWhite------------------- RIMOZIONE CONTATTO ------------------- $x"
		
		rm_contact 
	  else
		echo
		clear
		echo
                echo -e "${BRed}Impossibile effettuare la rimozione. Rubrica telefonica non esistente $x"
                sleep 1 
                menu
                echo
          fi ;;
	3)
	  stamp ;;
	4)
	  stamp_sort ;;
	5)
	  if [[ -e agenda_marco_debona.txt ]] ; then
	 	clear
	  	echo
         	echo -e "$BWhite---------------- RICERCA TRAMITE STRINGA ---------------$x "
         	
	        search_string
	  else
	  	clear
	  	echo
                echo -e "${BRed}Impossibile effettuare la ricerca. Rubrica telefonica non esistente $x"
                sleep 1 
                menu
                echo
           fi ;;
	6)
	   if [[ -e agenda_marco_debona.txt ]] ; then
		clear
		echo
          	echo -e "$BWhite---------------- ELENCO CONTATTI INSERITI DA UNA CERTA DATA  -------------- $x"
          	
          	date_list
          else
	  	echo
	  	clear
	  	echo
                echo -e "${BRed}Rubrica telefonica non esistente $x"
                sleep 1 
                menu
                echo
          fi ;;
	7)
	  if [[  -e agenda_marco_debona.txt ]] ; then
	  	open_addressbook
	  else
	  	echo
	  	clear
	  	echo
                echo -e "${BRed}Impossibile aprire la rubrica. Rubrica telefonica non esistente $x"
                sleep 1
                menu
                echo
          fi ;;
	  	
	8)
	  if [[ -e agenda_marco_debona.txt ]] ; then
	  	extra2
	  else
	  	echo
	  	clear
	  	echo
                echo -e "${BRed}Impossibile creare la cartella Contatti. Rubrica telefonica non esistente $x"
                sleep 1 
                menu
                echo
          fi ;;
	9)
	  close ;;
	*)
	  echo
	  echo -e "${BRed}Opzione inserita non valida$x" 
	  sleep 1 
	  clear
          menu
          echo ;;
	esac
}
#inserimento nome
function name() {
	echo
	echo "Inserire il nome " 
	echo
	read nome
	nome=$(echo $nome | tr -d ' '| tr '[:lower:]' '[:upper:]')
	if  [[ -z "$nome" || "$nome" =~ [0-9] ]] ;  then 
	        echo
	        echo -e "${BRed}Nome inserito non valido $x"
	        name
        fi
        surname
}    
#inserimento cognome    
function surname(){	        
	
	echo
	echo "Inserire il cognome " 
	echo
	read cognome
	cognome=$(echo $cognome | tr -d ' ' | tr '[:lower:]' '[:upper:]')
	if  [[ -z "$cognome" || "$cognome" =~ [0-9] ]] ;  then 
	        echo
	        echo -e "${BRed}Cognome inserito non valido $x"
	        surname
	fi
	phone_number
}
#inserimento cellulare
function phone_number(){
        
        echo
        echo "Inserire il numero di cellulare"
        echo
	read numero
	if  [[ "$numero" =~ ^[0-9]{3,15}$ ]] ;  then 
		if [[ -e  agenda_marco_debona.txt ]] ; then
			temp="$numero " 
			var=$(grep " $temp" agenda_marco_debona.txt )
			if [[ -n "$var" ]] ; then 
				echo
				echo -e  "${BYellow}$var$x"
				echo
				echo -e "${BRed}Numero già presente in rubrica, impossibile eseguire l'operazione $x"
				echo -e "${BRed}Ripetere l'operazione $x"
				phone_number
			fi
		fi
	        home_number 
	else 
	        echo
                echo -e "${BRed}Numero di cellulare inserito non valido $x"
                phone_number
        fi
}
# inserimento casa
function home_number(){
        
        echo
        echo "Inserire il numero di casa"
        echo
	read casa
	if [ "$casa" -eq "$numero" ];then
		echo
		echo -e "${BRed}Il numero di casa non può essere uguale al numero di casa$x"
		home_number
	fi
        if  [[ "$casa" =~ ^[0-9]{3,15}$ ]] ;  then 
        	if [[ -e  agenda_marco_debona.txt ]] ; then
			temp="$casa " 
			var=$(grep " $temp" agenda_marco_debona.txt )
			if [[ -n "$var" ]] ; then
				echo
				echo -e  "${BYellow}$var$x"
				echo
				echo -e "${BRed}Numero già presente in rubrica, impossibile eseguire l'operazione $x"
				echo -e "${BRed}Ripetere l'operazione $x"
				home_number
			fi
		fi
                add_test
	else
		echo 
                echo -e "${BRed}Numero di casa inserito non valido $x"
	        home_number
	fi
	
}
#stampa dei dati inseriti
function add_test(){
	data=$(date +"%Y/%m/%d")
        echo
        echo
        echo -e "Nome: ${BYellow}$nome$x"
        echo -e "Cognome: ${BYellow}$cognome$x"
        echo -e "Numero di cellulare: ${BYellow}$numero$x"
        echo -e "Numero di casa: ${BYellow}$casa$x"
        echo -e "Data di inserimento: ${BYellow}$data$x"
        add_txt
}
#controllo prima dell'inserimento
function add_txt(){
        
        if [[ -e  agenda_marco_debona.txt ]] ; then
        	temp="${nome} ${cognome} " 
		var=$(grep "$temp" agenda_marco_debona.txt )
		if [ -n "$var" ] ; then 
			echo
			echo -e "Nella rubrica è gia presente ${BYellow}$nome $cognome$x"
			echo
			echo
			echo -e "${BYellow}$var$x"
			echo
			echo
			echo -e "Premere  $BCyan[INVIO]$x per sostituire il contatto, per modificare i campi premi un tasto quasiasi"
			temp2="$nome"_"$cognome".ct
			read ans
			if [[ -n "$ans" ]]; then
					nome
			else 
				sed --in-place "/$temp/Id" agenda_marco_debona.txt
				if [[ -d Contatti ]] ; then
					cd Contatti	
					rm $temp2
					cd ..
				fi
				clear
				add_final
			fi
		fi
	fi
	echo
	echo -e "Per confermare l'inserimento premi $BCyan[INVIO]$x, per modificare i campi premi un tasto quasiasi"
        echo
        read ans
        if [[ -n "$ans" ]]; then
                name
        else
        	add_final
        fi
}
#inseirmento 
function add_final() {
	 if [[ -e  agenda_marco_debona.txt ]] ; then
                echo "$nome $cognome $numero $casa $data">>agenda_marco_debona.txt
        else
                touch agenda_marco_debona.txt
                echo "$nome $cognome $numero $casa $data">>agenda_marco_debona.txt
        fi
        sed -i '/^$/d' agenda_marco_debona.txt
        if [[ -d Contatti ]] ; then
        	extra
        else
        	clear
		echo "-------------------------------------"
		echo "- Operazione avvenuta correttamente -"
		echo "-------------------------------------"
		echo
		sleep 1
        	menu
        fi
}
#rimozione contatti
function rm_contact(){

	echo
	echo "Inserisci il nome "
	echo
	read nome
	echo
	echo "Inserisci cognome" 
	echo
	read cognome
	if [[ -z $nome ]] ;then 
		echo
		echo -e "${BRed}Inserire una stringa in entrambi i campi$x"
		rm_contact
	fi
	if [[ -z $cognome  ]] ;then 
		echo
		echo -e "${BRed}Inserire una stringa in entrambi i campi$x"
		rm_contact
	fi
	nome=$(echo $nome | tr -d ' '| tr '[:lower:]' '[:upper:]')
	cognome=$(echo $cognome | tr -d ' ' | tr '[:lower:]' '[:upper:]')
	temp="$nome $cognome "
	temp2="$nome"_"$cognome".ct
	var=$(grep "$temp" agenda_marco_debona.txt )
	if [[ ! -n "$var" ]]; then
		echo
	        echo -e "${BRed}Nessun contatto trovato$x,premere $BCyan[INVIO]$x per tornare al menu, qualsiasi tasto per ripetere la ricerca"
	        read ans
		if [[ -n "$ans" ]]; then
	       		rm_contact
		else
			clear
			menu
		fi
	else 
		echo
		echo -e "${BYellow}$var$x"
		echo
		echo -e "Premere $BCyan[INVIO]$x per confermare la rimozione, quasiasi altro tasto per tornare al menu"
		read ans
		if [[ -n "$ans" ]]; then
			clear
			menu
		else 
			sed --in-place "/$temp/Id" agenda_marco_debona.txt
			sed -i '/^$/d' agenda_marco_debona.txt
			read tmp < agenda_marco_debona.txt
			if [[ -z $tmp ]] ; then 
				rm agenda_marco_debona.txt
			fi 
			if [[ -d Contatti ]] ; then
				cd Contatti	
				rm $temp2
				cd ..
			fi
			clear
			echo "-------------------------------------"
			echo "- Operazione avvenuta correttamente -"
			echo "-------------------------------------"
			echo
			sleep 1
			menu
		fi
	fi
		
}
#stampa contatti  
function stamp(){
        
        if [[ -e agenda_marco_debona.txt ]] ; then
                clear
                echo
                echo -e "$BWhite------------------------ STAMPA DELLA RUBRICA TELEFONICA ------------------------$x "
                echo -e "${BYellow}"
                cat agenda_marco_debona.txt | column -t
                echo
                echo -e "$x"
                echo -e "Premere $BCyan[INVIO]$x per tornare al menu"
                read ans
                if [[ -n "$ans" ]];  then
                        stamp
                else 
                        clear
                        menu
                fi
        else 
                echo
                clear
		echo
                echo -e "${BRed}Rubrica telefonica non esistente $x"
                sleep 1
	        menu
        fi
        
}
#sort delle colonne
function stamp_sort(){
	
	if [[ -e agenda_marco_debona.txt ]] ; then
		clear
		echo
		echo -e "$BWhite------------------------- SCEGLI LA COLONNA DA ORDINARE ------------------------- $x "
		echo
		echo -e "	$BBlue 1)$x : Nome "
		echo -e "	$BBlue 2)$x : Cognome "
		echo -e "	$BBlue 3)$x : Numero di cellulare "
		echo -e "	$BBlue 4)$x : Numero di casa "
		echo -e "	$BBlue 5)$x : Data di inserimento  "
		echo -e "	$BBlue 6)$x : Ritorna al menu "
		echo
		read txt

		case $txt in 
		1) 
		  echo -e "${BYellow}"
		  sort -f -k 1 agenda_marco_debona.txt | column -t 
		  tput sgr0
		  stamp_sort2 ;;
		2)
		  echo -e "${BYellow}"
		  sort -f -k 2 agenda_marco_debona.txt | column -t 
		  tput sgr0
		  stamp_sort2 ;;
		  
		3)
		  echo -e "${BYellow}"
		  sort -g -k 3 agenda_marco_debona.txt | column -t 
		  tput sgr0
		  stamp_sort2 ;;
		  
		4)
		  echo -e "${BYellow}"
		  sort -g -k 4 agenda_marco_debona.txt | column -t 
		  tput sgr0
		  stamp_sort2 ;;
		  
		5)
		  echo -e "${BYellow}"
		  sort -k 5 agenda_marco_debona.txt | column -t 
		  tput sgr0
		  stamp_sort2 ;;
		  
		6)
		  clear
		  menu ;;
		*)
		  echo -e "${BRed}Opzione inserita non valida $x"
		  sleep 1 
		  clear 
		  echo
		  stamp_sort ;;
		esac
	else
		echo
		clear
		echo
		echo -e "${BRed}Rubrica telefonica non esistente $x"
		sleep 1 
		menu
	fi
}
#rirno al menu
function stamp_sort2() {
        echo
	echo -e  "Premere $BCyan[INVIO]$x per tornare al menu, quasiasi altro tasto per tornare alla scelta di ordinamento"
        echo
        read ans
	if [[ -n "$ans" ]]; then
                stamp_sort
        else 
        	clear
                menu
        fi
}
#ricerca tramite stringa	
function search_string(){
        echo
        echo "Inserisci la stringa con cui effettuare la ricerca " 
   	echo
        read string
        if [[ -z "$string" || "$string" =~ [0-9] ]]; then
        	echo
        	echo -e "${BRed}Stringa inserita non valida$x"
                search_string
        fi
        string=$(echo $string | tr -d ' '| tr '[:lower:]' '[:upper:]' )
        var=$(grep $string agenda_marco_debona.txt )
        if [[ -z "$var" ]]; then
        	echo
                echo -e "${BRed}Nessun risultato per la stringa di ricerca inserita $x"
        else 
        	echo
                echo -e  "${BYellow}$var$x" 
        fi
        echo
        echo -e "Premere $BCyan[INVIO]$x per tornare al menu, quasiasi altro tasto per ripetere la ricerca"
        echo
        read ans
        if [[ -n "$ans" ]]; then
                search_string
        else 
        	clear
                menu
        fi
}
#ricerca contatti inserite da una certa data in poi
function date_list(){
	
        echo
        echo -e "Inserire la data nel formato ${BGreen}aaaa/mm/gg$x"
        echo
        read datalist
        echo -e "${BRed}"
	test_data=$(date -d "$datalist" +"%Y/%m/%d") 
        if  [[ $? -eq 0 && ${#datalist} -eq 10 ]] ; then 
        	while read nome cognome numero casa data 
        		do
        			if [[ "$datalist" < "$data" ]] ; then 
        				echo "$nome $cognome $numero $casa $data" >> temp.txt
        				var=$nome
        			fi
        		done < agenda_marco_debona.txt | column -t 
		if [[ -f temp.txt ]] ; then
			echo -e "${BYellow}"
			sort -k 5 temp.txt | column -t 
			tput sgr0
			rm temp.txt
		else
			echo -e "${BRed}Nessuno contatto inserito dopo la data inserita$x"
			
		fi
        fi
        echo
        tput sgr0
        echo -e "Premere $BCyan[INVIO]$x per tornare al menu, quasiasi altro tasto per ripetere la ricerca"
        read ans
	if [[ -n "$ans" ]]; then
        	date_list
	else 
		clear
        	menu
	fi
        
}
#apre agenda_marco_debona.txt con gedit
function open_addressbook(){
        xdg-open agenda_marco_debona.txt
        clear
	echo "-------------------------------------"
	echo "- Operazione avvenuta correttamente -"
	echo "-------------------------------------"
	echo
	sleep 1
        menu
}
#aggiunta in contatti
function extra(){
	
	cd Contatti
	
        temp="$nome"_"$cognome".ct
        if [[ -e $temp ]] ; then
		echo "Nome: $nome"  >>"$temp"
		echo "Cognome: $cognome" >>"$temp"
		echo "Numero di cellulare: $numero">>"$temp"
		echo "Numero di Casa: $casa" >>"$temp"
		echo "Data di inserimento: $data" >>"$temp"
		cd ..
	else 
		touch $temp
		echo "Nome: $nome"  >>"$temp"
		echo "Cognome: $cognome" >>"$temp"
		echo "Numero di cellulare: $numero">>"$temp"
		echo "Numero di Casa: $casa" >>"$temp"
		echo "Data di inserimento: $data" >>"$temp"
		cd ..
	fi
	clear
        echo "-------------------------------------"
        echo "- Operazione avvenuta correttamente -"
        echo "-------------------------------------"
        echo
        sleep 1
        menu
	
}
#creazione della cartella contatti
function extra2(){
	clear
	echo
	echo -e "$BWhite--------------------- CREAZIONE CARTELLA CONTATTI ---------------------- $x "
	echo
	if [[ -d Contatti ]] ; then
		cp agenda_marco_debona.txt Contatti
		cd Contatti
	else 
		mkdir Contatti
		cp agenda_marco_debona.txt Contatti
		cd Contatti
	fi
	
	echo "Contatti creati : "
	echo
	while read nome cognome numero casa data 
		do
			temp="$nome"_"$cognome".ct
			if [ -e $temp ] ; then
				rm $temp
			fi
			touch $temp
			echo "Nome: $nome"  >>"$temp"
			echo "Cognome: $cognome" >>"$temp"
			echo "Numero di cellulare: $numero">>"$temp"
			echo "Numero di Casa: $casa" >>"$temp"
			echo "Data di inserimento: $data" >>"$temp"
			echo -e "	${BYellow}$temp$x"
			echo	
		done < agenda_marco_debona.txt
	rm agenda_marco_debona.txt
	cd ..
        echo -e "Premere $BCyan[INVIO]$x per tornare al menu, quasiasi altro tasto per ripetere l'operazione"
        read ans
	if [[ -z "$ans" ]]; then
		clear
		echo "-------------------------------------"
		echo "- Operazione avvenuta correttamente -"
		echo "-------------------------------------"
		echo
		sleep 1
		menu
	else 
		clear
		extra2
	fi
	
}
#uscita dal programma
function close(){
        clear
        echo
        echo
        echo
        echo -e "$BWhite --------------------------------------------------------------------------------------- "
        echo
        echo "                                    RUBRICA TELEFONICA CHIUSA                           "
        echo
        echo "---------------------------------------------------------------------------------------- "
        tput sgr0
        echo
        echo
        exit
}
menu







