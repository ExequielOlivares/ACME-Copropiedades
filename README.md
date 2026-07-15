# ACME Copropiedades - Sistema de Gestión de Copropiedad y Condominios 🏢💻

![Database](https://img.shields.io/badge/Database-SQLite3-003B57?style=flat-square&logo=sqlite&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-CC2927?style=flat-square&logo=microsoft-sql-server&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=flat-square)

Este repositorio contiene el diseño conceptual, lógico y físico de la base de datos relacional para **ACME Copropiedades**, una solución de software orientada a la administración integral de condominios y edificios de copropiedad. El sistema modela de forma estricta las reglas operativas, financieras y de gobernanza interna de múltiples comunidades.

---

## 📌 Tabla de Contenidos
1. [Descripción del Problema](#-descripción-del-problema)
2. [Arquitectura del Modelo (DER)](#-arquitectura-del-modelo-der)
3. [Modelo Relacional](#-modelo-relacional)
4. [Análisis de Normalización](#-análisis-de-normalización)
5. [Implementación Física (SQLite)](#-implementación-física-sqlite)
6. [Instrucciones de Uso](#-instrucciones-de-uso)

---

## 📝 Descripción del Problema

El sistema ha sido diseñado para dar cumplimiento riguroso a las siguientes reglas de negocio:
* **Comunidades y Áreas:** Gestión de múltiples condominios con administración independiente y registro de fechas de inicio de gestión.
* **Departamentos y Estacionamientos:** Clasificación por metros cuadrados, porcentaje de prorrateo de gastos comunes y condición de habitabilidad (dueño/arrendatario).
* **Personas y Multi-unidad:** Registro de residentes y propietarios, permitiendo que un residente sea dueño de múltiples unidades dentro de la comunidad de forma independiente a su residencia actual.
* **Comité y Supervisión:** Estructura jerárquica interna donde ciertos residentes actúan como supervisores de otros dentro del Comité de Administración.
* **Finanzas y Cobros:** Automatización de cobros mensuales individuales (Emite_Cobro) a partir de los Gastos Comunes Generales y la tasa de prorrateo de cada departamento.

---

## 🎨 Arquitectura del Modelo (DER)

El diseño conceptual ha sido estructurado mediante la notación formal del **Diagrama Entidad-Relación (DER)**, asegurando la correcta representación de relaciones fuertes, débiles, restricciones de participación y jerarquías:

* **DER Conceptual:** Ubicado en `Diagrama_acme_v4.png`. Representa de manera gráfica las entidades clave como `Residente`, `Comunidad`, `Departamento`, `Gasto_Comun`, entre otras, y sus respectivas relaciones (`Reside`, `Trabaja`, `Es Propietario`).

---

## 💾 Modelo Relacional

A continuación se detalla la estructura lógica del modelo de base de datos normalizado, explicitando Claves Primarias (**PK**) y Claves Foráneas (**FK**):

* **Comunidad** (**id_comunidad**, nombre, numero_calle, calle, nombre_admin, fecha_inicio)
* **Empleado** (**rut_empleado**, nombre, ap_p, ap_m, cargo, salario, *id_comunidad*)
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
* **Residente** (**rut_residente**, nombre, ap_p, ap_m, calle, numero, cp, salario, sexo, fecha_nacimiento, comite, reside, *id_comunidad*)
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
* **Comite** (***rut_residente***, supervisor)
    * *FK*: `rut_residente` → `Residente(rut_residente)`
* **Departamento** (**numero_depto**, prorrateo, metros_c, habita, *id_comunidad*, *rut_residente*)
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
    * *FK*: `rut_residente` → `Residente(rut_residente)`
* **Estacionamiento** (**numero_estacio**, tipo, *id_residente*, *id_comunidad*)
    * *FK*: `id_residente` → `Residente(rut_residente)`
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
* **Propietario_Departamento** (**id_propiedad_d**, *rut_residente*, *numero_depto*)
    * *FK*: `rut_residente` → `Residente(rut_residente)`
    * *FK*: `numero_depto` → `Departamento(numero_depto)`
* **Propietario_Estacionamiento** (**id_propiedad_e**, *rut_residente*, *numero_estacio*)
    * *FK*: `rut_residente` → `Residente(rut_residente)`
    * *FK*: `numero_estacio` → `Estacionamiento(numero_estacio)`
* **Area_Comun** (**id_area**, nombre, metros_c, tipo, *id_comunidad*)
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
* **Mantencion** (**id_mantencion**, costo, descripcion, fecha_ejecucion, *id_area*)
    * *FK*: `id_area` → `Area_Comun(id_area)`
* **Reserva_Area** (**id_reserva**, horas_semana, fecha_uso, *rut_residente*, *id_area*)
    * *FK*: `rut_residente` → `Residente(rut_residente)`
    * *FK*: `id_area` → `Area_Comun(id_area)`
* **Familiar** (**id_familiar**, nombre, ap_p, ap_m, sexo, fecha_nacimiento, edad, parentesco, *rut_residente*)
    * *FK*: `rut_residente` → `Residente(rut_residente)`
* **Gasto_Comun** (**id_gasto_c**, mes, anio, monto, *id_comunidad*)
    * *FK*: `id_comunidad` → `Comunidad(id_comunidad)`
* **Emite_Cobro** (**id_cobro**, valor, fecha_v, estado, *id_gasto_c*, *numero_depto*)
    * *FK*: `id_gasto_c` → `Gasto_Comun(id_gasto_c)`
    * *FK*: `numero_depto` → `Departamento(numero_depto)`

---

## 📈 Análisis de Normalización

El diseño lógico ha sido sometido a un riguroso proceso de normalización para asegurar la integridad de los datos y mitigar anomalías de inserción, actualización y borrado:

### 1️⃣ Primera Forma Normal (1FN)
* **Requisito:** Todos los atributos son atómicos y no existen grupos repetitivos.
* **Cumplimiento:** Atributos como nombres completos se descomponen en campos individuales (`nombre`, `ap_p`, `ap_m`). Los campos multivalorados se han resuelto mediante tablas relacionales de cardinalidad $1:N$.

### 2️⃣ Segunda Forma Normal (2FN)
* **Requisito:** Cumplir con la 1FN y que todo atributo de tipo "no clave" dependa funcionalmente de manera completa de la clave primaria.
* **Cumplimiento:** Para todas las entidades con claves primarias compuestas o simples, no existen dependencias parciales. Por ejemplo, en las tablas asociativas de propiedad (`Propietario_Departamento` y `Propietario_Estacionamiento`), se cuenta con una clave subrogada o restricción única compuesta que garantiza que las dependencias sean sobre la clave completa.

### 3️⃣ Tercera Forma Normal (3FN)
* **Requisito:** Cumplir con la 2FN y que no existan dependencias transitivas (ningún atributo no primario depende de otro atributo no primario a través de la PK).
* **Cumplimiento:** Se separó la información de `Comunidad`, `Departamento` y `Residente`. Un cambio en la información de una comunidad no afecta transitivamente a los datos de los departamentos o residentes de forma anómala.

---

## 🛠️ Implementación Física (SQLite)

El script SQL (`ACME_Copropiedades_V4.sql`) contiene la traducción directa a código DDL optimizado para **SQLite**, implementando:
* **Integridad de Datos:** Restricciones `CHECK` para validar dominios específicos como meses del año, montos no negativos, horas máximas semanales ($\le 168$ hrs), y tipos de estacionamiento válidos.
* **Integridad Referencial:** Claves foráneas configuradas con políticas `ON UPDATE CASCADE` para mantener la consistencia de los datos ante modificaciones de claves principales.
* **Unicidad:** Restricciones `UNIQUE` compuestas para evitar duplicidad de registros financieros y reservas superpuestas.

---

## 🚀 Instrucciones de Uso

Para levantar y testear la base de datos de manera local utilizando SQLite3, ejecuta los siguientes comandos en tu terminal:

### 1. Clonar el repositorio
```bash
git clone [https://github.com/tu-usuario/ACME-Copropiedades.git](https://github.com/tu-usuario/ACME-Copropiedades.git)
cd ACME-Copropiedades
