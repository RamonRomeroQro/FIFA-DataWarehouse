
CREATE TABLE Cuentasalfa (
    cveCuenta number(10) NOT NULL PRIMARY KEY,
    nombreCliente varchar2(50) NOT NULL,
    balance number(10,2) not null default 0
);


CREATE TABLE Operacionesalfa (
    cveOperacion number(10) NOT NULL PRIMARY KEY,
    cveCuenta number(10) NOT NULL FOREIGN KEY REFERENCES Cuentasalfa(cveCuenta),
    fechaOperacion NOT NULL DATE DEFAULT sysdate,
    tipoOperacion not null char(1),
    montoOperacion number(10,2) not null default 0
);












-- tabla cuentasalfa
CREATE TABLE CUENTASALFA
(
  CVECUENTA      NUMBER(10)                     NOT NULL,
  NOMBRECLIENTE  VARCHAR2(50 BYTE)              NOT NULL,
  BALANCE        NUMBER(10,2)                   DEFAULT 0                     NOT NULL
);

CREATE UNIQUE INDEX CUENTASALFA_PK ON CUENTASALFA
(CVECUENTA);

ALTER TABLE CUENTASALFA ADD (
  CONSTRAINT CUENTASALFA_PK
  PRIMARY KEY
  (CVECUENTA)
  USING INDEX CUENTASALFA_PK
  ENABLE VALIDATE);
  
-- tabla operacionesalfa
CREATE TABLE OPERACIONESALFA
(
  CVEOPERACION    NUMBER(10)                    NOT NULL,
  CVECUENTA       NUMBER(10)                    NOT NULL,
  FECHAOPERACION  DATE                          DEFAULT sysdate               NOT NULL,
  TIPOOPERACION   CHAR(1 BYTE)                  NOT NULL,
  MONTOOPERACION  NUMBER(10,2)                  DEFAULT 0                     NOT NULL
);


CREATE UNIQUE INDEX OPERACIONESALFA_PK ON OPERACIONESALFA
(CVEOPERACION);

ALTER TABLE OPERACIONESALFA ADD (
  CONSTRAINT OPERACIONESALFA_CHK1
  CHECK (TIPOOPERACION = 'D' OR TIPOOPERACION = 'R')
  ENABLE VALIDATE,
  CONSTRAINT OPERACIONESALFA_PK
  PRIMARY KEY
  (CVEOPERACION)
  USING INDEX OPERACIONESALFA_PK
  ENABLE VALIDATE);

ALTER TABLE OPERACIONESALFA ADD (
  CONSTRAINT OPERACIONESALFA_CUENTASAL_FK1 
  FOREIGN KEY (CVECUENTA) 
  REFERENCES CUENTASALFA (CVECUENTA)
  ENABLE VALIDATE);

 -- secuencia cveoperacion
 
 CREATE SEQUENCE SEQ_CVEOPERACION
 
 -- procedimiento creaoperacion
 CREATE OR REPLACE PROCEDURE CREAOPERACION 
(
  P_CVECUENTA IN NUMBER 
, P_TIPOOPERACION IN CHAR 
, P_MONTOOPERACION IN NUMBER 
) 

AS 
-- USTEDES LO COMPLETAN CON LO QUE COPIARON-TOMARON FOTO      
        
END CREAOPERACION;
/

-- tabla transferenciasalfa
CREATE TABLE TRANSFERENCIASALFA
(
  CVETRANS        NUMBER                        NOT NULL,
  CVECTAORIG      NUMBER                        NOT NULL,
  CVECTADEST      NUMBER                        NOT NULL,
  MONTOOPERACION  NUMBER                        DEFAULT 0                     NOT NULL
);


CREATE UNIQUE INDEX TRANSFERENCIASALFA_PK ON TRANSFERENCIASALFA
(CVETRANS);

ALTER TABLE TRANSFERENCIASALFA ADD (
  CONSTRAINT TRANSFERENCIASALFA_PK
  PRIMARY KEY
  (CVETRANS)
  USING INDEX TRANSFERENCIASALFA_PK
  ENABLE VALIDATE);

ALTER TABLE TRANSFERENCIASALFA ADD (
  CONSTRAINT TRANSFERENCIASALFA_CUENTA_FK1 
  FOREIGN KEY (CVECTAORIG) 
  REFERENCES CUENTASALFA (CVECUENTA)
  ENABLE VALIDATE);

-- secuencia cvetrans
CREATE SEQUENCE SEQ_CVETRANS

-- procedimiento transdist

CREATE OR REPLACE PROCEDURE TRANSDIST 
(
  P_CVECTAORIG IN NUMBER 
, P_CVECTADEST IN NUMBER 
, P_MONTOOPERACION IN NUMBER 
) AS 
v_saldo number;
v_existecuenta number; --uso estas variables locales de acuerdo a la lógica de programación que use
BEGIN
  -- aqui va una consulta para saber si la cuenta de origen existe cuando se hace una 
  -- consulta y se quiere dejar el valor en una variable se usa algo como esto: select count(1) into variable from ... en este caso me daria 0/1 dependiendo 
  -- si existe o no la cuenta
  if v_existecuenta=0 then
    raise_application_error(-20000,'{la cuenta origen no existe}'); -- aqui mando a decir que no existe la cuenta
  else
      -- aqui va una consulta para saber si la cuenta de destino existe 
    if v_existecuenta=0 then
      raise_application_error(-20000,'{la cuenta destino no existe}');
    else
      --debo obtener el balance para ver si puedo realizar el retiro de la cuenta origen
      if v_saldo >= P_MONTOOPERACION then	-- si tengo saldo suficiente
        --uso el procedimiento local creaoperacion con R-retiro
        --uso el procedimiento remoto creaoperacion con D-deposito
        insert into transferenciasalfa values(seq_cvetrans.nextval,P_CVECTAORIG,P_CVECTADEST,-P_MONTOOPERACION); -- le pongo menos como referencia que hice un retiro
        insert into transferenciasbeta@beta values(seq_cvetrans.nextval@beta,P_CVECTADEST,P_CVECTAORIG,P_MONTOOPERACION); -- intercambio las cuentas como referencia de constraint local
        commit;
      else
        raise_application_error(-20000,'{no se tiene el saldo suficiente para la operacion}');
      end if;
    end if;
  end if;
END TRANSDIST;
/
