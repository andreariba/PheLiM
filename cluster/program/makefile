GPP = g++
OPT = -O4 -g
OBJ = main.o HierClust.o mirna_score.o

HierClustering.exe: $(OBJ)
	$(GPP) $(OPT) $(OBJ) -o $@

main.o: main.cpp
	$(GPP) $(OPT) -c $< -o $@

HierClust.o: HierClust.cpp
	$(GPP) $(OPT) -c $< -o $@

mirna_score.o: mirna_score.cpp
	$(GPP) $(OPT) -c $< -o $@

clean:
	rm *.o
	rm *~

