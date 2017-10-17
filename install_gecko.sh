wget https://github.com/mozilla/geckodriver/releases/download/v0.19.0/geckodriver-v0.19.0-linux64.tar.gz
tar -xvzf geckodriver-v0.19.0-linux64.tar.gz
chmod +x geckodriver
mv geckodriver /usr/local/lib/
export PATH=$PATH:/usr/local/lib
