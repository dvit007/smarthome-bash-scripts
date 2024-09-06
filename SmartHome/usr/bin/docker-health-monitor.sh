#!/bin/bash

# Скрипт отправляет в OpenHab новое состояние контейнера docker когда он запущен/остановлен/есть проблемы
# состояние отправляется в формате JSON, которое получено от docker 
# у этого файла должны быть права 755
# файл с описание службы должен иметь права 644

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo "Health docker monitoring service started at ${DATE}" | systemd-cat -p info

oh4_api_encrypt="U2FsdGVkX1+7B6LRvhSVLz/kBaGc7u9Z7UnUKSLypvF+pmpks7ciN1DsXXLdiNPzUv+3oUSY2vvfZbcx8iOSjJnK1H9RC2VRHuPl1wS3bwMu3QCcrFK7EpkOMVU9lu+C5AxsTwapDkEm3faVgo4e/Q=="
file_secret_key="/home/dvit009/oh4_api_secret.key" #секретный ключ для расшифровки api ключа должне быть в той же папке где и этот скрипт
oh4_item='smarthome_docker_health_monitoring_raw' #имя объекта у которого будет обнавлятся состояние
oh4_server_adr='192.168.1.22:8080' #адрес сервера

api_key=$(echo "${oh4_api_encrypt}" | openssl enc -pass file:${file_secret_key} -d -aes-256-cbc -a)


docker events -f 'type=container' -f 'event=stop' -f 'event=start' -f 'event=health_status'  --format '{{json .}}' | while read -r EVENT; do
    #Обработчик событий с контейнерами
    echo "${EVENT}"
    #logger -t "docker health" "${EVENT}"
     
    # POST запрос через api OpenHab 4 
    curl -X 'POST' \
            "http://${oh4_server_adr}/rest/items/${oh4_item}" \
            -H 'accept: */*' \
            -H 'Content-Type: text/plain' \
            -H "Authorization: Bearer ${api_key}" \
            -d "${EVENT}"
done
