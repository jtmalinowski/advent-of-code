#include <iostream>
#include <iterator>
#include <string>
#include <regex>
#include <vector>
#include <set>
#include <map>
#include <queue>
using namespace std;

int lastColorId = 1;
map<string, int> colorIds;
map<int, set<int> > childIds;
map<int, set<int> > parentIds;
map<pair<int,int>, int> childCount;

regex bagsRegx(" bags?[\\,\\.]? ?$", regex_constants::ECMAScript);
regex containRegx(" contain ", regex_constants::ECMAScript);
regex noOthrRegx("no other bags", regex_constants::ECMAScript);
regex cntRegx("^([0-9]+) (.*)$", regex_constants::ECMAScript);
regex cntOtherRegx("^no other$", regex_constants::ECMAScript);

int getIdFromName(string name) {
  if (colorIds.find(name) == colorIds.end()) {
    colorIds.insert(std::pair<string,int>(name, lastColorId++));
  }

  return (*colorIds.find(name)).second;
}

map<int, set<int> >::iterator getChildrenForId(int id) {
  if (childIds.find(id) == childIds.end()) {
    set<int> newSet;
    childIds.insert(pair<int,set<int> >(id, newSet));
  }

  return childIds.find(id);
}

map<int, set<int> >::iterator getParentsForId(int id) {
  if (parentIds.find(id) == parentIds.end()) {
    set<int> newSet;
    parentIds.insert(pair<int,set<int> >(id, newSet));
  }

  return parentIds.find(id);
}

string stripBags(const string& input) {
  smatch bagsMatch;
  regex_search(input, bagsMatch, bagsRegx);

  if (bagsMatch.empty()) {
    printf("FATAL no 'bags' match.\n");
    return string("");
  }

  return input.substr(0, bagsMatch.position(0));
}

int main() {
  string line;

  while (!cin.eof()) {
    getline(std::cin, line);

    smatch containMatch;
    regex_search(line, containMatch, containRegx);

    if (containMatch.empty()) {
      printf("FATAL no 'contain'. \n");
      return 1;
    }

    string leftName = stripBags(line.substr(0, containMatch.position(0)));
    int leftId = getIdFromName(leftName);
    
    string rightLine = line.substr(containMatch.position(0) + containMatch.length(0), line.length());
    vector<string> rightNames;
    string delim = string(", ");
    int rightLineIdx; while ((rightLineIdx = rightLine.find(delim)) > -1) {
      rightNames.push_back(rightLine.substr(0, rightLineIdx));
      rightLine = rightLine.substr(rightLineIdx + delim.length());
    }
    rightNames.push_back(rightLine);
    
    for (auto rightName : rightNames) {
      rightName = stripBags(rightName);

      smatch cntMatch;
      int count = 0;
      regex_search(rightName, cntMatch, cntRegx);
      if (!cntMatch.empty()) {
        count = stoi(cntMatch[1].str());
        rightName = rightName.substr(cntMatch.position(2));
      }

      smatch cntOtherMatch;
      regex_search(rightName, cntOtherMatch, cntOtherRegx);
      if (!cntOtherMatch.empty()) {
        continue;
      }

      int rightId = getIdFromName(rightName);
      getChildrenForId(leftId)->second.insert(rightId);
      getParentsForId(rightId)->second.insert(leftId);
      childCount.insert(pair<pair<int,int>,int>(pair<int,int>(leftId, rightId), count));
    }
  }

  int shinyGoldId = getIdFromName("shiny gold");
  queue<int> q; q.push(shinyGoldId);
  set<int> shinyGoldParents;

  while (!q.empty()) {
    int id = q.front(); q.pop();
    for (auto parentId : getParentsForId(id)->second) {
      q.push(parentId);
      shinyGoldParents.insert(parentId);
    }
  }
  printf("Shiny gold bag can be hidden in %d different colors\n", shinyGoldParents.size());

  queue<pair<int,int> > q2; q2.push(pair<int,int>(shinyGoldId, 1));
  int sum = 0; while (!q2.empty()) {
    int id = q2.front().first, no = q2.front().second; q2.pop();
    for (auto childId : getChildrenForId(id)->second) {
      int childNo = childCount.find(pair<int,int>(id, childId))->second * no;
      sum += childNo;
      q2.push(pair<int,int>(childId, childNo));
      shinyGoldParents.insert(childId);
    }
  }
  printf("Children of shiny gold: %d\n", sum);
}
