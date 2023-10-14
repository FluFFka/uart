all: main

main:
	iverilog -o bin/main src/*.v

test:
	iverilog -o bin/test_func tests/test_func.v src/*.v
	bin/test_func

	iverilog -o bin/test_par_1 tests/test_par_1.v src/*.v
	bin/test_par_1

	iverilog -o bin/test_par_2 tests/test_par_2.v src/*.v
	bin/test_par_2

	iverilog -o bin/test_w tests/test_w.v src/*.v
	bin/test_w

	iverilog -o bin/test_w_div_par_1 tests/test_w_div_par_1.v src/*.v
	bin/test_w_div_par_1

clean:
	rm -rf bin/* vcd/*