#include <cstdio>
#include <cstdlib>
using namespace std;

int list[100000];

int compare(const void *a, const void *b) { return *(int*)a - *(int*)b; }

int main() {
  int N; scanf("%d", &N);
  for (int i = 1; i <= N;i++) { scanf("%d", list + i); }; list[0] = 0;
  qsort(list, N + 1, sizeof(int), compare);
  list[N + 1] = list[N] + 3;

  int current = 0, diffs1 = 0, diffs2 = 0, diffs3 = 0;
  for (int i = 1; i <= N + 1;i++) {
    int diff = list[i] - current;
    if (diff == 1) { diffs1++; }
    else if (diff == 2) { diffs2++; }
    else if (diff == 3) { diffs3++; }
    else if (diff > 3) { printf("FATAL large diff"); }
    current += diff;
  }
  printf("result part 1: %d\n", diffs1 * diffs3);

  long long countAt[1000]; for (int i = 0;i<1000;i++) { countAt[i] = 0; }; countAt[0] = 1;
  current = 0;
  for (int i = 1; i <= N + 1;i++) {
    for (int j=i-1;j>=0;j--) {
      if (list[i] - list[j] > 3) { break; }
      if (list[j] == list[j + 1]) { continue; }
      countAt[i] += countAt[j];
    }
  }
  printf("different ways: %lld\n", countAt[N]);
}
