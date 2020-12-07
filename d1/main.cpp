#include <cstdio>
#include <cstdlib>
#include <climits>

using namespace std;

int input[100000];

int compare (const void * a, const void * b) {
  return ( *(int*)a - *(int*)b );
}

const int TARGET = 2020;

int main() {
  int n; scanf("%d", &n);

  for (int i = 0; i < n; i++) {
    scanf("%d", input + i);
  }

  qsort (input, n, sizeof(int), compare);

  for (int l = 0, h = n - 1;;) {
    int sum = input[l] + input[h];
    
    if (l == h) {
      printf("fail\n");
      return 0;
    }

    if (sum == TARGET) {
      printf("%d\n", input[l] * input[h]);
      return 0;
    }

    if (sum > TARGET) {
      h--;
      continue;
    }

    if (sum < TARGET) {
      l++;
      continue;
    }
  }
}
