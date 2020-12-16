#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
using namespace std;

vector<pair<int,int> > busLines;

int counter = -1;
void maybeAddBusLine(string val) {
  counter++;
  if (val.compare("x") == 0) {
    return;
  }

  busLines.push_back(pair<int,int>(stoi(val), counter));
}

bool comp(pair<int,int> a, pair<int,int> b) {
  return a.second < b.second;
}

int main() {
  int T; scanf("%d", &T);
  char rawLine[10000]; scanf("%s", rawLine);

  string line = string(rawLine);
  string delim = string(",");
  int matchIdx; while ((matchIdx = line.find(delim)) != string::npos) {
    maybeAddBusLine(line.substr(0, matchIdx).c_str());
    line = line.substr(matchIdx + 1);
  }
  maybeAddBusLine(line.c_str());
  sort(busLines.begin(), busLines.end(), comp);

  int min = 1 << 30;
  int busNo;
  for (pair<int,int> busLine : busLines) {
    int wait = busLine.first - (T % busLine.first);
    if (wait < min) {
      min = wait;
      busNo = busLine.first;
    }
    min = wait < min ? wait : min;
  }
  printf("time x busNo: %d\n", min * busNo);

  long long lastModulo0 = 1, sum = 0;
  for (pair<int,int> busLine : busLines) {
    int target = busLine.first - (busLine.second % busLine.first);
    while (busLine.second != 0 && (sum % busLine.first) != target) { 
      sum += lastModulo0;
    }
    lastModulo0 *= busLine.first; // possibly wrong if not coprime
  }
  printf("final sum:%lld\n", sum);
}
