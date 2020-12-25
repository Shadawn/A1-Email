﻿Функция НастройкиМеханизма() Экспорт
	Настройки = А1Э_Механизмы.НовыйНастройкиМеханизма();
	
	Настройки.Обработчики.Вставить("ФормаПриСозданииНаСервере", Истина);
	
	Возврат Настройки;
КонецФункции

#Если НЕ Клиент Тогда
	
	Функция ФормаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
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
	
#КонецЕсли
#Если Клиент Тогда
	
	Функция Написать(Форма, Команда) Экспорт 
		А1Э_Формы.ПоказатьВыбор(Форма, "Справочник.А1Емэйл_Шаблоны", ИмяМодуля() + ".ПослеВыбораШаблона", , А1Э_Структуры.Создать(
		"Форма", Форма,
		));
	КонецФункции
	
	Процедура ПослеВыбораШаблона(Результат, Контекст) Экспорт
		Если НЕ ЗначениеЗаполнено(Результат) Тогда Возврат; КонецЕсли;
		
		Форма = Контекст.Форма;
		ИсточникиАдресов = Новый Массив;
		Если А1Э_Формы.ТипФормы(Форма) = "ФормаЭлемента" Тогда
			ИсточникиАдресов.Добавить(Форма.Объект.Ссылка);
		Иначе
			Для Каждого Ссылка Из Форма.Элементы.Список.ВыделенныеСтроки Цикл
				ИсточникиАдресов.Добавить(Ссылка);
			КонецЦикла;
		КонецЕсли;
		ДанныеДляОтправки = А1Э_ОбщееСервер.РезультатФункции(ИмяМодуля() + ".ДанныеДляОтправки", ИсточникиАдресов, Результат);
		ПараметрыОтправкиПисьма = РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправкиПисьма.Тема = ДанныеДляОтправки.Тема;
		ПараметрыОтправкиПисьма.Текст = ДанныеДляОтправки.Тело;
		ПараметрыОтправкиПисьма.Получатель = ДанныеДляОтправки.Получатели;
		РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправкиПисьма);
	КонецПроцедуры 
	
#КонецЕсли

Функция ИмяМодуля() Экспорт
	Возврат "А1Емэйл_СообщенияПоШаблону";	
КонецФункции 
 