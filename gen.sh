#!/bin/bash

declare -a chromosomes

declare -a allchromosomes

declare -a count_nukl_chrom

declare -a input_ch

read -p 'Input nukleotid: ' nukl

input_char ()
{
  local pos=0
  local nukl=$nukl
  for el in $(seq 0 ${#1}); do
    if [[ $nukl == ${1:el:${#nukl}} ]]
    then
      echo ${1:el:${#nukl}} - $pos - $(( $pos-1+${#nukl} )) "in" $2 Chromosome
    fi
    (( pos++ ))
  done
}

get_count_el_chrm ()
{
  local A=0
  local T=0
  local G=0
  local C=0
  local N=0
  local pos=0
  for el in $(seq 0 ${#1}); do
    case "${1:el:1}" in
      [Aa] ) (( A++ ));;
      [Tt] ) (( T++ ));;
      [Gg] ) (( G++ ));;
      [Cc] ) (( C++ ));;
      "N" ) (( N++ ));;
    esac
    (( pos++ ))
  done

  allnukl=$(( $A+$T+$G+$C+$N ))
  AP=$(( $A * 100 / $allnukl ))
  TP=$(( $T * 100 / $allnukl ))
  GP=$(( $G * 100 / $allnukl ))
  CP=$(( $C * 100 / $allnukl ))
  NP=$(( $N * 100 / $allnukl ))

  echo "$2 chromosome -> Count A - $AP% Count T - $TP% Count G - $GP% Count C - $CP% Count N - $NP%"
}

general_fun ()
{
  local i=0
  local x=0
  while read -r line
  do
      if ! [[ $line =~ ^(\>chr.*)$ ]]
      then
        chromosomes[i]="${chromosomes[i]}$line"
        allchromosomes[x]="${allchromosomes[x]}$line"
        count_nukl_chrom[i]=$(get_count_el_chrm ${chromosomes[i]} $i)
        input_ch[i]=$(input_char ${chromosomes[i]} $i)
      else
        (( i++ ))
      fi
  done < "genome_h.fa"

  for i in "${input_ch[@]}"
  do
   echo "$i"
  done

  get_count_el_chrm ${allchromosomes[@]} All

  for i in "${count_nukl_chrom[@]}"
  do
   echo "$i"
  done

}
general_fun
