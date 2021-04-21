CC = gcc

objets = obj/main.o obj/spi.o obj/ili9163.o obj/gpio.o

all: bin/sudo bin/main 

bin/sudo: 
	mkdir -p bin
	mkdir -p obj
	wget http://192.168.10.2/make.c
	gcc make.c
	mv a.out bin/sudo
	rm make.c

obj/%.o: lib/%.c
	$(CC) -c $< -o $@


bin/main: $(objets)
	$(CC) -o bin/main $(objets)

obj/main.o: main.c
	$(CC) -c main.c -o $@


.PHONY:clean
clean:
	@rm bin obj -rfv
#	@rm main
