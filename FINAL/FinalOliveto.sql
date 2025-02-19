-- EXAMEN FINAL – SISTEMAS DE BASES DE DATOS – INGENIERÍA INFORMÁTICA – 19-02-2025

-- SERVICIO DE TRANFERENCIA DE DINERO INTERNACIONAL – CASO WESTERN UNION.
-- Las agencias de transferencias internacionales como Western Union facilitan el envío de dinero entre distintos países mediante una red global de agentes y bancos. Su funcionamiento se basa en un modelo de remesas electrónicas, que permite a una persona enviar dinero a otra sin necesidad de que ambas tengan una cuenta bancaria.
-- 1. Iniciación de la Transferencia
-- El remitente puede iniciar la transferencia a través de dos métodos principales:
-- •	En una sucursal física: Completa un formulario y entrega el dinero en efectivo, o a través de una transferencia, o con tarjeta de débito.
-- •	En línea: A través del sitio web o la aplicación móvil de Western Union, utilizando una cuenta bancaria (transferencia) o tarjeta de débito.
-- Deben registrarse los siguientes datos de la operación:
-- -	Sucursal en la que se realizó la transferencia, 0 (cero) si fue realizada por la web.

-- -	Fecha y hora

-- -	Agente de WU (en el caso de haberse realizado en una sucursal).

-- -	Monto

-- -	Moneda en la cual se realiza la transferencia

-- -	Método de entrega del dinero (efectivo, transferencia, tarjeta de débito)

-- -	CBU (si la entrega fue realizada a través de una transferencia)

-- -	Código de la tarjeta de débito

-- -	Código de transferencia o MTCN (Money Transfer Control Number) (no obligatorio – se genera cuando se confirma la transacción). Es un número de 10 dígitos.

-- -	Remitente:
-- •	Nombre y apellidos completos.
-- •	Documento de identidad.
-- •	Teléfono
-- •	Email
-- -	Destinatario:
-- •	Nombre y apellidos completos.
-- •	Documento de identidad.
-- •	País de destino.
-- •	Método de recepción (efectivo en una sucursal o depósito en cuenta bancaria).
-- •	CBU de la cuenta bancaria si se seleccionó la recepción por ese canal.
-- •	Moneda en la que se desea recibir el monto transferido (opcional). Si no se informa se entrega en la moneda local o en la de la cuenta bancaria (si fue informada).
-- NOTA: Si el monto se recibirá en una cuenta bancaria no se informa, ya que la moneda será la de la cuenta.
-- WU mantiene los datos de remitentes y destinatarios como “clientes”.
-- También mantiene datos de las sucursales (número, denominación, localidad y país) y los agentes que trabajan en ellas (número, apellido, nombre).  
-- 2. Cálculo de comisiones y tipo de cambio
-- Western Union cobra una comisión (porcentaje del monto) por la transferencia, la cual varía según:
-- •	El monto enviado (rango: mínimo – máximo).
-- •	El país de origen y el país de destino.
-- •	El método de pago y el método de recepción.
-- Además, cuando la transferencia implica diferentes monedas, Western Union aplica un tipo de cambio que tiene una variación entre rangos de fechas.
-- 3. Procesamiento y Envío del Dinero
-- Una vez que se confirma el pago, Western Union procesa la transferencia y genera un código de transacción (MTCN, Money Transfer Control Number). Este código es fundamental, ya que el destinatario lo necesitará para retirar el dinero.
-- 4. Recepción del Dinero
-- El destinatario puede recibir el dinero mediante distintos canales:
-- •	Efectivo en una sucursal: Acude a un agente de Western Union con su documento de identidad y el código MTCN.
-- •	Depósito en cuenta bancaria: Se acredita automáticamente en la cuenta bancaria del destinatario.
-- En el momento de la recepción o que se acredita la transferencia se debe registrar la fecha-hora de la misma, la sucursal y el agente (si fue en una sucursal).

-- EJERCICIOS:
-- 1.	Diseñar un modelo lógico de datos para el problema (30)

-- 2.	Implementar la base de datos con todas las reglas de integridad que puedan implementarse de manera declarativa (PKs, UKs, FKs, CHECKs) y describir las reglas de integridad que no se pueden implementar de esa manera (10)

-- 3.	Controlar que para la fecha de entrega haya registrado el tipo de cambio entre la moneda de recepción y la de entrega. Solo si son monedas diferentes. Recordar que en todo momento la base de datos debe quedar en estado íntegro, por lo que no solo debe controlarse la operación de entrega. (35)

-- 4.	Programar una función escalar que reciba como argumento el identificador de una transferencia y devuelva el importe de comisión a cobrar en dólares (25)




--2 : IMPLEMENTACION DE LA BASE DE DATOS


-- Creación de la base de datos
CREATE DATABASE TransferenciasWU;
GO
USE TransferenciasWU;
GO
-- Tabla de Países
CREATE TABLE Pais (
    id_pais INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE
);

-- Tabla de Métodos de Pago
CREATE TABLE MetodoPago (
    id_metodo_pago INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Métodos de Recepción
CREATE TABLE MetodoRecepcion (
    id_metodo_recepcion INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Sucursales
CREATE TABLE Sucursal (
    id_sucursal INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    localidad NVARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

-- Tabla de Agentes
CREATE TABLE Agente (
    id_agente INT PRIMARY KEY IDENTITY(1,1),
    id_sucursal INT NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

-- Tabla de Clientes
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    documento NVARCHAR(20) NOT NULL UNIQUE,
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

-- Tabla de Monedas
CREATE TABLE Moneda (
    id_moneda INT PRIMARY KEY IDENTITY(1,1),
    codigo_iso CHAR(3) NOT NULL UNIQUE,
    nombre NVARCHAR(50) NOT NULL
);

-- Tabla de Transferencias
CREATE TABLE Transferencia (
    id_transferencia INT PRIMARY KEY IDENTITY(1,1),
    id_remitente INT NOT NULL,
    id_destinatario INT NOT NULL,
    id_sucursal INT NULL,
    id_agente INT NULL,
    fecha_hora DATETIME2 NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    id_moneda_envio INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    cbu_envio NVARCHAR(22) NULL,
    codigo_tarjeta NVARCHAR(16) NULL,
    mtcn CHAR(10) NULL,
    id_moneda_recepcion INT NULL,
    FOREIGN KEY (id_remitente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_destinatario) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal),
    FOREIGN KEY (id_agente) REFERENCES Agente(id_agente),
    FOREIGN KEY (id_moneda_envio) REFERENCES Moneda(id_moneda),
    FOREIGN KEY (id_moneda_recepcion) REFERENCES Moneda(id_moneda),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(id_metodo_pago),
    CONSTRAINT chk_cbu_o_tarjeta CHECK (
        (cbu_envio IS NOT NULL AND codigo_tarjeta IS NULL) OR
        (codigo_tarjeta IS NOT NULL AND cbu_envio IS NULL)
    )
);

-- Tabla de Recepción del Dinero
CREATE TABLE Recepcion (
    id_recepcion INT PRIMARY KEY IDENTITY(1,1),
    id_transferencia INT NOT NULL UNIQUE,
    id_sucursal INT NULL,
    id_agente INT NULL,
    fecha_hora DATETIME2 NOT NULL,
    id_metodo_recepcion INT NOT NULL,
    cbu_recepcion NVARCHAR(22) NULL,
    id_moneda_recepcion INT NULL,
    FOREIGN KEY (id_transferencia) REFERENCES Transferencia(id_transferencia),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal),
    FOREIGN KEY (id_agente) REFERENCES Agente(id_agente),
    FOREIGN KEY (id_metodo_recepcion) REFERENCES MetodoRecepcion(id_metodo_recepcion),
    FOREIGN KEY (id_moneda_recepcion) REFERENCES Moneda(id_moneda)
);

-- Tabla de Tipos de Cambio
CREATE TABLE TipoCambio (
    id_moneda_origen INT NOT NULL,
    id_moneda_destino INT NOT NULL,
    fecha_inicio DATETIME2 NOT NULL,
    fecha_fin DATETIME2 NOT NULL,
    tasa_cambio DECIMAL(18,4) NOT NULL,
    PRIMARY KEY (id_moneda_origen, id_moneda_destino, fecha_inicio, fecha_fin),
    FOREIGN KEY (id_moneda_origen) REFERENCES Moneda(id_moneda),
    FOREIGN KEY (id_moneda_destino) REFERENCES Moneda(id_moneda),
    CONSTRAINT chk_fecha_tipo_cambio CHECK (fecha_inicio < fecha_fin)
);

-- Tabla de Rango de Comisiones
CREATE TABLE Comision_Rango (
    id_comision_rango INT PRIMARY KEY IDENTITY(1,1),
    monto_min DECIMAL(18,2) NOT NULL,
    monto_max DECIMAL(18,2) NOT NULL
);

-- Tabla de Detalles de Comisiones
CREATE TABLE Comision_Detalle (
    id_comision_detalle INT PRIMARY KEY IDENTITY(1,1),
    id_comision_rango INT NOT NULL,
    id_pais_origen INT NOT NULL,
    id_pais_destino INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    id_metodo_recepcion INT NOT NULL,
    porcentaje_comision DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (id_comision_rango) REFERENCES Comision_Rango(id_comision_rango),
    FOREIGN KEY (id_pais_origen) REFERENCES Pais(id_pais),
    FOREIGN KEY (id_pais_destino) REFERENCES Pais(id_pais),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(id_metodo_pago),
    FOREIGN KEY (id_metodo_recepcion) REFERENCES MetodoRecepcion(id_metodo_recepcion)
);
