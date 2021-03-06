﻿#Если Клиент Тогда
	
	Функция СоздатьПисьмоПолучателям(Шаблон, Получатели, ДанныеЗаполнения = Неопределено) Экспорт 
		ДанныеДляПисьма = А1Э_ОбщееСервер.РезультатФункции(ИмяМодуля() + ".ДанныеДляПисьма", Шаблон, ДанныеЗаполнения);
		ПараметрыОтправкиПисьма = РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправкиПисьма.Тема = ДанныеДляПисьма.Тема;
		ПараметрыОтправкиПисьма.Текст = ДанныеДляПисьма.Тело;
		Если ДанныеЗаполнения <> Неопределено Тогда
			Для Каждого Пара Из ДанныеЗаполнения Цикл
				ПараметрыОтправкиПисьма.Текст.НТМЛ = СтрЗаменить(ПараметрыОтправкиПисьма.Текст.НТМЛ, "{{" + Пара.Ключ + "}}", Пара.Значение);	
			КонецЦикла;
		КонецЕсли;
		ПараметрыОтправкиПисьма.Получатель = Получатели;
		РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправкиПисьма);
	КонецФункции 
	
#КонецЕсли

#Область Механизм

Функция НастройкиМеханизма() Экспорт
	Настройки = А1Э_Механизмы.НовыйНастройкиМеханизма();
	
	Настройки.Обработчики.Вставить("ФормаПриСозданииНаСервере", Истина);
	
	Возврат Настройки;
КонецФункции

#Если НЕ Клиент Тогда
	
	Функция ФормаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
		Если НЕ А1Э_Общее.РавноОдномуИз(А1Э_Формы.ТипФормы(Форма), "ФормаЭлемента", "ФормаСписка") Тогда Возврат Неопределено; КонецЕсли;
		
		КоманднаяПанель = А1Э_Формы.КоманднаяПанель(Форма);
		МассивОписаний = Новый Массив;
		А1Э_Формы.ДобавитьОписаниеВертикальнойГруппы(МассивОписаний, ИмяМодуля(), "E-mail", КоманднаяПанель);
		А1Э_Формы.ДобавитьОписаниеКомандыИКнопки2(МассивОписаний, ИмяМодуля() + "_Написать", ИмяМодуля() + ".Написать", "По шаблону", ИмяМодуля());
		А1Э_УниверсальнаяФорма.ДобавитьРеквизитыИЭлементы(Форма, МассивОписаний);
	КонецФункции 
	
	Функция ДанныеДляОтправки(ИсточникиАдресов, Шаблон) Экспорт
		Возврат А1Э_Структуры.Создать(
		"Получатели", А1Емэйл.Получатели(ИсточникиАдресов),
		"Тело", Шаблон.Тело.Получить(),
		"Тема", Шаблон.Тема)
	КонецФункции
	
	Функция ДанныеДляПисьма(Знач Шаблон, Знач ДанныеЗаполнения = Неопределено) Экспорт 
		Если ТипЗнч(Шаблон) = Тип("Строка") Тогда
			ШаблонСсылка = Справочники.А1Емэйл_Шаблоны.НайтиПоРеквизиту("Имя", Шаблон);
			Если НЕ ЗначениеЗаполнено(ШаблонСсылка) Тогда
				А1Э_Служебный.СлужебноеИсключение("Не найден шаблон по имени " + Шаблон);
			КонецЕсли;
		ИначеЕсли ТипЗнч(Шаблон) = Тип("СправочникСсылка.А1Емэйл_Шаблоны") Тогда
			ШаблонСсылка = Шаблон;
		Иначе
			А1Э_Служебный.ИсключениеНеверныйТип("Шаблон", ИмяМодуля() + ".ДанныеДляПисьма", Шаблон, "Строка,СправочникСсылка.А1Емэйл_Шаблоны");
		КонецЕсли;
		ДанныеЗаполнения = А1Э_Структуры.Соответствие(ДанныеЗаполнения);
		Тело = ШаблонСсылка.Тело.Получить();
		Для Каждого Пара Из ДанныеЗаполнения Цикл
			Тело.НТМЛ = СтрЗаменить(Тело.НТМЛ, "{{" + Пара.Ключ + "}}", Пара.Значение);
		КонецЦикла;
		
		Возврат А1Э_Структуры.Создать(
		"Тело", Тело,
		"Тема", ШаблонСсылка.Тема,
		)
	КонецФункции
	
#КонецЕсли
#Если Клиент Тогда
	
	Функция Написать(Форма, Команда) Экспорт 
		А1Э_Формы.ПоказатьВыбор(Форма, "Справочник.А1Емэйл_Шаблоны", ИмяМодуля() + ".ПослеВыбораШаблона", , А1Э_Структуры.Создать(
		"Форма", Форма,
		));
	КонецФункции
	
	Процедура ПослеВыбораШаблона(Шаблон, Контекст) Экспорт
		Если НЕ ЗначениеЗаполнено(Шаблон) Тогда Возврат; КонецЕсли;
		
		Форма = Контекст.Форма;
		ИсточникиАдресов = Новый Массив;
		Если А1Э_Формы.ТипФормы(Форма) = "ФормаЭлемента" Тогда
			ИсточникиАдресов.Добавить(Форма.Объект.Ссылка);
		Иначе
			Для Каждого Ссылка Из Форма.Элементы.Список.ВыделенныеСтроки Цикл
				ИсточникиАдресов.Добавить(Ссылка);
			КонецЦикла;
		КонецЕсли;
		Получатели = А1Емэйл.Получатели(ИсточникиАдресов);
		СоздатьПисьмоПолучателям(Шаблон, Получатели); 
	КонецПроцедуры 
	
#КонецЕсли

#КонецОбласти 

Функция ИмяМодуля() Экспорт
	Возврат "А1Емэйл_СообщенияПоШаблону";	
КонецФункции 
