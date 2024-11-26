#!/bin/bash

# Clear screen 
clear -x

# Setup
y_level=60
start=$SECONDS
health=20
username=$USER
mineSwitch=1
exitFight=0
defendScore=0

# Colours
clear='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
bold_blue='\033[1;34m'
bold_yellow='\033[1;33m'
dark_grey='\033[1;30m'
orange='\033[0;33m'
purple='\033[0;35m'
light_blue='\033[1;34m'

DATA_FILE="$HOME/.config/cli-craft/clicraftsave.txt"

# Dependencies
# bc, shc, awk

# Inventory Reset Function
invReset () {
    stick=0; string=0; spider_eye=0
    dirt=0; pickaxe_iron=0; pickaxe_wood=0
    pickaxe_diamond=0; sword_wooden=0; sword_iron=0 
    sword_diamond=0; cobblestone=0; iron=0; diamond=0; deepslate=0 
    log=0; plank=0; bone=0; arrow=0; rotten_flesh=0; bow=0; porkchop=0; steak=0; chicken=0
    leather=0; feather=0
}
invReset

# Save Game Function
save () {
    tput sc
    echo "Saving."
    sleep .1; tput rc; tput el
    echo "Saving.."
    sleep .1; tput rc; tput el
    echo "Saving..."
    echo -e "$health\n$y_level\n$mineSwitch\n$spawnBiome\n$spawnPassiveMobsBase\n$spawnBiomeDesc\n$biome\n$passiveMobsBase\n$biomeDescription\n$iron\n$diamond\n$cobblestone\n$deepslate\n$dirt\n$log\n$plank\n$stick\n$pickaxe_wood\n$pickaxe_iron\n$pickaxe_diamond\n$sword_wooden\n$sword_iron\n$sword_diamond\n$bone\n$arrow\n$rotten_flesh\n$string\n$spider_eye\n$bow\n$porkchop\n$chicken\n$steak\n$leather\n$feather" > $DATA_FILE
}

# Spawn biome
biome_select () {
    biome_number=$(( RANDOM % 5 ))
    case $biome_number in
        0) biome="Forest"; passiveMobsBase=4 ; tree=$((($RANDOM % 4) + 2)) ; biomeDescription="damp, humid and a light breeze hits the logs creating a whistling sound." ;;
        1) biome="Tundra"; passiveMobsBase=3 ; tree=$((($RANDOM % 3) + 1)) ; biomeDescription="cool, chilly and the remnants of a snowstorm are carried throughout the trees in the air." ;;
        2) biome="Desert"; passiveMobsBase=1 ; tree=$((($RANDOM % 1) + 1)) ; biomeDescription="hot, dry and the blazing sun heats the sand between your toes." ;;
        3) biome="Plains"; passiveMobsBase=4 ; tree=$((($RANDOM % 3) + 1)) ; biomeDescription="moderate, lit-up and the vast green horizon fills you with hope and cheer." ;;
        4) biome="Swamp"; passiveMobsBase=2 ; tree=$((($RANDOM % 4) + 2)) ; biomeDescription="steamy, dark and a creepy mist surrounds you, emanating a haunting, strong smell..." ;;
    esac
}

biome_select
spawnBiome=$biome
spawnTrees=$tree
spawnBiomeDesc=$biomeDescription
spawnPassiveMobsBase=$passiveMobsBase

# Chance Function
chance () {
	chanceOperator=$((($RANDOM % 100) + 1))
	if [[ "$chanceOperator" -le 80 && "$chanceOperator" -ge 61 ]]
	then
		addAmount=$2
	elif [[ "$chanceOperator" -ge 81 ]]
	then
		addAmount=$3
    else
        addAmount=$1
	fi
}

# Death Function
death () {
    local cause="$1"
    echo -e ${red}"
        Y88b   d88P                       8888888b.  d8b               888 
        Y88b d88P                        888  Y88b Y8P               888 
        Y88o88P                         888    888                   888 
        Y888P     .d88b.  888  888     888    888 888  .d88b.   .d88888 
        888     d88   88b 888  888     888    888 888 d8P  Y8b d88  888 
        888     888  888 888  888     888    888 888 88888888 888  888 
        888     Y88..88P Y88b 888     888  .d88P 888 Y8b.     Y88b 888 
        888       Y88P   Y88888     8888888P   888   Y8888    Y88888 
    "${clear}
    echo "$username died $cause"
    echo -n "Would you like to respawn or end game? [r/e]: "
    read respawn
    exploreSwitch=1
    clear
    biome=$spawnBiome
    passiveMobsBase=$spawnPassiveMobsBase
    biomeDescription=$spawnBiomeDesc
    tree=$spawnTrees
    mineSwitch=1
    health=20
    invReset
    if [[ "$respawn" == "e" ]]
    then
        action="exit"
    else
        echo -e "${red}You have been sent back to your spawn, the $biome. Your inventory has been reset."${clear}
    fi
}

# Items Table Function
itemScroller () {
    case $currentItemNumber in
        0) itemSelected="Wooden Pickaxe" ; itemID="$pickaxe_wood" ;;
        1) itemSelected="Iron Pickaxe" ; itemID="$pickaxe_iron" ;;
        2) itemSelected="Diamond Pickaxe" ; itemID="$pickaxe_diamond" ;;
        3) itemSelected="Wooden Sword" ; itemID="$sword_wooden" ;;
        4) itemSelected="Iron Sword" ; itemID="$sword_iron" ;;
        5) itemSelected="Diamond Sword" ; itemID="$sword_diamond" ;;
        6) itemSelected="Bow" ; itemID="$bow" ;;
        7) itemSelected="Dirt" ; itemID="$dirt" ;;
        8) itemSelected="Cobblestone" ; itemID="$cobblestone" ;;
        9) itemSelected="Deepslate" ; itemID="$deepslate" ;; 
        10) itemSelected="Iron" ; itemID="$iron" ;;
        11) itemSelected="Diamond" ; itemID="$diamond" ;;
        12) itemSelected="Wood Log" ; itemID="$log" ;;
        13) itemSelected="Wooden Plank" ; itemID="$plank" ;;
        14) itemSelected="Stick" ; itemID="$stick" ;;
        15) itemSelected="Bone" ; itemID="$bone" ;;
        16) itemSelected="Arrow" ; itemID="$arrow" ;;
        17) itemSelected="Rotten Flesh" ; itemID="$rotten_flesh" ;;
        18) itemSelected="String" ; itemID="$string" ;;
        19) itemSelected="Feather" ; itemID="$feather" ;;
        20) itemSelected="Leather" ; itemID="$leather" ;;
        21) itemSelected="Spider Eye" ; itemID="$spider_eye" ;;
        22) itemSelected="Porkchop" ; itemID="$porkchop" ;;
        23) itemSelected="Chicken" ; itemID="$chicken" ;;
        24) itemSelected="Steak" ; itemID="$steak" ;;
    esac
}

# Pickaxe Delay Functions
pickaxeDelay () {
    if [[ "$pickaxe_diamond" == 1 ]]
    then
        bestPickaxe="diamond"
    elif [[ "$pickaxe_iron" -ge 1 && "$pickaxe_diamond" == 0 ]]
    then
        bestPickaxe="iron"
    elif [[ "$pickaxe_wood" -ge 1 && "$pickaxe_iron" == 0 && "$pickaxe_diamond" == 0 ]]
    then
        bestPickaxe="wood"
    elif [[ "$pickaxe_wood" == 0 && "$pickaxe_iron" == 0 && "$pickaxe_diamond" == 0 ]]
    then
        bestPickaxe=""
    fi
    # Testing purposes: echo "$bestPickaxe"
    
    # Create Table to change delay based on pickaxe
    case $bestPickaxe in
        "") delay=1.5 ;;
        "wood") delay=1 ;;
        "iron") delay=0.5 ;;
        "diamond") delay=0 ;;
    esac
    # Testing Purposes: echo "$delay"
}

# Sword Damage Function
swordDamage () {
    if [[ "$sword_diamond" == 1 ]]
    then
        bestSword="diamond"
    elif [[ "$sword_iron" -ge 1 && "$sword_diamond" == 0 ]]
    then
        bestSword="iron"
    elif [[ "$sword_wooden" -ge 1 && "$sword_iron" == 0 && "$sword_diamond" == 0 ]]
    then
        bestSword="wood"
    elif [[ "$sword_wooden" == 0 && "$sword_iron" == 0 && "$sword_diamond" == 0 ]]
    then
        bestSword=""
    fi

    # Create Table to change damage based on sword
    case $bestSword in
        "") baseDamage=1 ;;
        "wood") baseDamage=4 ;;
        "iron") baseDamage=6 ;;
        "diamond") baseDamage=7 ;;
    esac
}

# Statistics (Mold) Display Function
stats () {
    local currentInventoryItem="$1"
    local inventoryItem="$2"
    if [[ "$currentInventoryItem" -ge 1 ]]
    then
        echo -e "You have ${bold_yellow}$inventoryItem${clear} in amount of ${green}$currentInventoryItem"${clear}
    fi
}

# Hostile Mob Encounter Function
hostileMobEncounter () {
    exitFight=0
    local mob="$1"
    case $mob in
        "zombie") mobHealth=20 ; mainAttack="Bite" ; mainAttackDamage="type-a" ; firstDrop="Rotten Flesh" ; secondDrop="Iron" ;;
        "skeleton" | "stray" | "bogged") mobHealth=20 ; mainAttack="Shoot" ; mainAttackDamage="type-a" ; firstDrop="Bone" ; secondDrop="Arrow" ;;
        "spider") mobHealth=16 ; mainAttack="Strike" ; mainAttackDamage="type-b" ; firstDrop="String" ; secondDrop="Spider Eye" ;;
    esac
    echo -e "${bold_blue}You have encountered a ${bold_yellow}$mob!${bold_blue} You have 3 options, ${red}(a)ttack, ${green}(r)un and ${light_blue}(d)efend:"   
    echo -n "Press [Enter] to continue: "
    read throwaway
    echo -n -e "${orange}Action(You're in an encounter): ${clear}"
    read eAction     
    while [[ "$health" -gt 0 && "$mobHealth" -gt 0 && "$exitFight" != "1" ]]
    do
        # Attack
        if [[ "$eAction" == "a" || "$eAction" == "attack" ]]
        then
            useSword=1
            if [[ "$bow" -ge 1 && "$arrow" -ge 1 ]]
            then
                echo -n "Melee or Range? (m/r): "
                read attackType
                if [[ "$attackType" == r ]]
                then 
                    (( arrow-- ))
                    arrowOddsIncrease=0
                    useSword=0
                    baseDamage=5
                    echo -e "${red}You have 1 second to spam the letter 'b' and then [Enter] to increase the odds of your arrow landing${clear}"
                    echo -n "Spam [b]: "
                    read spamText
                    time=$SECONDS
                    while [[ "$SECONDS" -le $(($time + 1)) ]]
                    do
                        echo -n "Spam [b]: "
                        read spamText
                        if [[ "$spamText" == "b" ]]
                        then
                            (( arrowOddsIncrease++ ))
                        fi
                    done
                    (( arrowOddsIncrease++ ))
                    echo -n -e "${red}Time's Over!${clear} Cofirmation ${purple}1${clear} (Press [Enter]): "
                    read throwaway
                    echo -n -e "${red}Time's Over!${clear} Cofirmation ${purple}2${clear} (Press [Enter]): "
                    read throwaway
                    if [[ "$arrowOddsIncrease" -le 2 ]]
                    then
                        extraDamage=0
                        fullOdds=15
                    elif [[ "$arrowOddsIncrease" -ge 3 && "$arrowOddsIncrease" -le 5 ]]
                    then
                        extraDamage=1
                        fullOdds=20
                    elif [[ "$arrowOddsIncrease" -ge 6 && "$arrowOddsIncrease" -le 9 ]]
                    then
                        extraDamage=2
                        fullOdds=27
                    elif [[ "$arrowOddsIncrease" -ge 10 ]]
                    then
                        extraDamage=5
                        fullOdds=1
                    fi
                else
                    echo "Using Melee Sword..."
                fi
            fi
            if [[ "$useSword" != 0 ]]
            then
                swordDamage
                if [[ "$bestSword" == "diamond" ]]
                then
                    swordType="Diamond Sword"
                elif [[ "$bestSword" == "iron" ]]
                then
                    swordType="Iron Sword"
                elif [[ "$bestSword" == "wood" ]]
                then
                    swordType="Wooden Sword"
                else
                    swordType="Fist"
                fi
                fullOdds=15
                critChance=$(($RANDOM % 10))
                if [[ "$critChance" == 0 ]]
                then
                    extraDamage=2
                else
                    extraDamage=0
                fi
            fi
            mobHitPass=$((RANDOM % $fullOdds))
            if [[ "$mobHitPass" != 6 ]]
            then
                fullDamage=$(($baseDamage + $extraDamage))
                mobHealth=$((mobHealth - $fullDamage))
                echo -e "You ${purple}hit${clear} the $mob! You dealt ${green}$fullDamage${clear} damage!"
            else
                echo "Your attack missed! womp womp"
            fi

        #Run
        elif [[ "$eAction" == "r" || "$eAction" == "run" ]]
        then
            chance 0 1 0
            if [[ "$addAmount" == 0 ]]
            then
                exitFight=1
                echo -e "You ${green}safely escaped${clear} from a ${bold_blue}$mob${clear}! You ${red}coward${clear}."
            else
                echo -n "The $mob grabbed you by the scruff of your neck and pulled you back"
                chance 0 0 1
                if [[ "$addAmount" == 1 ]]
                then
                    echo -e " dealing 1 damage to you. \n"
                    (( health-- ))
                else
                    echo -e ".\n"
                fi
            fi
        # Defend
        elif [[ "$eAction" == "d" || "$eAction" == "defend" ]]
        then
            defendChance=$((RANDOM % 12))
            if [[ "$defendChance" != 9 ]]
            then
                defendScore=1
                echo -e "You used ${bold_blue}defend${clear}! It ${green}succeeded${clear}! You now have protection against the $mob's next attack!"
            elif [[ "$defendChance" == 1 ]]
            then
                echo -e "You used ${bold_blue}defend${clear}! It ${red}failed${clear} :("
            fi
        # Stats
        elif [[ "$eAction" == "stats" || "$eAction" == "s" ]]
        then
            while [[ "$currentItemNumber" -lt 19 ]]
            do
                healthNumber=0
                itemScroller
                stats "$itemID" "$itemSelected"
                ((currentItemNumber++))
            done
            currentItemNumber=0
            echo -e "Your Y-Level is ${green}$y_level${clear} and you are in a ${bold_blue}$biome${clear} biome."
            echo "Your health is $health/20 ❤️. "
        fi
        # Mob's attack
        if [[ "$health" -gt 0 && "$mobHealth" -gt 0 && "$exitFight" != 1 ]]
        then
            if [[ "$mainAttackDamage" == "type-a" ]]
            then
                chance 3 5 6
                if [[ "$defendScore" == 0 ]]
                then
                    health=$((health - $addAmount))
                    echo -e "The ${orange}${mob}${clear} used ${green}$mainAttack${clear}, dealing ${red}$addAmount${clear} damage."
                elif [[ "$defendScore" == 1 ]]
                then
                    echo -e "The ${orange}${mob}${clear} then attempted to use ${green}$mainAttack${clear}, but your defense stayed strong!"
                    defendScore=0
                fi
            elif [[ "$mainAttackDamage" == "type-b" ]]
            then
                chance 2 3 1
                if [[ "$defendScore" == 0 ]]
                then
                    health=$((health - $addAmount))
                    echo -e "The ${orange}${mob}${clear} used ${green}$mainAttack${clear}, dealing ${red}$addAmount${clear} damage."
                elif [[ "$defendScore" == 1 ]]
                then
                    echo -e "The ${orange}${mob}${clear} then attempted to use ${green}$mainAttack${clear}, but your defense stayed strong!"
                fi
            fi # Add more here when more mob types are added
        fi
        # Re-checking mob and player health
        if [[ "$health" -gt 0 && "$mobHealth" -gt 0 && "$exitFight" != 1 ]]
        then
            echo -n -e "${orange}Action: ${clear}"
            read eAction
        else
            if [[ "$health" -le 0 ]]
            then
            	death "whilst fighting $mob."
                exitFight=1
            elif [[ "$mobHealth" -le 0 ]]
            then
                if [[ "$firstDrop" == "Bone" ]]
                then
                    chance 2 3 4
                    bone=$((bone + $addAmount))
                elif [[ "$firstDrop" == "Rotten Flesh" ]]
                then
                    chance 2 3 4
                    rotten_flesh=$((rotten_flesh + $addAmount))
                elif [[ "$firstDrop" == "String" ]]
                then
                    chance 1 2 5
                    string=$((string + $addAmount))
                fi
                echo -n -e "${bold_yellow}Congratulations!${clear} You ${purple}killed${clear} a ${red}$mob${clear}! You gained ${green}$addAmount${bold_blue} $firstDrop(s)${clear}"
                if [[ "$secondDrop" == "Arrow" ]]
                then
                    chance 1 2 0
                    arrow=$((arrow + $addAmount))
                elif [[ "$secondDrop" == "Iron" ]]
                then
                    chance 0 0 1
                    iron=$((iron + $addAmount))
                elif [[ "$secondDrop" == "Spider Eye" ]]
                then
                    chance 1 2 0
                    spider_eye=$((spider_eye + $addAmount))
                fi
                if [[ "$addAmount" != 0 ]]
                then
            	    echo -e " and ${green}$addAmount${bold_blue} $secondDrop(s)${clear} \n"
                else
                    echo -e "\n"
                fi
            fi  
        fi
    done
} 

passiveMobKiller () {
    chance 0 1 2
    if [[ "$addAmount" == 0 ]]
    then
        porkChopAmount=$((($RANDOM % 4) + 1))
        porkchop=$(($porkchop + $porkChopAmount))
        echo -e "You see a ${purple}pig${clear}! You ${red}kill${clear} it, gaining ${green}$porkChopAmount${clear} porkchops!"
    elif [[ "$addAmount" == 1 ]]
    then
        chicken=$(($chicken + 1))
        featherAmount=$((($RANDOM % 3) + 1))
        feather=$(($feather + $featherAmount))
        echo -e -n "You see a ${orange}chicken${clear}! You ${red}kill${clear} it, gaining ${green}1${clear} chicken"
        if [[ "$featherAmount" -ge 1 ]]
        then
            echo -e " and ${green}$featherAmount${clear} feathers!"
        else
            echo -e "!"
        fi
    elif [[ "$addAmount" == 2 ]]
    then
        steakAmount=$((($RANDOM % 3) + 1))
        steak=$(($steak + $steakAmount))
        echo -e -n "You see a ${bold_yellow}cow${clear}! You ${red}kill${clear} it, gaining ${green}$steakAmount${clear} steak!"
        leatherAmount=$((($RANDOM % 3) + 1))
        leather=$(($leather + $leatherAmount))
        if [[ "$leatherAmount" -ge 1 ]]
        then
            echo -e " and ${green}$leatherAmount${clear} leather!"
        else
            echo -e "!"
        fi
    fi
    (( passiveMobsBase-- ))
}

# Tutorial Show Function
tutorial () {
    echo -e ${bold_yellow} "
    There are multiple 'actions' you can take.${bold_blue} 

    ${bold_yellow}1.${bold_blue} The first action available is ${green}mining down${bold_blue}. Activate this by typing ${purple}'mine down'${bold_blue} or ${purple}'m'${bold_blue}. This allows you to mine down 1 block. Remember, breaking blocks other than dirt and wood require a pickaxe!

    ${bold_yellow}2.${bold_blue} The second action available is ${green}observing${bold_blue}. Activate this by typing ${purple}'observe'${bold_blue} or ${purple}'o'${bold_blue}. This will give you a description of your surroundings including trees and mobs.

    ${bold_yellow}3.${bold_blue} The third action available is is ${green}statistics${bold_blue}. Activate this by typing ${purple}'stats'${bold_blue} or ${purple}'s'${bold_blue}. It's actually a stats feature that shows you your inventory, y-level and current biome!

    ${bold_yellow}4.${bold_blue} The fourth action available is ${green}clearing screen${bold_blue}. Activate this by typing ${purple}'clear'${bold_blue} or ${purple}'l'${bold_blue}. It's an aesthetic feature that clears the screen to remove any unessessary clutter.

    ${bold_yellow}5.${bold_blue} The fifth action available is ${green}exploration${bold_blue}. Activate this by typing ${purple}'explore'${bold_blue} or ${purple}'e'${bold_blue}. It allows you to move from one biome to another, allowing for more mob encounters.

    ${bold_yellow}6.${bold_blue} The sixth action available ${green}shows this tutorial${bold_blue}. Activate this by typing ${purple}'tutorial'${bold_blue} or ${purple}'help'${bold_blue}.
    
    ${bold_yellow}7.${bold_blue} The seventh action available is ${green}chopping${bold_blue}. Activate this by typing ${purple}'chop'${bold_blue} or ${purple}'h'${bold_blue}. Embrace your inner lumberjack and chop down surrounding trees!
    
    ${bold_yellow}8.${bold_blue} The eight action available is ${green}crafting${bold_blue}. Activate this by typing ${purple}'craft'${bold_blue} or ${purple}'c'${bold_blue}. Create new items with the resources you get from your surroundings!

    ${bold_yellow}9.${bold_blue} The ninth action available is ${green}saving${bold_blue}. Activate this by typing ${purple}'save'${bold_blue} or ${purple}'a'${bold_blue}. Save your game to a local folder so you can continue your playthrough next time you play!

    ${bold_yellow}10.${bold_blue} The tenth action available is ${green}hunting${bold_blue}. Activate this by typing ${purple}'hunt'${bold_blue} or ${purple}'n'${bold_blue}. Use this to hunt nearby passive mobs for food!

    ${bold_yellow}11.${bold_blue} The eleventh action available is ${green}eating${bold_blue}. Activate this by typing ${purple}'eat'${bold_blue} or ${purple}'t'${bold_blue}. Use this to eat your food, if you have any, to regenerate your health!

    ${bold_yellow}12.${bold_blue} The twelfth action available is ${green}exiting${bold_blue}. Activate this by typing ${purple}'exit'${bold_blue}. This exits the game.

    "${clear}
}

# Logo
logo () {
	echo -e ${green} "



	 ▄████▄   ██▓     ██▓    ▄████▄   ██▀███   ▄▄▄        █████▒▄▄▄█████▓
	▒██▀ ▀█  ▓██▒    ▓██▒▒   ██▀ ▀█  ▓██ ▒ ██▒▒████▄    ▓██   ▒ ▓  ██▒ ▓▒
	▒▓█    ▄ ▒██░    ▒██▒▒███▓█    ▄ ▓██ ░▄█ ▒▒██  ▀█▄  ▒████ ░ ▒ ▓██░ ▒░
	▒▓▓▄ ▄██▒▒██░    ░██░▒ ░ ▓▓▄ ▄██▒▒██▀▀█▄  ░██▄▄▄▄██ ░▓█▒  ░ ░ ▓██▓ ░ 
	▒ ▓███▀ ░░██████▒░██░▒    ▓███▀ ░░██▓ ▒██▒ ▓█   ▓██▒░▒█░      ▒██▒ ░ 
	░ ░▒ ▒  ░░ ▒░▓  ░░▓  ░    ░▒ ▒  ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ▒ ░      ▒ ░░   
	  ░  ▒   ░ ░ ▒  ░ ▒ ░     ░  ▒     ░▒ ░ ▒░  ▒   ▒▒ ░ ░          ░    
	░          ░ ░    ▒ ░░             ░░   ░   ░   ▒    ░ ░      ░      
	░ ░          ░  ░ ░  ░ ░            ░           ░  ░                 
	░                    ░                                            

	           ░                                            

	"${clear}
}
logo
# Starting game
echo -n "Press [Enter] to continue: "
read continue
clear -x
echo "Welcome to cli-craft, DontEvenTalkToMe's Minecraft Clone built for a CLI! It is scripted in Bash and is available at: https://www.github.com/DontEvenTalkToMe/clicraft. This is a passion project and is in no way, shape or form affiliated, endorsed or sponsored by Mojang, Microsoft or any of their constituent companies.
" 
#sleep 1
echo -e ${bold_yellow}"Tutorial: " ${clear}

# Running tutorial function
tutorial
if [[ -e $DATA_FILE ]]
then
    echo "Loading previous save from $DATA_FILE..."
    health=$(awk 'NR==1' $DATA_FILE)
    y_level=$(awk 'NR==2' $DATA_FILE)
    mineSwitch=$(awk 'NR==3' $DATA_FILE)
    spawnBiome=$(awk 'NR==4' $DATA_FILE)
    spawnPassiveMobsBase=$(awk 'NR==5' $DATA_FILE)
    spawnBiomeDesc=$(awk 'NR==6' $DATA_FILE)
    biome=$(awk 'NR==7' $DATA_FILE)
    passiveMobsBase=$(awk 'NR==8' $DATA_FILE)
    biomeDescription=$(awk 'NR==9' $DATA_FILE)
    iron=$(awk 'NR==10' $DATA_FILE)
    diamond=$(awk 'NR==11' $DATA_FILE)
    cobblestone=$(awk 'NR==12' $DATA_FILE)
    deepslate=$(awk 'NR==13' $DATA_FILE)
    dirt=$(awk 'NR==14' $DATA_FILE)
    log=$(awk 'NR==15' $DATA_FILE)
    plank=$(awk 'NR==16' $DATA_FILE)
    stick=$(awk 'NR==17' $DATA_FILE)
    pickaxe_wood=$(awk 'NR==18' $DATA_FILE)
    pickaxe_iron=$(awk 'NR==19' $DATA_FILE)
    pickaxe_diamond=$(awk 'NR==20' $DATA_FILE)
    sword_wooden=$(awk 'NR==21' $DATA_FILE)
    sword_iron=$(awk 'NR==22' $DATA_FILE)
    sword_diamond=$(awk 'NR==23' $DATA_FILE)
    bone=$(awk 'NR==24' $DATA_FILE)
    arrow=$(awk 'NR==25' $DATA_FILE)
    rotten_flesh=$(awk 'NR==26' $DATA_FILE)
    string=$(awk 'NR==27' $DATA_FILE)
    spider_eye=$(awk 'NR==28' $DATA_FILE)
    bow=$(awk 'NR==29' $DATA_FILE)
    porkchop=$(awk 'NR==30' $DATA_FILE)
    chicken=$(awk 'NR==31' $DATA_FILE)
    steak=$(awk 'NR==32' $DATA_FILE)
    leather=$(awk 'NR==33' $DATA_FILE)
    feather=$(awk 'NR==34' $DATA_FILE)
else
    echo "Press [Enter] to generate new world"
    read gen_world
    while [[ "$gen_world" != "" ]]
    do
        echo "Press [Enter] to generate new world"
        read gen_world
    done
fi

echo -n "Action: "
read action
while [[ "$action" != "exit" ]]
do
    # Action A: Mine Down
    if [[ "$action" == "m" || "$action" == "mine down" ]]
    then
        if [[ "$mineSwitch" == 1 ]]
        then
            if [[ "$pickaxe_wood" != "1" && "$pickaxe_iron" != "1" && "$pickaxe_diamond" != "1" ]]
            then
                if [[ "$y_level" == 60 || "$y_level" == 59 ]]
                then
                    (( y_level-- ))
                    ((  dirt++  ))
                    echo -e "You mined ${green}down${clear} 1 block and gained ${bold_blue}1 ${orange}dirt${clear}! Use the action 'stats' or 's' to see your Inventory!"
                else
                    echo -e "You ${red}need${clear} a pickaxe to mine the block ${purple}below${clear} you!"
                fi
            elif [[ "$y_level" -lt 61 && "$y_level" -gt 58 ]]
            then
                ((y_level--))
                ((dirt++))
                echo -e "You mined ${green}down${clear} 1 block and gained ${bold_blue}1 ${orange}dirt${clear}! Use the action 'stats' or 's' to see your Inventory!"
            elif [[ "$y_level" -lt 59 && "$y_level" -gt 0 ]]
            then
                ((y_level--))
                cobbleIronOre=$(($RANDOM % 10))
                cobbleDiamondOre=$(($RANDOM % 50))
                if [[ "$cobbleIronOre" == 6 ]]
                then
                    ironVein=$((($RANDOM % 9) + 1))
                    iron=$((iron + $ironVein))
                    echo -e "You found ${green}$ironVein ${bold_yellow}Iron${clear}! It has been added to your ${green}Inventory${clear}."
                elif [[ "$cobbleIronOre" != 6 && "$cobbleDiamondOre" == 6 ]]
                then
                    diamondVein=$((($RANDOM % 3) + 1))
                    diamond=$((diamond + $diamondVein))
                    echo -e "You found ${green}$diamondVein ${bold_blue}Diamond${clear}! It has been added to your Inventory."
                else
                    cobblestone=$(($cobblestone + 1))
                    echo -e "You ${orange}mined${clear} down ${green}1 block${clear} and gained ${bold_blue}1 ${purple}cobblestone${clear}! Use the action 'stats' or 's' to see your ${red}Inventory${clear}!"
                fi
            elif [[ "$y_level" -lt 1 && "$y_level" -gt -64 ]]
            then
                if [[ "$pickaxe_diamond" -ge 1 || "$pickaxe_iron" -ge 1 ]]
                then
                    y_level=$(($y_level - 1))
                    deepslateIronOre=$(($RANDOM % 10))
                    deepslateDiamondOre=$(($RANDOM % 25))
                    if [[ "$deepslateIronOre" == 6 ]]
                    then
                        ironVein=$((($RANDOM % 12) + 1))
                        iron=$((iron + $ironVein))
                        echo -e "You found ${green}$ironVein ${bold_yellow}Iron${clear}! It has been added to your Inventory."
                    elif [[ "$deepslateDiamondOre" == 9 ]]
                    then
                        diamondVein=$((($RANDOM % 6) + 1))
                        diamond=$((diamond + $diamondVein))
                        echo -e "You found ${green}$diamondVein ${bold_blue}Diamond${clear}! It has been added to your Inventory."
                    else
                        deepslate=$((deepslate + 1))
                        echo -e "You ${orange}mined${clear} down ${green}1 block${clear} and gained ${bold_blue}1 ${purple}deepslate${clear}! Use the action 'stats' or 's' to see your ${red}Inventory${clear}!"

                    fi
                else
                    echo -e "You ${red}need${clear} a ${green}better${clear} pickaxe to mine ${orange}deeper${clear}!"
                fi
            fi
# Adding Chance
            encounterMine=$((RANDOM % 80))
            if [[ "$encounterMine" == 9 ]]
            then
                randomMob=$(($RANDOM % 2))
                if [[ "$randomMob" == 1 ]]
                then
                    if [[ "$biome" == "Tundra" ]]
                    then
                        mobbo="stray"
                    elif [[ "$biome" == "Swamp" ]]
                    then
                        mobbo="bogged"
                    else
                        mobbo="skeleton"
                    fi
                elif [[ "$randomMob" == 0 ]]
                then
                    mobbo="zombie"
                fi
                hostileMobEncounter "$mobbo"
            fi
        else
            echo "You must move to another biome using 'explore' or 'e' to mine down again!"
        fi
    
    # Action B: Observe
    elif [[ "$action" == "observe" || "$action" == "o" ]]
    then
        if [[ "$y_level" -ge 59 ]]
        then
            echo -e "You are in a ${bold_blue}$biome${clear}, surrounded by ${green}$tree tree(s)${clear}. The atmosphere is ${orange}$biomeDescription${clear}"
            chance 0 0 1
            if [[ "$addAmount" == 1 ]]
            then
                echo -e "${red}\nSuddenly you feel a tremor...${clear}"
                randomMob=$(($RANDOM % 3))
                if [[ "$randomMob" == 1 ]]
                then
                    if [[ "$biome" == "Tundra" ]]
                    then
                        mobbo="stray"
                    elif [[ "$biome" == "Swamp" ]]
                    then
                        mobbo="bogged"
                    else
                        mobbo="skeleton"
                    fi
                elif [[ "$randomMob" == 0 ]]
                then
                    mobbo="zombie"
                elif [[ "$randomMob" == 2 ]]
                then
                    mobbo="spider"
                fi
                hostileMobEncounter "$mobbo"
            fi
        else
            echo -e "Your Y-Level is ${bold_blue}$y_level${clear}, ${red}you're in the ground.${clear} At best, you're looking at stone and dirt. ${green}Use '${bold_blue}up${green}' or '${bold_blue}u${green}' to see.${clear}"
        fi
    
    # Action C: Clear Screen
    elif [[ "$action" == "clear" || "$action" == "l" ]]
    then
        clear
    #Action D: Statistics
    elif [[ "$action" == "stats" || "$action" == "s" ]]
    then
        while [[ "$currentItemNumber" -lt 25 ]]
        do
            healthNumber=0
            itemScroller
            stats "$itemID" "$itemSelected"
            ((currentItemNumber++))
        done
        currentItemNumber=0
        echo -e "Your Y-Level is ${green}$y_level${clear} and you are in a ${bold_blue}$biome${clear} biome."
        echo "Your health is $health/20 ❤️. "

    # # Admin Testing
    # elif [[ "$action" == "admin" ]]
    # then
    #     randomMob=$(($RANDOM % 2))
    #     if [[ "$randomMob" == 1 ]]
    #     then
    #         if [[ "$biome" == "Tundra" ]]
    #         then
    #             mobbo="stray"
    #         elif [[ "$biome" == "Swamp" ]]
    #         then
    #             mobbo="bogged"
    #         else
    #             mobbo="skeleton"
    #         fi
    #     elif [[ "$randomMob" == 0 ]]
    #     then
    #         mobbo="zombie"
    #     fi
    #     hostileMobEncounter "$mobbo"

    # Action E: Tutorial
    elif [[ "$action" == "tutorial" || "$action" == "help" ]]
    then
        tutorial
    
    # Action F: Up
    elif [[ "$action" == "u" || "$action" == "up" ]]
    then
        if [[ "$y_level" -le 58 ]]
        then
            echo "Moving you up....."
            sleep .1
            y_level=60
            mineSwitch=0
            echo "You have been moved to land level, however to mine again you must travel to another biome! Travel using 'explore' or 'e'."
        elif [[ "$y_level" -ge 59 ]]
        then
            echo "You are already at land level! If you wish to travel to another biome use 'explore' or 'e'."
        fi
    
    #  Action G: Explore
    elif [[ "$action" == "explore" || "$action" == "e" ]]
    then
        if [[ "$y_level" -ge 59 ]]
        then
            exploreSwitch=0
            tput sc
            echo "Exploring.
            ⠀⠀⠀⠀⠀⠀⠀⢰⠒⠒⠒⠒⠒⠒⢲⡖⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀
            ⠀⠀⢀⡀⣯⠉⠉⠉⣖⣲⣶⡆⠀⠀⠈⠉⠉⠉⠉⠉⠉⢱⠀⠀⠀⠀
            ⢀⣀⣸⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⣀⡀
            ⢸⣿⣀⣀⡀⠀⠿⠿⠀⠀⠀⣸⣙⣿⣿⠀⢸⣿⠀⠀⠀⠀⠀⠀⢰⡇
            ⢸⡿⠾⠿⠟⠀⠀⠀⣤⡄⠀⠸⠿⠿⠟⠀⠸⠿⠀⠀⠀⣠⣤⠀⢸⡇
            ⢸⡃⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠀⢸⡇
            ⢸⣖⠀⠀⠀⠀⠀⠀⠙⠋⠀⢴⣶⣶⣶⠀⠀⠀⣶⣶⠀⠀⠀⠀⢸⡇
            ⢸⣿⣶⠀⠀⠀⣶⣶⠀⠀⠀⠈⠉⠉⠉⠀⠀⠀⠉⠉⠀⠀⠀⣷⣾⡇
            ⠈⠉⢹⣿⣿⣀⣀⣠⠀⠀⠀⠀⠀⠀⠸⣿⡇⠀⣀⣀⣀⣿⣿⡏⠉⠁
            ⠀⠀⠀⠀⢿⠿⠿⢿⣀⣀⣀⣀⣠⣤⣤⣤⣤⣤⣿⠿⠿⡿⠀⠀⠀⠀
            ⠀⠀⠀⠀⠀⠀⠀⠸⠿⠿⠿⠿⠿⣿⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀
            "
            sleep .5
            tput rc
            tput el
            echo "Exploring..
            ⠀⠀⠀⠀⠀⠀⠀⢰⠒⠒⠒⠒⠒⠒⢲⡖⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀
            ⠀⠀⢀⡀⣯⠉⠉⠉⣖⣲⣶⡆⠀⠀⠈⠉⠉⠉⠉⠉⠉⢱⠀⠀⠀⠀
            ⢀⣀⣸⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⣀⡀
            ⢸⣿⣀⣀⡀⠀⠿⠿⠀⠀⠀⣸⣙⣿⣿⠀⢸⣿⠀⠀⠀⠀⠀⠀⢰⡇
            ⢸⡿⠾⠿⠟⠀⠀⠀⣤⡄⠀⠸⠿⠿⠟⠀⠸⠿⠀⠀⠀⣠⣤⠀⢸⡇
            ⢸⡃⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠀⢸⡇
            ⢸⣖⠀⠀⠀⠀⠀⠀⠙⠋⠀⢴⣶⣶⣶⠀⠀⠀⣶⣶⠀⠀⠀⠀⢸⡇
            ⢸⣿⣶⠀⠀⠀⣶⣶⠀⠀⠀⠈⠉⠉⠉⠀⠀⠀⠉⠉⠀⠀⠀⣷⣾⡇
            ⠈⠉⢹⣿⣿⣀⣀⣠⠀⠀⠀⠀⠀⠀⠸⣿⡇⠀⣀⣀⣀⣿⣿⡏⠉⠁
            ⠀⠀⠀⠀⢿⠿⠿⢿⣀⣀⣀⣀⣠⣤⣤⣤⣤⣤⣿⠿⠿⡿⠀⠀⠀⠀
            ⠀⠀⠀⠀⠀⠀⠀⠸⠿⠿⠿⠿⠿⣿⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀
            "
            sleep .5
            tput rc
            tput el
            echo "Exploring...
            ⠀⠀⠀⠀⠀⠀⠀⢰⠒⠒⠒⠒⠒⠒⢲⡖⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀
            ⠀⠀⢀⡀⣯⠉⠉⠉⣖⣲⣶⡆⠀⠀⠈⠉⠉⠉⠉⠉⠉⢱⠀⠀⠀⠀
            ⢀⣀⣸⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⣀⡀
            ⢸⣿⣀⣀⡀⠀⠿⠿⠀⠀⠀⣸⣙⣿⣿⠀⢸⣿⠀⠀⠀⠀⠀⠀⢰⡇
            ⢸⡿⠾⠿⠟⠀⠀⠀⣤⡄⠀⠸⠿⠿⠟⠀⠸⠿⠀⠀⠀⣠⣤⠀⢸⡇
            ⢸⡃⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠀⢸⡇
            ⢸⣖⠀⠀⠀⠀⠀⠀⠙⠋⠀⢴⣶⣶⣶⠀⠀⠀⣶⣶⠀⠀⠀⠀⢸⡇
            ⢸⣿⣶⠀⠀⠀⣶⣶⠀⠀⠀⠈⠉⠉⠉⠀⠀⠀⠉⠉⠀⠀⠀⣷⣾⡇
            ⠈⠉⢹⣿⣿⣀⣀⣠⠀⠀⠀⠀⠀⠀⠸⣿⡇⠀⣀⣀⣀⣿⣿⡏⠉⠁
            ⠀⠀⠀⠀⢿⠿⠿⢿⣀⣀⣀⣀⣠⣤⣤⣤⣤⣤⣿⠿⠿⡿⠀⠀⠀⠀
            ⠀⠀⠀⠀⠀⠀⠀⠸⠿⠿⠿⠿⠿⣿⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀
            "
            sleep .5
            clear -x
            # Add a chance for a mob encounter here
            chance 1 0 1
            if [[ "$addAmount" == 1 ]]
            then
                echo -e "${red}\n\nSuddenly you feel a tremor...${clear}"
                randomMob=$(($RANDOM % 3))
                if [[ "$randomMob" == 1 ]]
                then
                    if [[ "$biome" == "Tundra" ]]
                    then
                        mobbo="stray"
                    elif [[ "$biome" == "Swamp" ]]
                    then
                        mobbo="bogged"
                    else
                        mobbo="skeleton"
                    fi
                elif [[ "$randomMob" == 0 ]]
                then
                    mobbo="zombie"
                elif [[ "$randomMob" == 2 ]]
                then
                    mobbo="spider"
                fi
                hostileMobEncounter "$mobbo"
            fi
            if [[ "$exploreSwitch" != 1 ]]
            then
                echo -e "You have found a ${bold_blue}$biome${clear} biome! Use 'observe' or 'o' to get details about your surroundings!"
                biome_select
            fi

            mineSwitch=1
        else
            echo -e "You're ${orange}underground${clear}, where do you want to explore to? A ${purple}rock${clear}? Go up to land to ${green}explore${clear}!"
        fi
    
    # Action H: Chop
    elif [[ "$action" == "chop" || "$action" == "h" ]]
    then
        if [[ "$tree" -ge 1 ]]
        then
            if [[ "$y_level" -ge 59 ]]
            then
                tput sc 
                echo "Chopping..."  
                sleep .5    
                tput rc 
                tput el 
                (( tree-- ))  
                treeLogAmount=$((($RANDOM % 4) + 1))    
                log=$((log + $treeLogAmount))   
                echo -e "You chopped down a ${green}tree${clear}! Thanks for ${red}destroying${clear} animal habitats and causing ${bold_yellow}gas emissions${clear}! /j. You gained ${green}$treeLogAmount${bold_blue} log(s)${clear}!"   
            else
                echo -e "You're ${orange}underground${clear}! Try using '${green}up${clear}' to get to ${bold_blue}land level${clear}!"
            fi
        else
            echo -e "Hey! There aren't any ${green}trees${clear} ${red}'round these here parts ya'${clear} see. Try ${purple}exploring${clear} using 'explore' or 'e'."
        fi

    # Action I: Logo(secret)
    elif [[ "$action" == "logo" ]]
    then
        logo
    
    # Action J: Crafting
    elif [[ "$action" == "craft" || "$action" == "c" ]]
    then
        recipeCount=0
        # Echo available crafts if-statement
        echo -e "${bold_blue}Available Crafts(if none show, you don't have enough ingredients): "${clear}
        if [[ "$log" -ge 1 ]]
        then
            echo -e "- You can craft ${purple}4${clear} planks with ${orange}1${clear} log. Type 'plank' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$plank" -ge 1 ]]
        then
            echo -e "- You can craft ${purple}4${clear} sticks with ${orange}1${clear} plank. Type 'stick' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 2 && "$plank" -ge 3 ]]
        then
            echo -e "- You can craft a ${purple}Wooden Pickaxe${clear} with ${orange}3${clear} planks and ${orange}2${clear} sticks. Type 'wooden pickaxe' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 2 && "$iron" -ge 3 ]]
        then
            echo -e "- You can craft an ${purple}Iron Pickaxe${clear} with ${orange}3${clear} iron and ${orange}2${clear} sticks. Type 'iron pickaxe' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 2 && "$diamond" -ge 3 ]]
        then
            echo -e "- You can craft a ${purple}Diamond Pickaxe${clear} with ${orange}3${clear} diamonds and ${orange}2${clear} sticks. Type 'diamond pickaxe' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 1 && "$plank" -ge 2 ]]
        then
            echo -e "- You can craft a ${purple}Wooden Sword${clear} with ${orange}2${clear} planks and ${orange}1${clear} stick. Type 'wooden sword' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 1 && "$iron" -ge 2 ]]
        then
            echo -e "- You can craft an ${purple}Iron Sword${clear} with ${orange}2${clear} iron and ${orange}1${clear} stick. Type 'iron sword' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 1 && "$diamond" -ge 2 ]]
        then
            echo -e "- You can craft a ${purple}Diamond Sword${clear} with ${orange}2${clear} diamonds and ${orange}1${clear} stick. Type 'diamond sword' to craft it!"
            (( recipeCount++ ))
        fi
        if [[ "$stick" -ge 3 && "$string" -ge 3 ]]
        then
            echo -e "- You can craft a ${purple}Bow${clear} with ${orange}3${clear} string and ${orange}3${clear} sticks. Type 'bow' to craft it!"
            (( recipeCount++ ))
        fi
        # Craft switch if-statement
        if [[ "$recipeCount" != 0 ]]
        then
            echo -e -n "${purple}Recipe: ${clear}"
            read cAction
        fi
        # Affecting the inventory based on craft
        if [[ "$cAction" == "plank" && "$log" -ge 1 ]]
        then
            echo -e "You crafted ${purple}1 ${orange}log ${clear}into ${green}4 ${bold_blue}planks!${clear}"
            (( log-- ))
            plank=$((plank + 4))
        elif [[ "$cAction" == "stick" && "$plank" -ge 1 ]]
        then
            echo -e "You crafted ${purple}1 ${orange}plank ${clear}into ${green}4 ${bold_blue}sticks!${clear}"
            (( plank-- ))
            stick=$((stick + 4))
        elif [[ "$cAction" == "wooden pickaxe" && "$stick" -ge 2 && "$plank" -ge 3 ]]
        then
            echo -e "You crafted ${purple}3 ${orange}planks and ${purple}2 ${orange}sticks ${clear}into ${green}1 ${bold_blue}wooden pickaxe!!${clear}"
            plank=$((plank - 3))
            stick=$((stick - 2))
            (( pickaxe_wood++ ))
        elif [[ "$cAction" == "iron pickaxe" && "$stick" -ge 2 && "$iron" -ge 3 ]]
        then
            echo -e "You crafted ${purple}3 ${orange}planks and ${purple}2 ${orange}sticks ${clear}into ${green}1 ${bold_blue}iron pickaxe!!${clear}"
            iron=$((iron - 3))
            stick=$((stick - 2))
            (( pickaxe_iron++ ))
        elif [[ "$cAction" == "diamond pickaxe" && "$stick" -ge 2 && "$diamond" -ge 3 ]]
        then
            echo -e "You crafted ${purple}3 ${orange}planks and ${purple}2 ${orange}sticks ${clear}into ${green}1 ${bold_blue}diamond pickaxe!!${clear}"
            diamond=$((diamond - 3))
            stick=$((stick - 2))
            (( pickaxe_diamond++ ))
        elif [[ "$cAction" == "wooden sword" && "$stick" -ge 1 && "$plank" -ge 2 ]]
        then
            echo -e "You crafted ${purple}2 ${orange}planks and ${purple}1 ${orange}stick${clear} into ${green}1 ${bold_blue}wooden sword!!${clear}"
            plank=$((plank - 2))
            stick=$((stick - 1))
            (( sword_wooden++ ))
        elif [[ "$cAction" == "iron sword" && "$stick" -ge 1 && "$iron" -ge 2 ]]
        then
            echo -e "You crafted ${purple}2 ${orange}iron and ${purple}1 ${orange}stick${clear}into ${green}1 ${bold_blue}iron sword!!${clear}"
            iron=$((iron - 2))
            stick=$((stick - 1))
            (( sword_iron++ ))
        elif [[ "$cAction" == "diamond sword" && "$stick" -ge 1 && "$diamond" -ge 2 ]]
        then
            echo -e "You crafted ${purple}2 ${orange}diamonds and ${purple}1 ${orange}stick${clear}into ${green}1 ${bold_blue}diamond sword!!${clear}"
            diamond=$((diamond - 2))
            stick=$((stick - 1))
            (( sword_diamond++ ))
        elif [[ "$cAction" == "bow" && "$stick" -ge 3 && "$string" -ge 3 ]]
        then
            echo -e "You crafted ${purple}3 ${orange}string and ${purple}3 ${orange}sticks${clear}into ${green}1 ${bold_blue}bow!${clear}"
            string=$((string - 3))
            stick=$((stick - 3))
            (( bow++ ))
        fi

    # Action K: Saving
    elif [[ "$action" == "a" || "$action" == "save" ]]
    then
        save               
    # Action L: Hunting
    elif [[ "$action" == "hunt" || "$action" == "n" ]]
    then
        if [[ "$passiveMobsBase" -ge 1 ]]
        then
            passiveMobKiller
        else
            echo "You've killed all the mobs in this region! Try exploring!"
        fi
    # Action M: Eating
    elif [[ "$action" == "eat" || "$action" == "t" ]]
    then
        if [[ "$health" -lt 20 ]]
        then
            foodAmount=0
            if [[ "$porkchop" -ge 1 ]]
            then
                echo -e "You have $porkchop ${purple}porkchops${clear}! Type '${purple}p${clear}' to eat it!"
                (( foodAmount++ ))
            fi
            if [[ "$chicken" -ge 1 ]]
            then
                echo -e "You have $chicken ${bold_blue}chicken${clear}! Type '${bold_blue}c${clear}' to eat it!"
                (( foodAmount++ ))
            fi
            if [[ "$steak" -ge 1 ]]
            then
                echo -e "You have $steak ${orange}steak${clear}! Type '${orange}s${clear}' to eat it!"
                (( foodAmount++ ))
            fi
            if [[ "$foodAmount" -ge 1 ]]
            then
                read -p "What would you like to eat?: " foodChoice
            else
                echo -e "You have ${red}no food${clear}! Try ${orange}'hu(n)ting'${clear}!"
            fi
            case $foodChoice in
                p) addRegen=3 ; foodName="porkchop" ; porkchop=$(( porkchop - 1 )) ;; 
                c) addRegen=2 ; foodName="chicken" ; chicken=$(( chicken - 1 )) ;; 
                s) addRegen=6 ; foodName="steak" ; steak=$(( steak - 1 )) ;; 
            esac
            grossHealth=$(( $addRegen + $health ))
            if [[ "$grossHealth" -le 20 ]]
            then
                health=$(( $addRegen + $health ))
                tempHealth=$addRegen
            else
                tempHealth=$((20 - $health))
                health=20
            fi
            if [[ "$foodChoice" == "p" || "$foodChoice" == "s" || "$foodChoice" == "c" ]]
            then
                echo -e "You ate 1 ${orange}$foodName${clear} gained ${red}$tempHealth health${clear}! You are now at ${red}$health${clear} health ❤️!"
            fi
        else
            echo -e "You are ${red}already${clear} at ${green}20${clear} health ❤️!"
        fi
    # Else: Invalid Action  
    else
        echo "Hey! That's not a valid action!"
        # Adding 0.003% Chance to die everytime you enter a wrong input
        invalidActionPenalty=$(($RANDOM))
        if [[ "$invalidActionPenalty" == 690 ]]
        then
            death "from Intentional Game Design."
        fi
    fi
    
    # Re-Check action's value
    if [[ "$action" != "exit" ]]
    then
        echo -n "Action: "
        read action
    fi
done

echo -n "Would you like to save the game? (y/n): "
read saveGame
while [[ "$saveGame" != "y" && "$saveGame" != "n" ]]
do
    echo -n "Would you like to save the game? (y/n): "
    read saveGame
done
if [[ "$saveGame" == "y" ]]
then
    save
fi

