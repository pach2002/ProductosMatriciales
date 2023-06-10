#/bin/bath
#Ensamblador/ligador script

if [ -z $1 ]; then
    echo "Usage ./asm64 <asmMainFile> (no extension)"
    exit
fi

#Verificar que no puso el usuario la extension

if [ ! -e "$1.asm" ]; then
    echo "Error $1.asm not found"
    echo "Note, do not enter file extensions."
    exit
fi

#Compile, assemble
echo "Estamos ensamblando el archivo" $1
yasm -Worphan-labels -g dwarf2 -f elf64 $1.asm -l $1.lst
echo "Ligando archivo. . ."
ld -g -o $1 $1.o
echo "Ya puedes ejecutar tu programa"
