#include <cstdio>
#include <iostream>
#include <string>
using namespace std;

char commandBuf [20];
int param;

string commandNop = string("nop");
string commandAcc = string("acc");
string commandJmp = string("jmp");

string commands[1000];
int parameters[1000];
bool visited[1000];
int commandsEndIdx = 0;

void solve(int *lineIdx, int *accumulator) {
  bool visited[1000];
  for (int i = 0; i < 1000; i++) { visited[i] = false; }

  while(1) {
    if ((*lineIdx) >= commandsEndIdx) { break; }
    if (visited[(*lineIdx)]) { break; }
    printf("%d: %s %d\n", (*lineIdx), commands[(*lineIdx)].c_str(), parameters[(*lineIdx)]);

    visited[(*lineIdx)] = true;
    if (commandNop.compare(commands[(*lineIdx)]) == 0) {
      printf("matched nop\n");
      (*lineIdx)++;
    } else if (commandAcc.compare(commands[(*lineIdx)]) == 0) {
      printf("matched acc\n");
      (*accumulator) += parameters[(*lineIdx)];
      (*lineIdx)++;
    } else if (commandJmp.compare(commands[(*lineIdx)]) == 0) {
      printf("matched jmp %d %d\n", (*lineIdx), parameters[(*lineIdx)]);
      (*lineIdx) += parameters[(*lineIdx)];
    }
  }
}

int main() {
  for (int i = 0; i < 1000; i++) { visited[i] = false; }

  string line;
  while (!cin.eof()) {
    getline(std::cin, line);
    sscanf(line.c_str(), "%s %d", commandBuf, &param);
    commands[commandsEndIdx] = string(commandBuf);
    parameters[commandsEndIdx] = param;
    commandsEndIdx++;
  }

  int lineIdx = 0, accumulator = 0;
  solve(&lineIdx, &accumulator);
  printf("accumulator: %d\n", accumulator);

  for (int i = 0; i < commandsEndIdx; i++) {
    if (commandNop.compare(commands[i]) == 0) {
      commands[i] = string("jmp");
      lineIdx = 0, accumulator = 0;
      solve(&lineIdx, &accumulator);
      if (lineIdx == commandsEndIdx) { break; }
      commands[i] = string("nop");
    } else if (commandJmp.compare(commands[i]) == 0) {
      commands[i] = string("nop");
      lineIdx = 0, accumulator = 0;
      solve(&lineIdx, &accumulator);
      if (lineIdx == commandsEndIdx) { break; }
      commands[i] = string("jmp");
    }
  }
  printf("accumulator with correction: %d\n", accumulator);
}
