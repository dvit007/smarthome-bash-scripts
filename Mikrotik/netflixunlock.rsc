#Скрипт разблоиркует доступ к Netflix через VPN
#для любых устройств без установки клиентов VPN
#в том числе и для любых Smart TV

#Функции из библиотеки library-ros:
:global chCon; #Проверка подключения устройства к серверам
:global geIp;  #Получить ip адрес по mac адресу устройства  
:global adNat; #Добавить правило firewall nat для переключения трафика через VPN
:global deNat; #Удалить правило firewall nat для устройства

#Инициализация переменных для работы скрипта
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
  } else {
     :put "$ipAdrress not connect to Netflix";
     #Удалим правило Nat для устройства
     $deNat srcAdr=$ipAdrress Comment=$comm;
  }
} else {
  :put "Device with mac $macDevice offline";
}