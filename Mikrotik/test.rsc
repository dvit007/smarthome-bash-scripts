#Функции из библиотеки library-ros:
:global geIp;  #Получить ip адрес по mac адресу устройства 

:put "Start script"
:local timeout1; #Переменная для таймаута в списке device-internet-allow
:local timeout2; #Переменная для таймаута в списке device-internet-deny
:local listallow "device-internet-allow"; 
:local listdeny  "device-internet-deny";

:local kidscount [/ip kid-control print count-only]
:for i from=0 to=($kidscount-1)  do={
  :local username [/ip kid-control get $i name]  
  :put "User name - $username"
  #:put [:typeof $username]

  :set timeout1 "2h"; #Таймаут по умолчанию - 2 часа
  :set timeout1 "5h"; #Таймаут по умолчанию - 5 часов

  :foreach a in=[/ip kid-control device find user=$username] do={
    :local macAdr [/ip kid-control device get $a mac-address]
    :local ipAdr  [$geIp macAdr=$macAdr]
    :put "$macAdr - $ipAdr"
    :if ([:tostr $ipAdr] != "") do={ #Проверяем подключение устройства с ip=$ipAdr
      :put "Connected" 
      #:put [/ip firewall address-list find (list=$listallow) && (address=$ipAdr)]
      :if ([/ip firewall address-list find (list=$listallow) && (address=$ipAdr)]) do={ #Проверяем ip=$ipAdr в списке $listallow
        :put "Find $ipAdr to $listallow"
        :local curTimeout1 [/ip firewall address-list get [find list=$listallow address=$ipAdr] timeout]
        :local curTimeout2 [/ip firewall address-list get [find list=$listdeny address=$ipAdr] timeout]
        :put "Timeout1 - [$curTimeout1]"
        :put "Timeout2 - [$curTimeout2]"
      } else={ #ip=$ipAdr НЕ в списке $listallow
        :put "Not find $ipAdr to $listallow"
      }
    }
  }
}


#TODO
#Доделать логику добавления в список
#Если ip адрес есть в списке, тогда обновим тамйеры для последующих адерсов
#Если адреса нет в списке, тогда добавляем его в оба списка, и таймера берем из общих переменных
#в таком случае таймер будет по умолчанию, если это первый адрес или нет других адресов в списке
#или таймер будет равен времени адреса, который уже есть в списке.