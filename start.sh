#!/bin/bash

cd java-app
docker build -t celo/app-java-validacao-cnpj -f Dockerfile .
docker run -d -p 8081:8081 --name app-java-validacao-cnpj celo/app-java-validacao-cnpj
docker exec -it app-java-validacao-cnpj ./mvnw test
docker stop app-java-validacao-cnpj
docker tag celo/app-java-validacao-cnpj hub.docker.com/repository/docker/celo/app-java-validacao-cnpj
docker push celo/app-java-validacao-cnpj
docker rm app-java-validacao-cnpj

cd ../terraform
terraform init
terraform validate
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo "[ec2-nodejs]" > ../ansible/hosts # cria arquivo
echo "$(terraform output | awk '{print $3;exit}')" >> ../ansible/hosts # captura output faz split de espaco e replace de ",

cd ../ansible
ansible-playbook -i /root/projetos/java/ansible/hosts /root/projetos/java/ansible/configurar.yml -u ubuntu 

cd ../terraform

curl "http://$(terraform output | awk '{print $3;exit}' | sed -e "s/\"//g")"


