create or replace type NameType as object (
   NStr varchar2(20)
);

create or replace type AdressTyp as object (
   WOHNORT varchar2(20),
   PLZ     varchar2(10),
   Land    char(2)
);

create or replace type PersonenType as object (
   NName   NameType,
   VName   varchar2(20),
   GebDatum date,
   Adr      AdressType
);

create table Person of PersonenType (
   NName not null,
   Adr   default AdressTyp('Wangen','8855','CH'),
   GebDatum  not null,
   constraint Name_UNIQUE INIQUE(NName.NStr, VName, Adr.PLZ)
);