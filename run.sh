#!bin/bash
mkdir results
../cd++.exe -m"hbv.ma" -l"results/hbv.log" -t00:16:00:000 -v
cp results/hbv.log01 ./hbv.log
rm -r results