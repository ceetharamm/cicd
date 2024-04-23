# CI/CD 

Install Kubernetes Plugin in Jenkins


k delete -f deployment.yaml
docker build -t pyapp .
docker tag pyapp ceetharamm/pyapp:latest
docker push ceetharamm/pyapp:latest
k apply -f deployment.yaml

docker run -d -p 80:80 ceetharamm/pyapp:latest

kubectl run my-shell --rm -i --tty --image curlimages/curl -- sh
If you don't see a command prompt, try pressing enter.
~ $ curl 127.0.0.1:32672
curl: (7) Failed to connect to 127.0.0.1 port 32672 after 0 ms: Couldn't connect to server
~ $ curl 127.0.0.1:8089
curl: (7) Failed to connect to 127.0.0.1 port 8089 after 0 ms: Couldn't connect to server
~ $ ls
~ $ dir
sh: dir: not found
~ $ curl mypyt-svc:32672
^C
~ $ curl mypyt-svc:8089
curl: (7) Failed to connect to mypyt-svc port 8089 after 1 ms: Couldn't connect to server
~ $


git remote set-url origin https://<TOKEN>@github.com/ceetharamm/cicd

