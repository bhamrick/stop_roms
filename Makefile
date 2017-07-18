all: stop.gb stop_ly.gb

stop.o: stop.s common/*
	wla-gb -o stop.o stop.s

stop.gb: stop.o linkfile
	wlalink linkfile stop.gb

stop_ly.o: stop_ly.s common/*
	wla-gb -o stop_ly.o stop_ly.s

stop_ly.gb: stop_ly.o linkfile_ly
	wlalink linkfile_ly stop_ly.gb

clean:
	rm *.o *.gb
