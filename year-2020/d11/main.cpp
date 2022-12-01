#include <cstdio>
#include <cstdlib>
#include <tuple>
using namespace std;

char boardA[40000];
char boardB[40000];

bool taken(char *board, int x, int y, int diffX, int diffY, int endX, int endY) {
  int idx = x + y * endX + diffX + diffY * endX;
  if (idx < 0 || idx >= endY * endX) { return false; }
  if (x + diffX >= endX) { return false; }
  if (x + diffX < 0) { return false; }
  if (y + diffY >= endY) { return false; }
  if (y + diffY < 0) { return false; }
  return *(board + idx) == '#';
}

int countAdj(char *board, int x, int y, int endX, int endY) {
  int res = 0;
  if (taken(board, x, y, -1, -1, endX, endY)) { res++; }
  if (taken(board, x, y, -1,  0, endX, endY)) { res++; }
  if (taken(board, x, y, -1,  1, endX, endY)) { res++; }
  if (taken(board, x, y,  0, -1, endX, endY)) { res++; }
  if (taken(board, x, y,  0,  1, endX, endY)) { res++; }
  if (taken(board, x, y,  1, -1, endX, endY)) { res++; }
  if (taken(board, x, y,  1,  0, endX, endY)) { res++; }
  if (taken(board, x, y,  1,  1, endX, endY)) { res++; }
  return res;
}

void swap(pair<char*,char*> &boards) {
  char *t = boards.first;
  boards.first = boards.second;
  boards.second = t;
}

int main() {
  int X, Y; scanf ("%d %d", &X, &Y);

  for(int y = 0; y < Y; y++) {
    char line[200]; scanf("%s", line);
    for(int x = 0; x < X; x++) {
      boardA[x + y * X] = line[x];
    }
  }

  char *_boardA = &boardA[0];
  pair<char*,char*> boards = pair<char*,char*>(boardA, boardB);
  bool stable = false;
  while (!stable) {
    stable = true;
    for(int y = 0; y < Y; y++) {
      for(int x = 0; x < X; x++) {
        int idx = x + y * X;
        if (boards.first[idx] == 'L' && countAdj(boards.first, x, y, X, Y) == 0) {
          boards.second[idx] = '#'; stable = false;
        } else if (boards.first[idx] == '#' && countAdj(boards.first, x, y, X, Y) >= 4) {
          boards.second[idx] = 'L'; stable = false;
        } else {
          boards.second[idx] = boards.first[idx];
        }
      }
    }
    swap(boards);
  }

  int occupied = 0;
  for(int y = 0; y < Y; y++) {
    for(int x = 0; x < X; x++) {
      int idx = x + y * X;
      if (boards.first[idx] == '#') { occupied++; }
    }
  }
  printf("occupied: %d\n", occupied);
}
