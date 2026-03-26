#!/bin/bash

actualMenu=0
selected=0

onResize() {
rows=$(tput lines)
cols=$(tput cols)

if (( cols < 80 || rows < 25 )); then
    tput clear
    echo "Terminal too small. Minimum 80x25"
    exit 1
fi
}

checkAndRunScript() {
    local scriptName="$1"

    if [[ ! -f "$scriptName" ]]; then
        echo "Error: Script '$scriptName' does not exist."
        sleep 5
        initMenus
        mainLoop
    fi

    ./"$scriptName"
}


initMenus(){

title="D K U K L I N S K I"

menu1=(
"[A] - About"
"[B] - Script B"
"[C] - Script C"
"[D] - Script D"
"[E] - Exit"
"[F] - Script F"
"[G] - Script G"
"[H] - Help"
"[N] - Next screen"
)

menu2=(
"[I] - Script I"
"[J] - Script J"
"[K] - Script K"
"[L] - Script L"
"[M] - Script M"
"[O] - Script O"
"[R] - Script R"
"[N] - Next screen"
"[P] - Previous screen"
)

menu3=(
"[S] - Script S"
"[T] - Script T"
"[U] - Script U"
"[V] - Script V"
"[X] - Script X"
"[Y] - Script Y"
"[Z] - Script Z"
"[N] - Next screen"
"[P] - Previous screen"
)

headerItems=("1 item1" "2 item2" "3 item3" "4 item4" "5 item5" "6 item6" "7 item7" "8 item8" "9 item9")
}

drawHeader(){

# ustaw kolor tła
tput setab 4
tput setaf 7

# wypełnij cały wiersz
tput cup 0 0
printf "%*s" "$cols" ""

# drukuj elementy headera
for ((i=0;i<${#headerItems[@]};i++)); do
    tput cup 0 $((i*10))
    printf "%s" "${headerItems[$i]}"
done

# reset kolorów
tput sgr0
}

drawFooter(){
tput setab 4
tput setaf 7

tput cup $((rows-1)) 0
printf "%*s" "$cols" ""

tput cup $((rows-1)) 0
printf "Dariusz Kukliński v 1.0. 0 | Menu=%d | Selected=%d | %sx%s" "$actualMenu" "$selected" "$cols" "$rows"
tput sgr0
}

drawBox(){

row=$1
col=$2
width=$3
height=$4

tl="┌"; tr="┐"; bl="└"; br="┘"
hor="-"; ver="│"

tput cup $row $col
printf "%s" "$tl"
printf "%*s" $((width-2)) "" | tr ' ' "$hor"
printf "%s" "$tr"

for ((i=1;i<height-1;i++)); do
    tput cup $((row+i)) $col
    printf "%s" "$ver"
    printf "%*s" $((width-2)) ""
    printf "%s" "$ver"
done

tput cup $((row+height-1)) $col
printf "%s" "$bl"
printf "%*s" $((width-2)) "" | tr ' ' "$hor"
printf "%s" "$br"
}

drawBoxes(){

box_width=60
box_height=16

start_row=$(( (rows-box_height)/2 ))
start_col=$(( (cols-box_width)/2 ))

case $actualMenu in

0)
drawBox $start_row $start_col $box_width $box_height
drawBox $((start_row-2)) $((start_col-2)) $box_width $box_height
drawBox $((start_row-4)) $((start_col-4)) $box_width $box_height
base_row=$((start_row-4))
base_col=$((start_col-4))
menu=("${menu1[@]}")
;;

1)
drawBox $start_row $start_col $box_width $box_height
drawBox $((start_row-4)) $((start_col-4)) $box_width $box_height
drawBox $((start_row-2)) $((start_col-2)) $box_width $box_height
base_row=$((start_row-2))
base_col=$((start_col-2))
menu=("${menu2[@]}")
;;

2)
drawBox $((start_row-4)) $((start_col-4)) $box_width $box_height
drawBox $((start_row-2)) $((start_col-2)) $box_width $box_height
drawBox $start_row $start_col $box_width $box_height
base_row=$start_row
base_col=$start_col
menu=("${menu3[@]}")
;;

esac

tput cup $((base_row+2)) $((base_col+box_width/3))
printf "%s" "$title"

row=$((base_row+4))

for i in "${!menu[@]}"; do

    tput cup $row $((base_col+2))

    text="${menu[$i]}"

    inner_width=$((box_width-4))   # padding 2 z lewej i 2 z prawej

    if [[ $i == $selected ]]; then
        tput rev
        printf "%-*s" "$inner_width" "$text"
        tput sgr0
    else
        printf "%-*s" "$inner_width" "$text"
    fi

    ((row++))
done
}

drawMenu(){
tput clear
drawHeader
drawBoxes
drawFooter
}

executeOption(){

case "$1" in

1) checkAndRunScript ./item1.sh ;;
2) checkAndRunScript ./item2.sh ;;
3) checkAndRunScript ./item3.sh ;;
4) checkAndRunScript ./item4.sh ;;
5) checkAndRunScript ./item5.sh ;;
6) checkAndRunScript ./item6.sh ;;
7) checkAndRunScript ./item7.sh ;;
8) checkAndRunScript ./item8.sh ;;
9) checkAndRunScript ./item9.sh ;;

esac
}

readKey(){
key=""
IFS= read -rsn1 key

if [[ $key == $'\x1b' ]]; then
    read -rsn2 key
fi

case "$key" in

"[A") ((selected--)) ;;
"[B") ((selected++)) ;;

n|N)
((actualMenu++))
((actualMenu>2)) && actualMenu=0
;;

p|P)
((actualMenu--))
((actualMenu<0)) && actualMenu=2
;;

a|A) checkAndRunScript ./about.sh ;;
b|B) checkAndRunScript ./scriptB.sh ;;
c|C) checkAndRunScript ./scriptC.sh ;;
d|D) checkAndRunScript ./scriptD.sh ;;
e|E) exit ;;
f|F) checkAndRunScript ./scriptF.sh ;;
g|G) checkAndRunScript ./scriptG.sh ;;
h|H) checkAndRunScript ./help.sh ;;

i|I) checkAndRunScript ./scriptI.sh ;;
j|J) checkAndRunScript ./scriptJ.sh ;;
k|K) checkAndRunScript ./scriptK.sh ;;
l|L) checkAndRunScript ./scriptL.sh ;;
m|M) checkAndRunScript ./scriptM.sh ;;

s|S) checkAndRunScript ./scriptS.sh ;;
t|T) checkAndRunScript ./scriptT.sh ;;
u|U) checkAndRunScript ./scriptU.sh ;;
v|V) checkAndRunScript ./scriptV.sh ;;
x|X) checkAndRunScript ./scriptX.sh ;;
y|Y) checkAndRunScript ./scriptY.sh ;;
z|Z) checkAndRunScript ./scriptZ.sh ;;

[1-9]) executeOption "$1" ;

esac

}

mainLoop(){

while true
do

menuSize=0

case $actualMenu in
0) menuSize=${#menu1[@]} ;;
1) menuSize=${#menu2[@]} ;;
2) menuSize=${#menu3[@]} ;;
esac

(( selected < 0 )) && selected=$((menuSize-1))
(( selected >= menuSize )) && selected=0

drawMenu

readKey

if [[ $key == "" ]]; then
    executeOption "$selected"
fi

done
}

trap onResize WINCH

onResize
initMenus
mainLoop