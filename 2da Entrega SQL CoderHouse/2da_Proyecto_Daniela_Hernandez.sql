DROP DATABASE IF EXISTS aeromexico;

CREATE DATABASE aeromexico;

USE aeromexico;

CREATE TABLE CLIENTE(
	IDCLIENTE INT PRIMARY KEY AUTO_INCREMENT,
    IDPASAJERO INT,
    IDTICKET INT,
    IDVUELO INT,
    IDEMPLEADO INT,
    IDCARRY INT,
	NOMBRE			VARCHAR(100),
    APELLIDO		VARCHAR(100),
    CORREO			VARCHAR(100),
    TELEFONO 		VARCHAR(100),
    FECHA DATETIME DEFAULT (CURRENT_TIMESTAMP)
);
CREATE TABLE PASAJERO(
	IDPASAJERO		INT PRIMARY KEY AUTO_INCREMENT,
    NOMBRE			VARCHAR(100),
    APELLIDO		VARCHAR(100),
    CORREO			VARCHAR(100),
    TELEFONO 		VARCHAR(100),
    TIPO_CLIENTE 	VARCHAR(100)
);
CREATE TABLE VUELO(
	IDVUELO				INT PRIMARY KEY AUTO_INCREMENT,
    IDTICKET			int,
    DESTINO				VARCHAR(100),
    NUMERO_VUELO		VARCHAR(100)
);
CREATE TABLE TICKET(
	IDTICKET		INT PRIMARY KEY AUTO_INCREMENT,
    COSTO			DECIMAL(50,2),
    ASIENTO			VARCHAR(100),
    PUERTA_ABORDAJE	VARCHAR(100)

);
CREATE TABLE EMPLEADO(
	IDEMPLEADO	 	INT PRIMARY KEY AUTO_INCREMENT,
    IDPASAJERO		INT,
    NOMBRE			VARCHAR(100),
    DIRECCION 		VARCHAR(100),
    TELEFONO 		VARCHAR(100)
);
CREATE TABLE CARRY(
	IDCARRY 		INT PRIMARY KEY AUTO_INCREMENT,
    TIPO_MALETA		boolean,
    DOCUMENTADA		boolean
);

-- FK
-- VUELO

ALTER TABLE VUELO
	ADD CONSTRAINT FK_VUELO_TICKET
    FOREIGN KEY (IDTICKET) REFERENCES TICKET(IDTICKET)
;

-- EMPLEADO

ALTER TABLE EMPLEADO
	ADD CONSTRAINT FK_EMPLEADO_PASAJERO
    FOREIGN KEY (IDPASAJERO) REFERENCES PASAJERO(IDPASAJERO)
;

-- CLIENTE

ALTER TABLE CLIENTE
	ADD CONSTRAINT FK_CLIENTE_PASAJERO
    FOREIGN KEY (IDPASAJERO) REFERENCES PASAJERO(IDPASAJERO)
;

ALTER TABLE CLIENTE
	ADD CONSTRAINT FK_CLIENTE_TICKET
    FOREIGN KEY (IDTICKET) REFERENCES TICKET(IDTICKET)
;

ALTER TABLE CLIENTE
	ADD CONSTRAINT FK_CLIENTE_VUELO
    FOREIGN KEY (IDVUELO) REFERENCES VUELO(IDVUELO)
;

ALTER TABLE CLIENTE
	ADD CONSTRAINT FK_CLIENTE_EMPLEADO
    FOREIGN KEY (IDEMPLEADO) REFERENCES EMPLEADO(IDEMPLEADO)
;

ALTER TABLE CLIENTE
	ADD CONSTRAINT FK_CLIENTE_CARRY
    FOREIGN KEY (IDCARRY) REFERENCES CARRY(IDCARRY)
;



 -- Se insertan los datos a la tabla


 INSERT INTO PASAJERO
 (NOMBRE, APELLIDO, CORREO, TELEFONO, TIPO_CLIENTE)
 VALUES
('Daniela','Hernandez','daniela@gmail.com','5591966557','Aeromexico Rewards'),
('Alejandro','Sosa','alejandro@gmail.com','5527720655','Aeromexico AMEX'),
('Jesus','Lopez','jesus@gmail.com','5514253658','Aeromexico Santander'),
('Bruno','Rufino','bruno@gmail.com','5518598463','Aeromexico Santander'),
('Karla','Soto','karla@gmail.com','5512785941','Aeromexico Rewards');

select * from PASAJERO;

 INSERT INTO TICKET
 (COSTO, ASIENTO, PUERTA_ABORDAJE)
 VALUES
(5000,'AS001','14'),
(4000,'AS002','12'),
(1500,'AS003','23'),
(1000,'AS004','21'),
(2500,'AS005','11');

select * from TICKET;

 INSERT INTO VUELO
 (IDTICKET,DESTINO, NUMERO_VUELO)
 VALUES
(1,'Toronto','VU001'),
(2,'Cancun','VU002'),
(3,'Bogota','VU003'),
(4,'Monterrey','VU004'),
(5,'Gudalajara','VU005');

select * from VUELO;


  INSERT INTO EMPLEADO
 (IDPASAJERO,NOMBRE, DIRECCION, TELEFONO)
 VALUES
(1,'Daniela','ciudad de mexico','5591966557'),
(2,'Alejandro','playa del carmen','5527720655'),
(3,'Jesus','xalapa','5514253658'),
(4,'Bruno','merida','5518598463'),
(5,'Karla','cancun','5512785941');
 
 select * from EMPLEADO;
 
  INSERT INTO CARRY
(TIPO_MALETA, DOCUMENTADA)
 VALUES
 (true,true),
(false,true),
(false,false),
(true,true),
(true,false);

select * from CARRY;

 
 INSERT INTO CLIENTE
 (IDPASAJERO, IDTICKET, IDVUELO, IDEMPLEADO, IDCARRY,NOMBRE, APELLIDO, CORREO, TELEFONO)
 VALUES
(1,1,1,1,1,'Daniela','Hernandez','daniela@gmail.com','5591966557'),
(2,2,2,2,2,'Alejandro','Sosa','alejandro@gmail.com','5527720655'),
(3,3,3,3,3,'Jesus','Lopez','jesus@gmail.com','5514253658'),
(4,4,4,4,4,'Bruno','Rufino','bruno@gmail.com','5518598463'),
(5,5,5,5,5,'Karla','Soto','karla@gmail.com','5512785941');

select * from cliente;

-- TRIGGERS --

use aeromexico;

-- TRIGGER para guardar los datos si el cliente cancela su vuelo

CREATE TABLE 
    tabla_cambios (
        id_cambio          INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    ,   tabla_afectada  VARCHAR (50)
    ,   accion          VARCHAR(50)
    ,   fecha           DATETIME
    ,   idcliente       INT
    ,   usuario         VARCHAR(50)
    );

DELIMITER //

CREATE TRIGGER after_insert_trigger
AFTER INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    INSERT INTO tabla_cambios  (tabla_afectada, accion, fecha,idcliente,usuario)
    VALUES ('CLIENTE', 'INSERT', NOW() , NEW.IDCLIENTE);
END //

DELIMITER ;

-- Trigger para verificar que el  correo de un cliente no sean repetidos

DELIMITER //

CREATE TRIGGER before_insert_cliente_trigger
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE correo_count INT;

    SELECT COUNT(*) INTO correo_count
        FROM CLIENTE
    WHERE CORREO = NEW.CORREO;
    
    IF correo_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo electrónico ya está en uso.';
    END IF;

END //

DELIMITER ;

-- Trigger para verificar que el numero de telefono de un cliente no sean repetidos

DELIMITER //

CREATE TRIGGER before_insert_cliente_trigger_telefono
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE tel_count INT;

    SELECT COUNT(*) INTO tel_count
        FROM CLIENTE
        
        
    WHERE TELEFONO = NEW.TELEFONO;
    
    IF tel_count > 0 THEN
        SIGNAL SQLSTATE '46000' SET MESSAGE_TEXT = 'El telefono ya está en uso.';
    END IF;

END //

DELIMITER ;
select * from before_insert_cliente_trigger_telefono;
-- FUNCIONES --

use aeromexico;

-- Funcion para saber si un ticket fue cancelado por el usuario

DELIMITER //

CREATE FUNCTION ticket_cancel(ticket_cancelado INT) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cancelacion_date DATETIME;
    DECLARE is_cancelada BOOLEAN;
    
    SELECT CANCELACION INTO cancelacion_date
        FROM TICKET
        WHERE IDTICKET = ticket_cancelado
        AND CANCELACION IS NOT NULL
        LIMIT 1;
    
    IF ticket_cancel IS NOT NULL THEN
        SET is_cancelada = TRUE;
    ELSE
        SET is_cancelada = FALSE;
    END IF;

    RETURN is_cancelada;
END //

DELIMITER ;

-- funcion para saber si un empleado vendio un ticket

DELIMITER //

CREATE FUNCTION ticket_vendido(ticket_sell INT) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE ticket_date DATETIME;
    DECLARE is_sell BOOLEAN;
    
    SELECT VENDIDO INTO ticket_date
        FROM TICKET
        WHERE IDTICKET = ticket_sell
        AND VENDIDO IS NOT NULL
        LIMIT 1;
    
    IF ticket_date IS NOT NULL THEN
        SET is_sell = TRUE;
    ELSE
        SET is_sell = FALSE;
    END IF;

    RETURN is_sell;
END //

DELIMITER ;

-- funcion para saber cuantos tickets vendio un empleado

DELIMITER //

CREATE FUNCTION cantidad_tickets(cantidad_empleado_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ticket_count INT;
    
    SELECT COUNT(*) INTO ticket_count
    FROM TICKET
    WHERE IDTICKET = cantidad_empleado_id;
    
    RETURN ticket_count;
END //

DELIMITER ;

-- VIEWS --

use aeromexico;

-- Vista para mostrar la cantidad de pasajeros que estan registrados de acuerdo a su tipo

CREATE VIEW
    Registro_Pasajeros AS
SELECT
    TIPO_CLIENTE,
    COUNT(IDPASAJERO) AS Cantidad_Pasajeros
FROM
    PASAJERO
GROUP BY
    TIPO_CLIENTE;
    
-- Vista para mostrar los ingresos que se tuvieron por cada vuelo

CREATE VIEW
    IngresosxVuelo AS
SELECT
    SUM(TICKET.COSTO) AS Ingresos
FROM
    VUELO
    LEFT JOIN TICKET ON TICKET.IDTICKET = VUELO.IDTICKET
GROUP BY
    TICKET.IDTICKET;
    
-- PROCEDURES --

use aeromexico;

-- procedimiento para verificar si el vuelo existe para insertar el nombre del pasajero

DELIMITER //

CREATE PROCEDURE crear_pasajero(
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(100),
    IN p_id_pasajero INT
)
BEGIN
    DECLARE pasajero_count INT;
    
    -- Verificar si el restaurante existe
    SELECT COUNT(*) INTO pasajero_count
    FROM VUELO
    WHERE IDVUELO = p_id_pasajero;
    
    -- Si el restaurante existe, insertar el empleado
    IF pasajero_count > 0 THEN
        INSERT INTO PASAJERO (NOMBRE, TELEFONO, CORREO, IDPASAJERO)
        VALUES (p_nombre, p_telefono, p_correo, p_id_restaurante);
        
        SELECT 'Pasajero creado exitosamente.';
    ELSE
        SELECT 'No existe el vuelo';
    END IF;
END //

DELIMITER ;
