CREATE DATABASE hw_5;
USE hw_5;

CREATE TABLE Cars (
    id    INT  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NULL,
    cost  INT NULL
);

INSERT INTO Cars (name, cost) VALUES ('Audi', 52642);
INSERT INTO Cars (name, cost) VALUES ('Mercedes', 57127);
INSERT INTO Cars (name, cost) VALUES ('Skoda', 9000);
INSERT INTO Cars (name, cost) VALUES ('Volvo', 29000);
INSERT INTO Cars (name, cost) VALUES ('Bentley', 350000);
INSERT INTO Cars (name, cost) VALUES ('Citroen', 21000);
INSERT INTO Cars (name, cost) VALUES ('Hummer', 41400);
INSERT INTO Cars (name, cost) VALUES ('Volkswagen', 21600);

/* Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов  */

CREATE VIEW cars_1_1 AS
SELECT * FROM Cars
WHERE cost < 25000;

/* Изменить в существующем представлении порог для стоимости: пусть цена будет до 
30 000 долларов (используя оператор ALTER VIEW) */

ALTER VIEW cars_1_1 AS
SELECT * FROM Cars
WHERE cost < 30000;

/* Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” 
(аналогично) */

CREATE VIEW cars_1_3 AS
SELECT * FROM Cars
WHERE name = "Audi" OR name = "Skoda";

/* Вывести название и цену для всех анализов, которые продавались 5 февраля 
2020 и всю следующую неделю. Есть таблица анализов Analysis: an_id — ID анализа; 
an_name — название анализа; an_cost — себестоимость анализа; an_price — розничная цена
анализа; an_group — группа анализов. Есть таблица групп анализов Groups: gr_id — 
ID группы; gr_name — название группы; gr_temp — температурный режим хранения. 
Есть таблица заказов Orders: ord_id — ID заказа; ord_datetime — дата и время заказа; 
ord_an — ID анализа. */

SELECT an_name, an_price, ord_datetime
FROM Analysis
JOIN Orders
ON Analysis.an_id = Orders.ord_id
AND Orders.ord_datetime >= '2020-02-05'
AND Orders.ord_datetime <= '2020-02-12';

/* Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это
значение, мы вычитаем время станций для пар смежных станций. Мы можем вычислить это
значение без использования оконной функции SQL, но это может быть очень сложно. Проще
это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной
строки со следующей строкой, чтобы получить результат. В этом случае функция сравнивает
значения в столбце «время» для станции со станцией сразу после нее */

CREATE TABLE train (
  train_id INT NOT NULL,
  station VARCHAR(20) NOT NULL,
  station_time TIME NOT NULL
);

INSERT train 
    (train_id, station, station_time)
  VALUES 
    (110, 'San Francisco', '10:00:00'),
    (110, 'Redwood City', '10:54:00'),
    (110, 'Palo Alto', '11:02:00'),
    (110, 'San Jose', '12:35:00'),
    (120, 'San Francisco', '11:00:00'),
    (120, 'Palo Alto', '12:49:00'),
    (120, 'San Jose', '13:30:00');
    

SELECT
  train_id, station, station_time,
  TIMEDIFF(LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time), station_time) 
    AS time_to_next_station 
FROM train; 
	