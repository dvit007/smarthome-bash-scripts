#Скрипт разблоиркует доступ к Netflix через VPN
#для любых устройств без установки клиентов VPN
#в том числе и для любых Smart TV

#Функции из библиотеки library-ros:
:global chCon; #Проверка подключения устройства к серверам
:global geIp;  #Получить ip адрес по mac адресу устройства  
:global adNat; #Добавить правило firewall nat для переключения трафика через VPN
:global deNat; #Удалить правило firewall nat для устройства

#Инициализация переменных для работы скрипта
:global DisconnectCount; #Счетчик накапливает проходы скрипта когда нет соединения, чтобы не удалять прввило Nat сразу после первого отключения
:local nameServers {"netflix";"amazonaws"};#именна серверов Netflix
:local macDevice "AC:F1:08:C7:F3:DA"; #Mac адрес Smart TV
#:local ipAdrress "192.168.1.14";
:local comm "LG TV 1,5 [NetflixUnlock script added]"; #Комментарий для правила firewall nat
:local ipClientAdrr "192.168.43.9"; #Ip адрес в сети VPN роутера Mikrotik для правила firewall

:local ipAdrress [$geIp macAdr=$macDevice];

:if ([:typeof $ipAdrress]!="nil") do={
  :put "Device with mac $macDevice online";
  :put "ipAdress=[$ipAdrress] type=$[:typeof $ipAdrress]";
  :if ([$chCon checkServers=$nameServers checkAdres=[:tostr $ipAdrress] ]=true) do={
     :put "$ipAdrress connect to Netflix";
     #Добавим парвило Nat для устройства
     $adNat srcAdr=$ipAdrress toAdr=$ipClientAdrr Comment=$comm;
     :set DisconnectCount 0;
  } else {
     :put "$ipAdrress not connect to Netflix";
     #Увеличим счетчик проходов без подключения, чтобы не удалять прввило Nat сразу после первого отключения
     :set DisconnectCount ($DisconnectCount+1);
     #Отключим правило примерно через 5 минут после первого отключения от Netflix. Время=количество звпусков скрипта с интвервалом 1 минута 
     :if ($DisconnectCount > 5) do={
     #Удалим правило Nat для устройства
     $deNat srcAdr=$ipAdrress Comment=$comm;
     :set DisconnectCount 0;
     }
  }
} else {
  :put "Device with mac $macDevice offline";
}