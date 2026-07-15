
-- 1. COMUNIDAD

CREATE TABLE Comunidad (
    id_comunidad INT,
    nombre TEXT,
    numero_calle INT,
    calle TEXT,
    nombre_admin TEXT,
    fecha_inicio varchar(10),
    CONSTRAINT PK_COMUNIDAD PRIMARY KEY (id_comunidad) 
);


-- 2. EMPLEADO
-- Cada empleado trabaja en una comunidad.

CREATE TABLE Empleado (
    rut_empleado varchar(12) NOT NULL,
    nombre TEXT,
    ap_p TEXT,
    ap_m TEXT,
    cargo TEXT,
    salario INT,
    id_comunidad INT,
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (rut_empleado),
    CONSTRAINT FK_COMUNIDAD_EMPLEADO FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE
);

-- 3. RESIDENTE
-- Cada residente pertenece a una comunidad.


CREATE TABLE Residente (
    rut_residente varchar(12) NOT NULL,
    nombre TEXT,
    ap_p TEXT,
    ap_m TEXT,
    calle TEXT,
    numero INT,
    cp TEXT,
    salario INT,
    sexo TEXT CHECK (sexo IN ('masculino', 'femenino', 'otro')),
    fecha_nacimiento varchar(10),
    comite INT CHECK (comite IN(1,0)),
    id_comunidad INT,
    reside INT(reside IN(1,0)),
    CONSTRAINT PK_RESIDENTE PRIMARY KEY (rut_residente),
    CONSTRAINT FK_COMUNIDAD_RESIDENTE FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE
);


-- 4. COMITÉ
-- Todo miembro del comité debe ser previamente residente.


CREATE TABLE Comite (
    rut_residente varchar(12),
    supervisor INT CHECK (supervisor IN(1,0)),
    CONSTRAINT FK_COMITE_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE
);


-- 5. DEPARTAMENTO


CREATE TABLE Departamento (
    numero_depto TEXT NOT NULL,
    prorrateo REAL CHECK (prorrateo > 0 AND prorrateo <= 100),
    metros_c REAL CHECK (metros_c > 0),
    habita INT CHECK (habita IN ('dueño', 'arrendatario')),
    id_comunidad INT,
    rut_residente varchar(12),
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (numero_depto),
    CONSTRAINT FK_DEPARTAMENTO_COMUNIDAD FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE,
    CONSTRAINT FK_DEPARTAMENTO_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE
);


-- 6. ESTACIONAMIENTO

CREATE TABLE Estacionamiento (
    numero_estacio INT NOT NULL,
    tipo TEXT,
    id_residente INT,
    id_comunidad,
    CONSTRAINT PK_ESTACIONAMIENTO PRIMARY KEY (numero_estacio),
    CONSTRAINT FK_ESTACIONAMIENTO_RESIDENTE FOREIGN KEY (id_residente) REFERENCES Residente (id_residente) ON UPDATE CASCADE
    CONSTRAINT FK_ESTACIONAMIENTO_COMUNIDAD FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE
);


-- 7. PROPIETARIO DEPARTAMENTO
--


CREATE TABLE Propietario_Departamento (
    id_propiedad_d INT,
    rut_residente varchar(12),
    numero_depto INT,
    CONSTRAINT PK_PropietarioD PRIMARY KEY (id_propiedad_d),
    CONSTRAINT FK_PropietarioD_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE,
    CONSTRAINT FK_PropietarioD_DEPARTAMENTO FOREIGN KEY (numero_depto) REFERENCES Departamento (numero_depto) ON UPDATE CASCADE,
    UNIQUE (rut_residente, numero_depto)
);


-- 8. PROPIETARIO ESTACIONAMIENTO


CREATE TABLE Propietario_Estacionamiento (
    id_propiedad_e INT,
    rut_residente varchar(12),
    numero_estacio INT,
    CONSTRAINT PK_PropietarioE PRIMARY KEY (id_propiedad_e),
    CONSTRAINT FK_PropietarioE_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE,
    CONSTRAINT FK_PropietarioE_ESTACIONAMIENTO FOREIGN KEY (numero_estacio) REFERENCES Estacionamiento (numero_estacio) ON UPDATE CASCADE,
    UNIQUE (rut_residente, numero_estacio)
);


-- 9. ÁREA COMÚN

CREATE TABLE Area_Comun (
    id_area INT,
    nombre TEXT,
    metros_c REAL CHECK (metros_c > 0),
    tipo TEXT,
    id_comunidad INT,
    CONSTRAINT PK_AREA_COMUN PRIMARY KEY (id_area),
    CONSTRAINT FK_AREA_COMUN_COMUNIDAD FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE,
    UNIQUE (id_comunidad, nombre)
);


-- 10. MANTENCIÓN


CREATE TABLE Mantencion (
    id_mantencion INT,
    costo REAL CHECK (costo >= 0),
    descripcion TEXT,
    fecha_ejecucion varchar(10),
    id_area INT,
    CONSTRAINT PK_MANTENCION PRIMARY KEY (id_mantencion),
    CONSTRAINT FK_MANTENCION_AREA FOREIGN KEY (id_area) REFERENCES Area_Comun (id_area) ON UPDATE CASCADE
);


-- 11. RESERVA DE ÁREA


CREATE TABLE Reserva_Area (
    id_reserva INT,
    horas_semana REAL CHECK (horas_semana > 0 AND horas_semana <= 168),
    fecha_uso varchar(10),
    rut_residente varchar(12),
    id_area INT,
    CONSTRAINT PK_RESERVA PRIMARY KEY (id_reserva),
    CONSTRAINT FK_RESERVA_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE,
    CONSTRAINT FK_RESERVA_AREA FOREIGN KEY (id_area) REFERENCES Area_Comun (id_area) ON UPDATE CASCADE,
    UNIQUE (rut_residente, id_area, fecha_uso)
);


-- 12. FAMILIAR


CREATE TABLE Familiar (
    id_familiar INT,
    nombre TEXT,
    ap_p TEXT,
    ap_m TEXT,
    sexo TEXT CHECK (sexo IN ('masculino', 'femenino', 'otro')),
    fecha_nacimiento varchar(10),
    edad INT CHECK (edad >= 0),
    parentesco TEXT,
    rut_residente varchar(12),
    CONSTRAINT PK_FAMILIAR PRIMARY KEY (id_familiar),
    CONSTRAINT FK_FAMILIAR_RESIDENTE FOREIGN KEY (rut_residente) REFERENCES Residente (rut_residente) ON UPDATE CASCADE
);


-- 13. GASTO COMÚN


CREATE TABLE Gasto_Comun (
    id_gasto_c INT,
    mes TEXT CHECK (mes IN ("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")),
    anio INT,
    monto INT CHECK (monto >= 0),
    id_comunidad INT,
    CONSTRAINT PK_GASTO PRIMARY KEY (id_gasto_c),
    CONSTRAINT FK_GASTO_COMUNIDAD FOREIGN KEY (id_comunidad) REFERENCES Comunidad (id_comunidad) ON UPDATE CASCADE,
    UNIQUE (id_comunidad, mes, anio)
);


-- 14. EMITE COBRO

CREATE TABLE Emite_Cobro (
    id_cobro INT,
    id_gasto_c INT,
    numero_depto TEXT,
    valor INT CHECK (valor >= 0),
    fecha_v varchar(10),
    estado TEXT CHECK ( estado IN ('Pendiente', 'Pagado','Atrasado')),
    CONSTRAINT PK_COBRO PRIMARY KEY (id_cobro),
    CONSTRAINT FK_COBRO_GASTO FOREIGN KEY (id_gasto_c) REFERENCES Gasto_Comun (id_gasto_c) ON UPDATE CASCADE,
    CONSTRAINT FK_COBRO_DEPARTAMENTO FOREIGN KEY (numero_depto) REFERENCES Departamento (numero_depto) ON UPDATE CASCADE,
    UNIQUE (id_gasto_c, numero_depto)
);

