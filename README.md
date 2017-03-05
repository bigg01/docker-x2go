# docker-x2go
```sh
git clone https://github.com/bigg01/x.git .
docker build -t centos7-x2goserver .
CID=$(docker run -p 2222:22 -t -d centos7-x2goserver)```
