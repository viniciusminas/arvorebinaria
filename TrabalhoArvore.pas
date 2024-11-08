Program Pzim ;

type                                                          
		arvore = ^nodo_arv;
    nodo_arv = Record
        conteudo: arvore;
        nome: string;
        arvdir, arvesq, arvpai: arvore;
    end;

var  estado : arvore;

Procedure ExibirNo(Raiz: arvore);
begin
	if Raiz <> nil then
	begin
		write(Raiz^.nome, ', ');
		ExibirNo(Raiz^.arvesq);
		ExibirNo(Raiz^.arvdir);
	end;
end;
	


Procedure EmOrdem(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        EmOrdem(Raiz^.arvesq);
        write(Raiz^.nome, '-');
        EmOrdem(Raiz^.arvdir);
    end;
end;

Procedure EmOrdemMun(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        EmOrdemMun(Raiz^.arvesq);
        write(Raiz^.nome, '-');
        EmOrdemMun(Raiz^.arvdir);
    end;
end;

Procedure PreOrdem(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        write(Raiz^.nome, '-');
        ExibirNo(Raiz); //teste para mostrar os mun's.
        PreOrdem(Raiz^.arvesq);
        PreOrdem(Raiz^.arvdir);
    end;
end;

procedure IniciarVariaveis(var est: arvore);
begin
	est := nil;	
end; 

function VerificarNoExiste(arv: arvore; conteudo: string):arvore;
begin
	if arv = nil then
		VerificarNoExiste := nil
	else if arv^.nome = conteudo then //se o nome inserido ja existe no nó
		VerificarNoExiste := arv
	else if conteudo < arv^.conteudo^.nome then
	  VerificarNoExiste := VerificarNoExiste(arv^.arvesq, conteudo)
	else
      VerificarNoExiste := VerificarNoExiste(arv^.arvdir, conteudo); 
end;

function CriarNo(var arv: arvore; arvpai:arvore; conteudo: string): arvore;
var novoNo: arvore;
begin
    new(novoNo);
    novoNo^.nome := conteudo;
    novoNo^.arvesq := nil;
    novoNo^.arvdir := nil;           
    novoNo^.arvpai := nil;
    CriarNo := novoNo;

    if arv = nil then
    begin
        arv := novoNo;
        arv^.arvpai := arvpai;
        CriarNo := arv;
    end
    else
    begin
        if conteudo < arv^.nome then
            CriarNo(arv^.arvesq, arv, conteudo)
        else
            CriarNo(arv^.arvdir, arv, conteudo);
    end;
end;

procedure IncluirMunicipio(var arvraiz: arvore; uf, municipio: string);
var 
		est: arvore;
begin
    est := VerificarNoExiste(arvraiz, uf);	
    if est = nil then
    begin
        est := CriarNo(arvraiz, arvraiz, uf);           
    end;
    
    writeln('Estado: ', est^.nome);

    while (est <> nil) and (est^.nome <> uf) do
    begin
        if uf < est^.nome then
            est := est^.arvesq
        else
            est := est^.arvdir;
    end;
	
	//condicional para adicionar o municipio na árvore desse estado
	if (est <> nil) and (VerificarNoExiste(est^.conteudo, municipio) = nil) then
		CriarNo(est^.conteudo, est^.conteudo, municipio)
	else
		writeln('Municipio já existe: ', municipio); //depuration, teste rs
end;


Begin  

	IniciarVariaveis(estado);
	IncluirMunicipio(estado, 'SC', 'Jaraguá');
	IncluirMunicipio(estado, 'SC', 'Ituporanga');
	IncluirMunicipio(estado, 'SC', 'Rio do Sul');
	IncluirMunicipio(estado, 'ZZ', 'AA');
	IncluirMunicipio(estado, 'PE', 'AA');
	IncluirMunicipio(estado, 'AA', 'AA');
	IncluirMunicipio(estado, 'BB', 'AA'); 
	{CriarNo(estado, estado, 'SC');
	CriarNo(estado, estado, 'SP');
	CriarNo(estado, estado, 'MG');
	CriarNo(estado, estado, 'ZZ');
	CriarNo(estado, estado, 'PE');
	CriarNo(estado, estado, 'AA');
	CriarNo(estado, estado, 'BB');
	CriarNo(estado, estado, 'CC');
	CriarNo(estado, estado, 'NN');
	CriarNo(estado, estado, 'LL');}
	EmOrdem(estado^.conteudo);

End.
