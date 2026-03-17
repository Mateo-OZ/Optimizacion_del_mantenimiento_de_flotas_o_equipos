# Gestión digital de mantenimiento de compresores industriales – Incolmotos Yamaha

## Descripción del proyecto

Este repositorio contiene la documentación, estructura de datos y scripts SQL de una solución orientada a la **gestión digital del mantenimiento de compresores industriales** en el contexto de **Incolmotos Yamaha**.

El proyecto reúne elementos de modelado de datos, validación de calidad de información, creación de esquema relacional y consultas analíticas para facilitar el registro, consulta y análisis de intervenciones de mantenimiento.

## Objetivo

Diseñar una base estructurada para administrar la información relacionada con:

- Equipos industriales
- Técnicos responsables
- Tipos de novedad o falla
- Componentes
- Repuestos
- Intervenciones de mantenimiento
- Relación entre intervenciones y técnicos
- Detalle de repuestos/componentes usados en cada intervención

## Alcance funcional

La solución permite sentar las bases para:

- Registrar equipos y sus características
- Registrar técnicos y su entidad
- Clasificar tipos de novedad
- Gestionar repuestos y componentes
- Registrar intervenciones de mantenimiento
- Asociar uno o varios técnicos a una intervención
- Registrar detalle de componentes y repuestos utilizados
- Ejecutar consultas de validación, conteo y análisis de datos

## Estructura del repositorio

```text
Gestion_digital_de_mantenimiento_de_compresores_industriales_Incolmotos_Yamaha/
│
├── README.md
├── diagrama.png
├── modelo estrella.png
├── Criterios de inclusión y estructura mínima estandarizada de los registros.pdf
├── Diccionario_De_Datos.pdf
├── Informe sobre vacíos de información e inconsistencias.pdf
│
└── Sprint 2/
    ├── Datos tablas/
    ├── Consultas.sql
    ├── creacion_esquema_base_de_datos.sql
    ├── privilegios_usuarios.sql
    ├── Datos.xlsx
    ├── Criterios de inclusión y estructura mínima estandarizada de los registros (1).pdf
    ├── Diccionario_De_Datos_Actualizado.pdf
    ├── Informe sobre validez del esquema en estrella.pdf
    └── modelo entidad-relacion.png.png
