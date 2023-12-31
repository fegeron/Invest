////////////////////////////////////////////////////////////////////////////////
// РАБОТА С JSON 

Функция ПрочитатьJSONИзСтроки(Значение, ПрочитатьВСоответствие = Истина) Экспорт
	Результат = Неопределено;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Значение);	
	
	Попытка
		//чтение штатными средствами
		Результат = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);	
	Исключение	
		// сервисное сообщение для анализа ошибок
		ТекстСообщения = "Метод <ПрочитатьJSON(ЧтениеJSON)> вернул ошибку. Подробности: " + ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Метод <ПрочитатьJSON(ЧтениеJSON)> вернул ошибку. Подробности: " + ОписаниеОшибки());
		ОбщегоНазначенияСервер.ЗаписатьОшибкуВЖурналРегистрации("ПрочитатьJSON", ТекстСообщения);	
	КонецПопытки;
	
	ЧтениеJSON.Закрыть();

	Возврат Результат;
КонецФункции	

Функция ЗаписатьДанныеВJSON(Данные, ПараметрыЗаписиJSON = Неопределено, НастройкиСериализацииJSON = Неопределено) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные, НастройкиСериализацииJSON);	
	СтрокаJSON = ЗаписьJSON.Закрыть();	
	Возврат СтрокаJSON;
	
КонецФункции

Функция ПреобразованиеJSON(Знач Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт

	Если ТипЗнч(Значение) = Тип("Дата") Тогда
		Возврат НормализоватьДату(Значение);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		Возврат НормализоватьСтроку(Значение);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		Возврат НормализоватьЧисло(Значение);
		
	Иначе
		Возврат Значение;
	КонецЕсли; 

КонецФункции

Функция НормализоватьСтроку(Знач Значение) Экспорт

	Значение = СтрЗаменить(Значение,"""","");
	Возврат Значение;

КонецФункции

Функция НормализоватьЧисло(Значение) Экспорт

	НовоеЗначение = СтрЗаменить(Строка(Значение), ",", ".");
	НовоеЗначение = СтрЗаменить(НовоеЗначение, Символы.НПП, "");
	Возврат НовоеЗначение;

КонецФункции

Функция НормализоватьДату(Значение) Экспорт
	Возврат Формат(Значение,"ДФ=yyyy-MM-dd");		
КонецФункции

Функция НормализоватьДатуВремя(Значение) Экспорт
	Возврат Формат(Значение,"ДФ='yyyy-MM-dd HH:mm'");		
КонецФункции
