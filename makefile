%.o : %.s
	ca65 $< --listing $(*F).lst

%.65b : %.o
	ld65 $< -o $@ --config $(*F).cfg -vm --mapfile $(*F).map

all: mos.65b

.PHONY : clean

clean :
	rm -fv *.o *.65b *.map *.lst
