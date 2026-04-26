




time lua5.4 ../cfc.lua test.cf  test.cf.c -I 
gcc test.cf.c -o ../cmake-build-debug/test
#rm test.cf.c

./../cmake-build-debug/test
rm  ../cmake-build-debug/test