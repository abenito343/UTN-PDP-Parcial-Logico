% Apellido y Nombre: Benito Ariel  
% Legajo: 1633168

% juego(juego, plataforma soportada)
juego(minecraft, pc([windows,linux,mac])).
juego(minecraft, playstation(2)).
juego(minecraft, playstation(3)).
juego(superMario, xbox).
juego(superMario, xcube).
juego(saga(finalFantasy, 1), gameboy).
juego(saga(finalFantasy, 2), gameboy).
juego(saga(finalFantasy, 3), gameboy).
juego(saga(finalFantasy, 3), gameboyColor).
juego(saga(finalFantasy, 3), xbox).
juego(saga(sonic,1), genesis).
juego(saga(sonic,2), genesis).
juego(saga(sonic,3), genesis).

% usuarios(juego, plataforma, cantidad).
usuarios(minecraft,playstation(2), 40000).
usuarios(minecraft, playstation(3), 36700).
usuarios(saga(finalFantasy, 1), gameboy, 400).
usuarios(saga(finalFantasy, 2), gameboy, 220).
usuarios(superMario, xbox, 980).
usuarios(saga(finalFantasy, 3), gameboy, 70).
usuarios(saga(finalFantasy, 3), gameboyColor, 100).
usuarios(saga(sonic, 1), genesis, 500).
usuarios(saga(sonic, 2), genesis, 800).
usuarios(saga(sonic, 3), genesis, 1400).

%consolaPortatil(Consola).
consolaPortatil(gameboy).
consolaPortatil(gameboyColor).
consolaPortatil(psp).

%vende(Empresa,Consola).
vende(nintendo,gameboy).
vende(nintendo,xbox).
vende(nintendo,xcube).
vende(apple,pc([mac])).
vende(microsoft,pc([windows])).
vende(lenovo,pc([windows,linux])).
vende(sony,playstation(_)).

%2 tienePlataformaQueSoporta(Empresa,Juego).
tienePlataformaQueSoporta(Empresa,Juego):-
    vende(Empresa,Plataforma),
    plataformaSoportada(Plataforma,Juego).

plataformaSoportada(Consola,Juego):-
    juego(Juego,Consola),
    Consola \= pc(_).

plataformaSoportada(pc(SOs), Juego):- 
	juego(Juego, pc(SistemasSoportados)),
	member(SistemaOperativo, SOs),
	member(SistemaOperativo, SistemasSoportados).

%3 propietario(Empresa,Juego).
propietario(Empresa,Juego):-
    tienePlataformaQueSoporta(Empresa,Juego),
    not((tienePlataformaQueSoporta(Empresa2,Juego),Empresa\=Empresa2)).
    
%4 prefierenPortatiles(Juego).
prefierenPortatiles(Juego):-
    estaParaNoPortatil(Juego),
    seJuegaSoloEnPortatil(Juego).

estaParaNoPortatil(Juego):-
    juego(Juego,Consola),
    not(consolaPortatil(Consola)).

seJuegaSoloEnPortatil(Juego):-
    forall(usuarios(Juego,Consola,_),consolaPortatil(Consola)).


%5 nivelFanatismo(Juego,Fanatismo).
nivelFanatismo(Juego,Fanatismo):-
    cantidadTotalUsuarios(Juego,CantidadUsuarios),
    Fanatismo is CantidadUsuarios / 10000.

cantidadTotalUsuarios(Juego,CantidadUsuarios):-
    usuarios(Juego,_,_),
    findall(Usuarios, usuarios(Juego,_,Usuarios), CantidadesPorConsola),
    sumlist(CantidadesPorConsola, CantidadUsuarios).

%6 esPirateable(Juego).
esPirateable(Juego):-
    juego(Juego,Plataforma),
    cantidadTotalUsuarios(Juego,CantidadUsuarios),
    CantidadUsuarios > 5000,
    esHackeable(Plataforma).

esHackeable(psp).
esHackeable(pc(_)).
esHackeable(playstation(Version)):-
    Version<3.

%7a ultimoDeLaSaga(Titulo, saga(Titulo,Version))
ultimoDeLaSaga(Titulo, saga(Titulo,Version)):-
    juego(saga(Titulo, Version), _),
    esLaUltima(Titulo, Version).

esLaUltima(Titulo,Version):-
    forall(juego(saga(Titulo, OtraVersion),_), Version>= OtraVersion).

%7b buenaSaga(Juego).
buenaSaga(Juego):-
    ultimoDeLaSaga(Titulo,UltimoSaga),
    mantuvoLosUsuarios(UltimoSaga).

mantuvoLosUsuarios(saga(_,1)).

mantuvoLosUsuarios(saga(Titulo,Version)):-
    cantidadTotalUsuarios(saga(Titulo, Version), CantidadUsuariosSaga1),
    VersionAnterior is Version -1,
    cantidadTotalUsuarios(saga(Titulo, VersionAnterior), CantidadUsuariosSaga2),
    CantidadUsuariosSaga1 * 2 > CantidadUsuariosSaga2,
    mantuvoLosUsuarios(saga(Titulo,VersionAnterior)).
