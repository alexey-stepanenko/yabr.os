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

Перем Данные;                  // Строка, Файл, Поток,   - имя файла, файл, двоичные данные или поток данных для чтения
                               // ДвоичныеДанные
Перем НачальнаяСтрока;         // Число                  - номер начальной строки файла для чтения
Перем УровниЗаписей;           // Массив(Число)          - номера уровней записей скобкофайла,
							   //                          которые будут переданы на дальнейшую обработку
Перем МинУровеньЗаписи;        // Число                  - минимальный обрабатываемый уровень записи
Перем КаталогПозицийЧтения;      // Строка               - путь к каталогу для сохранения позиций начала чтения 
Перем ПрефиксФайлаПозицииЧтения; // Строка               - префикс, добавляемый к имени файла для сохранения
                                 //                        позиции начала чтения 
Перем ИспользоватьВременныйФайл; // Булево               - Истина - чтение будет выполняться из временной копии файла

Перем ЧастотаЗамераСкоростиВыполнения; // Число          - через указанное количество прочитанных строк
                                       //                  будет выполняться замер скорости чтения
Перем ЗамерСкоростиВыполнения;         // Структура      - структура для хранения результатов замера скорости чтения

Перем ПрочитанныеДанные;               // Структура      - прочитанные данные

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
	                          "ПутьКФайлу",
	                          "Строка, Файл, Поток",
	                          ,
	                          "",
	                          "Имя файла, файл, адрес хранилища двоичных данных или поток данных для чтения.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "УровниЗаписей",
	                          "Строка, Массив",
	                          ,
	                          "1",
	                          "Список уровней записей в результате, которые будут переданы на дальнейшую обработку.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "НачальнаяСтрока",
	                          "Число",
	                          ,
	                          1,
	                          "Номер строки входящих данных с которой будет начато чтение.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "КаталогПозицийЧтения",
	                          "Строка",
	                          ,
	                          "",
	                          "Путь к каталогу для сохранения позиций начала чтения.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ПрефиксФайлаПозицииЧтения",
	                          "Строка",
	                          ,
	                          "",
	                          "Префикс, добавляемый к имени файла для сохранения позиции начала чтения.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ЧастотаЗамераСкоростиВыполнения",
	                          "Число",
	                          ,
	                          0,
	                          "Количество прочитанных записей для которых будет выполнен расчет скорости чтения данных.
                              |Если указан 0, то расчет скорости выполняться не будет.");
 
	ДобавитьОписаниеПараметра(Параметры,
	                          "ИспользоватьВременныйФайл",
	                          "Булево",
	                          Ложь,
	                          Ложь,
	                          "Истина - чтение будет выполняться из временной копии файла.");

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

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки данных
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	Если ПараметрыОбработки.Свойство("ПутьКФайлу") Тогда
		УстановитьДанные(ПараметрыОбработки.ПутьКФайлу);
	КонецЕсли;
	
	УровниЗаписей = Новый Массив();
	Если ПараметрыОбработки.Свойство("УровниЗаписей") Тогда
		ЗаполнитьУровниЗаписей(ПараметрыОбработки.УровниЗаписей);
	Иначе
		УровниЗаписей.Добавить(1);
		МинУровеньЗаписи = 1;
	КонецЕсли;
	
	НачальнаяСтрока = 1;
	Если ПараметрыОбработки.Свойство("НачальнаяСтрока") Тогда
		НачальнаяСтрока = ПараметрыОбработки.НачальнаяСтрока;
	КонецЕсли;
	
	КаталогПозицийЧтения = "";
	Если ПараметрыОбработки.Свойство("КаталогПозицийЧтения") Тогда
		КаталогПозицийЧтения = ПараметрыОбработки.КаталогПозицийЧтения;
		Если НЕ МенеджерОбработкиДанных.ЭтоWindows() Тогда
			КаталогПозицийЧтения = СтрЗаменить(КаталогПозицийЧтения, "\", "/");
		КонецЕсли;
	КонецЕсли;
	
	ПрефиксФайлаПозицииЧтения = "";
	Если ПараметрыОбработки.Свойство("ПрефиксФайлаПозицииЧтения") Тогда
		ПрефиксФайлаПозицииЧтения = ПараметрыОбработки.ПрефиксФайлаПозицииЧтения;
	КонецЕсли;
	
	ЧастотаЗамераСкоростиВыполнения = 0;
	Если ПараметрыОбработки.Свойство("ЧастотаЗамераСкоростиВыполнения") Тогда
		ЧастотаЗамераСкоростиВыполнения = ПараметрыОбработки.ЧастотаЗамераСкоростиВыполнения;
	КонецЕсли;
	
	ИспользоватьВременныйФайл = Ложь;
	Если ПараметрыОбработки.Свойство("ИспользоватьВременныйФайл") Тогда
		ИспользоватьВременныйФайл = ПараметрыОбработки.ИспользоватьВременныйФайл;
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

	Если ВРег(ИмяПараметра) = ВРег("ПутьКФайлу") Тогда
		УстановитьДанные(Значение);
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("УровниЗаписей") Тогда
		ЗаполнитьУровниЗаписей(Значение);
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("НачальнаяСтрока") Тогда
		НачальнаяСтрока = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("КаталогПозицийЧтения") Тогда
		КаталогПозицийЧтения = Значение;
		Если НЕ МенеджерОбработкиДанных.ЭтоWindows() Тогда
			КаталогПозицийЧтения = СтрЗаменить(КаталогПозицийЧтения, "\", "/");
		КонецЕсли;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ПрефиксФайлаПозицииЧтения") Тогда
		ПрефиксФайлаПозицииЧтения = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ЧастотаЗамераСкоростиВыполнения") Тогда
		ЧастотаЗамераСкоростиВыполнения = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ИспользоватьВременныйФайл") Тогда
		ИспользоватьВременныйФайл = Значение;
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//  Данные    - Строка, Файл, Поток      - имя файла, файл, адрес хранилища двоичных данных или поток данных для чтения
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
	Данные = ВходящиеДанные;

	Если ТипЗнч(Данные) = Тип("Строка") И НЕ МенеджерОбработкиДанных.ЭтоWindows() Тогда
		Данные = СтрЗаменить(Данные, "\", "/");
	КонецЕсли;
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт
	
	НачальнаяСтрока = ПолучитьНачальнуюПозициюЧтения();
	
	ОбновитьЗамерСкоростиВыполнения(НачальнаяСтрока, 1);

	Лог.Информация("[%1] Начало чтения файла ""%2"", начальная позиция чтения: %3.",
	               ТипЗнч(ЭтотОбъект),
	               ПолноеИмяФайла(),
	               НачальнаяСтрока);
	
	ВремФайл = Данные;
	Если ИспользоватьВременныйФайл Тогда

		Если ТипЗнч(Данные) = Тип("Строка") Тогда
			ВремФайл = Новый Файл(Данные);
			Расширение = ВремФайл.Расширение;
		ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда	
			Расширение = Данные.Расширение;
		Иначе
			Расширение = "tmp";
		КонецЕсли;

		ВремФайл = ПолучитьИмяВременногоФайла(Расширение);

		КопироватьФайл(Данные, ВремФайл);

		Лог.Информация("[%1] Создана временная копия ""%2"" файла ""%3"".",
		               ТипЗнч(ЭтотОбъект),
		               ВремФайл,
		               ПолноеИмяФайла());

		ПрочитатьСкобкоФайл(ВремФайл);
	
		УдалитьФайлы(ВремФайл);

		Лог.Информация("[%1] Удалена временная копия ""%2"" файла ""%3"".",
		               ТипЗнч(ЭтотОбъект),
		               ВремФайл,
					   ПолноеИмяФайла());

	Иначе
		ПрочитатьСкобкоФайл(ВремФайл);
	КонецЕсли;
	
	ОбновитьЗамерСкоростиВыполнения(НачальнаяСтрока, 1);
	
	Лог.Информация("[%1] Завершение чтения файла ""%2"",
	               | прочитано: %3 строк,
				   | скорость обработки: %4 стр./сек.,
				   | конечная позиция чтения: %5.",
				   ТипЗнч(ЭтотОбъект),
				   ПолноеИмяФайла(),
				   ЗамерСкоростиВыполнения.Прочитано,
				   Окр(ЗамерСкоростиВыполнения.Скорость, 1),
				   НачальнаяСтрока);
	
	СохранитьНачальнуюПозициюЧтения(НачальнаяСтрока);
	
КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает имя обрабатываемого файла (если было указано)
//
// Параметры
//	ДобавитьРасширение     - Булево     - Истина - к имени файла будет добавлено расширение
//
// Возвращаемое значение:
//	Произвольный     - имя обрабатываемого файла
//
Функция ИмяФайла(Знач ДобавитьРасширение = Истина) Экспорт
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		ВремФайл = Новый Файл(Данные);
		Возврат ?(ДобавитьРасширение, ВремФайл.Имя, ВремФайл.ИмяБезРасширения);
	ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда	
		Возврат ?(ДобавитьРасширение, Данные.Имя, Данные.ИмяБезРасширения);
	Иначе
		Возврат ТипЗнч(Данные);
	КонецЕсли;
	
КонецФункции // ИмяФайла()

// Функция - возвращает имя обрабатываемого файла (если было указано)
//
// Параметры
//	ДобавитьРасширение     - Булево     - Истина - к имени файла будет добавлено расширение
//
// Возвращаемое значение:
//	Произвольный     - имя обрабатываемого файла
//
Функция ПолноеИмяФайла() Экспорт
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		ВремФайл = Новый Файл(Данные);
		Возврат ВремФайл.ПолноеИмя;
	ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда	
		Возврат Данные.ПолноеИмя;
	Иначе
		Возврат ТипЗнч(Данные);
	КонецЕсли;
	
КонецФункции // ПолноеИмяФайла()

// Функция - возвращает каталог обрабатываемого файла (если было указано)
//
// Возвращаемое значение:
//	Произвольный     - имя обрабатываемого файла
//
Функция КаталогФайла() Экспорт
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		ВремФайл = Новый Файл(Данные);
		Возврат ВремФайл.Путь;
	ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда	
		Возврат Данные.Путь;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции // КаталогФайла()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат ПрочитанныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	// Код при завершении обработки данных
	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

// Функция - возвращает результаты последнего замера скорости выполнения обработки
//
// Возвращаемое значение:
//	Структура     - результаты замера скорости выполнения обработки данных
//
Функция ЗамерСкоростиВыполнения() Экспорт
	
	ТекЗамерСкоростиВыполнения = Новый Структура("Прочитано, Скорость, ТекСкорость");
	
	ЗаполнитьЗначенияСвойств(ТекЗамерСкоростиВыполнения, ЗамерСкоростиВыполнения);

	Возврат ТекЗамерСкоростиВыполнения;
	
КонецФункции // ЗамерСкоростиВыполнения()

#КонецОбласти // ПрограммныйИнтерфейс

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

#Область ПроцедурыИФункцииЧтенияДанныхСкобкофайла

// Процедура - выполняет чтение указанного файла скобочного формата 1С
//
//
// Параметры:
//  Данные    - Строка, Файл, Поток      - имя файла, файл, или поток данных для чтения
// 
Процедура ПрочитатьСкобкоФайл(Знач Данные = Неопределено)
	
	МенеджерОбработкиДанных.ПроверитьДопустимостьТипа(Данные,
	    "Строка, Файл, Поток, ПотокВПамяти, ФайловыйПоток",
	    "Некорректно указан источник данных, тип ""%1"", ожидается тип %2!");
	
	ПрочитанныеДанные = ИнициализироватьЭлементДанных(Неопределено);
	
	Текст = Новый ЧтениеТекста(Данные, КодировкаТекста.UTF8, , , Ложь);
	
	ДанныеСтроки = Текст.ПрочитатьСтроку();
	
	ИнициализироватьЗамерСкоростиВыполнения();
	
	НомерСтроки = 1;
	
	Пока НЕ ДанныеСтроки = Неопределено Цикл
		
		Если НомерСтроки < НачальнаяСтрока И НЕ НачальнаяСтрока < 1 Тогда
			ДанныеСтроки = Текст.ПрочитатьСтроку();
			НомерСтроки = НомерСтроки + 1;
			Продолжить;
		КонецЕсли;
		
		СтрокаДляОбработки = "";
		СтрокаДляОбработкиПрочитана = Ложь;
		КавычкиОткрыты = Ложь;
		
		// сборка "завершенной" строки, где кавычки закрыты и последний символ = "," или "}"
		НомераСтрок = Новый Структура();
		Пока НЕ (СтрокаДляОбработкиПрочитана ИЛИ ДанныеСтроки = Неопределено) Цикл

			ДобавитьНомерСтроки(НомераСтрок, НомерСтроки);

			СтрокаДляОбработкиПрочитана = ДополнитьСтрокуДляОбработки(СтрокаДляОбработки, ДанныеСтроки, КавычкиОткрыты);
			
			Если НЕ СтрокаДляОбработкиПрочитана Тогда
				Если КавычкиОткрыты Тогда
					СтрокаДляОбработки = СтрокаДляОбработки + Символы.ПС;
				КонецЕсли;
				ДанныеСтроки = Текст.ПрочитатьСтроку();
				НомерСтроки = НомерСтроки + 1;
			КонецЕсли;

		КонецЦикла;
		
		СчетчикСимволов = 1;
		
		ПрочитатьДанныеСтроки(ПрочитанныеДанные, СтрокаДляОбработки, СчетчикСимволов, НомераСтрок);
		
		ОбновитьЗамерСкоростиВыполнения(НомерСтроки);
		
		ДанныеСтроки = Текст.ПрочитатьСтроку();
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	ЗавершениеОбработкиДанныхВызовМенеджера();
	
	ОбновитьЗамерСкоростиВыполнения(НомерСтроки, 1);
		
	НачальнаяСтрока = НомерСтроки;
	
	// переход к корневому элементу структуры чтения
	Пока НЕ ПрочитанныеДанные.Родитель = Неопределено Цикл
		ПрочитанныеДанные = ПрочитанныеДанные.Родитель;
	КонецЦикла;
	
	Текст.Закрыть();

КонецПроцедуры // ПрочитатьСкобкоФайл()
  
// Процедура - Добавляет номер строки в струткуру прочитанных строк
//
// Параметры:
//  НомераСтрок          - Структура - диапазон прочитанных строк
//  НовыйНомерСтроки     - Число     - добавляемый номер строки
//
Процедура ДобавитьНомерСтроки(НомераСтрок, НовыйНомерСтроки)

	Если НЕ НомераСтрок.Свойство("НачСтрока") Тогда
		НомераСтрок.Вставить("НачСтрока", НовыйНомерСтроки);
	КонецЕсли;

	Если НомераСтрок.Свойство("КонСтрока") Тогда
		НомераСтрок.КонСтрока = Макс(НомераСтрок.КонСтрока, НовыйНомерСтроки);
	Иначе
		НомераСтрок.Вставить("КонСтрока", НовыйНомерСтроки);
	КонецЕсли;

КонецПроцедуры // ДобавитьНомерСтроки()

// Функция - добавляет строку к исходной и возвращает признак завершенности строки
// исходя из закрытия кавычек и окончания строки на "," или "}" 
//
// Параметры:
//  ДополняемаяСтрока    - Строка - исходная строка
//  Дополнение           - Строка - добавляемая строка
//  КавычкиОткрыты       - Булево - Истина - кавычки открыты; Ложь - кавычки закрыты
// 
// Возвращаемое значение:
//  Булево - Истина - строка завершена; Ложь - строка не завершена
//
Функция ДополнитьСтрокуДляОбработки(ДополняемаяСтрока, Дополнение, КавычкиОткрыты)
	
	КоличествоКавычек = СтрЧислоВхождений(Дополнение, """");
	
	ЧислоВхождений = 2;
	
	Если КавычкиОткрыты Тогда
		КавычкиОткрыты = (КоличествоКавычек % ЧислоВхождений = 0);
	Иначе
		КавычкиОткрыты = (КоличествоКавычек % ЧислоВхождений = 1);
	КонецЕсли;
	
	ДополняемаяСтрока = ДополняемаяСтрока + Дополнение;
	
	ПоследнийСимвол = Сред(Дополнение, СтрДлина(Дополнение), 1);
	
	// строка завершена если кавычки закрыты и последний символ = "," или "}"
	Возврат (НЕ КавычкиОткрыты) И (ПоследнийСимвол = "}" ИЛИ ПоследнийСимвол = ",");
	
КонецФункции // ДополнитьСтрокуДляОбработки()

// Функция - создает структуру нового элемента
//
// Параметры:
//  Родитель     - Структура              - ссылка на элемент-родитель (для корневого элемента "Неопределено")
//  НомераСтрок  - Соответствие(Число)    - массив номеров строк из которых был прочитан элемент
// 
// Возвращаемое значение:
//  Структура    - Новый элемент
//		*Родитель    - Структура            - ссылка на элемент-родитель
//		*Уровень     - Число                - уровень иерархии элемента
//		*Индекс      - Число                - индекс элемента в массиве значений родителя
//		*НачСтрока   - Число                - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока   - Число                - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения    - Массив(Структура)    - массив дочерних элементов
//
Функция ИнициализироватьЭлементДанных(Знач Родитель, Знач НомераСтрок = Неопределено)
	
	Если НЕ ТипЗнч(НомераСтрок) = Тип("Структура") Тогда
		НомераСтрок = Новый Структура();
		НомераСтрок.Вставить("НачСтрока"  , 0);
		НомераСтрок.Вставить("КонСтрока"  , 0);
	КонецЕсли;
	
	Уровень = 0;
	Если ТипЗнч(Родитель) = Тип("Структура") Тогда
		Если Родитель.Свойство("Уровень") Тогда
			Уровень = Родитель.Уровень + 1;
		КонецЕсли;
	КонецЕсли;
	
	Индекс = 0;
	Если ТипЗнч(Родитель) = Тип("Структура") Тогда
		Если Родитель.Свойство("Значения") Тогда
			Индекс = Родитель.Значения.ВГраница() + 1;
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура();
	Результат.Вставить("Родитель"   , Родитель);
	Результат.Вставить("Уровень"    , Уровень);
	Результат.Вставить("Индекс"     , Индекс);
	Результат.Вставить("НачСтрока"  , 0);
	Результат.Вставить("КонСтрока"  , 0);
	Результат.Вставить("Значения"   , Новый Массив());
	
	ДополнитьНомераСтрокРодителей(Результат);
	
	Возврат Результат;
	
КонецФункции // ИнициализироватьЭлементДанных()

// Процедура - дополняет массивы номеров строк родительских элементов номерами строк указанного элемента
//
// Параметры:
//  Элемент          - Структура           - структура элемента
//		*Родитель    - Структура           - ссылка на элемент-родитель
//		*Уровень     - Число               - уровень иерархии элемента
//		*Индекс      - Число               - индекс элемента в массиве значений родителя
//		*НачСтрока   - Число               - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока   - Число               - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения    - Массив(Структура)   - массив дочерних элементов
//  НомераСтрок      - Соответствие(Число) - массив номеров строк для заполнения
// 
Процедура ДополнитьНомераСтрокРодителей(Знач Элемент, Знач НомераСтрок = Неопределено)
	
	Если ТипЗнч(НомераСтрок) = Тип("Структура") Тогда
		Если НЕ НомераСтрок.Свойство("НачСтрока") ИЛИ НомераСтрок.НачСтрока = 0 Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Элемент.НачСтрока = ?(Элемент.НачСтрока = 0, НомераСтрок.НачСтрока, Мин(Элемент.НачСтрока, НомераСтрок.НачСтрока));
	Элемент.КонСтрока = Макс(Элемент.КонСтрока, НомераСтрок.КонСтрока);
	
	ТекЭлемент = Элемент.Родитель;

	Пока НЕ ТекЭлемент = Неопределено Цикл

		ТекЭлемент.НачСтрока = ?(ТекЭлемент.НачСтрока = 0,
								 НомераСтрок.НачСтрока,
								 Мин(ТекЭлемент.НачСтрока, НомераСтрок.НачСтрока));
		ТекЭлемент.КонСтрока = Макс(ТекЭлемент.КонСтрока, НомераСтрок.КонСтрока);

		ТекЭлемент = ТекЭлемент.Родитель;

	КонецЦикла;
	
КонецПроцедуры // ДополнитьНомераСтрокРодителей()

// Процедура - Читает, разбирает данные из переданной строки и добавляет результат в иерархию массива структур
//
// Параметры:
//  ЭлементДляЗаполнения     - Структура                 - структура элемента
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//  ДанныеСтроки             - Строка                    - строка для разбора
//  СчетчикСимволов          - Число                     - счетчик прочитанных символов переданной строки
//  НомераСтрок              - Соответствие(Число)       - массив номеров строк, на основе которых
//                                                         была сформирована структура текущего уровня
//
// BSLLS:CognitiveComplexity-off
Процедура ПрочитатьДанныеСтроки(ЭлементДляЗаполнения, 
                                ДанныеСтроки,
                                СчетчикСимволов,
                                НомераСтрок = Неопределено)
	
	Если НЕ ТипЗнч(НомераСтрок) = Тип("Структура") Тогда
		НомераСтрок = Новый Структура();
		НомераСтрок.Вставить("НачСтрока", 0);
		НомераСтрок.Вставить("КонСтрока", 0);
	КонецЕсли;
	
	СимволыСтроки = Новый Массив();
	КавычкиОткрыты = Ложь;
	ПредСимвол = "";
	
	ДлинаСтроки = СтрДлина(ДанныеСтроки);
	
	// посимвольное чтение строки
	Для й = СчетчикСимволов По ДлинаСтроки Цикл
		ТекСимвол = Сред(ДанныеСтроки, й, 1);
		
		Если КавычкиОткрыты Тогда // обработка строки внутри кавычек
			СимволыСтроки.Добавить(ТекСимвол);
			Если ТекСимвол = """" Тогда
				СледСимвол = Сред(ДанныеСтроки, й + 1, 1);
				Если СледСимвол = """" Тогда  // это экранированные кавычки внутри строки
					СимволыСтроки.Добавить(СледСимвол);
					й = й + 1;
				Иначе // закрытие кавычек
					КавычкиОткрыты = Ложь;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТекСимвол = """" Тогда // открытие кавычек
			СимволыСтроки.Добавить(ТекСимвол);
			КавычкиОткрыты = Истина;
		ИначеЕсли ТекСимвол = "{" Тогда // открытие вложенного списка
			Если ЭлементДляЗаполнения = Неопределено Тогда
				ВремЭлементДляЗаполнения = ИнициализироватьЭлементДанных(Неопределено, НомераСтрок);
				ЭлементДляЗаполнения = ВремЭлементДляЗаполнения;
			Иначе
				ВремЭлементДляЗаполнения = ИнициализироватьЭлементДанных(ЭлементДляЗаполнения, НомераСтрок);
				ЭлементДляЗаполнения.Значения.Добавить(ВремЭлементДляЗаполнения);
			КонецЕсли;
			й = й + 1;
			ПрочитатьДанныеСтроки(ВремЭлементДляЗаполнения, ДанныеСтроки, й, НомераСтрок);
			Если й > ДлинаСтроки Тогда
				 // если строка закончилась, то "наверх" поднимается элемент текущего уровня
				ЭлементДляЗаполнения = ВремЭлементДляЗаполнения;
				СчетчикСимволов = й;
				Возврат;
			КонецЕсли;
		ИначеЕсли ТекСимвол = "}" Тогда // закрытие вложенного списка
			Если НЕ (ПредСимвол = "{" ИЛИ ПредСимвол = "}" ИЛИ ПредСимвол = "") Тогда
				ЭлементДляЗаполнения.Значения.Добавить(СтрСоединить(СимволыСтроки));
				СимволыСтроки.Очистить();
				ДополнитьНомераСтрокРодителей(ЭлементДляЗаполнения, НомераСтрок);
			КонецЕсли;
			
			// обработка добавленного элемента по правилам обработки
			ОбработатьЭлементДанных(ЭлементДляЗаполнения);
			
			СчетчикСимволов = й + 1;

			ПрочитатьДанныеСтроки(ЭлементДляЗаполнения, ДанныеСтроки, СчетчикСимволов, НомераСтрок);
			
			Возврат;
		ИначеЕсли ТекСимвол = "," Тогда // добавление элемента текущего списка
			Если НЕ (ПредСимвол = "}" ИЛИ ПредСимвол = "") Тогда
				ЭлементДляЗаполнения.Значения.Добавить(СтрСоединить(СимволыСтроки));
				СимволыСтроки.Очистить();
				ДополнитьНомераСтрокРодителей(ЭлементДляЗаполнения, НомераСтрок);
			КонецЕсли;
		Иначе
			СимволыСтроки.Добавить(ТекСимвол);
		КонецЕсли;
		
		ПредСимвол = ТекСимвол;
	КонецЦикла;
	
	СчетчикСимволов = й;
	
КонецПроцедуры // ПрочитатьДанныеСтроки()
// BSLLS:CognitiveComplexity-on

// Процедура - выполняет обработку элемента данных
//
// Параметры:
//  Элемент                  - Структура                 - проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
Процедура ОбработатьЭлементДанных(Элемент)
	
	ПродолжитьОбработкуЭлемента = Истина;
	
	Если ТипЗнч(УровниЗаписей) = Тип("Массив") Тогда
		Если УровниЗаписей.Количество() > 0 Тогда
			Если УровниЗаписей.Найти(Элемент.Уровень) = Неопределено Тогда
				ПродолжитьОбработкуЭлемента = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РодительскийЭлемент = Элемент.Родитель;

	Если ПродолжитьОбработкуЭлемента Тогда
		
		ПродолжениеОбработкиДанныхВызовМенеджера(Элемент);
		
		Если Элемент.Уровень <= МинУровеньЗаписи Тогда
			Элемент.Родитель = Неопределено;
		КонецЕсли;

		Если Элемент.Уровень < МинУровеньЗаписи Тогда
			Элемент.Значения = Неопределено;
			РодительскийЭлемент.Значения[Элемент.Индекс] = Неопределено;
		КонецЕсли;

	КонецЕсли;
	
	Элемент = РодительскийЭлемент;
	
КонецПроцедуры // ОбработатьЭлементДанных()

// Функция - получает информацию о начальной позиции чтения данных
//
// Возвращаемое значение:
//   Число  - номер начальной строки в файле
//
Функция ПолучитьНачальнуюПозициюЧтения() Экспорт
	
	Результат = 1;
	
	Если ПустаяСтрока(КаталогПозицийЧтения) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПутьКФайлу = СтрШаблон("%1%2%3_%4.rp",
	                       КаталогПозицийЧтения,
	                       ПолучитьРазделительПути(),
	                       ПрефиксФайлаПозицииЧтения,
	                       ИмяФайла());
	
	ВремФайл = Новый Файл(ПутьКФайлу);
	
	Если НЕ ВремФайл.Существует() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ВремТекст = Новый ТекстовыйДокумент();
	ВремТекст.Прочитать(ВремФайл.ПолноеИмя);
		
	СтрокаПозиции = ВремТекст.ПолучитьСтроку(1);
		
	Если ПустаяСтрока(СтрокаПозиции) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = Число(СтрокаПозиции);
	
	Возврат Результат;
	
КонецФункции // ПолучитьНачальнуюПозициюЧтения()

// Процедура - сохраняет в файл информацию о начальной позиции для будущего чтения
//
// Параметры:
//  НомерСтроки      - Число  - номер начальной строки в файле
// 
Процедура СохранитьНачальнуюПозициюЧтения(НомерСтроки)
	
	Если ПустаяСтрока(ИмяФайла()) ИЛИ ПустаяСтрока(КаталогПозицийЧтения) Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = СтрШаблон("%1%2%3_%4.rp",
	                       КаталогПозицийЧтения,
	                       ПолучитьРазделительПути(),
	                       ПрефиксФайлаПозицииЧтения,
	                       ИмяФайла());
	
	МенеджерОбработкиДанных.ОбеспечитьКаталог(ПутьКФайлу, Истина);

	ВремТекст = Новый ТекстовыйДокумент();
	ВремТекст.ДобавитьСтроку(Формат(НомерСтроки, "ЧН=; ЧГ=0"));
	ВремТекст.Записать(ПутьКФайлу);
	
КонецПроцедуры // СохранитьНачальнуюПозициюЧтения()

// Процедура - устанавливает массив уровней записей для передачи на обработку
// и минимальный обрабатываемый уровень записей
//
// Параметры:
//  НовыеУровниЗаписей   - Массив(Число), Строка  - массив или строка номеров записей, разделенная ","
// 
Процедура ЗаполнитьУровниЗаписей(Знач НовыеУровниЗаписей)
	
	УровниЗаписей = Новый Массив();

	Если ТипЗнч(НовыеУровниЗаписей) = Тип("Строка") Тогда
		УровниЗаписей = СтрРазделить(НовыеУровниЗаписей, ",");
	ИначеЕсли ТипЗнч(НовыеУровниЗаписей) = Тип("Массив") Тогда
		УровниЗаписей = НовыеУровниЗаписей;
	Иначе
		УровниЗаписей.Добавить(1);
	КонецЕсли;
	
	МинУровеньЗаписи = Неопределено;
	Для й = 0 По УровниЗаписей.ВГраница() Цикл
		Если НЕ ТипЗнч(УровниЗаписей[й]) = Тип("Число") Тогда
			УровниЗаписей[й] = Число(УровниЗаписей[й]);
		КонецЕсли;
		Если МинУровеньЗаписи = Неопределено Тогда
			МинУровеньЗаписи = УровниЗаписей[й];
		Иначе
			МинУровеньЗаписи = Мин(МинУровеньЗаписи, УровниЗаписей[й]);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьУровниЗаписей()

#КонецОбласти // ПроцедурыИФункцииЧтенияДанныхСкобкофайла

#Область ПроцедурыИФункцииЗамераСкоростиВыполнения

// Процедура - инициализирует служебную структуру для замера скорости выполнения
// 
Процедура ИнициализироватьЗамерСкоростиВыполнения()
	
	ЗамерСкоростиВыполнения = Новый Структура();
	ЗамерСкоростиВыполнения.Вставить("Начало"     , ТекущаяУниверсальнаяДатаВМиллисекундах());
	ЗамерСкоростиВыполнения.Вставить("ТекНачало"  , ЗамерСкоростиВыполнения.Начало);
	ЗамерСкоростиВыполнения.Вставить("Прочитано"  , 0);
	ЗамерСкоростиВыполнения.Вставить("Скорость"   , 0);
	ЗамерСкоростиВыполнения.Вставить("ТекСкорость", 0);
	
КонецПроцедуры // ИнициализироватьЗамерСкоростиВыполнения()

// Процедура - обновляет данные замера скорости выполнения
// 
// Параметры:
//  НомерСтроки     - Число     - номер последней прочитанной строки
//  ЧастотаЗамера   - Число     - через указанное количество прочитанных строк
//                                будет выполняться замер скорости чтения
//
Процедура ОбновитьЗамерСкоростиВыполнения(Знач НомерСтроки, Знач ЧастотаЗамера = 0)
	
	Если ЧастотаЗамераСкоростиВыполнения = 0 И ЧастотаЗамера = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЧастотаЗамера = ?(ЧастотаЗамера = 0, ЧастотаЗамераСкоростиВыполнения, ЧастотаЗамера);
	
	Если НомерСтроки % ЧастотаЗамера > 0 Тогда
		Возврат;
	КонецЕсли;

	Коэффициент = 1000;
	
	ТекНачало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Если ТекНачало - ЗамерСкоростиВыполнения.ТекНачало > 0 Тогда
		ЗамерСкоростиВыполнения.ТекСкорость = (НомерСтроки - ЗамерСкоростиВыполнения.Прочитано)
		                                    / (ТекНачало - ЗамерСкоростиВыполнения.ТекНачало)
		                                    * Коэффициент;
	КонецЕсли;
	Если ТекНачало - ЗамерСкоростиВыполнения.Начало > 0 Тогда
		ЗамерСкоростиВыполнения.Скорость  = НомерСтроки / (ТекНачало - ЗамерСкоростиВыполнения.Начало) * Коэффициент;
	КонецЕсли;
	ЗамерСкоростиВыполнения.Прочитано = НомерСтроки;
	ЗамерСкоростиВыполнения.ТекНачало = ТекНачало;

КонецПроцедуры // ОбновитьЗамерСкоростиВыполнения()

#КонецОбласти // ПроцедурыИФункцииЗамераСкоростиЧтения

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

	ЧастотаЗамераСкоростиВыполнения = 0;

	ИнициализироватьЗамерСкоростиВыполнения();
	
	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
