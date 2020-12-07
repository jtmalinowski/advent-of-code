#include <cstdio>
#include <cstdlib>
#include <climits>

using namespace std;

struct Range { int a; int b; bool valid; };
int input[100000];

int compare (const void * a, const void * b) {
  return ( *(int*)a - *(int*)b );
}

const int TARGET = 2020;

Range solveBetween(int target, int min, int max) {
  for (int l = min, h = max;;) {
    int sum = input[l] + input[h];
    
    if (l == h) {
      struct Range range = { .valid = false };
      return range;
    }

    if (sum == target) {
      struct Range range = { .a = l, .b = h, .valid = true };
      return range;
    }

    if (sum > target) {
      h--;
      continue;
    }

    if (sum < target) {
      l++;
      continue;
    }
  }
}

int main() {
  int n; scanf("%d", &n);

  for (int i = 0; i < n; i++) {
    scanf("%d", input + i);
  }

  qsort (input, n, sizeof(int), compare);

  for (int lowest = 0; lowest < n - 3; lowest++) {
    Range s = solveBetween(TARGET - input[lowest], lowest + 1, n - 1);
    if (s.valid) {
      printf("%d\n", input[lowest] * input[s.a] * input[s.b]);
    }
  }
}
