#include<cstdio>
#include<iostream>
#include<map>
#include<regex>
#include<vector>
using namespace std;

map<long long,long long> mem, mem2;
const long long BASE_ONE = 1;

regex maskRegx("^mask = ([10X]*)$", regex_constants::ECMAScript);
regex memRegx("^mem\\[([0-9]*)\\] = ([0-9]*)$", regex_constants::ECMAScript);

void printSum() {
  long long sum = 0;
  for (auto kv : mem) {
    sum += kv.second;
  }
  printf("sum1: %lld\n", sum);

  long long sum2 = 0;
  for (auto kv : mem2) {
    sum2 += kv.second;
  }
  printf("sum2: %lld\n", sum2);
}

int main() {
  long long ones, zeroes, xes;
  vector<int> xIdxs;

  bool nowMyTicket = false, nowOtherTicket = false;
  while (!cin.eof()) {
    string line; getline(cin, line);

    if (line.find("your ticket:") != string::npos) {
      nowMyTicket = true;
      continue;
    }

    if () {
      
    }

    smatch maskMatch;
    regex_search(line, maskMatch, maskRegx);
    if (!maskMatch.empty()) {
      int idx = 0; 
      ones = 0; zeroes = 0; xes = 0;
      xIdxs = vector<int>();
      auto mask = maskMatch[1].str(); auto bit = mask.rbegin();
      while (bit != mask.rend()) {
        if (*bit == '0') { zeroes = zeroes | (BASE_ONE << idx); }
        if (*bit == '1') { ones = ones | (BASE_ONE << idx); }
        if (*bit == 'X') { xes = xes | (BASE_ONE << idx); }
        idx++; bit++;
      }
      for (int i = 0; i < 40; i++) { if ( (xes & (BASE_ONE << i) )) { xIdxs.push_back(i); } }
      continue;
    }

    smatch memMatch;
    regex_search(line, memMatch, memRegx);
    if (!memMatch.empty()) {
      long long memIdx = stoll(memMatch[1].str().c_str());
      long long value = stoll(memMatch[2].str().c_str());

      long long maskedValue = value;
      maskedValue = maskedValue | ones;
      maskedValue = maskedValue & (~zeroes);
      mem.erase(memIdx);
      mem.insert(pair<long long,long long>(memIdx, maskedValue));

      for (int i = 0; i < (1 << xIdxs.size()); i++) {
        long long memIdxCpy = memIdx;
        memIdxCpy = memIdxCpy | ones;
        for (int j = 0; j < xIdxs.size(); j++) {
          if (i & (1 << j) ) { 
            memIdxCpy = memIdxCpy | (BASE_ONE << xIdxs.at(j));
          } else {
            memIdxCpy = memIdxCpy & (~(BASE_ONE << xIdxs.at(j)));
          }
        }
        mem2.erase(memIdxCpy);
        mem2.insert(pair<long long,long long>(memIdxCpy, value));
      }
      continue;
    }

    printf("FAIL\n");
  }

  printSum();
}
