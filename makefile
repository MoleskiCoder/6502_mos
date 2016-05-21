%.o : %.s
	ca65 $< -g --listing $(*F).lst

%.65b : %.o
	ld65 $< -o $@ --config $(*F).cfg -vm --mapfile $(*F).map --dbgfile $(*F).dbg

all: mos.65b

.PHONY : clean

clean :
	rm -fv *.o *.65b *.map *.lst
