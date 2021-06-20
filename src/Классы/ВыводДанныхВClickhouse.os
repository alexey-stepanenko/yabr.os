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

Перем РазмерПорцииОбработки;   // Число                  - количество записей, которое будет добавлено в пакет
                               //                          для отправки в Clickhouse
Перем СохранятьОбработанныеДанные;   // Булево           - Истина - в результатах обработки
                                     //                    будут сохранены обработанные данные
Перем СохранятьОтправленныеСтроки;   // Булево           - Истина - в результатах обработки
                                     //                    будут сохранены отправленные строки

Перем Данные;                  // Структура              - данные для отправки в эластик 1С

Перем Клик_Сервер;            // Строка                - адрес сервера http-сервиса Clickhouse
Перем Клик_Порт;              // Число                 - порт сервера http-сервиса Clickhouse
Перем Клик_Путь;              // Строка                - относительный путь к REST API Clickhouse
Перем Клик_Пользователь;      // Строка                - имя пользователя сервиса Clickhouse
Перем Клик_Пароль;            // Строка                - пароль пользователя сервиса Clickhouse
Перем Клик_ИмяБазы;           // Строка                - имя базы для помещения данных
Перем Клик_ИмяТаблицы;        // Строка                - имя таблицы для помещения данных
Перем Клик_СоответствиеПолей; // Соответствие          - описание полей таблицы Clickhouse
                              //                         и соответствующих им полей данных
                              //   <Ключ>     - Строка    - имя поля Clickhouse
                              //   <Значение> - Структура - описание поля
                              //      Тип        - Строка    - тип поля Clickhouse
                              //      ПолеДанных - Строка    - имя поля источника данных
Перем Клик_УпорядочитьПо;     // Массив из Строка      - список полей упорядочивания
Перем Клик_Соединение;        // HTTP-соединение       - объект соединения с http-сервисом
                              //                         для повторного использования

Перем БылиОшибкиОтправки;
Перем ДанныеДляОтправки;       // Массив(Структура)      - накопленные данные для отправки в Elastic
Перем РезультатыОбработки;     // Структура              - результаты обработки последней порции данных
Перем ВсегоОбработано;         // Число                  - количество обработанных данных

Перем НачалоОбработкиПорции;   // Число                  - время начала обработки очередной порции данных
							   //                          для замера времени обработки
							   
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
	                          "Клик_Сервер",
	                          "Строка",
	                          Истина,
	                          "localhost",
	                          "Адрес сервера http-сервиса Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_Порт",
	                          "Число",
	                          Ложь,
	                          8123,
	                          "Порт сервера http-сервиса Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_Путь",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "Относительный путь к REST API Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_Пользователь",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Имя пользователя сервиса Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_Пароль",
	                          "Строка",
	                          ,
	                          "",
	                          "Пароль пользователя сервиса Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_ИмяБазы",
	                          "Строка",
	                          ,
	                          "1Cv8Log",
	                          "Имя базы для отправки данных.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_ИмяТаблицы",
	                          "Строка",
	                          ,
	                          "1Cv8Log",
	                          "Имя таблицы для отправки данных.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_СоответствиеПолей",
	                          "Соответствие",
	                          ,
	                          "",
	                          "Описание полей таблицы Clickhouse и соответствующих полей источника данных.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Клик_УпорядочитьПо",
	                          "Массив",
	                          ,
	                          "",
	                          "Список полей упорядочивания.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "РазмерПорцииОбработки",
	                          "Число",
	                          ,
	                          1,
	                          "Количество записей, которое будет добавлено в пакет
                              |для отправки в Clickhouse.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "СохранятьОбработанныеДанные",
	                          "Булево",
	                          ,
	                          Ложь,
	                          "Истина - в результатах обработки будут сохранены обработанные данные.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "СохранятьОтправленныеСтроки",
	                          "Булево",
	                          ,
	                          Ложь,
	                          "Истина - в результатах обработки будут сохранены отправленные строки.");
	    
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
	
	УстановитьАдресСервераКлик();

	Клик_Путь = "";
	Если ПараметрыОбработки.Свойство("Клик_Путь") И ЗначениеЗаполнено(ПараметрыОбработки.Клик_Путь) Тогда
		Клик_Путь = ?(Лев(ПараметрыОбработки.Клик_Путь, 1) = "/", "", "/") + ПараметрыОбработки.Клик_Путь;
	КонецЕсли;

	Клик_Пользователь = "";
	Если ПараметрыОбработки.Свойство("Клик_Пользователь") Тогда
		Клик_Пользователь = ПараметрыОбработки.Клик_Пользователь;
	КонецЕсли;
	
	Клик_Пароль = "";
	Если ПараметрыОбработки.Свойство("Клик_Пароль") Тогда
		Клик_Пароль = ПараметрыОбработки.Клик_Пароль;
	КонецЕсли;
	
	Клик_ИмяБазы = "1Cv8Log";
	Если ПараметрыОбработки.Свойство("Клик_ИмяБазы") Тогда
		Клик_ИмяБазы = ПараметрыОбработки.Клик_ИмяБазы;
	КонецЕсли;
	
	Клик_ИмяТаблицы = "1Cv8Log";
	Если ПараметрыОбработки.Свойство("Клик_ИмяТаблицы") Тогда
		Клик_ИмяТаблицы = ПараметрыОбработки.Клик_ИмяТаблицы;
	КонецЕсли;
	
	Клик_СоответствиеПолей = Новый Соответствие();
	Если ПараметрыОбработки.Свойство("Клик_СоответствиеПолей") Тогда
		Клик_СоответствиеПолей = ПараметрыОбработки.Клик_СоответствиеПолей;
	КонецЕсли;
	
	Клик_УпорядочитьПо = Новый Соответствие();
	Если ПараметрыОбработки.Свойство("Клик_УпорядочитьПо") Тогда
		Клик_УпорядочитьПо = ПараметрыОбработки.Клик_УпорядочитьПо;
	КонецЕсли;
	
	РазмерПорцииОбработки = 0;
	Если ПараметрыОбработки.Свойство("РазмерПорцииОбработки") Тогда
		РазмерПорцииОбработки = ПараметрыОбработки.РазмерПорцииОбработки;
	КонецЕсли;
	
	СохранятьОбработанныеДанные = Ложь;
	Если ПараметрыОбработки.Свойство("СохранятьОбработанныеДанные") Тогда
		СохранятьОбработанныеДанные = ПараметрыОбработки.СохранятьОбработанныеДанные;
	КонецЕсли;
	
	СохранятьОтправленныеСтроки = Ложь;
	Если ПараметрыОбработки.Свойство("СохранятьОтправленныеСтроки") Тогда
		СохранятьОтправленныеСтроки = ПараметрыОбработки.СохранятьОтправленныеСтроки;
	КонецЕсли;
	
	БылиОшибкиОтправки = Ложь;
	
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

	Если Найти(ВРег("Клик_Сервер, Клик_Порт"), ВРег(ИмяПараметра)) > 0 Тогда
		УстановитьАдресСервераКлик();
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_Путь") И ЗначениеЗаполнено(Значение) Тогда
		Клик_Путь = ?(Лев(Значение, 1) = "/", "", "/") + Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_Пользователь") Тогда
		Клик_Пользователь = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_Пароль") Тогда
		Клик_Пароль = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_ИмяБазы") Тогда
		Клик_ИмяБазы = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_ИмяТаблицы") Тогда
		Клик_ИмяТаблицы = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_СоответствиеПолей") Тогда
		Клик_СоответствиеПолей = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Клик_УпорядочитьПо") Тогда
		Клик_УпорядочитьПо = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("РазмерПорцииОбработки") Тогда
		РазмерПорцииОбработки = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("СохранятьОбработанныеДанные") Тогда
		СохранятьОбработанныеДанные = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("СохранятьОтправленныеСтроки") Тогда
		СохранятьОтправленныеСтроки = Значение;
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
	
	Если НачалоОбработкиПорции = Неопределено Тогда
        НачалоОбработкиПорции = ТекущаяУниверсальнаяДатаВМиллисекундах();
    КонецЕсли;
	
	ДобавитьЗаписи(Данные);
	
	Если ДанныеДляОтправки.Количество() < РазмерПорцииОбработки Тогда
		Возврат;
	КонецЕсли;
	
	ОтправитьДанные();

	ПродолжениеОбработкиДанныхВызовМенеджера(РезультатыОбработки);

	РезультатыОбработки = Неопределено;
	
КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат РезультатыОбработки;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	ОтправитьДанные();
	
	ПродолжениеОбработкиДанныхВызовМенеджера(РезультатыОбработки);
	
	РезультатыОбработки = Неопределено;
	
	АдресТаблицы = СтрШаблон("%1:%2%3\%4\%5",
	                         Клик_Сервер,
	                         Клик_Порт,
	                         Клик_Путь,
	                         Клик_ИмяБазы,
	                         Клик_ИмяТаблицы);

	Если БылиОшибкиОтправки Тогда
		Лог.Ошибка("[%1]: При отправке данных (%2) в ""%3"" возникли ошибки!",
		            ТипЗнч(ЭтотОбъект),
		            ВсегоОбработано,
		            АдресТаблицы);
	Иначе
		Лог.Информация("[%1]: Завершение отправки данных (%2) в ""%3""",
		               ТипЗнч(ЭтотОбъект),
		               ВсегоОбработано,
		               АдресТаблицы);
	КонецЕсли;

	ВсегоОбработано = 0;

	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииОтправкиДанныхВЭластик

// Процедура - добавляет записи в массив данных для отправки в Elastic
//
// Параметры:
//	Элемент         - Массив, Структура        - добавляемый элемент(-ы)
//
Процедура ДобавитьЗаписи(Элемент)
	
	Если НЕ ТипЗнч(ДанныеДляОтправки) = Тип("Массив") Тогда
		ДанныеДляОтправки = Новый Массив();
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("Массив") Тогда
		Для Каждого ТекЭлемент Из Элемент Цикл
			ДанныеДляОтправки.Добавить(ТекЭлемент);
		КонецЦикла;
	Иначе
		ДанныеДляОтправки.Добавить(Элемент);
	КонецЕсли;

КонецПроцедуры // ДобавитьЗаписи()

// Процедура - выполняет отправку данных на сервер elastic
//
Процедура ОтправитьДанные()
	
	Если НЕ ТипЗнч(ДанныеДляОтправки) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеДляОтправки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	АдресТаблицы = СтрШаблон("%1:%2%3\%4\%5",
	                         Клик_Сервер,
	                         Клик_Порт,
	                         Клик_Путь,
	                         Клик_ИмяБазы,
	                         Клик_ИмяТаблицы);

	Соединение = ПолучитьСоединение();
	
	Если НЕ СоздатьТаблицу(Соединение, Клик_ИмяТаблицы, Клик_ИмяБазы) Тогда
		Лог.Ошибка("[%1] Ошибка создания таблицы ""%2"".", ТипЗнч(ЭтотОбъект), АдресТаблицы);
		Возврат;
	КонецЕсли;

	Лог.Отладка("[%1] Отправка пакета данных (%2) в ""%3"".",
	            ТипЗнч(ЭтотОбъект),
	            ДанныеДляОтправки.Количество(),
	            АдресТаблицы);

	КоэффициентВремени = 1000;
	ВремяОжиданияДанных = (ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоОбработкиПорции) / КоэффициентВремени;
    НачалоОбработкиПорции = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ДанныеОтвета = "";
	ТекстОшибки = "";
	СтрокаЗапроса = Клик_Путь;
	
	СтрокиДляОтправки = ПолучитьСтрокиДляОтправки(ДанныеДляОтправки);
	
	ТелоЗапроса = СтрШаблон("INSERT INTO %1%2 VALUES %3",
	                        ?(ЗначениеЗаполнено(Клик_ИмяБазы), Клик_ИмяБазы + ".", ""),
	                        Клик_ИмяТаблицы,
	                        СтрокиДляОтправки);

	РезультатОбработки = ПолучитьРезультатОбработкиХТТПСервиса(Соединение,
	                                                           СтрокаЗапроса,
	                                                           ТелоЗапроса,
	                                                           ДанныеОтвета,
	                                                           ТекстОшибки);
	
	ВремяОтправки = (ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоОбработкиПорции) / КоэффициентВремени;

	РезультатыОбработки = Новый Структура();
	Если СохранятьОбработанныеДанные Тогда
		РезультатыОбработки.Вставить("Данные"         , ДанныеДляОтправки);
	КонецЕсли;
	Если СохранятьОтправленныеСтроки Тогда
		РезультатыОбработки.Вставить("Строки"         , СтрокиДляОтправки);
	КонецЕсли;
	РезультатыОбработки.Вставить("Обработано"         , РезультатОбработки);
    РезультатыОбработки.Вставить("Размер"             , ДанныеДляОтправки.Количество());
    РезультатыОбработки.Вставить("ВремяОжиданияДанных", ВремяОжиданияДанных);
    РезультатыОбработки.Вставить("ВремяОтправки"      , ВремяОтправки);
	РезультатыОбработки.Вставить("Ответ"              , ДанныеОтвета);
	РезультатыОбработки.Вставить("ТекстОшибки"        , ТекстОшибки);

	Если РезультатОбработки Тогда
		Лог.Отладка("[%1] Отправлен пакет данных (%2) в ""%3"". Время отправки: %4 сек.",
		            ТипЗнч(ЭтотОбъект),
		            ДанныеДляОтправки.Количество(),
		            АдресТаблицы,
		            РезультатыОбработки.ВремяОтправки);
	Иначе
		БылиОшибкиОтправки = Истина;
		Лог.Ошибка("[%1] Ошибка отправки пакет данных (%2) в ""%3"":%4%5%4Время отправки: %6 сек.",
		           ТипЗнч(ЭтотОбъект),
		           ДанныеДляОтправки.Количество(),
		           АдресТаблицы,
		           Символы.ПС,
		           ТекстОшибки,
		           РезультатыОбработки.ВремяОтправки);
	КонецЕсли;

	ВсегоОбработано = ВсегоОбработано + ДанныеДляОтправки.Количество();

	ДанныеДляОтправки = Новый Массив();
	
    НачалоОбработкиПорции = Неопределено;
	
КонецПроцедуры // ОтправитьДанные()

// Функция - создает базу Clickhouse если она не существует
// 
// Параметры:
//     Соединение           - HTTPСоединение      - соединение с сервером Clickhouse
//     ИмяБазы              - Строка              - имя создаваемой базы Clickhouse
//
// Возвращаемое значение:
//   Булево                         - Истина - база создана/существует;
//                                    Ложь - в противном случае 
//
Функция СоздатьБазу(Соединение, ИмяБазы)

	СтрокаЗапроса = Клик_Путь;
	ТелоЗапроса   = СтрШаблон("CREATE DATABASE IF NOT EXISTS %1", ИмяБазы);
	Ответ         = Неопределено;
	ТекстОшибки   = "";

	Результат = ПолучитьРезультатОбработкиХТТПСервиса(Соединение, СтрокаЗапроса, ТелоЗапроса, Ответ, ТекстОшибки);

	Возврат Результат;

КонецФункции // СоздатьБазу()

// Функция - создает таблицу в базе Clickhouse если она не существует
// 
// Параметры:
//     Соединение           - HTTPСоединение      - соединение с сервером Clickhouse
//     ИмяТаблицы           - Строка              - имя создаваемой таблицы Clickhouse
//     ИмяБазы              - Строка              - имя создаваемой базы Clickhouse
//
// Возвращаемое значение:
//   Булево                         - Истина - база создана/существует;
//                                    Ложь - в противном случае 
//
Функция СоздатьТаблицу(Соединение, Знач ИмяТаблицы, Знач ИмяБазы = "")

	Если ЗначениеЗаполнено(ИмяБазы) Тогда
		Если НЕ СоздатьБазу(Соединение, ИмяБазы) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(ИмяБазы) Тогда
		ИмяТаблицы = СтрШаблон("%1.%2", ИмяБазы, ИмяТаблицы);
	КонецЕсли;

	ПоляТаблицы = Новый Массив();
	Для Каждого ТекПоле Из Клик_СоответствиеПолей Цикл
		ПоляТаблицы.Добавить(СтрШаблон("%1 %2", ТекПоле.Ключ, ТекПоле.Значение.Тип));
	КонецЦикла;

	ВыражениеУпорядочивания = "";
	Если Клик_УпорядочитьПо.Количество() > 0 Тогда
		ВыражениеУпорядочивания = СтрШаблон("ORDER BY (%1)", СтрСоединить(Клик_УпорядочитьПо, ","));
	КонецЕсли;

	СтрокаЗапроса = Клик_Путь;
	ТелоЗапроса   = СтрШаблон("CREATE TABLE IF NOT EXISTS %1 (%2) ENGINE = MergeTree() PARTITION BY (toYYYYMM(DateTime)) %3 SETTINGS index_granularity = 8192;",
	                          ИмяТаблицы,
	                          СтрСоединить(ПоляТаблицы, ","),
	                          ВыражениеУпорядочивания);
	Ответ         = Неопределено;
	ТекстОшибки   = "";

	Результат = ПолучитьРезультатОбработкиХТТПСервиса(Соединение, СтрокаЗапроса, ТелоЗапроса, Ответ, ТекстОшибки);

	Возврат Результат;

КонецФункции // СоздатьТаблицу()

// Функция - преобразует переданные записи в строку для отправки в Clickhouse
// 
// Параметры:
//     Записи     - Массив(Структура)      - записи для отправки в Clickhouse
//
// Возвращаемое значение:
//   Строка - строка данных для отправки в Clickhouse
//
Функция ПолучитьСтрокиДляОтправки(Записи)
	
	МассивСтрокДляОтправки = Новый Массив();
	
	Для Каждого ТекЗапись Из Записи Цикл
		
		ДанныеСтрокиДляОтправки = Новый Массив();

		Для Каждого ТекПоле Из Клик_СоответствиеПолей Цикл
			Значение = ТекЗапись[ТекПоле.Значение.ПолеИсточника];
			Если ТипЗнч(Значение) = Тип("Строка") Тогда
				Значение = СтрЗаменить(Значение, "'", "''");
				Значение = СтрШаблон("'%1'", Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
				Значение = СтрШаблон("'%1'", Формат(Значение, "ДФ='гггг-ММ-дд ЧЧ:мм:сс'"));
			ИначеЕсли ТипЗнч(Значение) = Тип("Массив") Тогда
				Значение = СтрШаблон("'%1'", СтрСоединить(Значение, Символы.ПС));
			КонецЕсли;
			ДанныеСтрокиДляОтправки.Добавить(Значение);
		КонецЦикла;

		МассивСтрокДляОтправки.Добавить(СтрШаблон("(%1)", СтрСоединить(ДанныеСтрокиДляОтправки, ",")));
		
	КонецЦикла;
	
	СтрокаДляОтправки = СтрСоединить(МассивСтрокДляОтправки, ",");
	
	Возврат СтрокаДляОтправки;
	
КонецФункции // ПолучитьСтрокиДляОтправки()

// Функция - Получить соединение
//
// Возвращаемое значение:
//		HTTPСоединение		- Установленное соединение с http-сервисом
//
Функция ПолучитьСоединение()
	
	Если ТипЗнч(Клик_Соединение) = Тип("HTTPСоединение") Тогда
		Возврат Клик_Соединение;
	КонецЕсли;
	
	// Подключаем http-сервис указанный в настройках подключения к базе
	Попытка
		Клик_Соединение = Новый HTTPСоединение(Клик_Сервер, Клик_Порт, Клик_Пользователь, Клик_Пароль, , 20);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СтрШаблон("Ошибка установки соединения с сервером clickhouse (%1:%2): %3",
		                            Клик_Сервер,
		                            Клик_Порт,
		                            ТекстОшибки);
	КонецПопытки;
	
	Возврат Клик_Соединение;
	
КонецФункции // ПолучитьСоединение()

// Функция - отправляет запрос на обработку в Clickhouse
// 
// Параметры:
//     Соединение                    - HTTPСоединение      - соединение с сервером Clickhouse
//     СтрокаЗапроса                 - Строка              - адрес API на сервере Clickhouse
//     ПараметрыЗапросаДляОтправки   - Строка              - данные для отправки в Clickhouse
//     ДанныеОтвета                  - Массив, Структура   - ответ от сервера Clickhouse
//     ТекстОшибки                   - Строка              - текст ошибки отправки запроса
//
// Возвращаемое значение:
//   Булево                         - Истина - данные успешно обработаны;
//                                    Ложь - в противном случае 
//
Функция ПолучитьРезультатОбработкиХТТПСервиса(Соединение
	                                        , СтрокаЗапроса = ""
	                                        , ПараметрыЗапросаДляОтправки = ""
	                                        , ДанныеОтвета = Неопределено
	                                        , ТекстОшибки = "") Экспорт
	
	ЗапросКСервису = Новый HTTPЗапрос(СтрокаЗапроса);
	ЗапросКСервису.УстановитьТелоИзСтроки(ПараметрыЗапросаДляОтправки);
		
	ТекстОтвета = "";
		
	Попытка
		ОтветСервиса = Соединение.ОтправитьДляОбработки(ЗапросКСервису);
		ТекстОтвета = ОтветСервиса.ПолучитьТелоКакСтроку();
		ДанныеОтвета = ОтветСервиса.Заголовки.Получить("X-ClickHouse-Summary");
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
		
	Если НЕ Лев(ОтветСервиса.КодСостояния, 1) = "2" Тогда
		ТекстОшибки = СокрЛП(ОтветСервиса.КодСостояния) + ": <" + ТекстОтвета + ">";
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПолучитьРезультатОбработкиХТТПСервиса()

#КонецОбласти // ПроцедурыИФункцииОтправкиДанныхВЭластик

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

// Функция - раскладывает строку адреса сервера на протокол, сервер, порт
// 
// Параметры:
//     СтрокаАдреса        - Строка       - адрес сервера
//
// Возвращаемое значение:
//   Структура             - результат разбора
//       * Протокол        - Строка       - наименование протокола (http, https)
//       * Сервер          - Строка       - адрес/имя сервера
//       * Порт            - Число        - номер порта (если указан)
//
Функция РазложитьАдресСервера(Знач СтрокаАдреса)

	ЧастиАдреса = СтрРазделить(СтрокаАдреса, ":");

	Результат = Новый Структура();

	КоличествоЭлементов1 = 1;
	КоличествоЭлементов2 = 2;
	КоличествоЭлементов3 = 3;

	Если ЧастиАдреса.Количество() = КоличествоЭлементов1 Тогда
		Результат.Вставить("Сервер", ЧастиАдреса[0]);
	ИначеЕсли ЧастиАдреса.Количество() = КоличествоЭлементов2 Тогда
		Если Лев(ЧастиАдреса[1], 2) = "//" Тогда
			Результат.Вставить("Протокол", ЧастиАдреса[0]);
			Результат.Вставить("Сервер", Сред(ЧастиАдреса[1], 3));
		Иначе
			Результат.Вставить("Сервер", ЧастиАдреса[0]);
			Результат.Вставить("Порт", Число(ЧастиАдреса[1]));
		КонецЕсли;
	ИначеЕсли ЧастиАдреса.Количество() = КоличествоЭлементов3 Тогда
		Результат.Вставить("Протокол", ЧастиАдреса[0]);
		Результат.Вставить("Сервер", Сред(ЧастиАдреса[1], 3));
		Результат.Вставить("Порт", Число(ЧастиАдреса[2]));
	Иначе
		ВызватьИсключение СтрШаблон("Некорректно указан адрес сервера %1", СтрокаАдреса);
	КонецЕсли;

	Возврат Результат;

КонецФункции // РазложитьАдресСервера()

// Процедура - Устанавливает значения параметров подключения к серверу Elastic
//
Процедура УстановитьАдресСервераКлик()

	Клик_Сервер = "localhost";
	Клик_Порт = 8123;
	Если ПараметрыОбработки.Свойство("Клик_Сервер") Тогда

		ОписаниеСервера = РазложитьАдресСервера(ПараметрыОбработки.Клик_Сервер);

		Клик_Сервер = ОписаниеСервера.Сервер;

		Если ОписаниеСервера.Свойство("Порт") Тогда
			Клик_Порт = ОписаниеСервера.Порт;
		КонецЕсли;

	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("Клик_Порт") И ЗначениеЗаполнено(ПараметрыОбработки.Клик_Порт) Тогда
		Клик_Порт = ПараметрыОбработки.Клик_Порт;
	КонецЕсли;
	
КонецПроцедуры // УстановитьАдресСервераЭластик()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  Менеджер	 - МенеджерОбработкиДанных    - менеджер обработки данных - владелец
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Менеджер)

	УстановитьМенеджерОбработкиДанных(Менеджер);

	Лог = МенеджерОбработкиДанных.Лог();

	БылиОшибкиОтправки = Ложь;

	ВсегоОбработано = 0;

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
