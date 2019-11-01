// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yabr.os/
// ----------------------------------------------------------

Перем МенеджерОбработкиДанных; // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;           // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;      // Структура              - параметры обработки
Перем Лог;

Перем УровеньЭлементов;        // Число                  - номер уровня элементов в структуре данных,
                               //                          которые будут прочитаны и обработаны
Перем ИндексЭлементаРодителя;  // Число                  - индекс родительского элемента в структуре данных,
                               //                          подчиненные элементы которого будут прочитаны и обработаны
Перем Данные;                  // Структура              - результаты чтения скобочного формата 1С
Перем НакопленныеДанные;	   // Массив(Структура)      - результаты обработки данных

#Область ПрограммныйИнтерфейс

// Функция - признак возможности обработки, принимать входящие данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может принимать входящие данные для обработки;
//	         Ложь - обработка не принимает входящие данные;
//
Функция ПринимаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ПринимаетДанные()

// Функция - признак возможности обработки, возвращать обработанные данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может возвращать обработанные данные;
//	         Ложь - обработка не возвращает данные;
//
Функция ВозвращаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ВозвращаетДанные()

// Функция - возвращает список параметров обработки
// 
// Возвращаемое значение:
//	Структура                                - структура входящих параметров обработки
//      *Тип                    - Строка         - тип параметра
//      *Обязательный           - Булево         - Истина - параметр обязателен
//      *ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//      *Описание               - Строка         - описание параметра
//
Функция ОписаниеПараметров() Экспорт
	
	Параметры = Новый Структура();
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "УровеньЭлементов",
	                          "Число",
	                          ,
	                          1,
	                          "Номер уровня элементов в структуре данных, которые будут прочитаны и обработаны.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ИндексЭлементаРодителя",
	                          "Число",
	                          ,
	                          0,
	                          "Индекс родительского элемента в структуре данных,
                               |подчиненные элементы которого будут прочитаны и обработаны.");
	    
	Возврат Параметры;
	
КонецФункции // ОписаниеПараметров()

// Функция - Возвращает обработку - менеджер
// 
// Возвращаемое значение:
//	ВнешняяОбработкаОбъект - обработка-менеджер
//
Функция МенеджерОбработкиДанных() Экспорт
	
	Возврат МенеджерОбработкиДанных;
	
КонецФункции // МенеджерОбработкиДанных()

// Процедура - Устанавливает обработку - менеджер
//
// Параметры:
//	НовыйМенеджерОбработкиДанных      - ВнешняяОбработкаОбъект - обработка-менеджер
//
Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных) Экспорт
	
	МенеджерОбработкиДанных = НовыйМенеджерОбработкиДанных;
	
КонецПроцедуры // УстановитьМенеджерОбработкиДанных()

// Функция - Возвращает идентификатор обработчика
// 
// Возвращаемое значение:
//	Строка - идентификатор обработчика
//
Функция Идентификатор() Экспорт
	
	Возврат Идентификатор;
	
КонецФункции // Идентификатор()

// Процедура - Устанавливает идентификатор обработчика
//
// Параметры:
//	НовыйИдентификатор      - Строка - новый идентификатор обработчика
//
Процедура УстановитьИдентификатор(Знач НовыйИдентификатор) Экспорт
	
	Идентификатор = НовыйИдентификатор;
	
КонецПроцедуры // УстановитьИдентификатор()

// Функция - Возвращает значения параметров обработки данных
// 
// Возвращаемое значение:
//	Структура - параметры обработки данных
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	УровеньЭлементов = 1;
	Если ПараметрыОбработки.Свойство("УровеньЭлементов") Тогда
		УровеньЭлементов = ПараметрыОбработки.УровеньЭлементов;
	КонецЕсли;
	
	ИндексЭлементаРодителя = 0;
	Если ПараметрыОбработки.Свойство("НомерЭлементаРодителя") Тогда
		ИндексЭлементаРодителя = ПараметрыОбработки.НомерЭлементаРодителя;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрыОбработкиДанных()

// Функция - Возвращает значение параметра обработки данных
// 
// Параметры:
//	ИмяПараметра      - Строка           - имя получаемого параметра
//
// Возвращаемое значение:
//	Произвольный      - значение параметра
//
Функция ПараметрОбработкиДанных(Знач ИмяПараметра) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ПараметрыОбработки.Свойство(ИмяПараметра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыОбработки[ИмяПараметра];
	
КонецФункции // ПараметрОбработкиДанных()

// Процедура - Устанавливает значение параметра обработки
//
// Параметры:
//	ИмяПараметра      - Строка           - имя устанавливаемого параметра
//	Значение          - Произвольный     - новое значение параметра
//
Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		ПараметрыОбработки = Новый Структура();
	КонецЕсли;
	
	ПараметрыОбработки.Вставить(ИмяПараметра, Значение);

	Если ВРег(ИмяПараметра) = ВРег("УровеньЭлементов") Тогда
		УровеньЭлементов = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("НомерЭлементаРодителя") Тогда
		ИндексЭлементаРодителя = Значение;
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	Данные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
	Данные = ВходящиеДанные;
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт
	
	ПрочитанныйЭлемент = Неопределено;
	
	Если НЕ ДобавитьЗапись(Данные, ПрочитанныйЭлемент) Тогда
		Возврат;
	КонецЕсли;
	
	ПродолжениеОбработкиДанныхВызовМенеджера(ПрочитанныйЭлемент);
	
КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Лог.Информация("[%1]: Завершение обработки данных.", ТипЗнч(ЭтотОбъект));

	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ОбработкаДанных

// Процедура - проверяет, что элемент является записью словаря журнала регистрации
// и добавляет его в соответствующий словарь
//
// Параметры:
//	Элемент             - Структура                - проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//	ПрочитанныйЭлемент  - Структура                - прочитанный элемент
//		*ИмяСловаря          - Строка                    - имя словаря к которому относится прочитанный элемент
//		*Индекс              - Число                     - индекс элемента в словаре
//		*Значение            - Число                     - значение элемента
//
// BSLLS:CognitiveComplexity-off
Функция ДобавитьЗапись(Элемент, ПрочитанныйЭлемент) Экспорт
	
	Если НЕ Элемент.Уровень = УровеньЭлементов Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элемент.Родитель.Индекс = ИндексЭлементаРодителя Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяСловаря = "";
	Если Элемент.Значения[0] = "1" Тогда
		ИмяСловаря = "Пользователи";
	ИначеЕсли Элемент.Значения[0] = "2" Тогда
		ИмяСловаря = "Компьютеры";
	ИначеЕсли Элемент.Значения[0] = "3" Тогда
		ИмяСловаря = "Приложения";
	ИначеЕсли Элемент.Значения[0] = "4" Тогда
		ИмяСловаря = "События";
	ИначеЕсли Элемент.Значения[0] = "5" Тогда
		ИмяСловаря = "Метаданные";
	ИначеЕсли Элемент.Значения[0] = "6" Тогда
		ИмяСловаря = "Серверы";
	ИначеЕсли Элемент.Значения[0] = "7" Тогда
		ИмяСловаря = "ОсновныеПорты";
	ИначеЕсли Элемент.Значения[0] = "8" Тогда
		ИмяСловаря = "ВспомогательныеПорты";
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Запись = Новый Структура();
	
	Если ИмяСловаря = "Пользователи"
	 ИЛИ ИмяСловаря = "Метаданные" Тогда
		Запись.Вставить("Ид", Элемент.Значения[1]);
		Запись.Вставить("Значение", ОбработатьКавычкиВСтроке(Элемент.Значения[2]));
		Запись.Вставить("Индекс", Число(Элемент.Значения[3]));
	Иначе
		Запись.Вставить("Значение", ОбработатьКавычкиВСтроке(Элемент.Значения[1]));
		Запись.Вставить("Индекс", Число(Элемент.Значения[2]));
	КонецЕсли;
	
	Если НЕ ТипЗнч(НакопленныеДанные) = Тип("Структура") Тогда
		НакопленныеДанные = Новый Структура();
	КонецЕсли;
	
	Если НЕ НакопленныеДанные.Свойство(ИмяСловаря) Тогда
		НакопленныеДанные.Вставить(ИмяСловаря, Новый Соответствие());
	КонецЕсли;
	
	НакопленныеДанные[ИмяСловаря].Вставить(Запись.Индекс, Запись.Значение);
	
	ПрочитанныйЭлемент = Новый Структура("ИмяСловаря, Индекс, Значение", ИмяСловаря, Запись.Индекс, Запись.Значение);
	
	Возврат Истина;
	
КонецФункции // ДобавитьЗапись()
// BSLLS:CognitiveComplexity-on

// Функция - проверяет, что элемент является записью словаря журнала регистрации
// и проверяет необходимость удаления элемента
//
// Параметры:
//	Элемент                  - Структура          - проверяемый элемент (см. НужноУдалитьЭлемент)
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
// Возвращаемое значение:
//   Булево - Истина - элемент нужно удалить после обработки
//
Функция НужноУдалитьЭлемент(Элемент) Экспорт
	
	Если НЕ Элемент.Уровень = 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // НужноУдалитьЭлемент()

#КонецОбласти // ОбработкаДанных

#Область СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

// Процедура - выполняет действия обработки элемента данных
// и оповещает обработку-менеджер о продолжении обработки элемента
//
//	Параметры:
//		Элемент    - Произвольный     - Элемент данных для продолжения обработки
//
Процедура ПродолжениеОбработкиДанныхВызовМенеджера(Элемент)
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ПродолжениеОбработкиДанных(Элемент, Идентификатор);
	
КонецПроцедуры // ПродолжениеОбработкиДанныхВызовМенеджера()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанныхВызовМенеджера()
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ЗавершениеОбработкиДанных(Идентификатор);
	
КонецПроцедуры // ЗавершениеОбработкиДанныхВызовМенеджера()

#КонецОбласти // СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

#Область СлужебныеПроцедурыИФункции

// Процедура - добавляет описание параметра обработки
// 
// Параметры:
//     ОписаниеПараметров     - Структура      - структура описаний параметров
//     Параметр               - Строка         - имя параметра
//     Тип                    - Строка         - список возможных типов параметра
//     Обязательный           - Булево         - Истина - параметр обязателен
//     ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//     Описание               - Строка         - описание параметра
//
Процедура ДобавитьОписаниеПараметра(ОписаниеПараметров
	                              , Параметр
	                              , Тип
	                              , Обязательный = Ложь
	                              , ЗначениеПоУмолчанию = Неопределено
	                              , Описание = "")
	
	Если НЕ ТипЗнч(ОписаниеПараметров) = Тип("Структура") Тогда
		ОписаниеПараметров = Новый Структура();
	КонецЕсли;
	
	ОписаниеПараметра = Новый Структура();
	ОписаниеПараметра.Вставить("Тип"                , Тип);
	ОписаниеПараметра.Вставить("Обязательный"       , Обязательный);
	ОписаниеПараметра.Вставить("ЗначениеПоУмолчанию", ЗначениеПоУмолчанию);
	ОписаниеПараметра.Вставить("Описание"           , Описание);
	
	ОписаниеПараметров.Вставить(Параметр, ОписаниеПараметра);
	
КонецПроцедуры // ДобавитьОписаниеПараметра()

// Функция - удаляет начальные, конечные и экранированные кавычки из строки
//
// Параметры:
//  ПарамСтрока	 - Строка - строка для обработки
// 
// Возвращаемое значение:
//   Строка - результирующая строка
//
Функция ОбработатьКавычкиВСтроке(Знач ПарамСтрока)
	
	ПарамСтрока = СтрЗаменить(ПарамСтрока, """""", """");
	
	Если Лев(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 2);
	КонецЕсли;
	
	Если Прав(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 1, СтрДлина(ПарамСтрока) - 1);
	КонецЕсли;
	
	Возврат СокрЛП(ПарамСтрока);
	
КонецФункции // ОбработатьКавычкиВСтроке()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  Менеджер	 - МенеджерОбработкиДанных    - менеджер обработки данных - владелец
// 
Процедура ПриСозданииОбъекта(Менеджер)

	УстановитьМенеджерОбработкиДанных(Менеджер);

	Лог = МенеджерОбработкиДанных.Лог();

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()

#КонецОбласти // ОбработчикиСобытий
