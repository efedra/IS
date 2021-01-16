(deftemplate ioproxy
    (slot fact-id)
    (multislot answers)
    (multislot messages)
    (slot reaction)
    (slot value)
    (slot restore)
)

(deffacts proxy-fact
    (ioproxy
        (fact-id 0112)
        (value none)
        (messages)
    )
)

(defrule clear-messages
    (declare (salience 90))
    ?clear-msg-flg <- (clearmessage)
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (messages))
    (retract ?clear-msg-flg)
)

(defrule set-output-and-halt
    (declare (salience 99))
    ?current-message <- (sendmessagehalt ?new-msg)
    ?proxy <- (ioproxy (messages $?msg-list))
    =>
    (modify ?proxy (messages ?new-msg))
    (retract ?current-message)
    (halt)
)

(defrule append-output-and-halt
    (declare (salience 99))
    ?current-message <- (appendmessagehalt $?new-msg)
    ?proxy <- (ioproxy (messages $?msg-list))
    =>
    (modify ?proxy (messages $?msg-list $?new-msg))
    (retract ?current-message)
    (halt)
)

(defrule set-output-and-proceed
    (declare (salience 99))
    ?current-message <- (sendmessage ?new-msg)
    ?proxy <- (ioproxy)
    =>
    (modify ?proxy (messages ?new-msg))
    (retract ?current-message)
)

(defrule append-output-and-proceed
    (declare (salience 99))
    ?current-message <- (appendmessage ?new-msg)
    ?proxy <- (ioproxy (messages $?msg-list))
    =>
    (modify ?proxy (messages $?msg-list ?new-msg))
    (retract ?current-message)
)
    
(deftemplate adventure-element
    (slot thing)
    (slot chance)
)

(defrule greeting
  	(declare (salience 100))
   	=>
   	(assert (appendmessagehalt "Добро пожаловать в ваше приключение! Введите в поле внизу что вы возьмёте с собой. Удача у вас уже есть!"))
    (assert (adventure-element (thing Удача) (chance 0.9)))
    (assert (adventure-element (thing Ярмарка) (chance 0.9)))
)

(defrule Единорог_Яблоки_Конфеты
   (declare (salience 40))
   (adventure-element (thing Единорог) (chance ?c0))
   (adventure-element (thing Яблоки) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.4 ?c1 ))
   =>
   (assert (adventure-element (thing Конфеты) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Единорог(" ?c0 ") + Яблоки(" ?c1 ") -> Конфеты(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Конфеты_Иисус_Удача
   (declare (salience 40))
   (adventure-element (thing Конфеты) (chance ?c0))
   (adventure-element (thing Иисус) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Удача) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Конфеты(" ?c0 ") + Иисус(" ?c1 ") -> Удача(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Горы_Пещера
   (declare (salience 40))
   (adventure-element (thing Горы) (chance ?c0))
   (test ( < 0.2 ?c0 ))
   =>
   (assert (adventure-element (thing Пещера) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Горы(" ?c0 ") -> Пещера(" (* ?c0  1) ")")))
)
            
(defrule Волшебный-лес_Портал_Горы
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Горы) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Портал(" ?c1 ") -> Горы(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Горы_Портал_Подземелье
   (declare (salience 40))
   (adventure-element (thing Горы) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Подземелье) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Горы(" ?c0 ") + Портал(" ?c1 ") -> Подземелье(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Подземелье_Портал_Башня-темного-властелина
   (declare (salience 40))
   (adventure-element (thing Подземелье) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Башня-темного-властелина) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Подземелье(" ?c0 ") + Портал(" ?c1 ") -> Башня-темного-властелина(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Башня-темного-властелина_Портал_Рай
   (declare (salience 40))
   (adventure-element (thing Башня-темного-властелина) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Рай) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Башня-темного-властелина(" ?c0 ") + Портал(" ?c1 ") -> Рай(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Рай_Портал_Ярмарка
   (declare (salience 40))
   (adventure-element (thing Рай) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Ярмарка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Рай(" ?c0 ") + Портал(" ?c1 ") -> Ярмарка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Ярмарка_Портал_Море
   (declare (salience 40))
   (adventure-element (thing Ярмарка) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Море) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Ярмарка(" ?c0 ") + Портал(" ?c1 ") -> Море(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Море_Портал_Мост
   (declare (salience 40))
   (adventure-element (thing Море) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Мост) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Море(" ?c0 ") + Портал(" ?c1 ") -> Мост(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Мост_Портал_Волшебный-лес
   (declare (salience 40))
   (adventure-element (thing Мост) (chance ?c0))
   (adventure-element (thing Портал) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Волшебный-лес) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Мост(" ?c0 ") + Портал(" ?c1 ") -> Волшебный-лес(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Таверна_Деньги_Корзинка
   (declare (salience 40))
   (adventure-element (thing Таверна) (chance ?c0))
   (adventure-element (thing Деньги) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Корзинка) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Таверна(" ?c0 ") + Деньги(" ?c1 ") -> Корзинка(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Волшебный-лес_Корзинка_Яблоки
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Корзинка) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Яблоки) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Корзинка(" ?c1 ") -> Яблоки(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Волшебный-лес_Карта_Таверна
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Карта) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Таверна) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Карта(" ?c1 ") -> Таверна(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Ад_Сатана
   (declare (salience 40))
   (adventure-element (thing Ад) (chance ?c0))
   (test ( < 0.4 ?c0 ))
   =>
   (assert (adventure-element (thing Сатана) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Ад(" ?c0 ") -> Сатана(" (* ?c0  1) ")")))
)
            
(defrule Рай_Иисус
   (declare (salience 40))
   (adventure-element (thing Рай) (chance ?c0))
   (test ( < 0.7 ?c0 ))
   =>
   (assert (adventure-element (thing Иисус) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Рай(" ?c0 ") -> Иисус(" (* ?c0  1) ")")))
)
            
(defrule Сатана_Пиво_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Сатана) (chance ?c0))
   (adventure-element (thing Пиво) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Сатана(" ?c0 ") + Пиво(" ?c1 ") -> Крутая-награда(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Призраки_Заклинания_Карта
   (declare (salience 40))
   (adventure-element (thing Призраки) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Карта) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Призраки(" ?c0 ") + Заклинания(" ?c1 ") -> Карта(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Сатана_Иисус_Заклинания
   (declare (salience 40))
   (adventure-element (thing Сатана) (chance ?c0))
   (adventure-element (thing Иисус) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Заклинания) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Сатана(" ?c0 ") + Иисус(" ?c1 ") -> Заклинания(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Рай_Заклинания_Ад
   (declare (salience 40))
   (adventure-element (thing Рай) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Ад) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Рай(" ?c0 ") + Заклинания(" ?c1 ") -> Ад(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Ад_Заклинания_Рай
   (declare (salience 40))
   (adventure-element (thing Ад) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Рай) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Ад(" ?c0 ") + Заклинания(" ?c1 ") -> Рай(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Волшебный-лес_Заклинания_Темный-лес
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.4 ?c1 ))
   =>
   (assert (adventure-element (thing Темный-лес) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Заклинания(" ?c1 ") -> Темный-лес(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Темный-лес_Заклинания_Волшебный-лес
   (declare (salience 40))
   (adventure-element (thing Темный-лес) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Волшебный-лес) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Темный-лес(" ?c0 ") + Заклинания(" ?c1 ") -> Волшебный-лес(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Удача_Заклинания_Деньги
   (declare (salience 40))
   (adventure-element (thing Удача) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Деньги) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Удача(" ?c0 ") + Заклинания(" ?c1 ") -> Деньги(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Море_Заклинания_Ктулху
   (declare (salience 40))
   (adventure-element (thing Море) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Ктулху) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Море(" ?c0 ") + Заклинания(" ?c1 ") -> Ктулху(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Людоед_Мясо_Лодка
   (declare (salience 40))
   (adventure-element (thing Людоед) (chance ?c0))
   (adventure-element (thing Мясо) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Лодка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Людоед(" ?c0 ") + Мясо(" ?c1 ") -> Лодка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Людоед_Оружие_Щит_Лодка
   (declare (salience 40))
   (adventure-element (thing Людоед) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (adventure-element (thing Щит) (chance ?c2))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.8 ?c1 ))
   (test ( < 0.4 ?c2 ))
   =>
   (assert (adventure-element (thing Лодка) (chance (* ?c0 ?c1 ?c2 0.9))))
   (assert (appendmessagehalt (str-cat "Людоед(" ?c0 ") + Оружие(" ?c1 ") + Щит(" ?c2 ") -> Лодка(" (* ?c0 ?c1 ?c2 0.9) ")")))
)
            
(defrule Людоед_Неудача_Смерть
   (declare (salience 40))
   (adventure-element (thing Людоед) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Людоед(" ?c0 ") + Неудача(" ?c1 ") -> Смерть(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Людоед_Оружие_Мясо
   (declare (salience 40))
   (adventure-element (thing Людоед) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Мясо) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Людоед(" ?c0 ") + Оружие(" ?c1 ") -> Мясо(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Людоед_Дети_Отмычка
   (declare (salience 40))
   (adventure-element (thing Людоед) (chance ?c0))
   (adventure-element (thing Дети) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.4 ?c1 ))
   =>
   (assert (adventure-element (thing Отмычка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Людоед(" ?c0 ") + Дети(" ?c1 ") -> Отмычка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Темный-лес_Река_Мост_Волшебный-лес
   (declare (salience 40))
   (adventure-element (thing Темный-лес) (chance ?c0))
   (adventure-element (thing Река) (chance ?c1))
   (adventure-element (thing Мост) (chance ?c2))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.6 ?c1 ))
   (test ( < 0.2 ?c2 ))
   =>
   (assert (adventure-element (thing Волшебный-лес) (chance (* ?c0 ?c1 ?c2 1))))
   (assert (appendmessagehalt (str-cat "Темный-лес(" ?c0 ") + Река(" ?c1 ") + Мост(" ?c2 ") -> Волшебный-лес(" (* ?c0 ?c1 ?c2 1) ")")))
)
            
(defrule Волшебный-лес_Река_Мост_Темный-лес
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Река) (chance ?c1))
   (adventure-element (thing Мост) (chance ?c2))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.2 ?c1 ))
   (test ( < 0.3 ?c2 ))
   =>
   (assert (adventure-element (thing Темный-лес) (chance (* ?c0 ?c1 ?c2 0.9))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Река(" ?c1 ") + Мост(" ?c2 ") -> Темный-лес(" (* ?c0 ?c1 ?c2 0.9) ")")))
)
            
(defrule Горы_Хижина
   (declare (salience 40))
   (adventure-element (thing Горы) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Хижина) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Горы(" ?c0 ") -> Хижина(" (* ?c0  0.9) ")")))
)
            
(defrule Хижина_Удача_Мудрый-старец
   (declare (salience 40))
   (adventure-element (thing Хижина) (chance ?c0))
   (adventure-element (thing Удача) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Мудрый-старец) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Хижина(" ?c0 ") + Удача(" ?c1 ") -> Мудрый-старец(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Хижина_Слава_Мудрый-старец
   (declare (salience 40))
   (adventure-element (thing Хижина) (chance ?c0))
   (adventure-element (thing Слава) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Мудрый-старец) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Хижина(" ?c0 ") + Слава(" ?c1 ") -> Мудрый-старец(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Мудрый-старец_Вино_Заклинания
   (declare (salience 40))
   (adventure-element (thing Мудрый-старец) (chance ?c0))
   (adventure-element (thing Вино) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Заклинания) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Мудрый-старец(" ?c0 ") + Вино(" ?c1 ") -> Заклинания(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Мудрый-старец_Пиво_Супер-меч
   (declare (salience 40))
   (adventure-element (thing Мудрый-старец) (chance ?c0))
   (adventure-element (thing Пиво) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Супер-меч) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Мудрый-старец(" ?c0 ") + Пиво(" ?c1 ") -> Супер-меч(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Мудрый-старец_Деньги_Корзинка
   (declare (salience 40))
   (adventure-element (thing Мудрый-старец) (chance ?c0))
   (adventure-element (thing Деньги) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Корзинка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Мудрый-старец(" ?c0 ") + Деньги(" ?c1 ") -> Корзинка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Супер-меч_Слава
   (declare (salience 40))
   (adventure-element (thing Супер-меч) (chance ?c0))
   (test ( < 0.2 ?c0 ))
   =>
   (assert (adventure-element (thing Слава) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Супер-меч(" ?c0 ") -> Слава(" (* ?c0  1) ")")))
)
            
(defrule Супер-меч_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Супер-меч) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Супер-меч(" ?c0 ") -> Крутая-награда(" (* ?c0  1) ")")))
)
            
(defrule Деньги_Ад_Рай
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Ад) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Рай) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Ад(" ?c1 ") -> Рай(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Мудрый-старец_Знания
   (declare (salience 40))
   (adventure-element (thing Мудрый-старец) (chance ?c0))
   (test ( < 0.9 ?c0 ))
   =>
   (assert (adventure-element (thing Знания) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Мудрый-старец(" ?c0 ") -> Знания(" (* ?c0  1) ")")))
)
            
(defrule Знания_Деньги_Слава
   (declare (salience 40))
   (adventure-element (thing Знания) (chance ?c0))
   (adventure-element (thing Деньги) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Слава) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Знания(" ?c0 ") + Деньги(" ?c1 ") -> Слава(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Знания_Латы_Щит
   (declare (salience 40))
   (adventure-element (thing Знания) (chance ?c0))
   (adventure-element (thing Латы) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Щит) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Знания(" ?c0 ") + Латы(" ?c1 ") -> Щит(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Мудрый-старец_Отвага
   (declare (salience 40))
   (adventure-element (thing Мудрый-старец) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Отвага) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Мудрый-старец(" ?c0 ") -> Отвага(" (* ?c0  0.9) ")")))
)
            
(defrule Конь_Заклинания_Единорог
   (declare (salience 40))
   (adventure-element (thing Конь) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Единорог) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Конь(" ?c0 ") + Заклинания(" ?c1 ") -> Единорог(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Железо_Знания_Оружие
   (declare (salience 40))
   (adventure-element (thing Железо) (chance ?c0))
   (adventure-element (thing Знания) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Оружие) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Железо(" ?c0 ") + Знания(" ?c1 ") -> Оружие(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Железо_Знания_Щит
   (declare (salience 40))
   (adventure-element (thing Железо) (chance ?c0))
   (adventure-element (thing Знания) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Щит) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Железо(" ?c0 ") + Знания(" ?c1 ") -> Щит(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Железо_Знания_Латы
   (declare (salience 40))
   (adventure-element (thing Железо) (chance ?c0))
   (adventure-element (thing Знания) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Латы) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Железо(" ?c0 ") + Знания(" ?c1 ") -> Латы(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Железо_Знания_Отмычка
   (declare (salience 40))
   (adventure-element (thing Железо) (chance ?c0))
   (adventure-element (thing Знания) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Отмычка) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Железо(" ?c0 ") + Знания(" ?c1 ") -> Отмычка(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Волшебный-лес_Тролль
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (test ( < 0.3 ?c0 ))
   =>
   (assert (adventure-element (thing Тролль) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") -> Тролль(" (* ?c0  0.8) ")")))
)
            
(defrule Волшебный-лес_Единорог
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (test ( < 0.2 ?c0 ))
   =>
   (assert (adventure-element (thing Единорог) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") -> Единорог(" (* ?c0  0.8) ")")))
)
            
(defrule Волшебный-лес_Людоед
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (test ( < 0.4 ?c0 ))
   =>
   (assert (adventure-element (thing Людоед) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") -> Людоед(" (* ?c0  0.9) ")")))
)
            
(defrule Горы_Веревка_Дракон
   (declare (salience 40))
   (adventure-element (thing Горы) (chance ?c0))
   (adventure-element (thing Веревка) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Дракон) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Горы(" ?c0 ") + Веревка(" ?c1 ") -> Дракон(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Пещера_Дракон
   (declare (salience 40))
   (adventure-element (thing Пещера) (chance ?c0))
   (test ( < 0.6 ?c0 ))
   =>
   (assert (adventure-element (thing Дракон) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Пещера(" ?c0 ") -> Дракон(" (* ?c0  0.9) ")")))
)
            
(defrule Пещера_Тролль
   (declare (salience 40))
   (adventure-element (thing Пещера) (chance ?c0))
   (test ( < 0.3 ?c0 ))
   =>
   (assert (adventure-element (thing Тролль) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Пещера(" ?c0 ") -> Тролль(" (* ?c0  0.9) ")")))
)
            
(defrule Темный-лес_Карта_Отвага_Подземелье
   (declare (salience 40))
   (adventure-element (thing Темный-лес) (chance ?c0))
   (adventure-element (thing Карта) (chance ?c1))
   (adventure-element (thing Отвага) (chance ?c2))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.8 ?c1 ))
   (test ( < 0.3 ?c2 ))
   =>
   (assert (adventure-element (thing Подземелье) (chance (* ?c0 ?c1 ?c2 1))))
   (assert (appendmessagehalt (str-cat "Темный-лес(" ?c0 ") + Карта(" ?c1 ") + Отвага(" ?c2 ") -> Подземелье(" (* ?c0 ?c1 ?c2 1) ")")))
)
            
(defrule Волшебный-лес_Карта_Море
   (declare (salience 40))
   (adventure-element (thing Волшебный-лес) (chance ?c0))
   (adventure-element (thing Карта) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Море) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Волшебный-лес(" ?c0 ") + Карта(" ?c1 ") -> Море(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Карта_Темный-лес
   (declare (salience 40))
   (adventure-element (thing Карта) (chance ?c0))
   (test ( < 0.7 ?c0 ))
   =>
   (assert (adventure-element (thing Темный-лес) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Карта(" ?c0 ") -> Темный-лес(" (* ?c0  0.8) ")")))
)
            
(defrule Карта_Волшебный-лес
   (declare (salience 40))
   (adventure-element (thing Карта) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Волшебный-лес) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Карта(" ?c0 ") -> Волшебный-лес(" (* ?c0  0.9) ")")))
)
            
(defrule Карта_Море
   (declare (salience 40))
   (adventure-element (thing Карта) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Море) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Карта(" ?c0 ") -> Море(" (* ?c0  1) ")")))
)
            
(defrule Карта_Горы
   (declare (salience 40))
   (adventure-element (thing Карта) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Горы) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Карта(" ?c0 ") -> Горы(" (* ?c0  0.8) ")")))
)
            
(defrule Карта_Река
   (declare (salience 40))
   (adventure-element (thing Карта) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Река) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Карта(" ?c0 ") -> Река(" (* ?c0  0.9) ")")))
)
            
(defrule Знания_Море_Вода
   (declare (salience 40))
   (adventure-element (thing Знания) (chance ?c0))
   (adventure-element (thing Море) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Вода) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Знания(" ?c0 ") + Море(" ?c1 ") -> Вода(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Горшок-тролля_Море_Вода
   (declare (salience 40))
   (adventure-element (thing Горшок-тролля) (chance ?c0))
   (adventure-element (thing Море) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Вода) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Горшок-тролля(" ?c0 ") + Море(" ?c1 ") -> Вода(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Знания_Заклинания_Портал
   (declare (salience 40))
   (adventure-element (thing Знания) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Портал) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Знания(" ?c0 ") + Заклинания(" ?c1 ") -> Портал(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Подземелье_Призраки
   (declare (salience 40))
   (adventure-element (thing Подземелье) (chance ?c0))
   (test ( < 0.2 ?c0 ))
   =>
   (assert (adventure-element (thing Призраки) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Подземелье(" ?c0 ") -> Призраки(" (* ?c0  0.8) ")")))
)
            
(defrule Подземелье_Культисты
   (declare (salience 40))
   (adventure-element (thing Подземелье) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Культисты) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Подземелье(" ?c0 ") -> Культисты(" (* ?c0  0.9) ")")))
)
            
(defrule Культисты_Яблоки_Знания
   (declare (salience 40))
   (adventure-element (thing Культисты) (chance ?c0))
   (adventure-element (thing Яблоки) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Знания) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Культисты(" ?c0 ") + Яблоки(" ?c1 ") -> Знания(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Башня-темного-властелина_Призраки
   (declare (salience 40))
   (adventure-element (thing Башня-темного-властелина) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Призраки) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Башня-темного-властелина(" ?c0 ") -> Призраки(" (* ?c0  0.8) ")")))
)
            
(defrule Башня-темного-властелина_Отвага_Битва-с-темным-властелином
   (declare (salience 40))
   (adventure-element (thing Башня-темного-властелина) (chance ?c0))
   (adventure-element (thing Отвага) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Битва-с-темным-властелином) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Башня-темного-властелина(" ?c0 ") + Отвага(" ?c1 ") -> Битва-с-темным-властелином(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Лодка_Удочка_Море_Морское-чудовище
   (declare (salience 40))
   (adventure-element (thing Лодка) (chance ?c0))
   (adventure-element (thing Удочка) (chance ?c1))
   (adventure-element (thing Море) (chance ?c2))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.7 ?c1 ))
   (test ( < 0.6 ?c2 ))
   =>
   (assert (adventure-element (thing Морское-чудовище) (chance (* ?c0 ?c1 ?c2 1))))
   (assert (appendmessagehalt (str-cat "Лодка(" ?c0 ") + Удочка(" ?c1 ") + Море(" ?c2 ") -> Морское-чудовище(" (* ?c0 ?c1 ?c2 1) ")")))
)
            
(defrule Лодка_Море_Волшебный-лес_Латы
   (declare (salience 40))
   (adventure-element (thing Лодка) (chance ?c0))
   (adventure-element (thing Море) (chance ?c1))
   (adventure-element (thing Волшебный-лес) (chance ?c2))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.4 ?c1 ))
   (test ( < 0.4 ?c2 ))
   =>
   (assert (adventure-element (thing Латы) (chance (* ?c0 ?c1 ?c2 0.9))))
   (assert (appendmessagehalt (str-cat "Лодка(" ?c0 ") + Море(" ?c1 ") + Волшебный-лес(" ?c2 ") -> Латы(" (* ?c0 ?c1 ?c2 0.9) ")")))
)
            
(defrule Иисус_Вода_Вино
   (declare (salience 40))
   (adventure-element (thing Иисус) (chance ?c0))
   (adventure-element (thing Вода) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Вино) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Иисус(" ?c0 ") + Вода(" ?c1 ") -> Вино(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Пиво_Мясо_Тролль_Горшок-тролля
   (declare (salience 40))
   (adventure-element (thing Пиво) (chance ?c0))
   (adventure-element (thing Мясо) (chance ?c1))
   (adventure-element (thing Тролль) (chance ?c2))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.9 ?c1 ))
   (test ( < 0.3 ?c2 ))
   =>
   (assert (adventure-element (thing Горшок-тролля) (chance (* ?c0 ?c1 ?c2 0.9))))
   (assert (appendmessagehalt (str-cat "Пиво(" ?c0 ") + Мясо(" ?c1 ") + Тролль(" ?c2 ") -> Горшок-тролля(" (* ?c0 ?c1 ?c2 0.9) ")")))
)
            
(defrule Вино_Таверна_Пир-на-весь-мир
   (declare (salience 40))
   (adventure-element (thing Вино) (chance ?c0))
   (adventure-element (thing Таверна) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Пир-на-весь-мир) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Вино(" ?c0 ") + Таверна(" ?c1 ") -> Пир-на-весь-мир(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Пир-на-весь-мир_Слава
   (declare (salience 40))
   (adventure-element (thing Пир-на-весь-мир) (chance ?c0))
   (test ( < 0.4 ?c0 ))
   =>
   (assert (adventure-element (thing Слава) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Пир-на-весь-мир(" ?c0 ") -> Слава(" (* ?c0  0.8) ")")))
)
            
(defrule Деньги_Ярмарка_Оружие
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Оружие) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Ярмарка(" ?c1 ") -> Оружие(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Деньги_Ярмарка_Веревка
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Веревка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Ярмарка(" ?c1 ") -> Веревка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Деньги_Ярмарка_Щит
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Щит) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Ярмарка(" ?c1 ") -> Щит(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Деньги_Ярмарка_Лодка
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Лодка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Ярмарка(" ?c1 ") -> Лодка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Удача_Ярмарка_Деньги
   (declare (salience 40))
   (adventure-element (thing Удача) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.5 ?c1 ))
   =>
   (assert (adventure-element (thing Деньги) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Удача(" ?c0 ") + Ярмарка(" ?c1 ") -> Деньги(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Слава_Ярмарка_Деньги
   (declare (salience 40))
   (adventure-element (thing Слава) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Деньги) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Слава(" ?c0 ") + Ярмарка(" ?c1 ") -> Деньги(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Конь_Оружие_Мясо
   (declare (salience 40))
   (adventure-element (thing Конь) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Мясо) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Конь(" ?c0 ") + Оружие(" ?c1 ") -> Мясо(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Пиво_Отвага
   (declare (salience 40))
   (adventure-element (thing Пиво) (chance ?c0))
   (test ( < 0.3 ?c0 ))
   =>
   (assert (adventure-element (thing Отвага) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Пиво(" ?c0 ") -> Отвага(" (* ?c0  0.9) ")")))
)
            
(defrule Вино_Отвага
   (declare (salience 40))
   (adventure-element (thing Вино) (chance ?c0))
   (test ( < 0.4 ?c0 ))
   =>
   (assert (adventure-element (thing Отвага) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Вино(" ?c0 ") -> Отвага(" (* ?c0  0.8) ")")))
)
            
(defrule Морское-чудовище_Культисты_Ктулху
   (declare (salience 40))
   (adventure-element (thing Морское-чудовище) (chance ?c0))
   (adventure-element (thing Культисты) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Ктулху) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Морское-чудовище(" ?c0 ") + Культисты(" ?c1 ") -> Ктулху(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Ктулху_Заклинания_Сундук-с-алмазами
   (declare (salience 40))
   (adventure-element (thing Ктулху) (chance ?c0))
   (adventure-element (thing Заклинания) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Сундук-с-алмазами) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Ктулху(" ?c0 ") + Заклинания(" ?c1 ") -> Сундук-с-алмазами(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Ктулху_Рыба_Сундук-с-алмазами
   (declare (salience 40))
   (adventure-element (thing Ктулху) (chance ?c0))
   (adventure-element (thing Рыба) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Сундук-с-алмазами) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Ктулху(" ?c0 ") + Рыба(" ?c1 ") -> Сундук-с-алмазами(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Подземелье_Веревка_Железо
   (declare (salience 40))
   (adventure-element (thing Подземелье) (chance ?c0))
   (adventure-element (thing Веревка) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Железо) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Подземелье(" ?c0 ") + Веревка(" ?c1 ") -> Железо(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Латы_Дракон_Битва-с-драконом
   (declare (salience 40))
   (adventure-element (thing Латы) (chance ?c0))
   (adventure-element (thing Дракон) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Битва-с-драконом) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Латы(" ?c0 ") + Дракон(" ?c1 ") -> Битва-с-драконом(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Оружие_Щит_Дракон_Битва-с-драконом
   (declare (salience 40))
   (adventure-element (thing Оружие) (chance ?c0))
   (adventure-element (thing Щит) (chance ?c1))
   (adventure-element (thing Дракон) (chance ?c2))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.6 ?c1 ))
   (test ( < 0.6 ?c2 ))
   =>
   (assert (adventure-element (thing Битва-с-драконом) (chance (* ?c0 ?c1 ?c2 1))))
   (assert (appendmessagehalt (str-cat "Оружие(" ?c0 ") + Щит(" ?c1 ") + Дракон(" ?c2 ") -> Битва-с-драконом(" (* ?c0 ?c1 ?c2 1) ")")))
)
            
(defrule Битва-с-драконом_Смерть
   (declare (salience 40))
   (adventure-element (thing Битва-с-драконом) (chance ?c0))
   (test ( < 0.9 ?c0 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Битва-с-драконом(" ?c0 ") -> Смерть(" (* ?c0  0.8) ")")))
)
            
(defrule Битва-с-драконом_Оружие_Щит_Сокровища-дракона
   (declare (salience 40))
   (adventure-element (thing Битва-с-драконом) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (adventure-element (thing Щит) (chance ?c2))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.5 ?c1 ))
   (test ( < 0.8 ?c2 ))
   =>
   (assert (adventure-element (thing Сокровища-дракона) (chance (* ?c0 ?c1 ?c2 0.8))))
   (assert (appendmessagehalt (str-cat "Битва-с-драконом(" ?c0 ") + Оружие(" ?c1 ") + Щит(" ?c2 ") -> Сокровища-дракона(" (* ?c0 ?c1 ?c2 0.8) ")")))
)
            
(defrule Битва-с-драконом_Оружие_Щит_Слава
   (declare (salience 40))
   (adventure-element (thing Битва-с-драконом) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (adventure-element (thing Щит) (chance ?c2))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.7 ?c1 ))
   (test ( < 0.9 ?c2 ))
   =>
   (assert (adventure-element (thing Слава) (chance (* ?c0 ?c1 ?c2 0.8))))
   (assert (appendmessagehalt (str-cat "Битва-с-драконом(" ?c0 ") + Оружие(" ?c1 ") + Щит(" ?c2 ") -> Слава(" (* ?c0 ?c1 ?c2 0.8) ")")))
)
            
(defrule Битва-с-темным-властелином_Оружие_Латы_Сундук-с-проклятыми-монетами
   (declare (salience 40))
   (adventure-element (thing Битва-с-темным-властелином) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (adventure-element (thing Латы) (chance ?c2))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.2 ?c1 ))
   (test ( < 0.8 ?c2 ))
   =>
   (assert (adventure-element (thing Сундук-с-проклятыми-монетами) (chance (* ?c0 ?c1 ?c2 1))))
   (assert (appendmessagehalt (str-cat "Битва-с-темным-властелином(" ?c0 ") + Оружие(" ?c1 ") + Латы(" ?c2 ") -> Сундук-с-проклятыми-монетами(" (* ?c0 ?c1 ?c2 1) ")")))
)
            
(defrule Битва-с-темным-властелином_Оружие_Латы_Слава
   (declare (salience 40))
   (adventure-element (thing Битва-с-темным-властелином) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (adventure-element (thing Латы) (chance ?c2))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.4 ?c1 ))
   (test ( < 0.3 ?c2 ))
   =>
   (assert (adventure-element (thing Слава) (chance (* ?c0 ?c1 ?c2 0.8))))
   (assert (appendmessagehalt (str-cat "Битва-с-темным-властелином(" ?c0 ") + Оружие(" ?c1 ") + Латы(" ?c2 ") -> Слава(" (* ?c0 ?c1 ?c2 0.8) ")")))
)
            
(defrule Битва-с-темным-властелином_Смерть
   (declare (salience 40))
   (adventure-element (thing Битва-с-темным-властелином) (chance ?c0))
   (test ( < 0.7 ?c0 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0  1))))
   (assert (appendmessagehalt (str-cat "Битва-с-темным-властелином(" ?c0 ") -> Смерть(" (* ?c0  1) ")")))
)
            
(defrule Сундук-с-проклятыми-монетами_Неудача
   (declare (salience 40))
   (adventure-element (thing Сундук-с-проклятыми-монетами) (chance ?c0))
   (test ( < 0.3 ?c0 ))
   =>
   (assert (adventure-element (thing Неудача) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Сундук-с-проклятыми-монетами(" ?c0 ") -> Неудача(" (* ?c0  0.8) ")")))
)
            
(defrule Сундук-с-проклятыми-монетами_Отмычка_Деньги
   (declare (salience 40))
   (adventure-element (thing Сундук-с-проклятыми-монетами) (chance ?c0))
   (adventure-element (thing Отмычка) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Деньги) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Сундук-с-проклятыми-монетами(" ?c0 ") + Отмычка(" ?c1 ") -> Деньги(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Латы_Тролль_Битва-с-троллем
   (declare (salience 40))
   (adventure-element (thing Латы) (chance ?c0))
   (adventure-element (thing Тролль) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Битва-с-троллем) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Латы(" ?c0 ") + Тролль(" ?c1 ") -> Битва-с-троллем(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Битва-с-троллем_Оружие_Карта
   (declare (salience 40))
   (adventure-element (thing Битва-с-троллем) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (test ( < 0.9 ?c0 ))
   (test ( < 0.4 ?c1 ))
   =>
   (assert (adventure-element (thing Карта) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Битва-с-троллем(" ?c0 ") + Оружие(" ?c1 ") -> Карта(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Битва-с-троллем_Смерть
   (declare (salience 40))
   (adventure-element (thing Битва-с-троллем) (chance ?c0))
   (test ( < 0.2 ?c0 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Битва-с-троллем(" ?c0 ") -> Смерть(" (* ?c0  0.9) ")")))
)
            
(defrule Темный-лес_Оружие_Мясо
   (declare (salience 40))
   (adventure-element (thing Темный-лес) (chance ?c0))
   (adventure-element (thing Оружие) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.4 ?c1 ))
   =>
   (assert (adventure-element (thing Мясо) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Темный-лес(" ?c0 ") + Оружие(" ?c1 ") -> Мясо(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Темный-лес_Неудача_Смерть
   (declare (salience 40))
   (adventure-element (thing Темный-лес) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Темный-лес(" ?c0 ") + Неудача(" ?c1 ") -> Смерть(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Веревка_Неудача_Смерть
   (declare (salience 40))
   (adventure-element (thing Веревка) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Веревка(" ?c0 ") + Неудача(" ?c1 ") -> Смерть(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Деньги_Таверна_Пиво
   (declare (salience 40))
   (adventure-element (thing Деньги) (chance ?c0))
   (adventure-element (thing Таверна) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Пиво) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Деньги(" ?c0 ") + Таверна(" ?c1 ") -> Пиво(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Дети_Ярмарка_Конфеты
   (declare (salience 40))
   (adventure-element (thing Дети) (chance ?c0))
   (adventure-element (thing Ярмарка) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Конфеты) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Дети(" ?c0 ") + Ярмарка(" ?c1 ") -> Конфеты(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Конфеты_Единорог_Конь
   (declare (salience 40))
   (adventure-element (thing Конфеты) (chance ?c0))
   (adventure-element (thing Единорог) (chance ?c1))
   (test ( < 0.5 ?c0 ))
   (test ( < 0.3 ?c1 ))
   =>
   (assert (adventure-element (thing Конь) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Конфеты(" ?c0 ") + Единорог(" ?c1 ") -> Конь(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Дети_Единорог_Удача
   (declare (salience 40))
   (adventure-element (thing Дети) (chance ?c0))
   (adventure-element (thing Единорог) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Удача) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Дети(" ?c0 ") + Единорог(" ?c1 ") -> Удача(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Смерть_Удача_Рай
   (declare (salience 40))
   (adventure-element (thing Смерть) (chance ?c0))
   (adventure-element (thing Удача) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Рай) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Смерть(" ?c0 ") + Удача(" ?c1 ") -> Рай(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Смерть_Неудача_Ад
   (declare (salience 40))
   (adventure-element (thing Смерть) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Ад) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Смерть(" ?c0 ") + Неудача(" ?c1 ") -> Ад(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Портал_Сатана
   (declare (salience 40))
   (adventure-element (thing Портал) (chance ?c0))
   (test ( < 0.5 ?c0 ))
   =>
   (assert (adventure-element (thing Сатана) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Портал(" ?c0 ") -> Сатана(" (* ?c0  0.9) ")")))
)
            
(defrule Мост_Тролль
   (declare (salience 40))
   (adventure-element (thing Мост) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Тролль) (chance (* ?c0  0.9))))
   (assert (appendmessagehalt (str-cat "Мост(" ?c0 ") -> Тролль(" (* ?c0  0.9) ")")))
)
            
(defrule Река_Удочка_Рыба
   (declare (salience 40))
   (adventure-element (thing Река) (chance ?c0))
   (adventure-element (thing Удочка) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Рыба) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Река(" ?c0 ") + Удочка(" ?c1 ") -> Рыба(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Море_Удочка_Рыба
   (declare (salience 40))
   (adventure-element (thing Море) (chance ?c0))
   (adventure-element (thing Удочка) (chance ?c1))
   (test ( < 0.3 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Рыба) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Море(" ?c0 ") + Удочка(" ?c1 ") -> Рыба(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Рыба_Дракон_Удача
   (declare (salience 40))
   (adventure-element (thing Рыба) (chance ?c0))
   (adventure-element (thing Дракон) (chance ?c1))
   (test ( < 0.6 ?c0 ))
   (test ( < 0.2 ?c1 ))
   =>
   (assert (adventure-element (thing Удача) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Рыба(" ?c0 ") + Дракон(" ?c1 ") -> Удача(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Мост_Тролль_Загадка
   (declare (salience 40))
   (adventure-element (thing Мост) (chance ?c0))
   (adventure-element (thing Тролль) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.9 ?c1 ))
   =>
   (assert (adventure-element (thing Загадка) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Мост(" ?c0 ") + Тролль(" ?c1 ") -> Загадка(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Загадка_Удача_Горшок-тролля
   (declare (salience 40))
   (adventure-element (thing Загадка) (chance ?c0))
   (adventure-element (thing Удача) (chance ?c1))
   (test ( < 0.7 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Горшок-тролля) (chance (* ?c0 ?c1 1))))
   (assert (appendmessagehalt (str-cat "Загадка(" ?c0 ") + Удача(" ?c1 ") -> Горшок-тролля(" (* ?c0 ?c1 1) ")")))
)
            
(defrule Загадка_Неудача_Смерть
   (declare (salience 40))
   (adventure-element (thing Загадка) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Смерть) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Загадка(" ?c0 ") + Неудача(" ?c1 ") -> Смерть(" (* ?c0 ?c1 0.8) ")")))
)
            
(defrule Горшок-тролля_Деньги_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Горшок-тролля) (chance ?c0))
   (adventure-element (thing Деньги) (chance ?c1))
   (test ( < 0.4 ?c0 ))
   (test ( < 0.7 ?c1 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Горшок-тролля(" ?c0 ") + Деньги(" ?c1 ") -> Крутая-награда(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Сокровища-дракона_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Сокровища-дракона) (chance ?c0))
   (test ( < 0.8 ?c0 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0  0.8))))
   (assert (appendmessagehalt (str-cat "Сокровища-дракона(" ?c0 ") -> Крутая-награда(" (* ?c0  0.8) ")")))
)
            
(defrule Сундук-с-алмазами_Отмычка_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Сундук-с-алмазами) (chance ?c0))
   (adventure-element (thing Отмычка) (chance ?c1))
   (test ( < 0.8 ?c0 ))
   (test ( < 0.8 ?c1 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0 ?c1 0.9))))
   (assert (appendmessagehalt (str-cat "Сундук-с-алмазами(" ?c0 ") + Отмычка(" ?c1 ") -> Крутая-награда(" (* ?c0 ?c1 0.9) ")")))
)
            
(defrule Удача_Неудача_Крутая-награда
   (declare (salience 40))
   (adventure-element (thing Удача) (chance ?c0))
   (adventure-element (thing Неудача) (chance ?c1))
   (test ( < 0.2 ?c0 ))
   (test ( < 0.6 ?c1 ))
   =>
   (assert (adventure-element (thing Крутая-награда) (chance (* ?c0 ?c1 0.8))))
   (assert (appendmessagehalt (str-cat "Удача(" ?c0 ") + Неудача(" ?c1 ") -> Крутая-награда(" (* ?c0 ?c1 0.8) ")")))
)
            
