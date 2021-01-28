﻿Функция НастройкиМеханизма() Экспорт
	Настройки = А1Э_Механизмы.НовыйНастройкиМеханизма();
	
	Настройки.Обработчики.Вставить("ФормаЭлементаПриСозданииНаСервере", Истина);
	Настройки.Обработчики.Вставить("ОбработкаЗаполнения", Истина);
	Настройки.Обработчики.Вставить("ФормаПередЗаписьюНаСервере", Истина);
	
	Возврат Настройки;
КонецФункции

#Если НЕ Клиент Тогда
	
	Функция ФормаЭлементаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
		МассивОписаний = Новый Массив;
		А1Э_Формы.ДобавитьОписаниеПоляОбъекта(МассивОписаний, "Наименование");
		А1Э_Формы.ДобавитьОписаниеПоляОбъекта(МассивОписаний, "Тема");
		А1Э_Формы.ДобавитьОписаниеПоляОбъекта(МассивОписаний, "Имя");
		//Из-за корявого кода 1С это пришлось сделать на форме (панель команд форматированного документа).
		//А1Емэйл_А1Импорт.А1БК_СохраняемоеПолеФорматированногоДокумента().ДобавитьОписание(МассивОписаний, "Шаблон");
		А1Э_Формы.ДобавитьОписаниеГруппыСтраниц(МассивОписаний, "Страницы");
		А1Э_Формы.ДобавитьОписаниеСтраницы(МассивОписаний, "СтраницаРедактирование", "Редактирование", "Страницы");
		А1Э_Формы.ДобавитьОписаниеСтраницы(МассивОписаний, "СтраницаНТМЛ", "HTML", "Страницы");
		А1Э_Формы.ДобавитьОписаниеГоризонтальнойГруппы(МассивОписаний, "ГруппаКнопкиНТМЛ", , "СтраницаНТМЛ");
		А1Э_Формы.ДобавитьОписаниеКомандыИКнопки2(МассивОписаний, "Установить", ИмяМодуля() + ".УстановитьНТМЛ:НаСервере", , "ГруппаКнопкиНТМЛ");
		А1Э_Формы.ДобавитьОписаниеРеквизитаИЭлемента(МассивОписаний, "НТМЛ", "Строка", , , "СтраницаНТМЛ", , А1Э_Структуры.Создать(
		"Вид", ВидПоляФормы.ПолеТекстовогоДокумента,
		));
		А1Емэйл_А1Импорт.А1БК_ПолеВыбораНесколькихТаблицаОбъекта().ДобавитьОписание(МассивОписаний, "Ответственный", Форма);
		А1Э_УниверсальнаяФорма.ДобавитьРеквизитыИЭлементы(Форма, МассивОписаний);
		
		Форма.Элементы.Переместить(Форма.Элементы.ТелоКоманднаяПанель, Форма.Элементы.СтраницаРедактирование);
		Форма.Элементы.Переместить(Форма.Элементы.Тело, Форма.Элементы.СтраницаРедактирование);
		А1Э_УниверсальнаяФорма.ДобавитьОбработчикЭлементаФормы(Форма, Форма.Элементы.Тело, "ПриИзменении", ИмяМодуля() + ".ПолучитьНТМЛ"); 
		
		А1Э_ФорматированныйДокумент.УстановитьНТМЛ(Форма.Тело, А1Э_ФорматированныйДокумент.СсылкаНаИсточник(Форма).Тело.Получить());
		ПолучитьНТМЛ(Форма);
	КонецФункции
	
	Функция ОбработкаЗаполнения(Объект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
		Строка = Объект.Ответственный.Добавить();
		Строка.Значение = Пользователи.ТекущийПользователь();
	КонецФункции
	
	Функция ФормаПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		
		ТекущийОбъект.Тело = Новый ХранилищеЗначения(А1Э_ФорматированныйДокумент.СтруктураНТМЛ(Форма.Тело));
	КонецФункции 
	
#КонецЕсли

Функция ПолучитьНТМЛ(Форма, Команда = Неопределено) Экспорт   
	Форма.НТМЛ = А1Э_ФорматированныйДокумент.СтруктураНТМЛ(Форма.Тело).НТМЛ;
КонецФункции

Функция УстановитьНТМЛ(Форма, Команда = Неопределено) Экспорт 
	СтруктураНТМЛ = А1Э_ФорматированныйДокумент.СтруктураНТМЛ(Форма.Тело);
	СтруктураНТМЛ.НТМЛ = Форма.НТМЛ;
	А1Э_ФорматированныйДокумент.УстановитьНТМЛ(Форма.Тело, СтруктураНТМЛ);
КонецФункции 

Функция ИмяМодуля() Экспорт
	Возврат "А1Емэйл_Шаблоны";
КонецФункции 
