CFLAG = -Wall -Wextra -Werror -std=c11 -g
GCOV_FLAGS=-fprofile-arcs -ftest-coverage -lgcov
CHECK_FLAGS=-lcheck
ALL_FLAGS = $(CFLAG) $(GCOV_FLAGS) $(CHECK_FLAGS)
SRCS =	s21_string.c
OBJS = $(SRCS:.c=.o) tests.c
OBJST = $(SRCS:.c=.o)
NAME = test

all: clean test s21_string.a gcov_report

objs: $(SRCS)
	gcc $(CFLAG) -c $(SRCS)

test: $(OBJS)
	gcc $(CFLAG) $(CHECK_FLAGS) $(OBJS) -o $(NAME)
	./test
	make clean
	
s21_string.a: objs
	ar rc s21_string.a $(OBJST)
	ranlib s21_string.a

gcov_report: $(OBJS)
	gcc -o $(NAME) $(SRCS) tests.c $(GCOV_FLAGS) $(CHECK_FLAGS)
	./test
	~/homebrew/bin/lcov -t "gcov_report" -o test.info -c -d .
	~/homebrew/bin/genhtml -o gcov_report test.info
	rm -rf *.gcno *.gcda *.gcov *.info *.o test

check:
	python3 ../materials/linters/cpplint.py *.c s21_string.h
	cppcheck *.h s21_string.c
clean:
	rm -rf *.o *.out test s21_string.a *.gcno *.gcda *.gcov *.info gcov_report *.dSYM

rebuild: clean all
exp:
	gcc -o exp exp.c s21_string.c 
	./exp.out