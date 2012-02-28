#include <iostream>
#include <string>

using namespace std;

int main()
{
  char *line = "jedan dva tri cetiri pet sest sedam";

  cout << "test\n";


  string s4 (line, 10);
  cout << "s4  is: " << s4 << endl;
}
