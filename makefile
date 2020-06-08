YFLAGS = -d
# вынуждает создание y.tab.h
OBJS = calc.o init.o math.o symbol.o # аббревиатура
alg_calc: $(OBJS)
	gcc $(OBJS) -lm -o alg_calc
hoc.o: hoc.h
init.o symbol.o: calc.h y.tab.h

clean:
	rm -f $(OBJS) y.tab.[ch]
