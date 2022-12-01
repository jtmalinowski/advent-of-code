#include <cstdio>
using namespace std;

int anyAnss;
int allAnss;
int singleAnss;

int count(int in) { int sum = 0; while (in > 0) { if (in % 2 == 1) { sum++; } in /= 2; } return sum; }

int main() {
  int sumAny = 0, sumAll = 0;
  char c = '\0', prevC = '\0';
  anyAnss = 0; allAnss = (1 << 26) - 1;
  while(1) {
    prevC = c; c = getchar();

    if (c == EOF) {
      sumAny += count(anyAnss); anyAnss = 0;
      sumAll += count(allAnss); allAnss = (1 << 26) - 1;
      printf("sumAny: %d\n", sumAny);
      printf("sumAll: %d\n", sumAll);
      return 0;
    }

    if (c == '\n' && prevC == '\n') {
      sumAny += count(anyAnss); anyAnss = 0;
      sumAll += count(allAnss); allAnss = (1 << 26) - 1;

      continue;
    }

    if (c == '\n') {
      anyAnss = anyAnss | singleAnss;
      allAnss = allAnss & singleAnss;
      singleAnss = 0;

      continue;
    }

    singleAnss = singleAnss | 1 << (c - 'a');
  }

  return 0;
}
