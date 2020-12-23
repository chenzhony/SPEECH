#!/bin/sh
#This program returns the
#contents of my Home folder
HInit -S lists/trainList.txt -l Alex -L ../labels/train -M hmms -o Alex -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Amelia -L ../labels/train -M hmms -o Amelia -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Anushka -L ../labels/train -M hmms -o Anushka -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Chandupraveen -L ../labels/train -M hmms -o Chandupraveen -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Charlotte -L ../labels/train -M hmms -o Charlotte -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Ergun -L ../labels/train -M hmms -o Ergun -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Georgiana -L ../labels/train -M hmms -o Georgiana -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Jake -L ../labels/train -M hmms -o Jake -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Jardel -L ../labels/train -M hmms -o Jardel -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Joe -L ../labels/train -M hmms -o Joe -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Jordan -L ../labels/train -M hmms -o Jordan -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Josephine -L ../labels/train -M hmms -o Josephine -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Lukasz -L ../labels/train -M hmms -o Lukasz -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Matt -L ../labels/train -M hmms -o Matt -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Rob -L ../labels/train -M hmms -o Rob -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Shaun -L ../labels/train -M hmms -o Shaun -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Thomas -L ../labels/train -M hmms -o Thomas -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Tim -L ../labels/train -M hmms -o Tim -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Toby -L ../labels/train -M hmms -o Toby -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l Will -L ../labels/train -M hmms -o Will -T 1 ../lib/proto8StatesCombine.txt
HInit -S lists/trainList.txt -l sil -L ../labels/train -M hmms -o sil -T 1 ../lib/proto8StatesCombine.txt
HVite -T 1 -S lists/testList.txt -d hmms/ -w ../lib/NET -l results ../lib/dict ../lib/words3
HResults -p -e "???" sil -e "???" sp -L ../labels/test ../lib/words3 results/*.rec