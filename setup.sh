#!/bin/bash

# As of now, this script only works on Debian and OSX, but that's
# just because of the package managers installing zmap
echo -n "Netsploit depends on external tools."
echo -n "Is it okay to install them?(y/n) "
read ans
if [ $ans == "n" ]; then
  echo "Netsploit will not work without these tools. Exiting..."
  exit
else
  break
fi
os=`uname`
echo -e "Detected $os"
echo -e "Installing shodan"
pip install shodan
echo -e "Done!"
mkdir tools
cd tools
echo ""
echo -e "Installing additional tools"
pip install sslyze
git clone https://github.com/gkbrk/slowloris
cd slowloris
python setup.py install > /dev/null 2>&1
cd ..

# I suppose this is a form of file IO
echo "#!/bin/bash"                                      >> c4.sh
echo "os=\`uname\`"                                     >> c4.sh
echo "if [ \$os == \"Darwin\" ]; then"                  >> c4.sh
echo "  open \$(curl -Ls git.io/c4 | gshuf | head -n1)" >> c4.sh
echo "else"                                             >> c4.sh
echo "  open \$(curl -Ls git.io/c4 | shuf | head -n1)"  >> c4.sh
echo "fi"                                               >> c4.sh
chmod +x c4.sh

# include some of my own tools as well
git clone https://github.com/thecarterb/mail0wner.git
cd mail0wner
bash install.sh > /dev/null 2>&1
cd ..
git clone https://github.com/thecarterb/hb-test-copy heartbleed

#blacknurse router attack
git clone https://github.com/jedisct1/blacknurse
cd blacknurse
make
cd ..
git clone https://github.com/aboul3la/Sublist3r
cd Sublist3r
pip install -r requirements.txt > /dev/null 2>&1
cd ..
wget http://pastebin.com/raw/kGQ6qquB
mv kGQ6qquB cf-resolve.py

if [ $os == "Darwin" ]; then
  echo -e "Installing zmap"
  brew install zmap
  echo -e "Installing coreutils"
  brew install coreutils
  echo -n "Would you like to install tcpdump? (recommended) (y/n) "
  read ans
  if [ $ans == "y" ]; then
    echo "Installing tcpdump"
    brew install tcpdump
  fi
else
  echo -e "Installing zmap"
  apt-get install -y zmap
  echo -n "Would you like to install tcpdump? (recommended) (y/n) "
  read ans
  if [ $ans == "y" ]; then
    echo "Installing tcpdump"
    apt-get install tcpdump -y
  fi
fi

cd ..
echo -n "What is your shodan API key? "
read key
echo $key > .api_key
chmod +x netsploit
