////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СТРОКАМИ

// Функция "расщепляет" строку на подстроки, используя заданный
//      разделитель. Разделитель может иметь любую длину.
//      Если в качестве разделителя задан пробел, рядом стоящие пробелы
//      считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр
//      игнорируются.
//      Например,
//      РазложитьСтрокуВМассивПодстрок(",один,,,два", ",") возвратит массив значений из пяти элементов,
//      три из которых - пустые строки, а
//      РазложитьСтрокуВМассивПодстрок(" один   два", " ") возвратит массив значений из двух элементов
//
//  Параметры:
//      Стр -           строка, которую необходимо разложить на подстроки.
//                      Параметр передается по значению.
//      Разделитель -   строка-разделитель, по умолчанию - запятая.
//
//  Возвращаемое значение:
//      массив значений, элементы которого - подстроки
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз - 1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				Если (СокрЛП(Стр) <> "") Тогда
					МассивСтрок.Добавить(Стр);
				КонецЕсли;
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз - 1));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

// Возвращает строку, полученную из массива элементов, разделенных символом разделителя
//
// Параметры:
//  Массив - Массив - массив элементов из которых необходимо получить строку
//  Разделитель - Строка - любой набор символов, который будет использован как разделитель между элементами в строке
//
// Возвращаемое значение:
//  Результат - Строка - строка, полученная из массива элементов, разделенных символом разделителя
// 
Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",") Экспорт
	
	// возвращаемое значение функции
	Результат = "";
	
	Для Каждого Элемент ИЗ Массив Цикл
		
		Подстрока = ?(ТипЗнч(Элемент) = Тип("Строка"), Элемент, Строка(Элемент));
		
		РазделительПодстрок = ?(ПустаяСтрока(Результат), "", Разделитель);
		
		Результат = Результат + РазделительПодстрок + Подстрока;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сравнить две строки версий.
//
// Параметры
//  СтрокаВерсии1  – Строка – номер версии в формате РР.{П|ПП}.ЗЗ.СС
//  СтрокаВерсии2  – Строка – второй сравниваемый номер версии
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0.0", СтрокаВерсии2);
	Версия1 = РазложитьСтрокуВМассивПодстрок(Строка1, ".");
	Если Версия1.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
		                    НСтр("ru = 'Неправильный формат строки версии: %1'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = РазложитьСтрокуВМассивПодстрок(Строка2, ".");
	Если Версия2.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
	                         НСтр("ru = 'Неправильный формат строки версии: %1'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	Для Разряд = 0 По 3 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра").
// Параметр<n>         - Строка - параметр
// Возвращаемое значение:
//   Строка - текстовая строка с подставленными параметрами
//
// Пример:
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк");
//
//@skip-check method-too-many-params
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1,	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	Если СтрокаПодстановки = Неопределено ИЛИ СтрДлина(СтрокаПодстановки) = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = "";
	НачПозиция = 1;
	Позиция = 1;
	Пока Позиция <= СтрДлина(СтрокаПодстановки) Цикл
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		Если СимволСтроки <> "%" Тогда
			Позиция = Позиция + 1;
			Продолжить;
		КонецЕсли;
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, Позиция - НачПозиция);
		Позиция = Позиция + 1;
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		
		Если СимволСтроки = "%" Тогда
			Позиция = Позиция + 1;
			НачПозиция = Позиция;
			Продолжить;
		КонецЕсли;
		
		Попытка
			НомерПараметра = Число(СимволСтроки);
		Исключение
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + СимволСтроки);
		КонецПопытки;
		
		Если СимволСтроки = "1" Тогда
			ЗначениеПараметра = Параметр1;
		ИначеЕсли СимволСтроки = "2" Тогда
			ЗначениеПараметра = Параметр2;
		ИначеЕсли СимволСтроки = "3" Тогда
			ЗначениеПараметра = Параметр3;
		ИначеЕсли СимволСтроки = "4" Тогда
			ЗначениеПараметра = Параметр4;
		ИначеЕсли СимволСтроки = "5" Тогда
			ЗначениеПараметра = Параметр5;
		ИначеЕсли СимволСтроки = "6" Тогда
			ЗначениеПараметра = Параметр6;
		ИначеЕсли СимволСтроки = "7" Тогда
			ЗначениеПараметра = Параметр7;
		ИначеЕсли СимволСтроки = "8" Тогда
			ЗначениеПараметра = Параметр8;
		ИначеЕсли СимволСтроки = "9" Тогда
			ЗначениеПараметра = Параметр9;
		Иначе
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + ЗначениеПараметра);
		КонецЕсли;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = "";
		Иначе
			ЗначениеПараметра = Строка(ЗначениеПараметра);
		КонецЕсли;
		Результат = Результат + ЗначениеПараметра;
		Позиция = Позиция + 1;
		НачПозиция = Позиция;
	
	КонецЦикла;
	
	Если (НачПозиция <= СтрДлина(СтрокаПодстановки)) Тогда
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, СтрДлина(СтрокаПодстановки) - НачПозиция + 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Подставляет параметры в строку. Неограниченное число параметров в строке.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%1").
//  МассивПараметров   - Массив - массив строк, которые соответствуют параметрам в строке подстановки
//
// Возвращаемое значение:
//   Строка  - текстовая строка с подставленными параметрами
//
// Пример:
// МассивПараметров = Новый Массив;
// МассивПараметров = МассивПараметров.Добавить("Вася");
// МассивПараметров = МассивПараметров.Добавить("Зоопарк");
//
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), МассивПараметров);
//
Функция ПодставитьПараметрыВСтрокуИзМассива(Знач СтрокаПодстановки, Знач МассивПараметров) Экспорт
	
	СтрокаРезультата = СтрокаПодстановки;
	
	Для Индекс = 1 По МассивПараметров.Количество() Цикл
		Если Не ПустаяСтрока(МассивПараметров[Индекс-1]) Тогда
			СтрокаРезультата = СтрЗаменить(СтрокаРезультата, "%"+Строка(Индекс), МассивПараметров[Индекс-1]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультата;
	
КонецФункции

// Функция определяет есть ли в строке английские символы
// Параметры:
// 	ИсходнаяСтрока - Исходная строка
// Возвращаемое значение: Булево
Функция ТолькоАнглийскиеСимволыВСтроке(СтрокаПроверки) Экспорт
	//++OW Копачев А.С. 19.03.2019 ONEC-4402
	Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Если НЕ (
				(КодСимвола>=65 И КодСимвола<=90) //A-Z
				ИЛИ (КодСимвола>=97 И КодСимвола<=122) //a-z
				 ) Тогда
				 
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	//--OW Копачев А.С. 19.03.2019 ONEC-4402	
КонецФункции

// Проверяет содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки - строка для проверки.
//  УчитыватьЛидирующиеНули - Булево - нужно ли учитывать лидирующие нули.
//  УчитыватьПробелы - Булево - нужно ли учитывать пробелы.
//
// Возвращаемое значение:
//  Истина       - строка содержит только цифры;
//  Ложь         - строка содержит не только цифры.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина) Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
	
	Если НЕ УчитыватьЛидирующиеНули Тогда
		НомерПервойЦифры = 0;
		Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
			НомерПервойЦифры = НомерПервойЦифры + 1;
			КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
			Если КодСимвола <> 48 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, НомерПервойЦифры);
	КонецЕсли;
	
	Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Если НЕ (КодСимвола >= 48 И КодСимвола <= 57) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // ТолькоЦифрыВСтроке()

// Удаляет двойные кавычки с начала и конца строки, если они есть.
//
// Параметры:
//  Строка       - входная строка;
//
// Возвращаемое значение:
//  Строка - строка без двойных кавычек.
// 
Функция СократитьДвойныеКавычки(Знач Строка) Экспорт
	
	Результат = Строка;
	Пока Найти(Результат, """") = 1 Цикл
		Результат = Сред(Результат, 2); 
	КонецЦикла; 
	Пока Найти(Результат, """") = СтрДлина(Результат) Цикл
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 1); 
	КонецЦикла; 
	Возврат Результат;
	
КонецФункции 

// Процедура удаляет из строки указанное количество символов справа
//
Процедура УдалитьПоследнийСимволВСтроке(Текст, ЧислоСимволов) Экспорт
	
	Текст = Лев(Текст, СтрДлина(Текст) - ЧислоСимволов);
	
КонецПроцедуры 

// Находит символ в строке с конца
//
Функция НайтиСимволСКонца(Знач СтрокаВся, Знач ОдинСимвол) Экспорт
	
	ДлинаСтроки = СтрДлина(СтрокаВся);
	
	Для ТекущаяПозиция = 1 По СтрДлина(СтрокаВся) Цикл
		РеальнаяПозиция = ДлинаСтроки - ТекущаяПозиция + 1;
		ТекущийСимвол = Сред(СтрокаВся, РеальнаяПозиция, 1);
		Если ТекущийСимвол = ОдинСимвол Тогда
			Возврат РеальнаяПозиция;
		КонецЕсли;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции

// Функция проверяет, является ли переданная в неё строка уникальным идентификатором
//
Функция ЭтоУникальныйИдентификатор(ИдентификаторСтрока) Экспорт
	
	УИСтрока = ИдентификаторСтрока;
	Шаблон = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
	
	Если СтрДлина(Шаблон) <> СтрДлина(УИСтрока) Тогда
		Возврат Ложь;
	КонецЕсли;
	Для Сч = 1 По СтрДлина(УИСтрока) Цикл
		Если КодСимвола(Шаблон, сч) = 88 И 
			((КодСимвола(УИСтрока, сч) < 48 ИЛИ КодСимвола(УИСтрока, сч) > 57) И (КодСимвола(УИСтрока, сч) < 97 или КодСимвола(УИСтрока, сч) > 102)) Тогда
			Возврат ложь; 
		 ИначеЕсли КодСимвола(Шаблон, сч) = 45 И КодСимвола(УИСтрока, сч) <> 45 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;

КонецФункции

// Формирует строку повторяющихся символов заданной длины
//
Функция СформироватьСтрокуСимволов(Символ, КоличествоСимволов) Экспорт
	
	// возвращаемое значение функции
	Результат = "";
	
	Для Индекс = 1 ПО КоличествоСимволов Цикл
		
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Дополняет переданную в качестве первого параметра строку символами слева\справа до заданной длины и возвращает ее
// Незначащие символы слева и справа удаляются
// По умолчанию функция добавляет строку нулями слева
//
// Параметры:
//  Строка      - Строка - исходная строка, которую необходимо дополнить символами до заданной длины
//  ДлинаСтроки - Число - требуемая конечная длина строки
//  Символ      - Строка - (необязательный) значение символа, которым необходимо дополнить строку
//  Режим       - Строка - (необязательный) [Слева|Справа] режим добавления символов к исходной строке: слева или справа
// 
// Пример 1:
// Строка = "1234"; ДлинаСтроки = 10; Символ = "0"; Режим = "Слева"
// Возврат: "0000001234"
//
// Пример 2:
// Строка = " 1234  "; ДлинаСтроки = 10; Символ = "#"; Режим = "Справа"
// Возврат: "1234######"
//
// Возвращаемое значение:
//  Строка - строка, дополненная символами слева или справа
//
Функция ДополнитьСтроку(Знач Строка, Знач ДлинаСтроки, Знач Символ = "0", Знач Режим = "Слева") Экспорт
	
	Если ПустаяСтрока(Символ) Тогда
		Символ = "0";
	КонецЕсли;
	
	// длина символа не должна превышать единицы
	Символ = Лев(Символ, 1);
	
	// удаляем крайние пробелы слева и справа строки
	Строка = СокрЛП(Строка);
	
	КоличествоСимволовНадоДобавить = ДлинаСтроки - СтрДлина(Строка);
	
	Если КоличествоСимволовНадоДобавить > 0 Тогда
		
		СтрокаДляДобавления = СформироватьСтрокуСимволов(Символ, КоличествоСимволовНадоДобавить);
		
		Если ВРег(Режим) = "СЛЕВА" Тогда
			
			Строка = СтрокаДляДобавления + Строка;
			
		ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
			
			Строка = Строка + СтрокаДляДобавления;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

// ДобавитьСтроку
//	Функция конкатенирует строки, разделяя их разделителем
// Параметры:
//	ИсходнаяСтрока - Строка, исходная строка
//	ДополнительнаяСтрока - Строка, добавляемая строка
//	Разделитель - Строка, любой набор символов - разделитель между подстроками
// Возвращаемое значение:
//	Строка
Функция ДобавитьСтроку(Знач ИсходнаяСтрока, Знач ДополнительнаяСтрока, Знач Разделитель = ";") Экспорт
	//++OW Копачев А.С. 15.03.2019 ONEC-4364
	
	ВыходнаяСтрока = Строка(ИсходнаяСтрока);
	Если НЕ ПустаяСтрока(ДополнительнаяСтрока) Тогда
		
		ВыходнаяСтрока = ВыходнаяСтрока + ?(НЕ ПустаяСтрока(ВыходнаяСтрока), Разделитель, "");
		ВыходнаяСтрока = ВыходнаяСтрока + Строка(ДополнительнаяСтрока);
		
	КонецЕсли;//НЕ ПустаяСтрока(ДополнительнаяСтрока)
	
	Возврат ВыходнаяСтрока;
	
	//--OW Копачев А.С. 15.03.2019 ONEC-4364
КонецФункции 

// Удаляет повторяющиеся символы слева/справа в переданной строке
//
// Параметры:
//  Строка      - Строка - исходная строка, из которой необходимо удалить повторяющиеся символы
//  Символ      - Строка - значение символа, который необходимо удалить
//  Режим       - Строка - (необязательный) [Слева|Справа] режим добавления символов к исходной строке: слева или справа
//
Функция УдалитьПовторяющиесяСимволы(Знач Строка, Знач Символ, Знач Режим = "Слева") Экспорт
	
	Если ВРег(Режим) = "СЛЕВА" Тогда
		
		Пока Лев(Строка, 1)= Символ Цикл
			
			Строка = Сред(Строка, 2);
			
		КонецЦикла;
		
	ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
		
		Пока Прав(Строка, 1)= Символ Цикл
			
			Строка = Лев(Строка, СтрДлина(Строка) - 1);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Строка;
КонецФункции

// Получает номер версии конфигурации без номера сборки
//
// Параметры:
//  Версия - Строка - версия конфигурации в формате РР.ПП.ЗЗ.СС,
//                    где СС - номер сборки, который будет удален
// 
//  Возвращаемое значение:
//  Строка - номер версии конфигурации без номера сборки в формате РР.ПП.ЗЗ
//
Функция ВерсияКонфигурацииБезНомераСборки(Знач Версия) Экспорт
	
	Массив = РазложитьСтрокуВМассивПодстрок(Версия, ".");
	
	Если Массив.Количество() < 3 Тогда
		Возврат Версия;
	КонецЕсли;
	
	Результат = "[Редакция].[Подредакция].[Релиз]";
	Результат = СтрЗаменить(Результат, "[Редакция]",    Массив[0]);
	Результат = СтрЗаменить(Результат, "[Подредакция]", Массив[1]);
	Результат = СтрЗаменить(Результат, "[Релиз]",       Массив[2]);
	
	Возврат Результат;
КонецФункции

//Выполняет в строке ГДЕ замену символов ЧТО на соответствующие по номерам символы из строки НаЧто
//
// Параметры:
//  Что		- Строка - строка символов, каждый из которых будет заменен
//  Где		- Строка - исходная строка, в которой будет выполняться замена
//  НаЧто	- Строка - строка символов, на каждый из которых нужно заменить исходные символы
// 
//  Возвращаемое значение:
//  Строка - строка с замененными символами
//
Функция ЗаменитьОдниСимволыДругими(Что, Где, НаЧто) Экспорт
	
	Рез = Где;
	
	Для Сч = 1 По СтрДлина(Что) Цикл
		Рез = СтрЗаменить(Рез, Сред(Что, Сч, 1), Сред(НаЧто, Сч, 1));
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

// Выполняет преобразование русских символов в английские
//
// Параметры:
//		РусскиеСимволы			- строка
//
// Возвращаемое значение
//		Строка
//
// Описание
//		записывает русские символы в английские,
//		например:
//				ПреобразоватьЧислоВРимскуюНотацию("Ваня") = "Vanya"
//
Функция ПреобразоватьРусскиеСимволыВАнглийские(РусскиеСимволы) Экспорт
	//++OW Копачев А.С. 03.03.2023 ONEC-8418 
	СоответствиеRuEn = Новый Структура;
	
	СоответствиеRuEn.Вставить("а","a");  СоответствиеRuEn.Вставить("б","b");  СоответствиеRuEn.Вставить("в","v");   СоответствиеRuEn.Вставить("г","g");
	СоответствиеRuEn.Вставить("д","d");  СоответствиеRuEn.Вставить("е","e");  СоответствиеRuEn.Вставить("ё","yo");  СоответствиеRuEn.Вставить("ж","zh");
	СоответствиеRuEn.Вставить("з","z");  СоответствиеRuEn.Вставить("и","i");  СоответствиеRuEn.Вставить("й","y");   СоответствиеRuEn.Вставить("к","k");
	СоответствиеRuEn.Вставить("л","l");  СоответствиеRuEn.Вставить("м","m");  СоответствиеRuEn.Вставить("н","n");   СоответствиеRuEn.Вставить("о","o");
	СоответствиеRuEn.Вставить("п","p");  СоответствиеRuEn.Вставить("р","r");  СоответствиеRuEn.Вставить("с","s");   СоответствиеRuEn.Вставить("т","t");
	СоответствиеRuEn.Вставить("у","u");  СоответствиеRuEn.Вставить("ф","f");  СоответствиеRuEn.Вставить("х","kh");  СоответствиеRuEn.Вставить("ц","ts");
	СоответствиеRuEn.Вставить("ч","ch"); СоответствиеRuEn.Вставить("ш","sh"); СоответствиеRuEn.Вставить("щ","shch");СоответствиеRuEn.Вставить("ь","");
	СоответствиеRuEn.Вставить("ы","y");  СоответствиеRuEn.Вставить("ъ","");   СоответствиеRuEn.Вставить("э","e");   СоответствиеRuEn.Вставить("ю","yu");
	СоответствиеRuEn.Вставить("я","ya"); 
			
	ДлиннаИсх = СтрДлина(РусскиеСимволы);
	
    Результат = "";	
    Для а=1 По ДлиннаИсх Цикл 
        ТекущийСимвол = Сред(РусскиеСимволы,а,1);        
		КодСимвола = КодСимвола(ТекущийСимвол);
		
		Если КодСимвола>=1040 и КодСимвола<=1105 Тогда //(русские буквы)
			
			ЗначениеEn = Неопределено;
			// поиск идет без учета регистра
			СоответствиеRuEn.Свойство(ТекущийСимвол, ЗначениеEn);
			Если ЗначениеEn <> Неопределено Тогда 
				
				// приведем к регистру исходного символа
				Если ТекущийСимвол = ВРег(ТекущийСимвол) Тогда 
					ЗначениеEn = ?(СтрДлина(ЗначениеEn) > 1, ВРег(Лев(ЗначениеEn,1)) + Сред(ЗначениеEn, 2), ВРег(ЗначениеEn));
				КонецЕсли;
				
				ТекущийСимвол = ЗначениеEn;
			КонецЕсли;
		КонецЕсли;
		
		Результат = Результат + ТекущийСимвол;		
	КонецЦикла;
	
	Возврат Результат;
	//--OW Копачев А.С. 03.03.2023 ONEC-8418	
КонецФункции

// Выполняет преобразование арабского числа в римское
//
// Параметры:
//		АрабскоеЧисло			- число, целое, от 0 до 999
//		ИспользоватьКириллицу	- булево, использовать в качестве арабских цифр кириллицу или латиницу
//
// Возвращаемое значение
//		Строка
//
// Описание
//		записывает "обычное" число римскими цифрами,
//		например:
//				ПреобразоватьЧислоВРимскуюНотацию(17) = "ХVII"
//
Функция ПреобразоватьЧислоВРимскуюНотацию(АрабскоеЧисло, ИспользоватьКириллицу = Истина) Экспорт
	
	РимскоеЧисло	= "";
	АрабскоеЧисло	= ДополнитьСтроку(АрабскоеЧисло, 3);
	
	Если ИспользоватьКириллицу Тогда
		c1 = "1"; c5 = "У"; c10 = "Х"; c50 = "Л"; c100 ="С"; c500 = "Д"; c1000 = "М";
		
	Иначе
		c1 = "I"; c5 = "V"; c10 = "X"; c50 = "L"; c100 ="C"; c500 = "D"; c1000 = "M";
		
	КонецЕсли;
	
	Единицы	= Число(Сред(АрабскоеЧисло, 3, 1));
	Десятки	= Число(Сред(АрабскоеЧисло, 2, 1));
	Сотни	= Число(Сред(АрабскоеЧисло, 1, 1));
	
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Сотни,   c100, c500, c1000);
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Десятки, c10,  c50,  c100);
	РимскоеЧисло = РимскоеЧисло + ПреобразоватьЦифруВРимскуюНотацию(Единицы, c1,   c5,   c10);
	
	Возврат РимскоеЧисло;
	
КонецФункции //ПреобразоватьЧислоВРимскуюНотацию

// Выполняет преобразование римского числа в арабское
//
// Параметры:
//		РимскоеЧисло			- строка, число, записанное римскими цифрами
//		ИспользоватьКириллицу	- булево, использовать в качестве арабских цифр кириллицу или латиницу
//
// Возвращаемое значение
//		Число
//
// Описание
//		преобразует число, записанное римскими цифрами, в "обычное" число,
//		например:
//				ПреобразоватьЧислоВАрабскуюНотацию("ХVII") = 17
//
Функция ПреобразоватьЧислоВАрабскуюНотацию(РимскоеЧисло, ИспользоватьКириллицу = Истина) Экспорт
	
	АрабскоеЧисло=0;
	
	Если ИспользоватьКириллицу Тогда
		c1 = "1"; c5 = "У"; c10 = "Х"; c50 = "Л"; c100 ="С"; c500 = "Д"; c1000 = "М";
		
	Иначе
		c1 = "I"; c5 = "V"; c10 = "X"; c50 = "L"; c100 ="C"; c500 = "D"; c1000 = "M";
		
	КонецЕсли;
	
	РимскоеЧисло = СокрЛП(РимскоеЧисло);
	ЧислоСимволов = СтрДлина(РимскоеЧисло);
	
	Для Сч=1 По ЧислоСимволов Цикл
		Если Сред(РимскоеЧисло,Сч,1) = c1000 Тогда
			АрабскоеЧисло = АрабскоеЧисло+1000;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c500 Тогда
			АрабскоеЧисло = АрабскоеЧисло+500;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c100 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c500) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c1000)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-100;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+100;
			КонецЕсли;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c50 Тогда
			АрабскоеЧисло = АрабскоеЧисло+50;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c10 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c50) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c100)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-10;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+10;
			КонецЕсли;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c5 Тогда
			АрабскоеЧисло = АрабскоеЧисло+5;
		ИначеЕсли Сред(РимскоеЧисло,Сч,1) = c1 Тогда
			Если (Сч < ЧислоСимволов) И ((Сред(РимскоеЧисло,Сч+1,1) = c5) ИЛИ (Сред(РимскоеЧисло,Сч+1,1) = c10)) Тогда
				АрабскоеЧисло = АрабскоеЧисло-1;
			Иначе
				АрабскоеЧисло = АрабскоеЧисло+1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат АрабскоеЧисло;
	
КонецФункции //ПреобразоватьЧислоВАрабскуюНотацию

// Выполняет преобразование цифры в римскую нотацию 
//
// Параметры:
//		Цифра - число, целое, от 0 до 9
//      РимскаяЕдиница,РимскаяПятерка,РимскаяДесятка - строки, соответствующие римские цифры
//
// Возвращаемое значение
//		Строка
//
// Описание
//		записывает "обычную" цифру римскими цифрами,
//		например:
//				ПреобразоватьЦифруВРимскуюНотацию(7,"I","V","X") = "VII"
//
Функция ПреобразоватьЦифруВРимскуюНотацию(Цифра,РимскаяЕдиница,РимскаяПятерка,РимскаяДесятка)
	
	РимскаяЦифра="";
	Если Цифра = 1 Тогда
		РимскаяЦифра = РимскаяЕдиница
	ИначеЕсли Цифра = 2 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 3 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 4 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяПятерка;
	ИначеЕсли Цифра = 5 Тогда
		РимскаяЦифра = РимскаяПятерка;
	ИначеЕсли Цифра = 6 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница;
	ИначеЕсли Цифра = 7 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 8 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 9 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяДесятка;
	КонецЕсли;
	Возврат РимскаяЦифра;
	
КонецФункции //ПреобразоватьЦифруВРимскуюНотацию

//преобразовать список значений в строку с разделителем
Функция СписокЗначенийВСтроку(Список, Разделитель = ";", ПробелПослеРазделителя = Ложь) Экспорт

	Если Список = Неопределено Тогда
		Возврат "";
	КонецЕсли; 
	Если Список.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	Стр = "";
	Для каждого эл Из Список Цикл
		Стр = Стр + ?(ПустаяСтрока(Стр), "", Разделитель) +  СокрЛП(Строка(эл.Значение)) + ?(ПробелПослеРазделителя," ","");	
	КонецЦикла; 
	Возврат Стр;
	
КонецФункции


//преобразовать строку в число 
Функция ПреобразоватьСтрокуВЧисло(СтрокаЧисло) Экспорт
	
	СтрокаЧисло = СтрЗаменить(СтрокаЧисло, " ", "");
	СтрокаЧисло = СтрЗаменить(СтрокаЧисло, Символы.НПП, "");
	СтрокаЧисло = СтрЗаменить(СтрокаЧисло, Символы.Таб, "");
	СтрокаЧисло = СтрЗаменить(СтрокаЧисло, " ", "");  
	
	Попытка
		ПреобразованноеЧисло = Число(СтрокаЧисло);
	Исключение
	    ПреобразованноеЧисло = Неопределено;
	КонецПопытки;
	
	Возврат ПреобразованноеЧисло;
		
КонецФункции


